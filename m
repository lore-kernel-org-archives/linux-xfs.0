Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C7F77CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 16:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A4D2AC001
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 14:53:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rKWc64Jh1aIJECDB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Sep 2016 14:53:53 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A014465F5D
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 21:53:52 +0000 (UTC)
Received: from Liberator.example.com (ovpn03.gateway.prod.ext.phx2.redhat.com
	[10.5.9.3])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u8FLrpQC014513
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 17:53:52 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: Enable 3 more foreign commands
Message-ID: <5fe315ee-1198-ca43-16a0-13562ced179e@redhat.com>
Date: Thu, 15 Sep 2016 16:53:51 -0500
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
To: xfs-oss <xfs@oss.sgi.com>

Enable restore, limit, and timer.

Unsupported commands remain, for lack of kernel support, generally:
warn, quot,, enable, disable, and remove.

xfs_quota> report
User quota on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
                               Blocks                     
User ID          Used       Soft       Hard    Warn/Grace     
---------- -------------------------------------------------- 
root               13          0          0     00 [--------]

xfs_quota> restore -f quotadump
xfs_quota> report
User quota on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
                               Blocks                     
User ID          Used       Soft       Hard    Warn/Grace     
---------- -------------------------------------------------- 
root               13          0          0     00 [--------]
testuser            0      16384      32768     00 [--------]
fsgqa               0     102400     112640     00 [--------]

xfs_quota> limit bsoft=200m fsgqa

xfs_quota> report 
User quota on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
                               Blocks                     
User ID          Used       Soft       Hard    Warn/Grace     
---------- -------------------------------------------------- 
root               13          0          0     00 [--------]
testuser            0      16384      32768     00 [--------]
fsgqa               0     204800     112640     00 [--------]

xfs_quota> state -u
User quota state on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
  Accounting: ON
  Enforcement: ON
  Inode: #12 (16 blocks, 1 extents)
Blocks grace time: [7 days]
Inodes grace time: [7 days]

xfs_quota> timer -b 3days
xfs_quota> state -u
User quota state on /mnt/test2/git/xfsprogs/mnt (/dev/loop0)
  Accounting: ON
  Enforcement: ON
  Inode: #12 (16 blocks, 1 extents)
Blocks grace time: [3 days]
Inodes grace time: [7 days]
Realtime Blocks grace time: [--------]

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/edit.c b/quota/edit.c
index e5ddc8c..36b327a 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -709,6 +709,7 @@ edit_init(void)
 	_("[-g|-p|-u] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
 	limit_cmd.oneline = _("modify quota limits");
 	limit_cmd.help = limit_help;
+	limit_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	restore_cmd.name = "restore";
 	restore_cmd.cfunc = restore_f;
@@ -716,6 +717,7 @@ edit_init(void)
 	restore_cmd.argmax = -1;
 	restore_cmd.args = _("[-g|-p|-u] [-f file]");
 	restore_cmd.oneline = _("restore quota limits from a backup file");
+	restore_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	timer_cmd.name = "timer";
 	timer_cmd.cfunc = timer_f;
@@ -724,6 +726,7 @@ edit_init(void)
 	timer_cmd.args = _("[-bir] [-g|-p|-u] value");
 	timer_cmd.oneline = _("set quota enforcement timeouts");
 	timer_cmd.help = timer_help;
+	timer_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	warn_cmd.name = "warn";
 	warn_cmd.cfunc = warn_f;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
