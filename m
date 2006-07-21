Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 23:19:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L6JJDW031772
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 23:19:31 -0700
Message-ID: <44C07168.60904@sgi.com>
Date: Fri, 21 Jul 2006 16:17:12 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs FAQ update for write cache
References: <200607200602.k6K62Lsp32974694@snort.melbourne.sgi.com> <200607200955.36136.Martin@lichtvoll.de>
In-Reply-To: <200607200955.36136.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Hi Martin,

Martin Steigerwald wrote:
> Am Donnerstag 20 Juli 2006 08:02 schrieb Timothy Shimmin:
>> Modid:  current:xfs-website:212892a
>> faq.html - 1.88 - changed
>> 	- Update info about write cache.
>> 	  Mention persistent write cache, external logs,
>> 	  checking it was actually enabled in xfs msgs.
> 
> Hello Timothy,
> 
> thanks a lot... thats awesome... I have that directory corruption problem 
> also mentioned in the FAQ on a workstation at work. When you have a new 
> xfs_check available I can test it. (I know how to compile it under 
> Knoppix 5 ;-).
> 
> A little feedback: lines are not wrapped in either Firefox or Konqueror 
> (http://oss.sgi.com/projects/xfs/faq.html). This is for the complete FAQ. 
> It makes reading it difficult.
I believe Nathan has fixed this now.

> 
> It might make sense to include the log messages when barriers are disabled 
> at the approbiate places of the FAQ:
> 
Yeah, I was thinking of that - like Dave (dgc) did in his reply.
If you think that is helpful.

> root@deepdance:/usr/src/linux/fs/xfs -> grep -ir "barrier" *
> linux-2.6/xfs_super.c:xfs_mountfs_check_barriers(xfs_mount_t *mp)
> linux-2.6/xfs_super.c:            "Disabling barriers, not supported with 
> external log device");
> linux-2.6/xfs_super.c:          mp->m_flags &= ~XFS_MOUNT_BARRIER;
> linux-2.6/xfs_super.c:            "Disabling barriers, not supported by 
> the underlying device");
> linux-2.6/xfs_super.c:          mp->m_flags &= ~XFS_MOUNT_BARRIER;
> linux-2.6/xfs_super.c:  error = xfs_barrier_test(mp);
> linux-2.6/xfs_super.c:            "Disabling barriers, trial barrier write 
> failed");
> linux-2.6/xfs_super.c:          mp->m_flags &= ~XFS_MOUNT_BARRIER;
> 
> While they are quite self-explanatory it might still help to make it 
> absolutely clear what each log message mean.
Ok.

> 
> Is the last one  "Disabling barriers, trial barrier write failed" issued 
> when the underlying device does not support write barriers?

You mean is it the same as the msg:
"Disabling barriers, not supported by the underlying device" ;-)
I guess the end result is pretty much the same but the test is
different. I didn't write the code (Christoph could provide more
info here) but looking at it now...

The "trial barrier write" actually tries a barrier write on the
superblock and sees if we get an error back.

Whereas the "not supported by" case, we use the information set by
the driver for the block layer - it sets one of the ordered modes
as described in the doc you quoted Documentation/block/barrier.txt.
We test for QUEUE_ORDERED_NONE to give this message.
The doc says:
   QUEUE_ORDERED_NONE
       I/O barriers are not needed and/or supported.
Looking at IDE case, it would set ordered mode to NONE if
write cache was on and not supported by drive.
But I guess perhaps the only definitive way to be sure is to
try it out and hence the trial write.

And as for the external log case, we _may_ end up changing the
code to flush on the data device and log device and so not
need this message and action. We'll see.

Cheers,
Tim.
