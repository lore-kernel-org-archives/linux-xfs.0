Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 03:35:22 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms1.lichtvoll.de [194.150.191.234])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KAZ7DW005487
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 03:35:11 -0700
Received: from localhost (dslb-084-056-078-084.pools.arcor-ip.net [84.56.78.84])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id D4E9FFA8A6
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 12:32:10 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS and write barrier
Date: Thu, 20 Jul 2006 12:34:41 +0200
References: <200607151248.56603.Martin@lichtvoll.de> <200607182027.49648.Martin@lichtvoll.de> <20060718192135.GV15160733@melbourne.sgi.com>
In-Reply-To: <20060718192135.GV15160733@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607201234.42293.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 18 Juli 2006 21:21 schrieb David Chinner:

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

Thanks for your answer. I think now I understand it:

The driver and the drive does a cache flush immediately, but they can 
delay a write barrier related cache flush as long as they make sure that 
they has completed all of the io requests before the write barrier and 
none of the io requests after the write barrier.

The smart driver of a smart drive that supports ordered requests may 
additionally offload request ordering from the operating system to the 
drive.

> > Does a device need to support more than this cache flush in order to
> > support barriers? Up to know I thought that when a device supports
> > cache flushes the kernel can provide barrier functinality for it.
>
> Not necessarily as different device/protocol commands are used.

Do you have any specific information link about this one?

AFAIK it should be possible to implement barrier functionality in the 
driver as soon as the drive supports cache flushes. According to what I 
understand from Documentation/block/barriers.txt, this is this case. That 
would be

"iii. Devices which have queue depth of 1.  This is a degenerate case
of ii.  Just keeping issue order suffices.  Ancient SCSI
controllers/drives and IDE drives are in this category."

in combination with this one:

"iii. Write-back cache and flush operation but no FUA (forced unit
access).  We need two cache flushes - before and after the barrier
request."

The number of cache flushes can be reduced to one if FUA is used:

"iv. Write-back cache, flush operation and FUA.  We still need one
flush to make sure requests preceding a barrier are written to medium,
but post-barrier flush can be avoided by using FUA write on the
barrier itself."

And then there are drives with queue depth greater 1 with support or do 
not support ordered requests.

Ah, I think I finally got all of this and have a complete picture. Lets 
see whether I can put that into a diagram or what ;-).

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
