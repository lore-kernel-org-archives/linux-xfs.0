Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 16:01:55 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0P00hIf029234
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 16:00:46 -0800
Date: Fri, 25 Jan 2008 11:01:09 +1100
Subject: Re: xfs_rapair memory requirement per TB
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <1201042882.32649.256.camel@holwrs01.bp.com> <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080123085339.GB12435@p15145560.pureserver.info> <20080124002828.GC155259@sgi.com> <op.t5euakap3jf8g2@pc-bnaujok.melbourne.sgi.com> <1201189816.32649.358.camel@holwrs01.bp.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t5gkz7ds3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1201189816.32649.358.camel@holwrs01.bp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rene Salmon <salmr0@bp.com>
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, xfs@oss.sgi.com

On Fri, 25 Jan 2008 02:50:16 +1100, Rene Salmon <salmr0@bp.com> wrote:

>
>
>
>
>> >> >
>> >> > General rule of thumb at the moment is 128MB of RAM/TB of
>> filesystem
>> >> > plus 4MB/million inodes on that filesystem.
>> >>
>> >> Did this change lately? I found the rule of thumb: 2 GB RAM for 1
>> TB
>> >> of disk storage + some RAM per x inodes.
>> >
>> > The above is based on actual theoretical usage, the below:
>> >
>> >> http://oss.sgi.com/archives/xfs/2005-08/msg00045.html
>> >
>> > was based on reported usage on during live repair runs.
>> >
>> > I think Barry discovered the difference to be things external
>> > to repair such as heap fragmentation and has since corrected
>> > the worst of the issues so requirements are, in general,
>> > much closer to the theoretical numbers now.
>>
>> Yes, quite a few memory improvements have been made.
>>
>> Right now, I can repair a 9TB filesystem with ~150 million inodes
>> in 2GB of RAM without going to swap using xfs_repair 2.9.4 and
>> with no custom/tuning/config options.
>
>
>
>
> Thanks. That is great news about the memory improvements.  We currently
> run SLES 10 SP1 which comes with:
>
> hpcxe005:# xfs_repair -V
> xfs_repair version 2.8.16
>
> others come with:
>
> hpcxe001:~ # xfs_repair -V
> xfs_repair version 2.9.2
>
>
> Did the memory improvements make it into 2.8.16? How about 2.9.2? If not
> i take it we can download the latest source and just have the 2.9.4
> xfs_repair binary laying around in case we ever need to use it.  Would
> using a 2.9.4 xfs_repair binary on a 2.8.16 created xfs file system
> cause any problems?

The memory improvements showed up in 2.9.2.

As Ralf said, xfs_repair can always fix older mkfs'ed filesystems.

Regards,
Barry.
