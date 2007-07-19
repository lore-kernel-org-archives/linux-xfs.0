Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 04:14:49 -0700 (PDT)
Received: from mail.rupa.com (hosted.rupa.com [207.210.101.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JBEbbm009488
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 04:14:39 -0700
Message-ID: <469F6296.9090902@rupa.com>
Date: Thu, 19 Jul 2007 06:09:42 -0700
From: Rupa Schomaker <rupa@rupa.com>
MIME-Version: 1.0
Subject: Re: XFS repair on / in a hosted environment
References: <469E690B.5070600@rupa.com> <20070719023419.GC12413810@sgi.com>
In-Reply-To: <20070719023419.GC12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com



On 7/18/2007 7:34 PM, David Chinner wrote:
> On Wed, Jul 18, 2007 at 12:24:59PM -0700, Rupa Schomaker wrote:
>> I have a virtual server hosted in a XEN environment.  Kernel is
>> 2.6.16.13-XenU and I can't change it. :( Host provider is not responsive
>> to getting us a newer kernel.
>>
>> Anyway, during my nightly rsync backup, I started seeing the following:
> .....
> 
> what does /proc/mounts tell you (rather than /etc/mtab)?
> 
> If /proc/mounts says ro, then try upgrading your xfsprogs package.
> and then retrying the repair....

/proc/mounts shows ro.

What version is new enough?  I'm running debian sarge, so have:

# xfs_repair -V
xfs_repair version 2.9.0

ftp://oss.sgi.com/projects/xfs/cmd_tars/

only shows a xfs_progs up to 2.8.21-1.

> Cheers,
> 
> Dave.

Thanks,

-Rupa
