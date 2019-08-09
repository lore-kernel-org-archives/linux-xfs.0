Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:9691 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbfHIW6o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 18:58:44 -0400
From: ira.weiny@intel.com
Subject: [RFC PATCH v2 02/19] fs/locks: Add Exclusive flag to user Layout lease
Date: Fri,  9 Aug 2019 15:58:16 -0700
Message-Id: <20190809225833.6657-3-ira.weiny@intel.com>
In-Reply-To: <20190809225833.6657-1-ira.weiny@intel.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>

From: Ira Weiny <ira.weiny@intel.com>

Add an exclusive lease flag which indicates that the layout mechanism
can not be broken.

Exclusive layout leases allow the file system to know that pages may be
GUP pined and that attempts to change the layout, ie truncate, should be
failed.

A process which attempts to break it's own exclusive lease gets an
EDEADLOCK return to help determine that this is likely a programming bug
vs someone else holding a resource.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/locks.c                       | 23 +++++++++++++++++++++--
 include/linux/fs.h               |  1 +
 include/uapi/asm-generic/fcntl.h |  2 ++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index ad17c6ffca06..0c7359cdab92 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -626,6 +626,8 @@ static int lease_init(struct file *filp, long type, unsigned int flags,
 	fl->fl_flags = FL_LEASE;
 	if (flags & FL_LAYOUT)
 		fl->fl_flags |= FL_LAYOUT;
+	if (flags & FL_EXCLUSIVE)
+		fl->fl_flags |= FL_EXCLUSIVE;
 	fl->fl_start = 0;
 	fl->fl_end = OFFSET_MAX;
 	fl->fl_ops = NULL;
@@ -1619,6 +1621,14 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 	list_for_each_entry_safe(fl, tmp, &ctx->flc_lease, fl_list) {
 		if (!leases_conflict(fl, new_fl))
 			continue;
+		if (fl->fl_flags & FL_EXCLUSIVE) {
+			error = -ETXTBSY;
+			if (new_fl->fl_pid == fl->fl_pid) {
+				error = -EDEADLOCK;
+				goto out;
+			}
+			continue;
+		}
 		if (want_write) {
 			if (fl->fl_flags & FL_UNLOCK_PENDING)
 				continue;
@@ -1634,6 +1644,13 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 			locks_delete_lock_ctx(fl, &dispose);
 	}
 
+	/* We differentiate between -EDEADLOCK and -ETXTBSY so the above loop
+	 * continues with -ETXTBSY looking for a potential deadlock instead.
+	 * If deadlock is not found go ahead and return -ETXTBSY.
+	 */
+	if (error == -ETXTBSY)
+		goto out;
+
 	if (list_empty(&ctx->flc_lease))
 		goto out;
 
@@ -2044,9 +2061,11 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
 	 * to revoke the lease in break_layout()  And this is done by using
 	 * F_WRLCK in the break code.
 	 */
-	if (arg == F_LAYOUT) {
+	if ((arg & F_LAYOUT) == F_LAYOUT) {
+		if ((arg & F_EXCLUSIVE) == F_EXCLUSIVE)
+			flags |= FL_EXCLUSIVE;
 		arg = F_RDLCK;
-		flags = FL_LAYOUT;
+		flags |= FL_LAYOUT;
 	}
 
 	fl = lease_alloc(filp, arg, flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd60d5be9886..2e41ce547913 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1005,6 +1005,7 @@ static inline struct file *get_file(struct file *f)
 #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
 #define FL_OFDLCK	1024	/* lock is "owned" by struct file */
 #define FL_LAYOUT	2048	/* outstanding pNFS layout or user held pin */
+#define FL_EXCLUSIVE	4096	/* Layout lease is exclusive */
 
 #define FL_CLOSE_POSIX (FL_POSIX | FL_CLOSE)
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index baddd54f3031..88b175ceccbc 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -176,6 +176,8 @@ struct f_owner_ex {
 
 #define F_LAYOUT	16      /* layout lease to allow longterm pins such as
 				   RDMA */
+#define F_EXCLUSIVE	32      /* layout lease is exclusive */
+				/* FIXME or shoudl this be F_EXLCK??? */
 
 /* operations for bsd flock(), also used by the kernel implementation */
 #define LOCK_SH		1	/* shared lock */
-- 
2.20.1
