Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L7e6No125048 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 02:40:06 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71BAD160870B
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 00:45:26 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id T3KhPtWHjgBDGMAg
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 00:45:26 -0700 (PDT)
Message-ID: <4E7994D3.5020103@profihost.ag>
Date: Wed, 21 Sep 2011 09:40:03 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
References: <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard>
In-Reply-To: <20110921021133.GM15688@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 21.09.2011 04:11, schrieb Dave Chinner:

> How much memory does your test machine have? The performance will be
> vastly different if there is enough RAM to hold the working set of
> inodes and page cache (~20GB all up), and that could be one of the
> factors contributing to the problems.
The livesystems which crash within hours have between 48GB and 64GB RAM. 
But my testing system has only 8GB.

> The above xfs_info output is from your 160GB SSD - what's the output
> from the 1TB device?

The 1TB device is now doing something else and does not have XFS on it 
anymore. But here are the layouts of two livesystems.

xfs_info /dev/sda6
meta-data=/dev/root              isize=256    agcount=4, agsize=35767872 
blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=143071488, imaxpct=25
          =                       sunit=64     swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=69888, version=2
          =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

xfs_info /dev/sda6
meta-data=/dev/root              isize=256    agcount=4, agsize=35768000 
blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=143071774, imaxpct=25
          =                       sunit=64     swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


> Also, what phase do you see it hanging in? the random stat phase is
> terribly slow on spinning disks, so if I can avoid that it woul dbe
> nice....
Creating or deleting files. never in the stat phase.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
