Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FE787F4E
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 14:18:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 30D198F804B
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 12:18:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lvSIHWbW4vPV5SxB for
	<xfs@oss.sgi.com>; Wed, 26 Jun 2013 12:18:07 -0700 (PDT)
Date: Wed, 26 Jun 2013 12:18:04 -0700
From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH] xfstests: check if the scratch dev pool is mounted in
	_require_scratch
Message-ID: <20130626191804.GA20692@lenny.home.zabbo.net>
References: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

> $SCRATCH_DEV, so anybody who wants to just use the scratch mnt with the scratch
> dev will fail to work because we never unmount the scratch mount.

Yeah, this is annoying.

> Fix this by
> checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
> so we can run our test.  This fixes the issue I was seeing by running

But this fix seems bonkers.  Can we have _scratch_unmount unmount the
mountpoint instead of the device?  That's what Eric suggested when I
whined about this a while ago.

- z

index fe6bbfc..481486a 100644
--- a/common/rc
+++ b/common/rc
@@ -280,7 +280,7 @@ _scratch_mount()
 
 _scratch_unmount()
 {
-    $UMOUNT_PROG $SCRATCH_DEV
+    $UMOUNT_PROG $SCRATCH_MNT
 }
 
 _scratch_remount()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
