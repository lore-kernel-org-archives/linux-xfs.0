Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2E4C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Oct 2022 22:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJ2WCh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 18:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2WCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 18:02:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE16B2CCB5
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 15:02:34 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b11so7477910pjp.2
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 15:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt0nmCbRltPLSVL25RgnVxAM7CFIno3Gz30lQjYP84E=;
        b=mKOoZO6Arc8qmUa5ZzQLGHmXRTJUw72GZNw4Rmm7IZb+ryojNhJMVicn0xk9dH9Fj3
         VFuXg5vT8vU0oqx8yhht2wUWpM0QWCpSvLFj74G+fLpjjlUrMwwU+0N7teBtlzWli1wv
         c1gTV99ngBxonNwZh1zKrJTKPxKj3dNeddS1x9pUAfkxdTHCRNT3zVBJszC/g3ctKdEE
         RHVS1mglr7Aw629peDslj/dddJj3Ur7P/3X3vFsdZ2Vcg41LsbNnyrkEUx/6gZznAEoU
         GZc3+FNSvKe58tsAlvYi0SsbXe/fuPvAGxFsvgDJ5gdWe9WNS7BI3QCxbO6p1bjFlpXn
         K8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bt0nmCbRltPLSVL25RgnVxAM7CFIno3Gz30lQjYP84E=;
        b=Pu3YO+NT/yinuYK+FSaRe1iF64HJIniSB1gaWW+yvm7C2RWWlo48RYO94YqhvW9bzm
         udl0NnE4e7M/LhssbfrSPKA17Y46KOJKqACSTy4rsvizUOG+0gxsFuKF9ST6+ch/hpEM
         ndw5Oq6pUtpo1PY8xItb03PpXD3KMgChx2paBU4B+RTeqooB0NiMUk3tsAXJRLjvv9nx
         OESW4+1CnckyN+3EvXMxvETdhxZr8G52/2g6yRzrUMgm1i8ITXRp+Ss67KO1M724JotN
         u2bcUQE7yJRd0gzCex73Ipj83OTY9cJzLMOs4kbyX25XwKG64Xf3CiOF0iY0JQX0VZIx
         x2uQ==
X-Gm-Message-State: ACrzQf3hX1GmCNM5vvDS9OszCTdSfkvEq/HlS6rkWefFs5yjhlYGErTh
        5rlM8OsUJx4scPZJhSRtLq1CjLNKq6n/Ag==
X-Google-Smtp-Source: AMsMyM76vwI/ts6bsxOiQPwWFzW1Cl+UvoNxucP9sg+dfUzFeqWJ+lS5MO8zpIUenATu6RIul6fJEQ==
X-Received: by 2002:a17:902:f60a:b0:186:5d06:8da4 with SMTP id n10-20020a170902f60a00b001865d068da4mr6491359plg.106.1667080895359;
        Sat, 29 Oct 2022 15:01:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b0018685257c0dsm1752523pla.58.2022.10.29.15.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 15:01:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oottT-007xUx-KI; Sun, 30 Oct 2022 09:01:31 +1100
Date:   Sun, 30 Oct 2022 09:01:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <20221029220131.GF3600936@dread.disaster.area>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
 <Y1we59XylviZs+Ry@bfoster>
 <20221028213014.GD3600936@dread.disaster.area>
 <Y1xqkT1vZ9OmzDmH@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1xqkT1vZ9OmzDmH@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 04:49:37PM -0700, Darrick J. Wong wrote:
