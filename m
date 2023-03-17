Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FC4C76196
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCQLIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCQLIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:49 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776F528EA8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:43 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v16so4084534wrn.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEnBZ7cY3XwVYz9pj+LbW9TyrRM8DzdvnhMYIo+uxZw=;
        b=oCst3Hy6sVBCcffIP+/oNMh8p9f5PGiEmASdHAmtwVotVgmpiFhusOYQENPpfSEliS
         9kldvZ3spA/DW+1YqjpJmVRHETJgy/RxHi5WLcCcwD8CvCjvUVvLNamM0fM0EMc6UiwP
         eSJGmmyF/qtkj1jHXtcPLtTH7BA+fQwouyPcSoNCsb9WpPy2BIFr+t4LQP6HXoM50eVS
         J97T89tqMZjFcKq/RFrCW48xEuKO41oWfslXtCarNZA9bF4hijcZHMYmASib/D9XsK7i
         Hvnrw8oIQv4RxzvNVorYY0rAfivgsiJhPpckuAuRUUJfJ/rFO1/PKyY1GcRBtwoZa4qa
         qW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wEnBZ7cY3XwVYz9pj+LbW9TyrRM8DzdvnhMYIo+uxZw=;
        b=aGErdAFeiJGZIOotDizyVcxFbeesE+vLNfQpMoFyITDsOgIYcDKRb7qGGdHCbs4do8
         yGGR/3RmRKXnlln1B52oQOXMIv1cSVcEXlUm19iQ4nQDfcz0u+1w9D7g3nOhfo9fz1yt
         9RdPD9MDIbmVeva5Ga0AIpoSoFctoVfgvkR01Bw2wGdF8nFMXO7n1L4kGZJCBfY9aWIC
         x+17BftRJ4Lqn5tAL46WHBPxp0znfkCEjgoFUs76/zdiKTRc3RmZ3hav8YXTym5hN0F8
         QfInm8JRFZW2impqm2IRw1I6zDbL7uLye/Rb/6Q7pdHxR67b9d20vJiRFjaRo6C7+Ubf
         3OQQ==
X-Gm-Message-State: AO0yUKWrMYC2ljjOy7dioS1IMUtMNebTl3niObg18cFQc1iJdel92Ujm
        jilSlUjLGmEItfS6s+uICiQ=
X-Google-Smtp-Source: AK7set/9U+RfkL6UMtRAza8P2n5vMjKx4VqjE/lQmBEmhca5VYhd2JMa6FqCAHU7HI6FOHiqv1jXWA==
X-Received: by 2002:a5d:6044:0:b0:2cf:e956:9740 with SMTP id j4-20020a5d6044000000b002cfe9569740mr2025059wrt.6.1679051321981;
        Fri, 17 Mar 2023 04:08:41 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 13/15] attr: use consistent sgid stripping checks
Date:   Fri, 17 Mar 2023 13:08:15 +0200
Message-Id: <20230317110817.1226324-14-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

commit ed5a7047d2011cb6b2bf84ceb6680124cc6a7d95 upstream.

[backported to 5.10.y, prior to idmapped mounts]

Currently setgid stripping in file_remove_privs()'s should_remove_suid()
helper is inconsistent with other parts of the vfs. Specifically, it only
raises ATTR_KILL_SGID if the inode is S_ISGID and S_IXGRP but not if the
inode isn't in the caller's groups and the caller isn't privileged over the
inode although we require this already in setattr_prepare() and
setattr_copy() and so all filesystem implement this requirement implicitly
because they have to use setattr_{prepare,copy}() anyway.

But the inconsistency shows up in setgid stripping bugs for overlayfs in
xfstests (e.g., generic/673, generic/683, generic/685, generic/686,
generic/687). For example, we test whether suid and setgid stripping works
correctly when performing various write-like operations as an unprivileged
user (fallocate, reflink, write, etc.):

echo "Test 1 - qa_user, non-exec file $verb"
setup_testfile
chmod a+rws $junk_file
commit_and_check "$qa_user" "$verb" 64k 64k

The test basically creates a file with 6666 permissions. While the file has
the S_ISUID and S_ISGID bits set it does not have the S_IXGRP set. On a
regular filesystem like xfs what will happen is:

sys_fallocate()
-> vfs_fallocate()
   -> xfs_file_fallocate()
      -> file_modified()
         -> __file_remove_privs()
            -> dentry_needs_remove_privs()
               -> should_remove_suid()
            -> __remove_privs()
               newattrs.ia_valid = ATTR_FORCE | kill;
               -> notify_change()
                  -> setattr_copy()

