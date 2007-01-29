Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Jan 2007 13:51:04 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0TLovqw014819
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 13:50:59 -0800
Subject: Re: [DISCUSS] xfs allocation bitmap method over linux raid
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <1170020997.18017.236.camel@edge>
References: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
	 <1169678294.18017.200.camel@edge>
	 <5d96567b0701280232w17e1a187r95d2c59711799b1a@mail.gmail.com>
	 <1170020997.18017.236.camel@edge>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 08:49:43 +1100
Message-Id: <1170107383.18017.245.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, 2007-01-29 at 08:49 +1100, Nathan Scott wrote:
> prealloc shouldn't be zero for writes that will extend the file size;
> but now that I think about it, I'm not sure how it could ever get set
> for a buffered write (delalloc), since by the time we come to do the
> actual allocation and writes to disk, the inode size will be beyond
> the allocation offset.  Hmm, maybe the logic in there needs a rethink
> (any thoughts there, Dave/Lachlan?)

I had a closer look, and remember now how this works - I was looking
in the wrong place entirely.  For real (not delayed) allocations, the
stripe alignment is performed within the allocator, so deep down in
the xfs_bmapi -> xfs_bmap_alloc -> xfs_bmap_btalloc call path.

In particular, see the big comment mid-way through xfs_bmap_btalloc..

         * If we are not low on available data blocks, and the
         * underlying logical volume manager is a stripe, and
         * the file offset is zero then try to allocate data
         * blocks on stripe unit boundary.
         * NOTE: ap->aeof is only set if the allocation length
         * is >= the stripe unit and the allocation offset is
         * at the end of file.

(the "file offset is zero" part seems misleading to me, since it
is not only aligning in that case).

So, the real answer to your "why isn't it aligning" question lies
in there - if you can instrument that code and figure out why you
aren't seeing allocation alignment adjustnments inside there, you
should be 99% of the way to understanding your problem.

cheers.

-- 
Nathan
