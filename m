Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEADC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0F620885
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="drBNIGwB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgHTRsA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:48:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgHTRry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 13:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597945671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hDBQBHQNHEPgvaKMM+JjP41luO68SMD949up6Njp9HI=;
        b=drBNIGwBDdFJFxntEvfqEiRvzm7xVo/kpcwOJP+W/kY4foy2LM10TVnESglIkK3wdlN0+M
        FGb1H6BnOURXUhODX+PLieUNixS3vvhhqTPFCkaU+GdiMSBUNhiw+sc4fJdboShZ3nf5+V
        VnT2zLMq3mWTGceWsJH3RU+3xNZgBbo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-uVpEVSPAOnGAuGMYQhquBw-1; Thu, 20 Aug 2020 13:47:48 -0400
X-MC-Unique: uVpEVSPAOnGAuGMYQhquBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F38AD1015C96;
        Thu, 20 Aug 2020 17:47:10 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A9727B8F4;
        Thu, 20 Aug 2020 17:47:10 +0000 (UTC)
Date:   Thu, 20 Aug 2020 13:47:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one in inode alloc block reservation
 calculation
Message-ID: <20200820174708.GA183950@bfoster>
References: <20200820170734.200502-1-bfoster@redhat.com>
 <20200820172512.GJ6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820172512.GJ6096@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 10:25:12AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 01:07:34PM -0400, Brian Foster wrote:
> > The inode chunk allocation transaction reserves inobt_maxlevels-1
> > blocks to accommodate a full split of the inode btree. A full split
> > requires an allocation for every existing level and a new root
> > block, which means inobt_maxlevels is the worst case block
> > requirement for a transaction that inserts to the inobt. This can
> > lead to a transaction block reservation overrun when tmpfile
> > creation allocates an inode chunk and expands the inobt to its
> > maximum depth. This problem has been observed in conjunction with
> > overlayfs, which makes frequent use of tmpfiles internally.
> > 
> > The existing reservation code goes back as far as the Linux git repo
> > history (v2.6.12). It was likely never observed as a problem because
> > the traditional file/directory creation transactions also include
> > worst case block reservation for directory modifications, which most
> > likely is able to make up for a single block deficiency in the inode
> > allocation portion of the calculation. tmpfile support is relatively
> > more recent (v3.15), less heavily used, and only includes the inode
> > allocation block reservation as tmpfiles aren't linked into the
> > directory tree on creation.
> > 
> > Fix up the inode alloc block reservation macro and a couple of the
> > block allocator minleft parameters that enforce an allocation to
> > leave enough free blocks in the AG for a full inobt split.
> 
> Looks all fine to me, but... does a similar logic apply to the other
> maxlevels uses in the kernel?
> 
> fs/xfs/libxfs/xfs_trans_resv.c:73:      blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
> fs/xfs/libxfs/xfs_trans_resv.c:75:              blocks += max(num_ops * (2 * mp->m_rmap_maxlevels - 1),
> fs/xfs/libxfs/xfs_trans_resv.c:78:              blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
> 
> Can we end up in the same kind of situation with those other trees
> {bno,cnt,rmap,refc} where we have a maxlevels-1 tall tree and split each
> level all the way to the top?
> 

Hmm.. it seems so at first glance, but I'm not sure I follow the
calculations in that function. If we factor out the obvious
num_ops/num_trees components, the comment refers to the following
generic formula:

	((2 blocks/level * max depth) - 1)

I take it that since this is a log reservation calculation, the two
block/level multiplier is there because we have to move records between
two blocks for each level that splits. Is there a reason the -1 is
applied after that multiplier (as opposed to subtracting 1 from the max
depth first)? I'm wondering if that's intentional and it reflects that
the root level is only one block...

Brian

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> For this bit,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c      | 4 ++--
> >  fs/xfs/libxfs/xfs_trans_space.h | 2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index f742a96a2fe1..a6b37db55169 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -688,7 +688,7 @@ xfs_ialloc_ag_alloc(
> >  		args.minalignslop = igeo->cluster_align - 1;
> >  
> >  		/* Allow space for the inode btree to split. */
> > -		args.minleft = igeo->inobt_maxlevels - 1;
> > +		args.minleft = igeo->inobt_maxlevels;
> >  		if ((error = xfs_alloc_vextent(&args)))
> >  			return error;
> >  
> > @@ -736,7 +736,7 @@ xfs_ialloc_ag_alloc(
> >  		/*
> >  		 * Allow space for the inode btree to split.
> >  		 */
> > -		args.minleft = igeo->inobt_maxlevels - 1;
> > +		args.minleft = igeo->inobt_maxlevels;
> >  		if ((error = xfs_alloc_vextent(&args)))
> >  			return error;
> >  	}
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index c6df01a2a158..7ad3659c5d2a 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -58,7 +58,7 @@
> >  #define	XFS_IALLOC_SPACE_RES(mp)	\
> >  	(M_IGEO(mp)->ialloc_blks + \
> >  	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> > -	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> > +	  M_IGEO(mp)->inobt_maxlevels))
> >  
> >  /*
> >   * Space reservation values for various transactions.
> > -- 
> > 2.25.4
> > 
> 

