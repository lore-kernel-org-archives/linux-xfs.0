Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2F0VxaN009629 for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 19:31:59 -0500
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	kt6zZk5tCqHeVus1 for <xfs@OSS.SGI.com>;
	Wed, 14 Mar 2012 17:31:56 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB6474058C9B67 for xfs@OSS.SGI.com; Thu, 15 Mar 2012 00:31:56 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S7ybb-0003AT-Bf
	for <xfs@OSS.SGI.com>; Thu, 15 Mar 2012 00:31:47 +0000
MIME-Version: 1.0
Message-ID: <20321.14449.839373.158043@tree.ty.sabi.co.UK>
Date: Thu, 15 Mar 2012 00:31:45 +0000
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <33506375.post@talk.nabble.com>
References: <33498437.post@talk.nabble.com>
	<4F605877.2030304@hardwarefreak.com>
	<33504048.post@talk.nabble.com> <20120314210514.GA46448@nsrc.org>
	<33506375.post@talk.nabble.com>
From: pg_xf2@xf2.for.to.sabi.co.UK (Peter Grandi)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>> lfs.303:
>> 0: [0..4192255]: 36322376672..36326568927
[ ... ]
>> lfs.3:
>> 0: [0..1048575]: 2039336992..2040385567

  $ factor 36322376672 2039336992
  36322376672: 2 2 2 2 2 37 3257 9419
  2039336992: 2 2 2 2 2 7 11 37 22369
  $ factor 4192256 1048576
  4192256: 2 2 2 2 2 2 2 2 2 2 2 23 89
  1048576: 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2

The starting addresses look like to be 16KiB aligned (starting
sector a multiple of 2^5 512B sectors). I would have expected
different. The sizes are a multiple of 1MB, 2047MiB and 512MiB,
which are plausible.

[ ... ]

> I'm not familiar with the btrace output, but here's the summary of roughly
> 5 minutes:

>> Total (8,16):
>> Reads Queued:      16,914,    1,888MiB  Writes Queued:      47,147,   1,438MiB
>> Read Dispatches:   16,914,    1,888MiB  Write Dispatches:   47,050,   1,438MiB
>> Reads Requeued:         0               Writes Requeued:         0
>> Reads Completed:   16,914,    1,888MiB  Writes Completed:   47,050,   1,438MiB
>> Read Merges:            0,        0KiB  Write Merges:           97,   592KiB
>> IO unplugs:        17,060               Timer unplugs:           6
>> Throughput (R/W): 5,528KiB/s / 4,209KiB/s
>> Events (8,16): 418,873 entries
>> Skips: 0 forward (0 -   0.0%)

That's around 17k reads, or 60/s, each of 100K, and 47k writes,
or 160/s, average 31K. Both read and writes happen at around
4-5MB/s.

Since the RAID5 is managed by the PERC, the reads cannot be
those in RMW, and it is unlikely that these be sequential with
the writes. There may be quite a bit of random access going on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