> On Sat, Oct 29, 2022 at 08:30:14AM +1100, Dave Chinner wrote:
> > On Fri, Oct 28, 2022 at 02:26:47PM -0400, Brian Foster wrote:
> > > On Fri, Oct 28, 2022 at 09:11:09AM -0400, Brian Foster wrote:
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > Here's a quick prototype of "option 3" described in my previous mail.
> > > > This has been spot tested and confirmed to prevent the original stale
> > > > data exposure problem. More thorough regression testing is still
> > > > required. Barring unforeseen issues with that, however, I think this is
> > > > tentatively my new preferred option. The primary reason for that is it
> > > > avoids looking at extent state and is more in line with what iomap based
> > > > zeroing should be doing more generically.
> > > > 
> > > > Because of that, I think this provides a bit more opportunity for follow
> > > > on fixes (there are other truncate/zeroing problems I've come across
> > > > during this investigation that still need fixing), cleanup and
> > > > consolidation of the zeroing code. For example, I think the trajectory
> > > > of this could look something like:
> > > > 
> > > > - Genericize a bit more to handle all truncates.
> > > > - Repurpose iomap_truncate_page() (currently only used by XFS) into a
> > > >   unique implementation from zero range that does explicit zeroing
> > > >   instead of relying on pagecache truncate.
> > > > - Refactor XFS ranged zeroing to an abstraction that uses a combination
> > > >   of iomap_zero_range() and the new iomap_truncate_page().
> > > > 
> > > 
> > > After playing with this and thinking a bit more about the above, I think
> > > I managed to come up with an iomap_truncate_page() prototype that DTRT
> > > based on this. Only spot tested so far, needs to pass iomap_flags to the
> > > other bmbt_to_iomap() calls to handle the cow fork, undoubtedly has
> > > other bugs/warts, etc. etc. This is just a quick prototype to
> > > demonstrate the idea, which is essentially to check dirty state along
> > > with extent state while under lock and transfer that state back to iomap
> > > so it can decide whether it can shortcut or forcibly perform the zero.
> > > 
> > > In a nutshell, IOMAP_TRUNC_PAGE asks the fs to check dirty state while
> > > under lock and implies that the range is sub-block (single page).
> > > IOMAP_F_TRUNC_PAGE on the imap informs iomap that the range was in fact
> > > dirty, so perform the zero via buffered write regardless of extent
> > > state.
> > 
> > I'd much prefer we fix this in the iomap infrastructure - failing to
> > zero dirty data in memory over an unwritten extent isn't an XFS bug,
> > so we shouldn't be working around it in XFS like we did previously.
> 
> Hmm, I think I agree, given that this is really a bug in cache handling.
> Or so I gather; reading on...
> 
> > I don't think this should be call "IOMAP_TRUNC_PAGE", though,
> > because that indicates the caller context, not what we are asking
> > the internal iomap code to do. What we are really asking is for
> > iomap_zero_iter() to do is zero the page cache if it exists in
> > memory, otherwise ignore unwritten/hole pages.  Hence I think a name
> > like IOMAP_ZERO_PAGECACHE is more appropriate,
> 
> I don't even like ZERO_PAGECACHE -- in my mind that implies that it
> unconditionally zeroes any page it finds, whereas we really only want it
> to zero dirty cache contents.  IOMAP_ZERO_DIRTY_CACHE?

Fine by me, the name just needs to describe the action that needs to
be performed....

> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 07da03976ec1..16d9b838e82d 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -915,6 +915,7 @@ xfs_buffered_write_iomap_begin(
> > >  	int			allocfork = XFS_DATA_FORK;
> > >  	int			error = 0;
> > >  	unsigned int		lockmode = XFS_ILOCK_EXCL;
> > > +	u16			iomap_flags = 0;
> > >  
> > >  	if (xfs_is_shutdown(mp))
> > >  		return -EIO;
> > > @@ -942,6 +943,10 @@ xfs_buffered_write_iomap_begin(
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > +	if ((flags & IOMAP_TRUNC_PAGE) &&
> > > +	    filemap_range_needs_writeback(VFS_I(ip)->i_mapping, offset, offset))
> > > +			iomap_flags |= IOMAP_F_TRUNC_PAGE;
> > 
> > As per above, I don't think we should be putting this check in the
> > filesystem. That simplifies this a lot as filesystems don't need to
> > know anything about how iomap manages the page cache for the
> > filesystem...
> 
> I gather from the bug description that this appears to me to be a
> problem with how we manage the page cache during a truncation when the
> eofpage is backed by unwritten extents.

Right, think of iomap_truncate_page() as having exactly the same
responsibilites as block_truncate_page() has for filesystems using
bufferheads. i.e. both functions need to ensure the disk contents
are correctly zeroed such that the caller can safely call
truncate_setsize() afterwards resulting in both the on-disk state
and in-memory state remaining coherent.

Hence iomap_truncate_page() needs to ensure that we handle dirty
data over unwritten extents correctly. If we look further, it is
obvious that iomap already has this responsibility:
SEEK_HOLE/SEEK_DATA does page cache lookups to find data over
unwritten extents. Hence it makes no sense for one part of iomap to
take responsibility for managing data over unwritten extents, whilst
another part ignores it...

If there was another filesystem using iomap and unwritten extents,
it would have exactly the same issues with iomap_truncate_page().
Hence:

> As such, I think that this
> should be a fix within iomap.

This.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
