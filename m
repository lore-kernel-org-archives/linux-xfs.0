Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD99C54FD0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 12:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5419A20704
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 12:40:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhsM6kFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXMkU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:40:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45527 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbgDXMkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 08:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587732018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijkIu4+S3Fz/OGwjz2LBfwJTX3FhFMe+U0Og/vA3ZHg=;
        b=QhsM6kFcZjkByYsy2AP2gr0morzU2WC/q3VnIzlGbENIPr47fmSP6trP6+l4VeBrtOWI/W
        rAMobywfEQDoKhLlaZWd6DNDrskDhXDi/k28PSE/dZo1hj+pHA/oUXm2sV6jarxbReCpfG
        4pBVvPThpwLkN0mcWKodOD/WtSxBdTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-GqMn5RLIMPykV4DnWB-ATw-1; Fri, 24 Apr 2020 08:40:14 -0400
X-MC-Unique: GqMn5RLIMPykV4DnWB-ATw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53C341030980
        for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2020 12:40:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0A921002380;
        Fri, 24 Apr 2020 12:40:10 +0000 (UTC)
Date:   Fri, 24 Apr 2020 08:40:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH RFC] xfs: log message when allocation fails due to
 alignment constraints
Message-ID: <20200424124008.GB53690@bfoster>
References: <37a73948-ff5a-5375-c2e7-54174ae75462@redhat.com>
 <0db6c0a6-5a10-993c-d3f9-d56d36e3c911@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0db6c0a6-5a10-993c-d3f9-d56d36e3c911@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 02:52:39PM -0500, Eric Sandeen wrote:
> On 4/23/20 2:34 PM, Eric Sandeen wrote:
> > This scenario is the source of much confusion for admins and
> > support folks alike:
> >=20
> > # touch mnt/newfile
> > touch: cannot touch =E2=80=98mnt/newfile=E2=80=99: No space left on d=
evice
> > # df -h mnt
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/loop0      196M  137M   59M  71% /tmp/mnt
> > # df -i mnt/
> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> > /dev/loop0     102400 64256 38144   63% /tmp/mnt
> >=20
> > because it appears that there is plenty of space available, yet ENOSP=
C
> > is returned.
> >=20
> > Track this case in the allocation args structure, and when an allocat=
ion
> > fails due to alignment constraints, leave a clue in the kernel logs:
> >=20
> >  XFS (loop0): Failed metadata allocation due to 4-block alignment con=
straint
>=20
> Welp, I always realize what's wrong with the patch right after I send i=
t;
> I think this reports the failure on each AG that fails, even if a later
> AG succeeds so I need to get the result up to a higher level.
>

Hmm, yeah.. the inode chunk allocation code in particular can make
multiple attempts at xfs_alloc_vextent() before the higher level
operation ultimately fails.

> Still, can see what people think of the idea in general?
>=20

Seems reasonable to me in general..

> Thanks,
> -Eric
>=20
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> >=20
> > Right now this depends on my "printk_once" patch but you can change
> > xfs_warn_once to xfs_warn or xfs_warn_ratelimited for testing.
> >=20
> > Perhaps a 2nd patch to log a similar message if alignment failed due =
to
> > /contiguous/ free space constraints would be good as well?
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 203e74fa64aa..10f32797e5ca 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2303,8 +2303,12 @@ xfs_alloc_space_available(
> >  	/* do we have enough contiguous free space for the allocation? */
> >  	alloc_len =3D args->minlen + (args->alignment - 1) + args->minalign=
slop;
> >  	longest =3D xfs_alloc_longest_free_extent(pag, min_free, reservatio=
n);
> > -	if (longest < alloc_len)
> > +	if (longest < alloc_len) {
> > +		/* Did we fail only due to alignment? */
> > +		if (longest >=3D args->minlen)
> > +			args->alignfail =3D 1;
> >  		return false;
> > +	}
> > =20
> >  	/*
> >  	 * Do we have enough free space remaining for the allocation? Don't
> > @@ -3067,8 +3071,10 @@ xfs_alloc_vextent(
> >  	agsize =3D mp->m_sb.sb_agblocks;
> >  	if (args->maxlen > agsize)
> >  		args->maxlen =3D agsize;
> > -	if (args->alignment =3D=3D 0)
> > +	if (args->alignment =3D=3D 0) {
> >  		args->alignment =3D 1;
> > +		args->alignfail =3D 0;
> > +	}

Any reason this is reinitialized only when the caller doesn't care about
alignment? This seems more like something that should be reset on each
allocation call..

BTW I'm also wondering if this is something that could be isolated to a
single location by looking at perag state instead of plumbing the logic
through the allocator args (which is already a mess). I guess we no
longer have the allocator's perag reference once we're back in the inode
allocation code, but the xfs_ialloc_ag_select() code does use a perag to
filter out AGs without enough space. I wonder if that's enough to assume
alignment is the problem if we attempt a chunk allocation and it
ultimately fails..? We could also just consider looking at the perag
again in xfs_dialloc() if the allocation fails, since it looks like we
still have a reference there.

> >  	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
> >  	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
> >  	ASSERT(args->minlen <=3D args->maxlen);
> > @@ -3227,6 +3233,13 @@ xfs_alloc_vextent(
> > =20
> >  	}
> >  	xfs_perag_put(args->pag);
> > +	if (!args->agbp && args->alignment > 1 && args->alignfail) {
> > +		xfs_warn_once(args->mp,
> > +"Failed %s allocation due to %u-block alignment constraint",
> > +			XFS_RMAP_NON_INODE_OWNER(args->oinfo.oi_owner) ?
> > +			  "metadata" : "data",
> > +			args->alignment);
> > +	}

Perhaps this should be ratelimited vs. printed once? I suppose there's
not much value in continuing to print it once an fs is in this inode
-ENOSPC state, but the tradeoff is that if the user clears the state and
maybe runs into it again sometime later without a restart, they might
not see the message and think it's something else. (What about hitting
the same issue across multiple mounts, btw?). I suppose the ideal
behavior would be to print once and never again until an inode chunk has
been successfully allocated (or the system reset)..?

Brian

> >  	return 0;
> >  error0:
> >  	xfs_perag_put(args->pag);
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index a851bf77f17b..29d13cd5c9ac 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -73,6 +73,7 @@ typedef struct xfs_alloc_arg {
> >  	int		datatype;	/* mask defining data type treatment */
> >  	char		wasdel;		/* set if allocation was prev delayed */
> >  	char		wasfromfl;	/* set if allocation is from freelist */
> > +	char		alignfail;	/* set if alloc failed due to alignmt */
> >  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
> >  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> >  } xfs_alloc_arg_t;
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index fda13cd7add0..808060649cad 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3563,6 +3563,7 @@ xfs_bmap_btalloc(
> >  	args.mp =3D mp;
> >  	args.fsbno =3D ap->blkno;
> >  	args.oinfo =3D XFS_RMAP_OINFO_SKIP_UPDATE;
> > +	args.alignfail =3D 0;
> > =20
> >  	/* Trim the allocation back to the maximum an AG can fit. */
> >  	args.maxlen =3D min(ap->length, mp->m_ag_max_usable);
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 7fcf62b324b0..e98dcb8e65eb 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -685,6 +685,7 @@ xfs_ialloc_ag_alloc(
> >  		 * but not to use them in the actual exact allocation.
> >  		 */
> >  		args.alignment =3D 1;
> > +		args.alignfail =3D 0;
> >  		args.minalignslop =3D igeo->cluster_align - 1;
> > =20
> >  		/* Allow space for the inode btree to split. */
> >=20
>=20

