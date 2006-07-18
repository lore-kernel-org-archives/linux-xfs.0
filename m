Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 11:28:48 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6IISXDW011729
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 11:28:34 -0700
Received: from localhost (dslb-084-056-120-082.pools.arcor-ip.net [84.56.120.82])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 7D5F6FA68B
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 20:25:40 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS and write barrier
Date: Tue, 18 Jul 2006 20:27:48 +0200
References: <200607151248.56603.Martin@lichtvoll.de> <17596.41680.124148.595601@cse.unsw.edu.au> <20060718170406.GT15160733@melbourne.sgi.com>
In-Reply-To: <20060718170406.GT15160733@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607182027.49648.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 18 Juli 2006 19:04 schrieb David Chinner:

> > "Journalling filesystems need write barrier" isn't really accurate.
> > They can make good use of write barrier if it is supported, and where
> > it isn't supported, they should use blkdev_issue_flush in combination
> > with regular submit/wait.
>
> blkdev_issue_flush() causes a write cache flush - just like a
> barrier typically causes a write cache flush up to the I/O with the
> barrier in it.  Both of these mechanisms provide the same thing - an
> I/O barrier that enforces ordering of I/Os to disk.

Hello David,

well now it gets interesting. If both provide the same thing, whats the 
difference?

> Given that filesystems already indicate to the block layer when they
> want a barrier, wouldn't it be better to get the block layer to issue
> this cache flush if the underlying device doesn't support barriers
> and it receives a barrier request?

Does a device need to support more than this cache flush in order to 
support barriers? Up to know I thought that when a device supports cache 
flushes the kernel can provide barrier functinality for it.

I see in boot output that my notebook harddisk supports cache flushes. But 
not in dmesg nor in syslog. I don't know yet how to actually determine 
whether barrier functionality is really usable on a certain system. 

> FWIW, Only XFS and Reiser3 use this function, and only then when
> issuing a fsync when barriers are disabled to make sure a common
> test (fsync then power cycle) doesn't result in data loss...

So will XFS be safe even without write barriers? What will it do when it 
cannot do write barriers but write barriers are requested by the user or 
the inbuilt default setting of the filesystem? Will it work unsafely or 
will mount readonly or disable write caches in that case?

I think I need to read / learn even more to get a complete picture of 
this.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
