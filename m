Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 02:32:04 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6M9VlDW022775
	for <linux-xfs@oss.sgi.com>; Sat, 22 Jul 2006 02:31:48 -0700
Received: from localhost (dslb-084-056-114-021.pools.arcor-ip.net [84.56.114.21])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id D61ABFA8A7
	for <linux-xfs@oss.sgi.com>; Sat, 22 Jul 2006 11:28:29 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS and write barrier
Date: Sat, 22 Jul 2006 11:31:15 +0200
References: <200607151248.56603.Martin@lichtvoll.de> <200607182027.49648.Martin@lichtvoll.de> <20060718192135.GV15160733@melbourne.sgi.com>
In-Reply-To: <20060718192135.GV15160733@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607221131.16238.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 18 Juli 2006 21:21 schrieb David Chinner:

> > > blkdev_issue_flush() causes a write cache flush - just like a
> > > barrier typically causes a write cache flush up to the I/O with the
> > > barrier in it.  Both of these mechanisms provide the same thing -
> > > an I/O barrier that enforces ordering of I/Os to disk.
> >
> > Hello David,
> >
> > well now it gets interesting. If both provide the same thing, whats
> > the difference?
>
> A WRITE_BARRIER I/O can be optimised by smart drivers, protocols and
> hardware to minimise the adverse effects of the barrier, whereas a
> cache flush is a brute force cache cleaning mechanism that cannot be
> optimised....

Hello David,

I like to understand this difference a bit better.

As far as I understand there are three important differences between 
blkdev_issue_flush() and using the new barrier functionality:

1) blkdev_issue_flush() issues a cache flush synchronously and the 
filesystem has to wait for it to return. OTOH a write barrier is like a 
asynchron cache flush: The filesystem sends a barrier request to the 
block layer and forgets about it then. It can handle other stuff in the 
meanwhile while block layer will take care of the correct order of the 
write requests.

2) Since the filesystem offloads the ordering of the requests to the block 
layer, block layer can support smart drivers, protocols and hardware to 
optimize request ordering (say TCQ devices for example).

3) A direct cache flush means that the cache flush has to happen 
immediately while with a barrier it can happen some time in the future 
given that it happens before the barrier request is issued.  

So the advantages of the barrier functionality that is that it provides 
request ordering at a lower cost for the filesystem.

Anything to add or correct?

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
