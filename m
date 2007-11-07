Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Nov 2007 01:34:56 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA79YoO4025749
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2007 01:34:52 -0800
Message-ID: <56697.192.168.3.1.1194428121.squirrel@mail.aconex.com>
In-Reply-To: <cc7060690711062142h3668e831o8fc49bdb5a1615bf@mail.gmail.com>
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
    <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
    <20071106001223.GY66820511@sgi.com>
    <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
    <20071106204100.GW995458@sgi.com>
    <1194388733.3862.206.camel@edge.yarra.acx>
    <cc7060690711062142h3668e831o8fc49bdb5a1615bf@mail.gmail.com>
Date: Wed, 7 Nov 2007 20:35:21 +1100 (EST)
Subject: Re: TAKE 972756 - Implement fallocate.
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

> Since size log change and data I/O are not binded, it is always possible
> that size can reach to the
> disk before I/O reaching to the disk.

Not clear what that has to do with whether partial blocks are zeroed or not?
Can you give a specific series of steps that would demonstrate a problem?
(preferably with a test case)

> Also, the other problem is because
> of
> speculative allocation.
> A write-back allocation can leady to allocation of delayed extents into
> real
> and gets pruned only
> close of the file.
> Before that, we get fallocate, it allocates the exents,
> but the extents residing
> because of delayed allocation write-back will not have zero'ed content.

Again, I think a test case demonstrating the problem would go a long way
to helping explain the issue.

The preallocation code and ioctl interface have been in XFS forever on
Linux - are you reporting problems you've actually observed here, or
are these rather "potential issues" that you foresee from code analysis?

cheers.

--
Nathan
