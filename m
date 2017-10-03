Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdJCSxU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 14:53:20 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 1/5] fs: add iterate_supers_reverse()
Date: Tue,  3 Oct 2017 11:53:09 -0700
Message-Id: <20171003185313.1017-2-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-1-mcgrof@kernel.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

There are use cases where we wish to traverse the superblock list
in reverse order. This particular implementation will also enable
to capture errors.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/super.c         | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 2 files changed, 44 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 02da00410de8..d45e92d9a38f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -609,6 +609,49 @@ void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
 	spin_unlock(&sb_lock);
 }
 
+/**
+ *	iterate_supers_reverse - call function for active superblocks in reverse
+ *	@f: function to call
+ *	@arg: argument to pass to it
+ *
+ *	Scans the superblock list and calls given function, passing it
+ *	locked superblock and given argument, in reverse order. Returns if
+ *	an error occurred.
+ */
+int iterate_supers_reverse(int (*f)(struct super_block *, void *), void *arg)
+{
+	struct super_block *sb, *p = NULL;
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
+		if (hlist_unhashed(&sb->s_instances))
+			continue;
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+
+		down_read(&sb->s_umount);
+		if (sb->s_root && (sb->s_flags & SB_BORN)) {
+			error = f(sb, arg);
+			if (error) {
+				spin_lock(&sb_lock);
+				break;
+			}
+		}
+		up_read(&sb->s_umount);
+
+		spin_lock(&sb_lock);
+		if (p)
+			__put_super(p);
+		p = sb;
+	}
+	if (p)
+		__put_super(p);
+	spin_unlock(&sb_lock);
+
+	return error;
+}
+
 /**
  *	iterate_supers_type - call function for superblocks of given type
  *	@type: fs type
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 46796b2f956b..cd084792cf39 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3097,6 +3097,7 @@ extern struct super_block *get_active_super(struct block_device *bdev);
 extern void drop_super(struct super_block *sb);
 extern void drop_super_exclusive(struct super_block *sb);
 extern void iterate_supers(void (*)(struct super_block *, void *), void *);
+extern int iterate_supers_reverse(int (*)(struct super_block *, void *), void *);
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
 
-- 
2.14.0

