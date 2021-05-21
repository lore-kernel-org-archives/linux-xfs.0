Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08AFC4707D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 19:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0E3B6023D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 19:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhEUTdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 15:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236901AbhEUTc7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 May 2021 15:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FBC36023D;
        Fri, 21 May 2021 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621625493;
        bh=Lzpwa+4Dv31f5JLAaUOIDfqllOjAhxhucSq83xbuMY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DazaZ5Y34kCMO6QABv9ERiOlcuCWKhjgzdRb3HrkKS6XmFKBvLVeof05WCYAsdyai
         zpWXpuKw+mi8sU8Aqq3jMTa17gKJgwwE+Ie4I0nkt29h7Z5mwiIF7CJlHuWuw6Pe28
         UvFBNHLqwE7Yy2Ca6Y0R+m/8jWg7SHY5edZcYnaHILV/kVsQcvaILwBWDR3Q7ToLPE
         kHIJs2rSIOHDJFwd9bQ45hUtPf3knv6ZpzRej9c5u0Kv2QMEVOm4N9Kr89NlZenlWU
         ILTOPl/g3hzKyI3TyhRk4OD5SZHe5iWRyRAZPSKrSEpvB6lo3f1f20zDfNIDIuisws
         w8hAUiLkSZ2NA==
Date:   Fri, 21 May 2021 12:31:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <20210521193133.GA15971@magnolia>
References: <162152893588.2694219.2462663047828018294.stgit@magnolia>
 <162152894725.2694219.2966158387963381824.stgit@magnolia>
 <YKdl75i5ORTiJqlO@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKdl75i5ORTiJqlO@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 21, 2021 at 08:49:03AM +0100, Christoph Hellwig wrote:
> On Thu, May 20, 2021 at 09:42:27AM -0700, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 045118c7bf78..dce267dbea5f 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -589,8 +589,21 @@ xfs_inode_validate_extsize(
> >  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> >  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> >  
> > +	/*
> > +	 * Historically, XFS didn't check that the extent size hint was an
> > +	 * integer multiple of the rt extent size on a directory with both
> > +	 * rtinherit and extszinherit flags set.  This results in math errors
> > +	 * in the rt allocator and inode verifier errors when the unaligned
> > +	 * hint value propagates into new realtime files.  Since there might
> > +	 * be filesystems in the wild, the best we can do for now is to
> > +	 * mitigate the harms by stopping the propagation.
> > +	 *
> > +	 * The next time we add a new inode feature, the if test below should
> > +	 * also trigger if that new feature is enabled and (rtinherit_flag &&
> > +	 * inherit_flag).
> > +	 */
> 
> I don't understand how this comment relates to the change below, and
> in fact I don't understand the last paragraph at all.

It doesn't relate to the cleanup below at all.  I put a comment there to
explain why this verifier function doesn't check the rextsize alignment
of the hint.  In other words, it's a comment describing a gap in a
validation function and why we can't remove the gap here but have to
sprinkle mitigations everywhere else.

Earlier iterations of this patch simply fixed the verifier and allowed
existing filesystems to fail.  Brian and I weren't totally comfortable
with introducing a breaking change like that even though the
consequences of the bad hint actually propagating into a realtime file
are immediate filesystem corruption shutdowns, so this iteration
mitigates the propagation issue by fixing directories when they get
rewritten and preventing propagation of bad hints into new files.

I don't want to introduce a new feature/inode flag just to say
"corrected rt extent size hint" since having an extent size hint set on
a filesystem with a realtime extent size larger than 1 fsb on a
filesystem with a realtime volume configured at all is a vanishingly
rare condition.

Granted, we could decide to introduce the breaking verifier change and
say "fmeh to this corner case, if you did that you're screwed anyway",
but I think I want a few more ACKs on /that/ strategy before I do that.

> >  	if (rt_flag)
> > -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> > +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> 
> This just looks like a cleanup, that is replace the open coded version
> of XFS_FSB_TO_B with the actual helper.

Yes.  As I mentioned above, the comment documents code that isn't there
and cannot be added.

> > +	/*
> > +	 * Clear invalid extent size hints set on files with rtinherit and
> > +	 * extszinherit set.  See the comments in xfs_inode_validate_extsize
> > +	 * for details.
> > +	 */
> 
> Maybe that comment should be here as it makes a whole lot more sense
> where we do the actual clearing.

Ok.

> 
> > +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> > +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> > +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> > +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);
> 
> Overly long line.

Fixed, though Linus said to stop caring about code that goes slightly
over.

> > +	xfs_failaddr_t		failaddr;
> >  	umode_t			mode = VFS_I(ip)->i_mode;
> >  
> >  	if (S_ISDIR(mode)) {
> >  		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
> > -			di_flags |= XFS_DIFLAG_RTINHERIT;
> > +			ip->i_diflags |= XFS_DIFLAG_RTINHERIT;
> 
> The removal of the di_flags seems like an unrelated (though nice)
> cleanup.

Ok fine I'll do this bugfix properly and turn the cleanups into new
separate patches and add all three to the 15+ cleanup patches I didn't
manage to get merged last cycle.

--D
