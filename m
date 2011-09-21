Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LBtWUE139501 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:55:33 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0540317B7DD
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 04:55:31 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id cxfe6rBPcEfOpwsS
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 04:55:31 -0700 (PDT)
Message-ID: <4E79D0B2.2010305@profihost.ag>
Date: Wed, 21 Sep 2011 13:55:30 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
References: <4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard>
In-Reply-To: <20110921114237.GP15688@dastard>
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

Am 21.09.2011 13:42, schrieb Dave Chinner:
> Ok, I got a hang in the random delete phase. Not sure what is wrong
> yet, but inode reclaim is trying to reclaim inodes but failing, and
> the AIL is trying to push items but failing. Hence the tail of the
> log is not being moved forward and new transactions are being
> blocked until log space bcomes available.
OK that matches my findings. It was also mostly in the random delete 
phase. But i've also seen it on creates.

> Given this, just triggering a log force is shoul dget everything
> moving again. Running "echo 2>  /proc/sys/vm/drop_caches" gets inode
> reclaim running in sync mode, which causes pinned inodes to trigger
> a log force. And once I've done this, everything starts running
> again.
Oh man i was thinking about trying this. But then i forgot that idea ;-(

> So, the log force not triggering in the AIL code looks to be the
> problem. That, I simply cannot explain right now - it makes no sense
> but that is what all the stats and trace events point to. I need to
> do more investigation.
Thanks Dave and great that you were able to repeat it.

What helps is to build bonnie++ yourself and just remove the stat tests. 
I've done this too - so bonnie++ runs a lot faster.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
