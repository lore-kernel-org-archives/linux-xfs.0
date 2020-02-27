Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEFAC4BA3B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 11:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A434424695
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 11:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9U9IX29"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgB0Lxu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 06:53:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728908AbgB0Lxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 06:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582804428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/iHyTCTmW3Yuc5G14lBOULM67MrZDJB3a2Ct8b8PNYk=;
        b=J9U9IX29q0HhmheRFXN20dVbTPe0dd1oFlLVsKwmw5IIHHflicFBa5AgB30zBQ9PwQf4QE
        Z6zDODkT/EXM3Z43zwGMjCutGCNH0wROlzp7VHqdMsnl7IqFL3U8MB9eVgZ1DB0clzoRlA
        ChKoueZ7akMU15CqVjj2Td7q1b1aoEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-JGuIGxQBNWqqZzDF926gSA-1; Thu, 27 Feb 2020 06:53:44 -0500
X-MC-Unique: JGuIGxQBNWqqZzDF926gSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6898107ACC4;
        Thu, 27 Feb 2020 11:53:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B30C5C297;
        Thu, 27 Feb 2020 11:53:42 +0000 (UTC)
Date:   Thu, 27 Feb 2020 06:53:40 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 3/7] xfs: xfs_attr_calc_size: Calculate Bmbt
 blks only once
Message-ID: <20200227115340.GA5604@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <9720921.4HTaHYPh1W@localhost.localdomain>
 <20200226164258.GC19695@bfoster>
 <4371238.mKpYxNBjvR@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4371238.mKpYxNBjvR@localhost.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 02:29:16PM +0530, Chandan Rajendra wrote:
> On Wednesday, February 26, 2020 10:12 PM Brian Foster wrote: 
> > On Wed, Feb 26, 2020 at 08:33:12PM +0530, Chandan Rajendra wrote:
> > > On Tuesday, February 25, 2020 9:41 PM Brian Foster wrote: 
> > > > On Mon, Feb 24, 2020 at 09:30:40AM +0530, Chandan Rajendra wrote:
> > > > > The number of Bmbt blocks that is required can be calculated only once by
> > > > > passing the sum of total number of dabtree blocks and remote blocks to
> > > > > XFS_NEXTENTADD_SPACE_RES() macro.
> > > > > 
> > > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > > ---
> > > > 
> > > > According to the cover letter this is fixing a reservation calculation
> > > > issue, though the commit log kind of gives the impression it's a
> > > > refactor. Can you elaborate on what this fixes in the commit log?
> > > > 
> > > 
> > > XFS_NEXTENTADD_SPACE_RES() first figures out the number of Bmbt leaf blocks
> > > needed for mapping the 'block count' passed to it as the second argument.
> > > When calculating the number of leaf blocks, it accommodates the 'block count'
> > > argument in groups of XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp). For each such
> > > group it decides that a bmbt leaf block is required. For each of the leaf
> > > blocks that needs to be allocated, it assumes that there will be a split of
> > > the bmbt tree from root to leaf. Hence it multiplies the number of leaf blocks
> > > with the maximum height of the tree.
> > > 
> > > With two individual calls to XFS_NEXTENTADD_SPACE_RES() (one is indirectly
> > > through the call to XFS_DAENTER_BMAPS() => XFS_DAENTER_BMAP1B() and the other
> > > is for remote attr blocks) we miss out on the opportunity to group the bmbt
> > > leaf blocks and hence overcompensate on the bmbt blocks calculation.
> > > 
> > > Please let me know if my understanding is incorrect.
> > > 
> > 
> > Ok, thanks. I think I follow the intent. This patch is actually intended
> > to reduce block reservation by simplifying this calculation, right?
> 
> I noticed xfs/132 test failing when I had changed the code to have 32-bit
> xattr extent counter. The corresponding mount failure was due to log size
> checks failing in xfs_log_mount(). The difference in value returned by
> xfs_log_calc_minimum_size() => xfs_log_get_max_trans_res() =>
> xfs_log_calc_max_attrsetm_res() was pretty large.
> 
> Upon code inspection I found the inconsistencies in
> xfs_log_calc_max_attrsetm_res() which are described in the cover letter and as
> part of the commit message of the last patch.
> 

