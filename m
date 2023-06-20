Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F949EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 06:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjFTGBx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 02:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjFTGBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 02:01:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADDF10FA
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 23:01:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-25695bb6461so3620993a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 23:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687240877; x=1689832877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eFY34EZCi4QDhuf9OBg62utkYNPK8RakusWnKrkexYQ=;
        b=sJzNWki7IzLZDOGhLNAXbpyEGEMhk9Ho2paG9PsWOYrB5etpFHXl1VNG01uMwL5DP5
         ekHSfnfv9lTwXNb79UfQCIi+k6DlzTNxBgNql4nBFNFoco4qANFFOS+UjDngNpd9gQVq
         ZNdxm1xvU5YnnAxMkD3ZI4cqTfD2+g3n7PZrP9NT8DGcaVDvngJLyS+3xb2MalNeUGAO
         Ugz8rGKwuEkHejZd18ToGyvRJG++JU3+Yg89Zjg380SFb+GBwQ/xGO1p7wQuHm2dIVXA
         3dA3zo5YTQ4LW1MgDvH2hSS3EoIalCAeLAGHy6/5dW0ziwVdzHRgDvuakqcSw3daRG6H
         SY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687240877; x=1689832877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFY34EZCi4QDhuf9OBg62utkYNPK8RakusWnKrkexYQ=;
        b=HN/L/DdDBOd0oRh0UQtSO4ljOQVEzkn1Z7HrtrCxxdMjLCAYQsEYEDDToDC4duQnBT
         tmylPEK77iWPolCGpriaULObHLrAlGNRJi/qiM0QCIpEejJTj+/3cogo790h8bymz6wI
         13CU9XI6d7FdeyrhVV2MnQ6s+ymgFvGC9L/VyLSj830g9HuJS7/W7RDJnq8/b36NLK4n
         Fq02S2WGgWUYucCDpk9NFQewJPHiqvx06c0JiaFOvDsl0l4pAp01xyaftUlGK4IUOQWi
         pD2ixH9GWlHiYe9YSgiKbQB7BF921fCom2+PK4wbl5xAQSDn8uW/FGyBzoZh3gu04GFG
         XW6Q==
X-Gm-Message-State: AC+VfDzrnMvoh1pICUO4sGAREvhmhT/ovWlEDsMxCfzxk97KJINlNobu
        IRxbbOXOZXpXXkCBD3fgX/C3J9FZDujpUoeTCMk=
X-Google-Smtp-Source: ACHHUZ4+72Cgzl7SMTToVb3TKPyaoT8ijgkJpHMqBxF/SqG2f8P15EnExHQvnyFxXCfrw8qC1NQDAw==
X-Received: by 2002:a17:90b:158e:b0:25e:6196:ff96 with SMTP id lc14-20020a17090b158e00b0025e6196ff96mr22669682pjb.12.1687240877271;
        Mon, 19 Jun 2023 23:01:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id jk14-20020a170903330e00b001b536aaf7c2sm745926plb.189.2023.06.19.23.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 23:01:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBUQT-00DwZ0-1o;
        Tue, 20 Jun 2023 16:01:13 +1000
Date:   Tue, 20 Jun 2023 16:01:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <ZJFAqTaV6AO37v04@dread.disaster.area>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
 <ZJEb2nSpIWoiKm6a@dread.disaster.area>
 <20230620044443.GE11467@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620044443.GE11467@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 19, 2023 at 09:44:43PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 20, 2023 at 01:24:10PM +1000, Dave Chinner wrote:
