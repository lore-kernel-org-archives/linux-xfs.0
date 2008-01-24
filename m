Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 17:25:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0O1PniG020553
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 17:25:53 -0800
Date: Thu, 24 Jan 2008 12:26:34 +1100
Subject: Re: xfs_rapair memory requirement per TB
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <1201042882.32649.256.camel@holwrs01.bp.com> <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080123085339.GB12435@p15145560.pureserver.info> <20080124002828.GC155259@sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t5euakap3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080124002828.GC155259@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs@oss.sgi.com

On Thu, 24 Jan 2008 11:28:28 +1100, David Chinner <dgc@sgi.com> wrote:

> On Wed, Jan 23, 2008 at 09:53:39AM +0100, Ralf Gross wrote:
>> Barry Naujok schrieb:
>> > >
>> > >Reading the "Repairing a possibly incomplete xfs_growfs command?"  
>> thread
>> > >this month makes me wonder if there is some type of rough formula or
>> > >guesstimation cheat sheet to figure out how much memory and swap one
>> > >would need for an xfs_repair given a file system with many terabytes.
>> > >
>> > >
>> > >Say I have an 8TB LUN that needs an xfs_repair.  What would be the  
>> rough
>> > >memory requirements and swap space?
>> > >
>> >
>> > General rule of thumb at the moment is 128MB of RAM/TB of filesystem
>> > plus 4MB/million inodes on that filesystem.
>>
>> Did this change lately? I found the rule of thumb: 2 GB RAM for 1 TB
>> of disk storage + some RAM per x inodes.
>
> The above is based on actual theoretical usage, the below:
>
>> http://oss.sgi.com/archives/xfs/2005-08/msg00045.html
>
> was based on reported usage on during live repair runs.
>
> I think Barry discovered the difference to be things external
> to repair such as heap fragmentation and has since corrected
> the worst of the issues so requirements are, in general,
> much closer to the theoretical numbers now.

Yes, quite a few memory improvements have been made.

Right now, I can repair a 9TB filesystem with ~150 million inodes
in 2GB of RAM without going to swap using xfs_repair 2.9.4 and
with no custom/tuning/config options.

Regards,
Barry.