Ok, so the fixes to xfs_log_calc_max_attrsetm_res() are what actually
fixed the test failure? If so, that strikes me as a good independent fix
candidate (re: refactoring) because the commit log for that one should
probably describe the observable problem and the fix separate from other
issues.

> After a quick chat with Dave on irc, we figured that the best approach was to
> convert xfs_attr_calc_size() into a helper function so that the size
> calculations for an xattr set operation is placed in a single function. These
> values can then be used by other functions like xfs_attr_set() and
> xfs_log_calc_max_attrsetm_res().
> 
> Along the way, I found that the mount time reservation was incorrectly done as
> well. For E.g. dabtree splits getting accounted as part of mount time
> reservation was wrong. Due to these reasons and others listed in the cover
> letter I ended up changing the mount time and run time reservation
> calculations.
> 
> Hence, The reduced reservation sizes are actually a side effect of fixing the
> inconsistencies.
> 

Ok, so most of the rest sounds like bogosity discovered by code
inspection. That's not that surprising given that transaction
reservations are worst case values and thus it seems we sometimes get
away with bogus calculations just so long as the reservations are large
enough. :)

As it is, the final result of this patchset looks nice to me, it's just
a matter of getting there more incrementally to facilitate reviewing the
changes being made. FWIW, if we do end up with a final "fix the broken
xattr res calculation" patch at the end of the series, I think it would
be helpful to have a very deliberate commit log that contains something
like the following:

'The xattr reservation currently consists of:

	- superblock
	- dabtree * maxdepth
	- ...

This calculation is bogus because it double accounts X as part of Y and
Z, doesn't account for AGF, etc. etc. ...

The xattr reservation needs to account the following:

	- superblock
	- agf
	- dabtree * maxdepth
	- rmtblocks
	- ...

... '

> > 
> > I'm not hugely familiar with the dabtree code, but is it possible the
> > existing reservations are written this way because each dabtree
> > extension along with a remote block allocation are independent
> > xfs_bmapi_write() calls? IOW, perhaps we cannot assume these can all
> > land in the same bmbt blocks across the xattr operation? ISTM that might
> > explain that XFS_DAENTER_BMAPS() calculates the reservation for a single
> > attr block and multiplies it by the max depth, but I could easily be
> > misunderstanding something.
> 
> I think you are right. I will keep the bmbt calculations separate for dabtree
> and remote blocks and add them up at the end of the function.
> 

Ok. I think it's probably safer to preserve historical behavior in that
regard, unless somebody can confirm otherwise in the meantime.

Brian

> > 
> > What is the motivation for this patch btw? Have you observed a problem
> > or excessive reservation sizes, or is this by code inspection?
> > 
> > Brian
> > 
> > > > 
> > > > >  fs/xfs/libxfs/xfs_attr.c | 7 +++----
> > > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > > index 942ba552e0bdd..a708b142f69b6 100644
> > > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > > @@ -154,12 +154,10 @@ xfs_attr_calc_size(
> > > > >  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> > > > >  			args->valuelen, local);
> > > > >  	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > > > > -	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
> > > > >  	if (*local) {
> > > > >  		if (size > (args->geo->blksize / 2)) {
> > > > >  			/* Double split possible */
> > > > >  			total_dablks *= 2;
> > > > > -			bmbt_blks *= 2;
> > > > >  		}
> > > > >  		rmt_blks = 0;
> > > > >  	} else {
> > > > > @@ -168,10 +166,11 @@ xfs_attr_calc_size(
> > > > >  		 * make room for the attribute value itself.
> > > > >  		 */
> > > > >  		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> > > > > -		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, rmt_blks,
> > > > > -				XFS_ATTR_FORK);
> > > > >  	}
> > > > >  
> > > > > +	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> > > > > +			XFS_ATTR_FORK);
> > > > > +
> > > > >  	return total_dablks + rmt_blks + bmbt_blks;
> > > > >  }
> > > > >  
> > > > 
> > > > 
> > > 
> > 
> > 
> 
> -- 
> chandan
> 
> 
> 

