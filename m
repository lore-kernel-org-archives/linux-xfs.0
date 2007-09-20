Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 17:50:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8K0oiuw018919
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 17:50:48 -0700
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com> <46F17BBE.7060304@sandeen.net>
Date: Thu, 20 Sep 2007 10:54:33 +1000
Message-ID: <op.tyxgs7j83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46F17BBE.7060304@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Jochen K." <jochen.f.k@googlemail.com>
Cc: xfs@oss.sgi.com

On Thu, 20 Sep 2007 05:42:54 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Jochen K. wrote:
>
>> [output with encryption]
>>
>> mkfs.xfs -f /dev/mapper/raid6
>>
>> meta-data=/dev/mapper/raid6      isize=256    agcount=32,  
>> agsize=53412581
>> blks
>>          =                       sectsz=512   attr=0
>> data     =                       bsize=4096   blocks=1709202592,  
>> imaxpct=25
>>          =                       sunit=0      swidth=0 blks, unwritten=1
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=32768, version=1
>>          =                       sectsz=512   sunit=0 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> b7f57ad0: Badness in key lookup (length)
>> bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096  
>> bytes)
>
> What generates the last two lines in the above message, and do you know
> what it indicates?

One problem I discovered with libxfs and repair in the prefetch is the
handling of I/O to a block offset, but with different I/O size.
libxfs cannot handle this, so I enabled IO_BCOMPARE_CHECK to detect
any I/Os that have the same offset but different length. This is a
bad thing for libxfs and it can lose data coherency.

I need to know what mkfs is doing at that offset. Probably the simplest
way is to enable IO_DEBUG, rebuild and observe all the I/Os to libxfs.
Since it's mkfs, there shouldn't be too many I/Os in total.

If you want to be clever, use XFS_BUF_TRACING with gdb, that will
pin-point the exact location :)

Regards,
Barry.
