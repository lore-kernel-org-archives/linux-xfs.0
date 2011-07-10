Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AFsiYq139595 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 10:54:49 -0500
Received: from zenon.apartia.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AE6D1D81D45
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 08:54:41 -0700 (PDT)
Received: from zenon.apartia.fr (zenon.apartia.fr [82.66.93.83]) by
	cuda.sgi.com with ESMTP id ALKfdUYtAKD8k8HB for
	<xfs@oss.sgi.com>; Sun, 10 Jul 2011 08:54:41 -0700 (PDT)
Date: Sun, 10 Jul 2011 17:54:37 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: xfs_repair stuck?
Message-ID: <20110710155437.GA19200@apartia.fr>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I've lauched xfs_repair on pretty damaged 300G partition and it has been
stuck for a couple hours at this stage:

	bad magic # 0xdbe565b2 in inobt block 19/6115
	expected level 1 got 34602 in inobt block 19/6115
	agi_count 24064, counted 0 in ag 19
	agi_freecount 1375, counted 0 in ag 19
	agi unlinked bucket 0 is 44810432 in ag 19 (inode=2594947264)
	agi unlinked bucket 11 is 44722251 in ag 19 (inode=2594859083)
	agi unlinked bucket 24 is 44811800 in ag 19 (inode=2594948632)
	agi unlinked bucket 32 is 44722400 in ag 19 (inode=2594859232)
	agi unlinked bucket 47 is 65583 in ag 19 (inode=2550202415)
	agi unlinked bucket 48 is 44811056 in ag 19 (inode=2594947888)
	agi unlinked bucket 57 is 45920825 in ag 19 (inode=2596057657)

I tried interrupting and re-launching but it always stops here.

Any idea?

Thanks,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
