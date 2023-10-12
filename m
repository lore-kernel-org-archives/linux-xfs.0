Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E779BCDB474
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 21:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347421AbjJLVzu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 17:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347416AbjJLVzt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 17:55:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E5B8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 14:55:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14465C433C7;
        Thu, 12 Oct 2023 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697147747;
        bh=SlCKDpmqnyk938VcIBYwsf2RW/UBw3Hfqvj+bIgpL88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XgBUR2PaJMxb3pVpaMljGXm223HEzG00+/zVBs9pZX8AWcAIy4ZnXyt06E4KaK1eU
         /uVnWwaFcOifP3adDy+5+ObrHLfhfTqAAKYREDZWjXd9iHzhmTI6I+UWbn/p4MGG/Z
         N8S1wKpBSaK5b8gmzx8BnHrjrF6zdTJ//HePsbIojPh7rvR9gwlwFxQhB5czPAKKZZ
         XP2GIw025mDiVfmT+YxC7eiQbIsY5m5RuGRO9AWkj+cnj+//xdKxgWmDipGurUb4KV
         e2wxj05Dr53YPO00SPiSJfL9zcqzti/Az0c5c6vauPoVWBNuqmxThXfiOm80Gdh5VT
         73yzy4Xqbg6NQ==
Date:   Thu, 12 Oct 2023 14:55:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 5/8] xfs: create helpers for rtbitmap block/wordcount
 computations
Message-ID: <20231012215546.GN21298@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721706.1773834.7063943000548807823.stgit@frogsfrogsfrogs>
 <20231012054433.GD2795@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012054433.GD2795@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:44:33AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:07:32AM -0700, Darrick J. Wong wrote:
> > +/*
> > + * Compute the number of rtbitmap blocks needed to track the given number of rt
> > + * extents.
> > + */
> > +xfs_filblks_t
> > +xfs_rtbitmap_blockcount(
> > +	struct xfs_mount	*mp,
> > +	xfs_rtbxlen_t		rtextents)
> > +{
> > +	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
> > +}
> 
> Given that this only has a few users, the !RT stub is a pain, and
> having a different result from before in the transaction reservation
> is somewhat unexpected change (even if harmless),

Ohh, right, I didn't even notice that the result changes slightly when
the we go from dividing by NBBY before howmany'ing with blocksize to
howmany'ing with (NBBY * blocksize).

> maybe just mark this inline?

I could make these inline functions at the bottom of xfs_rtbitmap.h, and
even put them outside of the #ifdef RT bits.  That'll get rid of two
stubs for now, but later the rtgroups patchset wants to add a header
to rtbitmap blocks.  Then we'll need a function to compute the number of
rtextents covered by a single bitmap block:

/* Compute the number of rt extents tracked by a single bitmap block. */
xfs_rtxnum_t
xfs_rtbitmap_rtx_per_rbmblock(
	struct xfs_mount	*mp)
{
	unsigned int		rbmblock_bytes = mp->m_sb.sb_blocksize;

	if (xfs_has_rtgroups(mp))
		rbmblock_bytes -= sizeof(struct xfs_rtbuf_blkinfo);

	return rbmblock_bytes * NBBY;
}

So then either this function will need to have a stub that returns a
garbage value.  Alternately, it could move out of xfs_rtbitmap.c.

Right now, xfs_rtbitmap_rtx_per_rbmblock isn't even a defined symbol for
!RT, and the stub version of _wordcount and _blockcount return 0, which
at least makes sense.

> > +/*
> > + * Compute the number of rtbitmap words needed to populate every block of a
> > + * bitmap that is large enough to track the given number of rt extents.
> > + */
> > +unsigned long long
> > +xfs_rtbitmap_wordcount(
> > +	struct xfs_mount	*mp,
> > +	xfs_rtbxlen_t		rtextents)
> > +{
> > +	xfs_filblks_t		blocks;
> > +
> > +	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
> > +	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
> > +}
> 
> This one isn't used in this patch or the rest of the series.  Maybe
> move it to the patch (-series) that adds the caller in the repair
> code?

<shrug> The xfsprogs version of this patch uses this helper to decrapify
the incore rtbitmap computation in xfs_repair:

diff --git a/repair/rt.c b/repair/rt.c
index 8f3b9082a9b..244b59f04ce 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -19,6 +19,8 @@
 void
 rtinit(xfs_mount_t *mp)
 {
+       unsigned long long      wordcnt;
+
        if (mp->m_sb.sb_rblocks == 0)
                return;
 
@@ -26,11 +28,9 @@ rtinit(xfs_mount_t *mp)
         * realtime init -- blockmap initialization is
         * handled by incore_init()
         */
-       /*
-       sumfile = calloc(mp->m_rsumsize, 1);
-       */
-       if ((btmcompute = calloc(mp->m_sb.sb_rbmblocks *
-                       mp->m_sb.sb_blocksize, 1)) == NULL)
+       wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+       btmcompute = calloc(wordcnt, sizeof(xfs_rtword_t));
+       if (!btmcompute)
                do_error(
        _("couldn't allocate memory for incore realtime bitmap.\n"));

So I'd rather leave these two helpers defined as they are.

--D
