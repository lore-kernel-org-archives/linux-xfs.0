Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFHDJjC149266 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 11:13:19 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBC78180657
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 09:14:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cL2Rf15iuOnTrDVw for
	<xfs@oss.sgi.com>; Mon, 15 Nov 2010 09:14:50 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: Hole Punching V2
Date: Mon, 15 Nov 2010 12:05:17 -0500
Message-Id: <1289840723-3056-1-git-send-email-josef@redhat.com>
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
To: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

This is version 2 of the hole punching series I posted last week.  The following
things have changed

-Hole punching doesn't change file size
-Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to

I posted updates to xfstests and xfsprogs in order to test this new interface,
and ran the test on xfs to make sure hole punching worked properly for xfs and I
tested it on btrfs to make sure it failed properly.  This series also adds
support for doing hole punching to ocfs2, but I did not test this part of it,
albiet it's an obvious fix so it should work fine.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
