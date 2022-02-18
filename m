Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BD2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Feb 2022 14:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiBROTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Feb 2022 09:19:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBROTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Feb 2022 09:19:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 746FAD1D6A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Feb 2022 06:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645193971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iSjCSZZm7yvYSOB2voThZmD6OwcRUSWJOF2dtNs20/M=;
        b=CcN7R9zhHBNU33F6EJ54kCodhvVMXJSVGnj59l09whARMkqb5v3Hb/o65R2Qjoq3DT/pkV
        HZ8RoeAxOxQ9a0ws+3vEy3WLXAIEm7C6Sqmzyigs4IC39o5iTbwkPUip3QACijW6s1lFjZ
        iAIqIJKuTXqM7iDhgH1eXXXILh8LFUY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-W_3OLKavOiq1xa1IvRLJ3w-1; Fri, 18 Feb 2022 09:19:30 -0500
X-MC-Unique: W_3OLKavOiq1xa1IvRLJ3w-1
Received: by mail-qv1-f70.google.com with SMTP id kd18-20020a056214401200b0042de5c14702so8960597qvb.12
        for <linux-xfs@vger.kernel.org>; Fri, 18 Feb 2022 06:19:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iSjCSZZm7yvYSOB2voThZmD6OwcRUSWJOF2dtNs20/M=;
        b=BVA57DyzmFPs1Wz/cGa6yDqrEUVPdA8Fhbsra8Xw77evnA0yHb/b/k6AlLfJcBdZXH
         DmC7mB9WMRPpIbXnYnVrPvvb+GP5RCiO8NT7rF9mBPc80LjLlnTS//sWSea3nBWtykgB
         KvP8h9EH8FwBLRbOebSA7xYDNtypnb+jBl4rFraStiMkCpPEXlc7gQd6BtsBsRssNKqz
         k5g37SCWaPssTeYE5YR3LDIrYjwagdqDZqndHS+7gbObfzig/X7v1XZBas3DQ+aWsJN3
         iFDvGeuqOQyRud2Xrem8SROTl+8NR6VVbKOWk9PimvWGfIcp5YJBH7v+C6ufTt6Clqhy
         r3xA==
X-Gm-Message-State: AOAM533aCl2On6GUWBS32uxwu8nTOhrhFVcAntKCjp2e0AEkJrcfAH0C
        R9cSsjDo473/3pnUsfwmNHK3TvfOW/Ok8285WuR+HeBWCtiqVtAMTRmjcd9Xc5aMlZ+cmF/2qeb
        GICv6Lw4VOyNjSUOim/eZ
X-Received: by 2002:a37:a148:0:b0:47e:b863:a656 with SMTP id k69-20020a37a148000000b0047eb863a656mr4747881qke.522.1645193969343;
        Fri, 18 Feb 2022 06:19:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrRTeX7W7xhmjIDbkyw2/3wRosKHILRIprs4ruFdB7LJyhPtp/Y+E8/oyIPdFCbWC9Im3JIA==
X-Received: by 2002:a37:a148:0:b0:47e:b863:a656 with SMTP id k69-20020a37a148000000b0047eb863a656mr4747855qke.522.1645193968897;
        Fri, 18 Feb 2022 06:19:28 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id m4sm21184907qka.111.2022.02.18.06.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 06:19:28 -0800 (PST)
Date:   Fri, 18 Feb 2022 09:19:26 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] xfs: tag reclaimable inodes with pending RCU
 grace periods as busy
Message-ID: <Yg+q7mAwfGsOcpXV@bfoster>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-3-bfoster@redhat.com>
 <20220217231649.GC59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217231649.GC59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 18, 2022 at 10:16:49AM +1100, Dave Chinner wrote:
> On Thu, Feb 17, 2022 at 12:25:16PM -0500, Brian Foster wrote:
> > In order to avoid aggressive recycling of in-core xfs_inode objects with
> > pending grace periods and the subsequent RCU sync stalls involved with
> > recycling, we must be able to identify them quickly and reliably at
> > allocation time. Claim a new tag for the in-core inode radix tree and
> > tag all inodes with a still pending grace period cookie as busy at the
> > time they are made reclaimable.
> > 
> > Note that it is not necessary to maintain consistency between the tag
> > and grace period status once the tag is set. The busy tag simply
> > reflects that the grace period had not expired by the time the inode was
> > set reclaimable and therefore any reuse of the inode must first poll the
> > RCU subsystem for subsequent expiration of the grace period. Clear the
> > tag when the inode is recycled or reclaimed.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_icache.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 693896bc690f..245ee0f6670b 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -32,6 +32,8 @@
> >  #define XFS_ICI_RECLAIM_TAG	0
> >  /* Inode has speculative preallocations (posteof or cow) to clean. */
> >  #define XFS_ICI_BLOCKGC_TAG	1
> > +/* inode has pending RCU grace period when set reclaimable  */
> > +#define XFS_ICI_BUSY_TAG	2
> >  
> >  /*
> >   * The goal for walking incore inodes.  These can correspond with incore inode
> > @@ -274,7 +276,7 @@ xfs_perag_clear_inode_tag(
> >  	if (agino != NULLAGINO)
> >  		radix_tree_tag_clear(&pag->pag_ici_root, agino, tag);
> >  	else
> > -		ASSERT(tag == XFS_ICI_RECLAIM_TAG);
> > +		ASSERT(tag == XFS_ICI_RECLAIM_TAG || tag == XFS_ICI_BUSY_TAG);
> >  
> >  	if (tag == XFS_ICI_RECLAIM_TAG)
> >  		pag->pag_ici_reclaimable--;
> > @@ -336,6 +338,7 @@ xfs_iget_recycle(
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct inode		*inode = VFS_I(ip);
> > +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> >  	int			error;
> >  
> >  	trace_xfs_iget_recycle(ip);
> > @@ -392,8 +395,9 @@ xfs_iget_recycle(
> >  	 */
> >  	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
> >  	ip->i_flags |= XFS_INEW;
> > -	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> > -			XFS_ICI_RECLAIM_TAG);
> > +
> > +	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_BUSY_TAG);
> > +	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
> 
> This doesn't need any of the global mp->m_perag_tree tracking or
> anything else to be tracked or queued - it's just a single state bit
> that is associated with the inode and nothing more. The inode
> allocation side of things is already per-ag, so it can check the
> perag icache tree directly and hence there's no need for global
> perag tree tracking.
> 

