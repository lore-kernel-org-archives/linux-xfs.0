Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E9FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0919F64F6A
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhCSGFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233756AbhCSGFg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 02:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AEF864F1C;
        Fri, 19 Mar 2021 06:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616133935;
        bh=A5TJoETdcjsIxUrfnA6AAlju7CW2pubdIJFXnlN1BCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ay2sSYb8hGv/GoOh/GasX+r4SFebbYZikK2WBdrgLkGYFsJtp/PgW3TifMRNps+EL
         c5LNdc47bxfAdV7A3AOx3gYexPKJ7wmbk9oPTWaMxEj5mEy6m3r6+WRGB/D7hTG17s
         rqHoGthF5vGLv7cLRxEWzSt3C8xHnmaCRtSD7h/2+3dphNTP8LySL9QUB80zP0e59Y
         4kZ0PLjQ4bw5LFR/zTQMyZzKYPovyirfiRH2Dniw1bOL3rnogegcujz1pQtVNjkoHt
         HasH1Bqea5Kx4mqKrpYCe/zKSviqIamGv3kjmoPTXpMLk+nmoowuUDUFA11nytnYsZ
         uZwaTf9XOU41w==
Date:   Thu, 18 Mar 2021 23:05:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
Message-ID: <20210319060534.GF1670408@magnolia>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681767.1887542.5197301352012661570.stgit@magnolia>
 <20210319055907.GB955126@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319055907.GB955126@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 05:59:07AM +0000, Christoph Hellwig wrote:
> On Thu, Mar 18, 2021 at 03:33:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix the weird split of responsibilities between xfs_can_free_eofblocks
> > and xfs_free_eofblocks by moving the chunk of code that looks for any
> > actual post-EOF space mappings from the second function into the first.
> > 
> > This clears the way for deferred inode inactivation to be able to decide
> > if an inode needs inactivation work before committing the released inode
> > to the inactivation code paths (vs. marking it for reclaim).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_bmap_util.c |  148 +++++++++++++++++++++++++-----------------------
> >  1 file changed, 78 insertions(+), 70 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index e7d68318e6a5..d4ceba5370c7 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -597,8 +597,17 @@ xfs_bmap_punch_delalloc_range(
> >   * regular files that are marked preallocated or append-only.
> >   */
> >  bool
> > -xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
> > +xfs_can_free_eofblocks(
> > +	struct xfs_inode	*ip,
> > +	bool			force)
> >  {
> > +	struct xfs_bmbt_irec	imap;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_fileoff_t		end_fsb;
> > +	xfs_fileoff_t		last_fsb;
> > +	int			nimaps = 1;
> > +	int			error;
> 
> Should we have an assert here that this is called under the iolock?
> Or can't the reclaim be expressed nicely?

xfs_inactive doesn't take the iolock because (evidently) at some point
there were lockdep complaints about taking it in reclaim context.  By
the time the inode reaches inactivation context, there can't be any
other users of it anyway -- the last caller dropped its reference, we
tore down the VFS inode, and anyone who wants to resuscitate the inode
will wait in xfs_iget for us to finish.

--D

> > +/*
> > + * This is called to free any blocks beyond eof. The caller must hold
> > + * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
> > + * reference to the inode.
> > + */
> 
> Same thing here, usually asserts are better than comments..  That being
> said can_free_eofblocks would benefit from at least a comment if the
> assert doesn't work.
> 
> Otherwise this looks good.
