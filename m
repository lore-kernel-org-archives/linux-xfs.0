Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1M9wXFL040685
	for <linux-xfs@oss.sgi.com>; Sun, 22 Feb 2009 03:58:33 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73AB719628BE
	for <linux-xfs@oss.sgi.com>; Sun, 22 Feb 2009 01:57:59 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id bJeKFWGsqfAyuSBy
	for <linux-xfs@oss.sgi.com>; Sun, 22 Feb 2009 01:57:59 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.68 #1) id 1Laau3-0000jT-Pw
	for <linux-xfs@oss.sgi.com>; Fri, 20 Feb 2009 19:19:15 +0000
MIME-Version: 1.0
Message-ID: <18847.561.585731.857362@tree.ty.sabi.co.uk>
Date: Fri, 20 Feb 2009 19:19:13 +0000
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<200812151948.59870.Martin@lichtvoll.de>
	<18758.57121.570007.816329@tree.ty.sabi.co.uk>
	<B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> The purpose of barriers is to guarantee that relevant data is known
>>> to be on persistent storage (kind of hardware 'fsync').

>>> [ ... ] Unfortunately in my understanding none of this is reflected
>>> by Documentation/block/barrier.txt

>> But we are talking about XFS and barriers here. That described just a
>> (flawed, buggy) mechanism to implement those. Consider for example:

>> http://www.xfs.org/index.php/XFS_FAQ#Write_barrier_support.
>> http://www.xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F

>> In any case as to the kernel "barrier" mechanism, its description is
>> misleading because it heavily fixates on the ordering issue, which is
>> just a consequence, but yet mentions the far more important "flush/sync"
>> aspect.

>> Still, there is a lot of confusion about barrier support and what it
>> means at which level, as reflected in several online discussions and
>> the different behaviour of different kernel versions.

> The semantics of a barrier are whatever semantics we describe to it.
> So we can continue to be confused about it.

As Humpty Dumpty said, one can make anything mean anything.

But we are not discussing the *semantics* of barriers...

We are discussing, as the original poster said, their *purpose*. The
semantics are a formal property, and the purpose is a practical one.

There is no dispute that Linux/Posix barrier *semantics* do not require
any form of persistence at all, ever, only that *if* data is made
persistent that be done in order.

The question is about the *purpose* of barriers, and that is to
implement timely, reliable transactions to persistent storage, and
ordering consistency is just a side effect of that.

But then if the *semantics* of Linux barriers do not support the
*purpose* of barriers, those semantics are buggy.

> [ ... ] Correct ordering can be proven to be enough to provide
> transactional correctness, enough to ensure that filesystems can not
> get corrupted on power down.

Indeed, and it can also be proven that not writing *anything* to disk is
enough to provide transactional correctness and correct ordering; and
filesystems that do not get written to cannot get corrupted ever.

By the same principle, whether one loses 1KiB or 10GiB or 1TiB of
pending transactions matters not at all to the semantics of Linux
barriers, because that's a violation of a stronger predicate:

> Using barriers to guarantee that (all submitted) write requests
> (before the barrier) made it to the medium are a stronger predicate.

Sure, and indeed, writing nothing guarantees transactional correctness,
and fully respects the semantics of Linux barriers. That's by far the
safest and most semantically correct solution.

There are however deluded fellows like those who use computers to record
real-world transactions who care about whether and when data is made
persistent (and usually as quickly as possible) and to whom consistency
is a side effect of completeness.

Fortunately such concerns are not significant because they require
excessively strong semantics:

> The Linux approach and documentation talks about the first type of
> semantics (which I rather like for them being strong enough and not
> more).

Precisely as the "Linux approach and documentation" do not guarantee
that anything will ever be written to disk, preserving transactional
correctness with the least possible effort. Why bother with stronger
predicates?

BTW, as the other links that I have provided show, the root cause of
this silliness is that POSIX 'fsync' does not guarantee persistency
either, only (practically useless on its own) ordering.

But that is a bug, not something for clever people to claim is righteous
not-stronger-than-necessary semantics.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
