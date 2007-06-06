Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 19:03:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5622wWt021282
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 19:03:00 -0700
Message-ID: <46661657.2060507@sgi.com>
Date: Wed, 06 Jun 2007 12:05:11 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Reducing memory requirements for high extent xfs files
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com> <20070606013601.GR86004887@sgi.com> <4666153C.9050409@sgi.com>
In-Reply-To: <4666153C.9050409@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@agami.com>, Michael Nishimoto <miken@stanfordalumni.org>, xfs@oss.sgi.com

Vlad Apostolov wrote:

No, Dave is right. The example worked because the extent hint was the 
same size
as the filesystem block.

Regards,
Vlad
>>
>> Note - i don't think extent size hints alone will help as they
>> don't prevent EOF truncation on close.
> Dave,
>
> I think extent hint should help in this situation. Here is an example
> of writing 4 chars in a file with extent hint of 16Kb. The file ends
> up with size of 4 and 8 basic blocks (512 bytes each) allocation in
> one extent.
>
> emu:/mnt/scratch1/temp # xfs_io -c "extsize 16384" -f foo
> emu:/mnt/scratch1/temp # ls -al foo
> -rw------- 1 root root 0 2007-06-06 12:33 foo
> emu:/mnt/scratch1/temp # xfs_bmap -l -v foo
> foo: no extents
> emu:/mnt/scratch1/temp # echo "abc" > foo
> emu:/mnt/scratch1/temp # ls -al foo
> -rw------- 1 root root 4 2007-06-06 12:35 foo
> emu:/mnt/scratch1/temp # xfs_bmap -l -v foo
> foo:
> EXT: FILE-OFFSET BLOCK-RANGE AG AG-OFFSET TOTAL
> 0: [0..7]: 326088..326095 0 (326088..326095) 8
>
> Just a warning that the extent hint works at the moment only for
> contiguous files. There are problems for sparse files (with holes)
> and extent hint.
>
> Regards,
> Vlad
>