In should_remove_suid() we can see that ATTR_KILL_SUID is raised
unconditionally because the file in the test has S_ISUID set.

But we also see that ATTR_KILL_SGID won't be set because while the file
is S_ISGID it is not S_IXGRP (see above) which is a condition for
ATTR_KILL_SGID being raised.

So by the time we call notify_change() we have attr->ia_valid set to
ATTR_KILL_SUID | ATTR_FORCE. Now notify_change() sees that
ATTR_KILL_SUID is set and does:

ia_valid = attr->ia_valid |= ATTR_MODE
attr->ia_mode = (inode->i_mode & ~S_ISUID);

which means that when we call setattr_copy() later we will definitely
update inode->i_mode. Note that attr->ia_mode still contains S_ISGID.

Now we call into the filesystem's ->setattr() inode operation which will
end up calling setattr_copy(). Since ATTR_MODE is set we will hit:

if (ia_valid & ATTR_MODE) {
        umode_t mode = attr->ia_mode;
        vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
        if (!vfsgid_in_group_p(vfsgid) &&
            !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
                mode &= ~S_ISGID;
        inode->i_mode = mode;
}

and since the caller in the test is neither capable nor in the group of the
inode the S_ISGID bit is stripped.

But assume the file isn't suid then ATTR_KILL_SUID won't be raised which
has the consequence that neither the setgid nor the suid bits are stripped
even though it should be stripped because the inode isn't in the caller's
groups and the caller isn't privileged over the inode.

If overlayfs is in the mix things become a bit more complicated and the bug
shows up more clearly. When e.g., ovl_setattr() is hit from
ovl_fallocate()'s call to file_remove_privs() then ATTR_KILL_SUID and
ATTR_KILL_SGID might be raised but because the check in notify_change() is
questioning the ATTR_KILL_SGID flag again by requiring S_IXGRP for it to be
stripped the S_ISGID bit isn't removed even though it should be stripped:

sys_fallocate()
-> vfs_fallocate()
   -> ovl_fallocate()
      -> file_remove_privs()
         -> dentry_needs_remove_privs()
            -> should_remove_suid()
         -> __remove_privs()
            newattrs.ia_valid = ATTR_FORCE | kill;
            -> notify_change()
               -> ovl_setattr()
                  // TAKE ON MOUNTER'S CREDS
                  -> ovl_do_notify_change()
                     -> notify_change()
                  // GIVE UP MOUNTER'S CREDS
     // TAKE ON MOUNTER'S CREDS
     -> vfs_fallocate()
        -> xfs_file_fallocate()
           -> file_modified()
              -> __file_remove_privs()
                 -> dentry_needs_remove_privs()
                    -> should_remove_suid()
                 -> __remove_privs()
                    newattrs.ia_valid = attr_force | kill;
                    -> notify_change()

The fix for all of this is to make file_remove_privs()'s
should_remove_suid() helper to perform the same checks as we already
require in setattr_prepare() and setattr_copy() and have notify_change()
not pointlessly requiring S_IXGRP again. It doesn't make any sense in the
first place because the caller must calculate the flags via
should_remove_suid() anyway which would raise ATTR_KILL_SGID.

While we're at it we move should_remove_suid() from inode.c to attr.c
where it belongs with the rest of the iattr helpers. Especially since it
returns ATTR_KILL_S{G,U}ID flags. We also rename it to
setattr_should_drop_suidgid() to better reflect that it indicates both
setuid and setgid bit removal and also that it returns attr flags.

Running xfstests with this doesn't report any regressions. We should really
try and use consistent checks.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 31 +++++++++++++++++--------------
 fs/inode.c                     |  2 +-
 fs/ocfs2/file.c                |  4 ++--
 fs/open.c                      |  6 +++---
 include/linux/fs.h             |  2 +-
 6 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
index 87cf5c010d5d..ed2e45f9b762 100644
--- a/Documentation/trace/ftrace.rst
+++ b/Documentation/trace/ftrace.rst
@@ -2923,7 +2923,7 @@ Produces::
               bash-1994  [000] ....  4342.324898: ima_get_action <-process_measurement
               bash-1994  [000] ....  4342.324898: ima_match_policy <-ima_get_action
               bash-1994  [000] ....  4342.324899: do_truncate <-do_last
-              bash-1994  [000] ....  4342.324899: should_remove_suid <-do_truncate
+              bash-1994  [000] ....  4342.324899: setattr_should_drop_suidgid <-do_truncate
               bash-1994  [000] ....  4342.324899: notify_change <-do_truncate
               bash-1994  [000] ....  4342.324900: current_fs_time <-notify_change
               bash-1994  [000] ....  4342.324900: current_kernel_time <-current_fs_time
diff --git a/fs/attr.c b/fs/attr.c
index c8049ae34a2e..326a0db3296d 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -45,34 +45,37 @@ int setattr_should_drop_sgid(const struct inode *inode)
 	return 0;
 }
 
