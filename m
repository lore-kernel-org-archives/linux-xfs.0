Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3ALTovQ212469 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 16:29:50 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id vwIMAMXwNuRiZbAU
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 14:29:48 -0700 (PDT)
Message-ID: <4F84A64E.5000209@hardwarefreak.com>
Date: Tue, 10 Apr 2012 16:29:50 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<4F8055E4.1000808@hardwarefreak.com>
	<CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
	<4F8372DC.7030405@hardwarefreak.com>
	<CAAxjCEx14NrgUatB349vx8h0kCxE=cS7d4DLLPnjwB035tB3Hw@mail.gmail.com>
	<4F849817.4060102@hardwarefreak.com>
	<CAAxjCEyjwSvsiUg1zYDjikWZ8NAYiaNLAkL6HHQMJn9DaJh4GA@mail.gmail.com>
In-Reply-To: <CAAxjCEyjwSvsiUg1zYDjikWZ8NAYiaNLAkL6HHQMJn9DaJh4GA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 4/10/2012 3:43 PM, Stefan Ring wrote:
> I don=92t want to be expected to hand-tune every damn thing.

You don't.

>> $ mkfs.xfs -d agcount=3D3 /dev/[device]

> With a nice and tidy fresh XFS file system, performance is indeed
> impressive =96 about 16 sec for the same task that would take 2 min 25
> before.

9x improvement in your workload.  First problem down.  What was the
runtime for EXT4 here?  Less than 16 seconds?

>>> and doesn=92t seem to cope well with fragmented free space (which
>>> is what this entire thread is really about),

>> Did you retest fragmented freespace writes

> Yes, I did this. It performed very well. Only slightly slower than on
> a completely empty file system.

2nd problem down.  So the concat is your solution, no?  If not, what's
still missing?

BTW, concats don't have parity thus no RMW, so with the concat setup you
should set 100% of the P400 cache to writes.  The 25% you had for reads
definitely helps RAID6 RMW, but yields no benefit for concat.  Bump
write cache to 100% and you'll gain a little more XFS concat
performance.  And if by chance there is some weird logic in the P400
firmware, dedicating 100% to write cache may magically blow the doors
off.  I'm guessing I'm not the only one here to have seen odd magical
settings values like this at least once, though not necessarily with
RAID cache.

Even if not magical, in addition to increasing write cache size by 25%,
you will also increase write cache bandwidth with your high allocation
workload, as metadata free space lookups won't get cached by the
controller.  And given that sector write ordering is an apparent problem
currently, having this extra size and bandwidth may put you over the top.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
