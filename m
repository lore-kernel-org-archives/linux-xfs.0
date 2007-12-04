Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Dec 2007 16:08:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB408ka2002388
	for <xfs@oss.sgi.com>; Mon, 3 Dec 2007 16:08:48 -0800
Received: from timothy-shimmins-power-mac-g5.local (boing.melbourne.sgi.com [134.14.55.141]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA11891 for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 11:08:55 +1100
Message-ID: <47549B1A.4070508@sgi.com>
Date: Tue, 04 Dec 2007 11:11:06 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: 2.6.24-rc3 oopses while mounting fs
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com> <20071203220200.GC13667@luba>
In-Reply-To: <20071203220200.GC13667@luba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi Peter,

FYI

Just a couple of things in case you weren't aware.
Often it is simplest to save the log using the -C option to a file.
        -C filename
               Copy the log from the filesystem to the file filename.
               The log itself is not printed.
The log can then be analysed in various ways later.

Running logprint in operation mode (the default mode without options)
(non-transaction mode without -t)
is really pretty useless without the -s option.
If you use the -s option then one needs to know where to seek to
(you can use -t to find the head/tail or -d to see where log records start).
The problem here is that if you do logprint
like this (no options) then it will start at offset zero and will invariably have
trouble decoding if the log has wrapped around (the general case) as
you'll start in the middle of a record.
So the -t option is often a more interesting starting point as it
will operate more like the file system recovery does, finding the head and tail,
and processing from the tail to the head of the log.

If you want to save the filesystem away for possible metadata debugging later,
then xfs_metadump is your friend.

Cheers,
Tim.

KELEMEN Peter wrote:
> * Lachlan Mcilroy (lachlan@sgi.com) [20071203 14:24]:
> 
> Lachlan,
> 
>> Okay, sounds like it might be a corrupt log.
> 
> Yep.
> 
>> Can you run xfs_logprint on the device or saved log?
> 
> Sure.
> 
> http://cern.ch/fuji/lxfsre1103/xfs_logprint1.txt.bz2
> It aborted though, with the following message:
> 
> 	xfs_logprint: unknown log operation type (343b)
> 	Bad data in log
> 
>> Also give xfs_logprint -t -i a go.
> 
> http://cern.ch/fuji/lxfsre1103/xfs_logprint2.txt.bz2
> 
>> You've saved the log into a file?  You can get the filesystem
>> mounted again by deleting the log with xfs_repair -L <dev>.
>> You'll probably need to run xfs_repair over the filesystem to be
>> safe.
> 
> I conserved this filesystem away for further analysis, I'm not
> sure how helpful it can be.
> 
> Thanks,
> Peter
> 
