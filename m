Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI1sZRM115693 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 19:54:35 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61C6D13C9752
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 17:56:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SrYwrRGz3EuUZIpY for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 17:56:08 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: Hole Punching V3
Date: Wed, 17 Nov 2010 20:46:14 -0500
Message-Id: <1290044780-2902-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz

This is version 3 of the hole punching series I've been posting.  Not much has
changed, the history is below

V2->V3
-FALLOC_FL_PUNCH_HOLE must also have FALLOC_FL_KEEP_SIZE in order to work
-formatting fixes

V1->V2
-Hole punching doesn't change file size
-Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to

I've updated my local copies of the xfsprogs patches I have to test this to use
KEEP_SIZE and PUNCH_HOLE together, I'll post them after it looks like these
patches are good to go, including the manpage update.  The xfstest I wrote ran
fine both on xfs and btrfs (failing on btrfs obviously).  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
