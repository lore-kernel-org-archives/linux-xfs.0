Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Nov 2007 16:12:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA60CTqv007559
	for <xfs@oss.sgi.com>; Mon, 5 Nov 2007 16:12:33 -0800
Date: Tue, 6 Nov 2007 11:12:23 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 972756 - Implement fallocate.
Message-ID: <20071106001223.GY66820511@sgi.com>
References: <20071102024314.9BF3458C38F7@chook.melbourne.sgi.com> <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690711051042h5c39c540mf60f95e2f67c7bd7@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Nov 06, 2007 at 12:12:52AM +0530, Bhagi rathi wrote:
> David, What happens if offset is not aligned to 4k? Let's say we have a file
> whose size is
> not aligned to 4k. It could have blocks beyond the eof which haven't been
> zero'ed out.

No it won't. They are *preallocated* blocks, which by definition are
zero-filled. Preallocated blocks are marked as unwritten on disk, so
it is known that they contain zeros, even if they lie beyond EOF.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
