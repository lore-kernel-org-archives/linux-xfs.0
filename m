Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B15C4363D
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 01:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04E2021531
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 01:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJABP4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 21:15:56 -0400
Received: from icp-osb-irony-out6.external.iinet.net.au ([203.59.1.106]:1959
        "EHLO icp-osb-irony-out6.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgJABP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 21:15:56 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 21:15:54 EDT
X-SMTP-MATCH: 0
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AtNgCLKnVf//3vRWpgHgEBCxIMQAe?=
 =?us-ascii?q?BSoFzgXpfhD2JAoYyTgEBAQEBAQaBFIRFhX+QCIF8CwEBAQEBAQEBARwZAQI?=
 =?us-ascii?q?EAQGERQSCNiY6BA0CEAEBAQUBAQEBAQYDAYZVhhwEL1gCGA4CSRYBEoV+JLV?=
 =?us-ascii?q?OfzOKR4EOKoZbgkGELXmBB4ERMwOBMoFmhCWDL4JgBJM1hyWBGVGaf4Jxmlg?=
 =?us-ascii?q?igw6POo5MAZMKoiQLgWxNLgo7gmlQGQ2cczcwNwIGCgEBAwlZAQGOLAEB?=
X-IPAS-Result: =?us-ascii?q?A2AtNgCLKnVf//3vRWpgHgEBCxIMQAeBSoFzgXpfhD2JA?=
 =?us-ascii?q?oYyTgEBAQEBAQaBFIRFhX+QCIF8CwEBAQEBAQEBARwZAQIEAQGERQSCNiY6B?=
 =?us-ascii?q?A0CEAEBAQUBAQEBAQYDAYZVhhwEL1gCGA4CSRYBEoV+JLVOfzOKR4EOKoZbg?=
 =?us-ascii?q?kGELXmBB4ERMwOBMoFmhCWDL4JgBJM1hyWBGVGaf4Jxmlgigw6POo5MAZMKo?=
 =?us-ascii?q?iQLgWxNLgo7gmlQGQ2cczcwNwIGCgEBAwlZAQGOLAEB?=
X-IronPort-AV: E=Sophos;i="5.77,322,1596470400"; 
   d="scan'208";a="268660902"
Received: from 106-69-239-253.dyn.iinet.net.au (HELO mickey.themaw.net) ([106.69.239.253])
  by icp-osb-irony-out6.iinet.net.au with ESMTP; 01 Oct 2020 09:06:31 +0800
Subject: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Date:   Thu, 01 Oct 2020 09:06:31 +0800
Message-ID: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some of the xfsprogs utilities read the mount table via. getmntent(3).

The mount table may contain (almost always these days since /etc/mtab is
symlinked to /proc/self/mounts) autofs mount entries. During processing
of the mount table entries statfs(2) can be called on mount point paths
which will trigger an automount if those entries are direct or offset
autofs mount triggers (indirect autofs mounts aren't affected).

This can be a problem when there are a lot of autofs direct or offset
mounts because real mounts will be triggered when statfs(2) is called.
This can be particularly bad if the triggered mounts are NFS mounts and
the server is unavailable leading to lengthy boot times or worse.

Simply ignoring autofs mount entries during getmentent(3) traversals
avoids the statfs() call that triggers these mounts. If there are
automounted mounts (real mounts) at the time of reading the mount table
these will still be seen in the list so they will be included if that
actually matters to the reader.

Recent glibc getmntent(3) can ignore autofs mounts but that requires the
autofs user to configure autofs to use the "ignore" pseudo mount option
for autofs mounts. But this isn't yet the autofs default (to prevent
unexpected side effects) so that can't be used.

The autofs direct and offset automount triggers are pseudo file system
mounts and are more or less useless in terms on file system information
so excluding them doesn't sacrifice useful file system information
either.

Consequently excluding autofs mounts shouldn't have any adverse side
effects.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fsr/xfs_fsr.c   |    3 +++
 libfrog/linux.c |    2 ++
 libfrog/paths.c |    2 ++
 3 files changed, 7 insertions(+)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 77a10a1d..466ad9e4 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -323,6 +323,9 @@ initallfs(char *mtab)
 	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
 		int rw = 0;
 
+		if (!strcmp(mnt->mnt_type, "autofs"))
+			continue;
+
 		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
 		    stat(mnt->mnt_fsname, &sb) == -1 ||
 		    !S_ISBLK(sb.st_mode))
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 40a839d1..a45d99ab 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -73,6 +73,8 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
 	 * servers.  So first, a simple check: does the "dev" start with "/" ?
 	 */
 	while ((mnt = getmntent(f)) != NULL) {
+		if (!strcmp(mnt->mnt_type, "autofs"))
+			continue;
 		if (mnt->mnt_fsname[0] != '/')
 			continue;
 		if (stat(mnt->mnt_dir, &mst) < 0)
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 32737223..d6793764 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -389,6 +389,8 @@ fs_table_initialise_mounts(
 			return errno;
 
 	while ((mnt = getmntent(mtp)) != NULL) {
+		if (!strcmp(mnt->mnt_type, "autofs"))
+			continue;
 		if (!realpath(mnt->mnt_dir, rmnt_dir))
 			continue;
 		if (!realpath(mnt->mnt_fsname, rmnt_fsname))


