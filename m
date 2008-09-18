Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Sep 2008 20:29:16 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8I3SjiD003104
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 20:28:46 -0700
Message-ID: <48D1CD46.4010104@sgi.com>
Date: Thu, 18 Sep 2008 13:38:46 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com>
In-Reply-To: <48D19A83.4040608@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

Russell Cattelan wrote:
> 
> Reference:
> http://oss.sgi.com/archives/xfs/2008-06/msg00209.html
> 
> 
> It turns out that the code in question is still broken.
> 
> xfs_iext_irec_compact_full will still corrupt the incore extent list if 
> it does
> the the partial copy of extents from one page to the next.
> I haven't quit figured out where things get out of sync but somehow
> if_real_bytes which tracks the total number of bytes available in
> the extent buffers and if_bytes (which tracks the total bytes used
> for extents.
> 
> So at some point the inode thinks is has more extents than allocated 
> pages allow.
> So what happens is xfs_iext_idx_to_irec which uses idxp to pass IN the
> absolute extent index is suppose to change  idxp on the way OUT and 
> erp_idxp
> to be a buffer index pair. What happens is that it doesn't find the 
> extent so idxp
> is left holding the same value as was passed in and erp_idx is 0.
> This causes the extent code to then index way past the end of extent 
> buffer 0
> into garbage mem.
> 
> with 4k ext buffers max extent count per buffer is 256.
> example being:
> IN:
> idxp = 400
> should become:
> idexp = 144
> erp_idxp = 1
> 
> but we end up not finding the extent so
> we have
> idxp = 400
> erp_idxp =0
> 
> so we now index 6400 bytes into a 4k buffer.
> 
> Which often times  is a pages of mostly 0 so we end up with access to 
> block 0 errors.
> 
> The more I looked at this code the more it didn't make sense to do 
> partial moves.
> Since the list of extent buffers is only scanned once vs restarting the 
> list whenever a partial move is done,
> it is very unlikely to actually free an extent buffer. (granted it's 
> possible but unlikely)
> 
> xfs_iext_irec_compact_pages does the same thing as 
> xfs_iext_irec_compact_full except that doesn't handle partial moves.
> 
> xfs_iext_irec_compact is written such that ratio of current extents has 
> to be significantly smaller than the current allocated space
> xfs_inode: 4513
> nextents < ( nlists  * XFS_LINEAR_EXT) >> 3
> 
> As it turns out 99% of the time it calls xfs_iext_irec_compact_pages
> (which is why it has been so hard to track this bug down).
> 
> If you change the 3 to a 1 so the code alway calls compact_full vs 
> compact_pages the extent list will corrupt amost
> immediately.
Awesome work Russell, we'll give it a go.

> 
> Since the code is broken, almost never used, and provides only micro 
> optimization of incore space I propose we just
> remove it all together.
Are you sure the bug is in xfs_iext_irec_compact_full?

Is it possible that we are still indexing beyond the page when using
xfs_iext_irec_compact_pages but the pages just happen to be sequential
so the indexing gets the extent anyway?

> 
> I'm also including an xfsidbg patch that for xexlist that prints out 
> buffer offset and index.
> 
> -Russell Cattelan
> 
> 
