Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E85F7CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 17:58:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10CDDAC003
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 15:58:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fEZaTAr4IIHSXL5E (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Sep 2016 15:58:28 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: un-flag non-foreign-capable commands
Message-ID: <294717b5-f997-ca39-2095-cc144a71de47@redhat.com>
Date: Thu, 15 Sep 2016 17:58:26 -0500
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

The off command calls XFS_QUOTAOFF / Q_XQUOTAOFF, which calls
quota_disable in the kernel, which returns ENOSYS if the
->quota_enable quota op doesn't exist - and it does not exist
on any non-xfs filesystems.

We could get clever if we wanted it, and send Q_QUOTAOFF
instead for foreign filesystems, but for now it's broken
so just remove the flag.

The free command relies on XFS_IOC_FSGEOMETRY_V1, so unflag it
as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/state.c b/quota/state.c
index 05e4ec5..09dfa70 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -584,7 +584,6 @@ state_init(void)
 	off_cmd.args = _("[-gpu] [-v]");
 	off_cmd.oneline = _("permanently switch quota off for a path");
 	off_cmd.help = off_help;
-	off_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	state_cmd.name = "state";
 	state_cmd.cfunc = state_f;
diff --git a/quota/free.c b/quota/free.c
index b9be954..3c8a5ce 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -372,7 +372,6 @@ free_init(void)
 	free_cmd.args = _("[-bir] [-hn] [-f file]");
 	free_cmd.oneline = _("show free and used counts for blocks and inodes");
 	free_cmd.help = free_help;
-	free_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	add_command(&free_cmd);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
