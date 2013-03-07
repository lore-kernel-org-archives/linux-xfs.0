Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFD257FBE
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:32:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5F3D304039
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:32:05 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CfqGOgHPTcdzn3KO
	for <xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:32:05 -0800 (PST)
Message-ID: <513896DF.7010609@hardwarefreak.com>
Date: Thu, 07 Mar 2013 07:32:15 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<51380FD3.5010302@hardwarefreak.com>
	<CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
In-Reply-To: <CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Julien FERRERO <jferrero06@gmail.com>
Cc: xfs@oss.sgi.com

On 3/7/2013 7:04 AM, Julien FERRERO wrote:
>> It may be unrelated to your corruption, problem but I'm curious why you
>> are specifying a 32MB log section instead of letting mkfs.xfs make the
>> log size decision.
> 
> I honestly don' know, the rebuild script was written 8 years ago by an
> engineer that since left the company.
> 
> Is 32MB a short log space for a 1.5 TB of data ?

The log is for journal metadata.  So if you're capturing a frame of
video per file, or 24 or 60 frames per file, and thus are writing lots
of files, 32MB may be too small.  I'm not an expert here.  Dave C. would
be better able to answer this.  But this is a very minor problem
compared to...

> Moreover, the common usage is to power off all the equipment (included
> ours) from a general power switch.

this.  Have the crews been hard cutting power to these XFS boxen for the
8 years you mention above?  And this filesystem corruption problem
and/or corrupted files, is just now cropping up?  That's hard to
believe.  There may be a bug in 2.6.35 that exacerbates this that's been
fixed in later versions--2.6.35 is not a long term stable kernel--odd
that a vendor would choose it for long term use.

If you never had this problem before, I can only guess that previously
you were using hardware RAID controllers with BBWC having sufficient
battery hours of cache power to survive until the next power on, at
which point the BBWC RAID dumped the data to the disks.  If you switched
from that solution to non BBWC RAID, or to Linux software RAID, that
might explain why you're seeing corruption now and did not previously.
And even with BBWC RAID, hard cutting power to the system is still not a
smart thing to do.

For this kind of environment, if field techs are going to hard cut power
no matter what you tell them, then you simply MUST get LSI (or possibly
other) RAID cards with the flash backed write cache.  This doesn't rely
on batteries so the cache is never volatile, and can sit overnight, or
for days or weeks, without losing the data in the write cache.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
