Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 09:27:06 -0800 (PST)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.225])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6HR0ux013831
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 09:27:03 -0800
Received: by wr-out-0506.google.com with SMTP id c48so148366wra
        for <xfs@oss.sgi.com>; Tue, 06 Nov 2007 09:27:05 -0800 (PST)
Message-ID: <cc7060690711060927n1ea8a489n9f02029a11b73b00@mail.gmail.com>
Date: Tue, 6 Nov 2007 22:57:03 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 972756 - Implement fallocate.
In-Reply-To: <20071106001223.GY66820511@sgi.com>
MIME-Version: 1.0
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com>
	 <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
	 <20071106001223.GY66820511@sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

File is of size 1k.  A 4k block is allocated as file-system block size is
4k.
 Preallocation happened from 1k to 256k. Now, it looks to me that we have
un-written extents from 4k to 256k. There is no guarantee that data from 1k
to 4k is all zero'es. Fallocate is updating size.  Hence on subsequent read,
we can get garbage from 1k to 4k and all zero'es from 4k to 256k

Is the expectation here is application should take the responsibility of
zero'ing
data?  I still need to through fallocate requirements.

-Thanks,
 Bhagi.


On 11/6/07, David Chinner <dgc@sgi.com> wrote:
>
> On Tue, Nov 06, 2007 at 12:12:52AM +0530, Bhagi rathi wrote:
> > David, What happens if offset is not aligned to 4k? Let's say we have a
> file
> > whose size is
> > not aligned to 4k. It could have blocks beyond the eof which haven't
> been
> > zero'ed out.
>
> No it won't. They are *preallocated* blocks, which by definition are
> zero-filled. Preallocated blocks are marked as unwritten on disk, so
> it is known that they contain zeros, even if they lie beyond EOF.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>


[[HTML alternate version deleted]]
