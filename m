Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBIJ02YS010208 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 13:00:02 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0004321A7
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 10:59:59 -0800 (PST)
Received: from ty.sabi.co.UK ([192.100.78.57]) by cuda.sgi.com with ESMTP id
	zTpVoWdWL7N23zcw for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2008 10:59:59 -0800 (PST)
MIME-Version: 1.0
Message-ID: <18760.5684.997874.673460@tree.ty.sabi.co.uk>
Date: Tue, 16 Dec 2008 20:57:24 +0000
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <200812161039.07700.Martin@lichtvoll.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<20081215223857.GF32301@disturbed>
	<200812161039.07700.Martin@lichtvoll.de>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>

[ ... ]

>>>> It doesn't mean that the barrier has to land immediately and
>>>> the filesystem has to wait for this. At least that always was
>>>> the whole point of barriers for me. If thats not the case I
>>>> misunderstood the purpose of barriers to the maximum extent
>>>> possible.

>>> The purpose of barriers is to guarantee that relevant data is
>>> known to be on persistent storage (kind of hardware 'fsync').

>> Barriers provide strong ordering semantics. [ ... ]This is all
>> documented in Documentation/block/barrier.txt. Please read it
>> because most of what you are saying appears to be based on
>> incorrect assumptions about what barriers do.

No, it is based on the assumption that we are discussing the
"whole point of barriers" and "the purpose of barriers".

Those are the ability to do atomic, serially dependent transactions
*to stable storage*. Some people may be interested in integrity
only, with potentially unbounded data loss, but most people who
care about barriers are interested in reliable commit to stable
storage.

Then there are different types of barriers, from XFS barriers to
host adapter/drive controller barriers, and even the Linux block
layer "barrier" mechanism, which is arguably misdesigned, because
what it does is not what it should be doing to achieve "the whole
point" and "the purpose" of a barrier system, and achieving that
can be quite difficult.

This is somewhat controversial, and to further the understanding
of the whole point of barriers and their purpose I have provided
in a previous post a pointer to two very relevant discussion
threads, which to me seem pretty clear.

> Hmmm, so I am not completely off track it seems ;-).

Well, your description seems to be based on the actual properties
of the flawed implementation of barriers in current Linux, but not
about the "whole point" and "purpose" that should be served by such
a mechanism.

The documentation of barriers in the Linux kernel makes the mess
worse, because it does talk about committing to stable storage, but
then gives the impression that the point and purpose is indeed
ordering, which it should not be. That an ordering is imposed
should be consequence of the committment of serially dependent
transactions to stable storage in a consistent way, not a goal in
itself.

The discussion threads I mentioned previously show that the big
issue is indeed having a reliable mechanism to commit transactions
to stable storage, rather than provide just the transaction
dependency part of that mechanism.

Quite a few people think that just transaction property is too
weak a purpose or point for barriers. Which point or purpose is
precisely to offer the application (file system or user process
like a DBMS instance) the ability to definitely commit to stable
storage:

  > When should be a choice of the user on how much data she /
  > he risks to loose in case of a sudden interruption of
  > writing out requests.

Unfortunately as I have already remarked this area, which should be
crystal clear as it is important to people who need transaction
persistence guarantees, is messy, with various file systems or
DBMSes doing bad, dirty things because the point and purpose of
barriers has been misunderstood so often (arguably even by the
POSIX committee with 'fsync'/'fdatasync').

The rapid escalation of complexity of the levels and types of
nonpersistent caching in current storage subsystem is so bad that
reminding people that the whole point and purpose of barriers is to
provide stable storage commits rather than merely ordering seems
quite important to me.

The way Linux block layer barriers currently work, like other
aspects of that block layer (for example the absurd rationale
behind the plugging/unplugging mechanism), is so misguided that it
should not be confused with the whole point and purpose of barriers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
