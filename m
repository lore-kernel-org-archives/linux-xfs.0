Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 19:22:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5O2MDkX010811
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:22:13 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 789A512331B6
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:23:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id EXaJM9S5yoqQhfix for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:23:13 -0700 (PDT)
Message-ID: <48605A8E.9070903@sandeen.net>
Date: Mon, 23 Jun 2008 21:23:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: md raid1 passes barriers, but xfs doesn't use them?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

So md raid1 is happy to pass down any barrier writes that it sees, but
this bit in xfs_mountfs_check_barriers() at mount time:

        if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
                                        QUEUE_ORDERED_NONE) {
                xfs_fs_cmn_err(CE_NOTE, mp,
                  "Disabling barriers, not supported by the underlying
device");
                mp->m_flags &= ~XFS_MOUNT_BARRIER;
                return;
        }

winds up with XFS disabling barriers on these devices.  However, if this
is simply commented out, XFS happily tests barriers, finds that they
work, leaves them turned on and all subsequent barrier writes to the
device succeed.

Perhaps what we have here is a failure to communicate?  :)

I'm not sure; *should* XFS be looking for a QUEUE_ORDERED tag?  Should
MD be setting one?  Maybe there should be a QUEUE_ORDERED_PASSTHRU flag?
 Or should XFS just stick with the test write and ignore the flag?  I'm
not sure of the queue->ordered flag details, but it seems that XFS & md
raid1 both try hard to keep barriers in force, and there's a disconnect
here somewhere.

Thanks,
-Eric