> > On Thu, May 25, 2023 at 05:44:48PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > After an online repair, we need to invalidate buffers representing the
> > > blocks from the old metadata that we're replacing.  It's possible that
> > > parts of a tree that were previously cached in memory are no longer
> > > accessible due to media failure or other corruption on interior nodes,
> > > so repair figures out the old blocks from the reverse mapping data and
> > > scans the buffer cache directly.
> > > 
> > > Unfortunately, the current buffer cache code triggers asserts if the
> > > rhashtable lookup finds a non-stale buffer of a different length than
> > > the key we searched for.  For regular operation this is desirable, but
> > > for this repair procedure, we don't care since we're going to forcibly
> > > stale the buffer anyway.  Add an internal lookup flag to avoid the
> > > assert.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/scrub/reap.c |    2 +-
> > >  fs/xfs/xfs_buf.c    |    5 ++++-
> > >  fs/xfs/xfs_buf.h    |   10 ++++++++++
> > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> > > index 30e61315feb0..ca75c22481d2 100644
> > > --- a/fs/xfs/scrub/reap.c
> > > +++ b/fs/xfs/scrub/reap.c
> > > @@ -149,7 +149,7 @@ xrep_block_reap_binval(
> > >  	 */
> > >  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> > >  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > > -			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
> > > +			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> > 
> > Can't say I'm a big fan of XBF_BCACHE_SCAN as a name - it tells me
> > nothing about what the incore lookup is actually doing. The actual
> > lookup action that is being performed is "find any match" rather
> > than "find exact match". XBF_ANY_MATCH would be a better name, IMO.
> > 
> > >  	if (error)
> > >  		return;
> > >  
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 15d1e5a7c2d3..b31e6d09a056 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
> > >  		 * reallocating a busy extent. Skip this buffer and
> > >  		 * continue searching for an exact match.
> > >  		 */
> > > -		ASSERT(bp->b_flags & XBF_STALE);
> > > +		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
> > > +			ASSERT(bp->b_flags & XBF_STALE);
> > 
> > And this becomes XBM_ANY_MATCH, too.
> 
> Hmmm.  I've never come up with a good name for this flag.  The caller
> actually has a *specific* length in mind; it simply doesn't want to trip
> the assertions on the cached buffers that have a different length but
> won't be returned by *this* call.
> 
> If the buffer cache has bufs for daddr 24 len 8 and daddr len 120, the
> scan calls xfs_buf_get as follows:
> 
> daddr 24 len 1 (nothing)
> daddr 24 len 2 (nothing)
> ...
> daddr 24 len 8 (finds the first buffer)
> ...
> daddr 24 len 120 (finds the second buffer)
> ...
> daddr 24 len 132 (nothing)
> 
> I don't want the scan to ASSERT 130 times, because that muddles the
> output so badly that it becomes impossible to find relevant debugging
> messages among the crap.

As I mentioned in the my response to the next patch, this is an
O(N^2) brute force search. But how do you get two buffers at the
same address into the cache in the first place?

> > >  		return 1;
> > >  	}
> > >  	return 0;
> > > @@ -682,6 +683,8 @@ xfs_buf_get_map(
> > >  	int			error;
> > >  	int			i;
> > >  
> > > +	if (flags & XBF_BCACHE_SCAN)
> > > +		cmap.bm_flags |= XBM_IGNORE_LENGTH_MISMATCH;
> > >  	for (i = 0; i < nmaps; i++)
> > >  		cmap.bm_len += map[i].bm_len;
> > >  
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 549c60942208..d6e8c3bab9f6 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -44,6 +44,11 @@ struct xfs_buf;
> > >  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
> > >  
> > >  /* flags used only as arguments to access routines */
> > > +/*
> > > + * We're scanning the buffer cache; do not warn about lookup mismatches.
> > 
> > The code using the flag isn't doing this - it's trying to invalidate
> > any existing buffer at the location given. It simply wants any
> > buffer at that address to be returned...
> > 
> > > + * Only online repair should use this.
> > > + */
> > > +#define XBF_BCACHE_SCAN	 (1u << 28)
> > >  #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
> > >  #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
> > >  #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
> > > @@ -67,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
> > >  	{ _XBF_KMEM,		"KMEM" }, \
> > >  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> > >  	/* The following interface flags should never be set */ \
> > > +	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
> > >  	{ XBF_INCORE,		"INCORE" }, \
> > >  	{ XBF_TRYLOCK,		"TRYLOCK" }, \
> > >  	{ XBF_UNMAPPED,		"UNMAPPED" }
> > > @@ -114,8 +120,12 @@ typedef struct xfs_buftarg {
> > >  struct xfs_buf_map {
> > >  	xfs_daddr_t		bm_bn;	/* block number for I/O */
> > >  	int			bm_len;	/* size of I/O */
> > > +	unsigned int		bm_flags;
> > >  };
> > >  
> > > +/* Don't complain about live buffers with the wrong length during lookup. */
> > > +#define XBM_IGNORE_LENGTH_MISMATCH	(1U << 0)
> > 
> > Which makes me wonder now: can we have two cached buffers at the
> > same address with different lengths during a repair?
> 
> Let's say there's a filesystem with dirblksize 8k.  A directory block
> gets crosslinked with an xattr block.  Running the dir and xattr
> scrubbers each will create a new cached buffer -- an 8k buffer for the
> dir, and a 4k buffer for the xattr. 

The second one will trip an assert fail because it found a non-stale
block of a different length.

This is fundamental property of the buffer cache - there is only
supposed to be a single active buffer for a given daddr in the cache
at once. Just because the production code doesn't noisily complain
about it, doesn't mean it is valid behaviour.

> Let's say that the dir block
> overwrote the attr block.  Then, the xattr read verifier will fail in
> xfs_trans_buf_read, but that doesn't remove the buffer from the cache.

It won't even get to the read verifier on a debug kernel - it should
be assert failing in the compare function trying to look up the
second buffer as it's asking for a different length.

i.e. I don't see how the above "crosslinked with different lengths
instantiates two independent buffers" works at all on a debug
kernel. It should fail, it is meant to fail, it is meant to tell us
something is breaking the fundamental assumption that there is only
one active cached buffer for a given daddr at a given time....

What am I missing?

> I want the xattr repair to be able to scan the buffer cache and examine
> both buffers without throwing assertions all over the place, because
> that makes it harder to debug repair.

Right, but I don't see anything in the buffer cache changes so far
that allow that or make it in any way safe for it to occur.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
