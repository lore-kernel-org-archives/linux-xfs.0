Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 20F707F56
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 06:35:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1FFA304032
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:14 -0700 (PDT)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
	[209.85.220.42]) by cuda.sgi.com with ESMTP id 8rOBTYqu6QvSXJoX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:12 -0700 (PDT)
Received: by pacwe9 with SMTP id we9so62576960pac.1
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:12 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 1/5] new helper: iov_iter_rw()
Date: Mon, 16 Mar 2015 04:33:49 -0700
Message-Id: <34dc78b262546e9343e0ed872232a97f5eaa5f15.1426502566.git.osandov@osandov.com>
In-Reply-To: <cover.1426502566.git.osandov@osandov.com>
References: <cover.1426502566.git.osandov@osandov.com>
In-Reply-To: <cover.1426502566.git.osandov@osandov.com>
References: <cover.1426502566.git.osandov@osandov.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, osd-dev@open-osd.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, HPDD-discuss@lists.01.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Changman Lee <cm224.lee@samsung.com>, Boaz Harrosh <ooo@electrozaur.com>, Eric Van Hensbergen <ericvh@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Oleg Drokin <oleg.drokin@intel.com>, Joel Becker <jlbec@evilplan.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Benny Halevy <bhalevy@primarydata.com>, Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Ron Minnich <rminnich@sandia.gov>, Omar Sandoval <osandov@osandov.com>, Anna Schumaker <anna.schumaker@netapp.com>

Get either READ or WRITE out of iter->type.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 include/linux/uio.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 7188029..87a47b3 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -10,6 +10,7 @@
 #define __LINUX_UIO_H
 
 #include <linux/kernel.h>
+#include <linux/fs.h>
 #include <uapi/linux/uio.h>
 
 struct page;
@@ -111,6 +112,15 @@ static inline bool iter_is_iovec(struct iov_iter *i)
 }
 
 /*
+ * Get one of READ or WRITE out of iter->type without any other flags OR'd in
+ * with it.
+ */
+static inline int iov_iter_rw(const struct iov_iter *i)
+{
+	return i->type & RW_MASK;
+}
+
+/*
  * Cap the iov_iter by given limit; note that the second argument is
  * *not* the new size - it's upper limit for such.  Passing it a value
  * greater than the amount of data in iov_iter is fine - it'll just do
-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