Seems reasonable, though I'll probably worry about this sort of cleanup
after the bigger picture things are worked out. (I like having the
existing tracepoints available, if nothing else).

> Hence this could just be:
> 
> +	radix_tree_tag_clear(&pag->pag_ici_root, agino, XFS_ICI_BUSY_TAG);
> 
> 
> >  	inode->i_state = I_NEW;
> >  	spin_unlock(&ip->i_flags_lock);
> >  	spin_unlock(&pag->pag_ici_lock);
> > @@ -931,6 +935,7 @@ xfs_reclaim_inode(
> >  	if (!radix_tree_delete(&pag->pag_ici_root,
> >  				XFS_INO_TO_AGINO(ip->i_mount, ino)))
> >  		ASSERT(0);
> > +	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_BUSY_TAG);
> >  	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_RECLAIM_TAG);
> >  	spin_unlock(&pag->pag_ici_lock);
> 
> This becomes unnecessary, because radix_tree_delete() clears the
> tags for the slot where the entry being deleted is found.
> 
> >  
> > @@ -1807,6 +1812,7 @@ xfs_inodegc_set_reclaimable(
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_perag	*pag;
> > +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> >  
> >  	if (!xfs_is_shutdown(mp) && ip->i_delayed_blks) {
> >  		xfs_check_delalloc(ip, XFS_DATA_FORK);
> > @@ -1821,10 +1827,12 @@ xfs_inodegc_set_reclaimable(
> >  	trace_xfs_inode_set_reclaimable(ip);
> >  	if (destroy_gp)
> >  		ip->i_destroy_gp = destroy_gp;
> > +	if (!poll_state_synchronize_rcu(ip->i_destroy_gp))
> > +		xfs_perag_set_inode_tag(pag, agino, XFS_ICI_BUSY_TAG);
> 
> And this becomes:
> 
> +	if (!poll_state_synchronize_rcu(ip->i_destroy_gp))
> +		radix_tree_tag_set(&pag->pag_ici_root, agino, XFS_ICI_BUSY_TAG);
> 
> ---
> 
> FWIW, I have most of the inode cache life-cycle rework prototyped.
> All the unlink stuff is done - unlinked inodes are freed directly
> in ->destroy_inode now which gets callled on demand when the inodes
> are marked clean or XFS_ISTALE cluster buffers are committed. Hence
> they don't even go through an IRECLAIMABLE state anymore. I'm
> currently working on the same thing for inodes that needed EOF block
> trimming, and once that is done the whole XFS_IRECLAIMABLE state and
> the background inode reclaim goes away. This also takes with it the 
> XFS_ICI_RECLAIM_TAG, the inode cache shrinker and a few other bits
> and pieces...
> 
> The prototype needs busy inode tracking now, so I was looking at
> doing a simple busy inode tracking thing yesterday hence my comments
> above. I'm currently just using the XFS_INACTIVE flags to delay
> xfs_iget lookups from allocation until the inode has been reclaimed
> (really, really slow!) and generic/001 hits this pretty hard.
> 

Ok. As shown here, the tracking bits are fairly trivial either way. The
allocation side is a bit more involved..

> I'll have a deeper look at patch 4 on Monday and chop it down to
> the bare minimum tag lookups and, hopefully, I'll be able to get
> rid of the need for patch 3 in this series at the same time...
> 

Patch 3 is just an incremental hack to implement a fallback to chunk
allocation when the inode selection algorithm decides it's warranted. I
was expecting (hoping) this would get cleaned up properly by reworking
some of the selection code so we can continue to make this allocation
decision up front (including some busy state in the logic), but hadn't
got to that point yet. Is that what you're referring to here, or are you
trying to implement some other type of fallback behavior in its place..?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

