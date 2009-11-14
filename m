Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGL63U194113 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:21:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E15C89BB4
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:21:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bGACdRA1BMdhFkOG for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:21:27 -0800 (PST)
Date: Sat, 14 Nov 2009 11:21:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091114162126.GB17658@infradead.org>
References: <20091012233854.GA29446@infradead.org>
	<20091019011600.GO9464@discord.disaster>
	<20091019035426.GB18296@infradead.org>
	<20091020034048.GA9464@discord.disaster>
	<89c4f90c0910210245h4691cd82hd1d63f5ed72fb2e3@mail.gmail.com>
	<20091022085937.GA2039@infradead.org>
	<89c4f90c0910270341r7833f490g60810f2817eb0950@mail.gmail.com>
	<89c4f90c0910280519k759230c1r7b1586932ac792f7@mail.gmail.com>
	<20091030101601.GA11142@infradead.org>
	<4AF0422D.1070104@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AF0422D.1070104@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Tue, Nov 03, 2009 at 03:46:05PM +0100, Patrick Schreurs wrote:
> We're back to 2.6.28 at the moment. Please advice if we can do anything  
> to assist.
>
> Any clue why we seem to be the only one hitting this problem? It might  
> have something to do with the short term data retention on these  
> particular servers. All partitions are always 100% full and data is only  
> kept for a couple of days.

Sorry for the lack of updates, been travelling and working a lot and
didn't have much time to look at your screen dumps.  I really wish where
the magic offset for the NULL pointer dereference comes from.  The 100%
full might be a pretty good hint that is has to deal with ENOSPC
handling somewhere.  I don't know of anything you can help me with for
now, but will come back as soon as I have something more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