-/*
- * The logic we want is
+/**
+ * setattr_should_drop_suidgid - determine whether the set{g,u}id bit needs to
+ *                               be dropped
+ * @inode:	inode to check
+ *
+ * This function determines whether the set{g,u}id bits need to be removed.
+ * If the setuid bit needs to be removed ATTR_KILL_SUID is returned. If the
+ * setgid bit needs to be removed ATTR_KILL_SGID is returned. If both
+ * set{g,u}id bits need to be removed the corresponding mask of both flags is
+ * returned.
  *
- *	if suid or (sgid and xgrp)
- *		remove privs
+ * Return: A mask of ATTR_KILL_S{G,U}ID indicating which - if any - setid bits
+ * to remove, 0 otherwise.
  */
-int should_remove_suid(struct dentry *dentry)
+int setattr_should_drop_suidgid(struct inode *inode)
 {
-	umode_t mode = d_inode(dentry)->i_mode;
+	umode_t mode = inode->i_mode;
 	int kill = 0;
 
 	/* suid always must be killed */
 	if (unlikely(mode & S_ISUID))
 		kill = ATTR_KILL_SUID;
 
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
+	kill |= setattr_should_drop_sgid(inode);
 
 	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
 		return kill;
 
 	return 0;
 }
-EXPORT_SYMBOL(should_remove_suid);
+EXPORT_SYMBOL(setattr_should_drop_suidgid);
 
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
@@ -350,7 +353,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 		}
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+		if (mode & S_ISGID) {
 			if (!(ia_valid & ATTR_MODE)) {
 				ia_valid = attr->ia_valid |= ATTR_MODE;
 				attr->ia_mode = inode->i_mode;
diff --git a/fs/inode.c b/fs/inode.c
index f52dd6feea98..7ec90788d8be 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1868,7 +1868,7 @@ int dentry_needs_remove_privs(struct dentry *dentry)
 	if (IS_NOSEC(inode))
 		return 0;
 
-	mask = should_remove_suid(dentry);
+	mask = setattr_should_drop_suidgid(inode);
 	ret = security_inode_need_killpriv(dentry);
 	if (ret < 0)
 		return ret;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1470b49adb2d..ca00cac5a12f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1994,7 +1994,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
-	if (file && should_remove_suid(file->f_path.dentry)) {
+	if (file && setattr_should_drop_suidgid(file_inode(file))) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -2282,7 +2282,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * inode. There's also the dinode i_size state which
 		 * can be lost via setattr during extending writes (we
 		 * set inode->i_size at the end of a write. */
-		if (should_remove_suid(dentry)) {
+		if (setattr_should_drop_suidgid(inode)) {
 			if (meta_level == 0) {
 				ocfs2_inode_unlock_for_extent_tree(inode,
 								   &di_bh,
diff --git a/fs/open.c b/fs/open.c
index b3fbb4300fc9..1ca4b236fdbe 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -665,10 +665,10 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 		newattrs.ia_valid |= ATTR_GID;
 		newattrs.ia_gid = gid;
 	}
-	if (!S_ISDIR(inode->i_mode))
-		newattrs.ia_valid |=
-			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	inode_lock(inode);
+	if (!S_ISDIR(inode->i_mode))
+		newattrs.ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV |
+				     setattr_should_drop_sgid(inode);
 	error = security_path_chown(path, uid, gid);
 	if (!error)
 		error = notify_change(path->dentry, &newattrs, &delegated_inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 527791e4860b..57afa4fa5e7b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2960,7 +2960,7 @@ extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
-extern int should_remove_suid(struct dentry *);
+extern int setattr_should_drop_suidgid(struct inode *);
 extern int file_remove_privs(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
-- 
2.34.1

