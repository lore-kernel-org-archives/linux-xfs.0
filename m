Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39LldeJ212277 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 16:47:39 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Mh8vAUBEuTY0QE8v for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 14:47:38 -0700 (PDT)
Date: Tue, 10 Apr 2012 07:47:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
Message-ID: <20120409214736.GK18323@dastard>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<20120409001943.GI18323@dastard>
	<20120409133913.2fb9d94b@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120409133913.2fb9d94b@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Stefan Ring <stefanrin@gmail.com>, stan@hardwarefreak.com, Linux fs XFS <xfs@oss.sgi.com>

On Mon, Apr 09, 2012 at 01:39:13PM +0200, Emmanuel Florac wrote:
> Le Mon, 9 Apr 2012 10:19:43 +1000 vous =E9criviez:
> =

> > A decent RAID controller with a BBWC and a single LUN benefits from
> > parallelism just as much as a large disk arrays do because the BBWC
> > minimises the write IO latency and the controller to do a better job
> > of scheduling its IO.
> =

> BTW recently I've found that for storage servers, noop io scheduler
> often is the best choice, I suppose precisely because it doesn't try to
> outsmart the RAID controller logic...

We've been recommending the use of the no-op (or worst case,
deadline) scheduler for XFS on hardware RAID for quite a few years.
I only test against the no-op scheduler, because I got sick of
having to track down regressions caused by "smart" CFQ heuristics....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
