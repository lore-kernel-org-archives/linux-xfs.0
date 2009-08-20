Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KFj3QS104623 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:45:13 -0500
Received: from mail-vw0-f107.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5786414F992A
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:45:43 -0700 (PDT)
Received: from mail-vw0-f107.google.com (mail-vw0-f107.google.com
	[209.85.212.107]) by cuda.sgi.com with ESMTP id
	7QGJu20CUTEc7JTE for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2009 08:45:43 -0700 (PDT)
Received: by vws5 with SMTP id 5so76274vws.32
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:45:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8D6A6D.405@sandeen.net>
References: <a0531a500908200800m3f5ea065v818c97e845042221@mail.gmail.com>
	<4A8D6A6D.405@sandeen.net>
Date: Thu, 20 Aug 2009 11:45:42 -0400
Message-ID: <a0531a500908200845m5dbc4356o278cb6c90d2925f9@mail.gmail.com>
Subject: Re: XFS Best Practices
From: Jeff Flowers <ragepie@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 20, 2009 at 11:23 AM, Eric Sandeen<sandeen@sandeen.net> wrote:
> Jeff Flowers wrote:
>> I am going to use XFS on a Arch Linux box and I am looking for ways to
>> maximize XFS performance. According to an article I have read [1],
>> best XFS performance was reached with a file system formatted with a
>> 64MB log and mounted with 8 log buffers and atime disabled. But I am
>> curious, from the prespective of the XFS experts of this list, if this
>> is still good advice and if it is still relevant, as this article was
>> published in 2003.
>
> Based on the information you've provided about the performance issues
> you're seeing with your particular workload (i.e., nothing), the
> existing defaults are perfect for you. =A0:)

For me, it is not about dissatisfaction with XFS performance but
simply wanting to know if there are optimizations I am missing and
could be taking advantage of. Many forums have people talking about
options to improve or optimize Ext3 and Ext4 performance but XFS seems
to be dismissed (which I don't understand, as XFS is a very mature and
proven filesystem).


>> Also, I have seen a few people recommend turning off the internal
>> buffers of hard drives (via hdparm) when using a file system like XFS.
>> Good advice?
>
> When drive write caches lose power it may lead to inconsistencies in a
> journaling filesystem like xfs, which relies on data hitting the disk in
> a certain order, more or less. =A0By default xfs issues barriers to
> enforce this ordering; this has the effect of flushing the write cache
> to make it safe. =A0In some cases disabling barriers and also disabling
> write cache may be a good choice.
>
> If you "never" lose power (good ups?) then write caching is safe even
> w/o barriers.
>
> -Eric

Thanks for the information. Your explaination of write barries is one
of the better ones I have read.

-- =

Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
