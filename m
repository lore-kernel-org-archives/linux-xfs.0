Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 21:42:36 -0800 (PST)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.224])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA75gOGb026653
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 21:42:25 -0800
Received: by nz-out-0506.google.com with SMTP id x3so1391256nzd
        for <xfs@oss.sgi.com>; Tue, 06 Nov 2007 21:42:29 -0800 (PST)
Message-ID: <cc7060690711062142h3668e831o8fc49bdb5a1615bf@mail.gmail.com>
Date: Wed, 7 Nov 2007 11:12:28 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 972756 - Implement fallocate.
In-Reply-To: <1194388733.3862.206.camel@edge.yarra.acx>
MIME-Version: 1.0
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
	 <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
	 <20071106001223.GY66820511@sgi.com>
	 <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
	 <20071106204100.GW995458@sgi.com>
	 <1194388733.3862.206.camel@edge.yarra.acx>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Since size log change and data I/O are not binded, it is always possible
that size can reach to the
disk before I/O reaching to the disk. Also, the other problem is because of
speculative allocation.
A write-back allocation can leady to allocation of delayed extents into real
and gets pruned only
close of the file. Before that, we get fallocate, it allocates the exents,
but the extents residing
because of delayed allocation write-back will not have zero'ed content.

Conceptually, fallocate if it intends to change size, it is no way different
from size extending write.
 We do xfs_zero_eof for write and not  in this case. Probably, I am missing
the context of usage of
 fallocate if it has some semantics over-loaded.

-Thanks,
  Bhagi.

On 11/7/07, Nathan Scott <nscott@aconex.com> wrote:
>
> On Wed, 2007-11-07 at 07:41 +1100, David Chinner wrote:
> > >  Preallocation happened from 1k to 256k. Now, it looks to me that we
> > have
> > > un-written extents from 4k to 256k. There is no guarantee that data
> > from 1k
> > > to 4k is all zero'es.
>
> That guarantee does exist - when the initial 1K block write is done, the
> end of the block is zeroed (by the kernel write path).  This is always
> done (guaranteed) and is required independently to unwritten extents.
>
> cheers.
>
> --
> Nathan
>
>


[[HTML alternate version deleted]]
