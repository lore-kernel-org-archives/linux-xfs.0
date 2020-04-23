Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07462C54FD0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 19:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A3D2076C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 19:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPMjbg2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWTyE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 15:54:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725934AbgDWTyD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 15:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587671641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=jYPepcP1l5E0qk11GCoNOs7CvkHo0h1AjF/ZjqMuMlw=;
        b=FPMjbg2c1lrN26iXOYEtOQIrhk9uOpTRysZbKtxYRzgB+mQu8TC/wTdPhL//PbvUI2g9RF
        UEFVDSTnUR7R0ZU3FAzwJx/I4YNrVwCng92f7mMHYK/QbEhkP5DhxE0oCwe5RKaLn5JS66
        9W3F3QBTdDC6rA15CWdd6frxcUxVhpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-7u4d_8Z3PEOx0mLVG2duEA-1; Thu, 23 Apr 2020 15:52:41 -0400
X-MC-Unique: 7u4d_8Z3PEOx0mLVG2duEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C412107BF11
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 19:52:40 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BDC15D9DA
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 19:52:40 +0000 (UTC)
Subject: Re: [PATCH RFC] xfs: log message when allocation fails due to
 alignment constraints
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <37a73948-ff5a-5375-c2e7-54174ae75462@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <0db6c0a6-5a10-993c-d3f9-d56d36e3c911@redhat.com>
Date:   Thu, 23 Apr 2020 14:52:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <37a73948-ff5a-5375-c2e7-54174ae75462@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/23/20 2:34 PM, Eric Sandeen wrote:
> This scenario is the source of much confusion for admins and
> support folks alike:
>=20
> # touch mnt/newfile
> touch: cannot touch =E2=80=98mnt/newfile=E2=80=99: No space left on dev=
ice
> # df -h mnt
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop0      196M  137M   59M  71% /tmp/mnt
> # df -i mnt/
> Filesystem     Inodes IUsed IFree IUse% Mounted on
> /dev/loop0     102400 64256 38144   63% /tmp/mnt
>=20
> because it appears that there is plenty of space available, yet ENOSPC
> is returned.
>=20
> Track this case in the allocation args structure, and when an allocatio=
n
> fails due to alignment constraints, leave a clue in the kernel logs:
>=20
>  XFS (loop0): Failed metadata allocation due to 4-block alignment const=
raint

Welp, I always realize what's wrong with the patch right after I send it;
I think this reports the failure on each AG that fails, even if a later
AG succeeds so I need to get the result up to a higher level.

Still, can see what people think of the idea in general?

Thanks,
-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20
> Right now this depends on my "printk_once" patch but you can change
> xfs_warn_once to xfs_warn or xfs_warn_ratelimited for testing.
>=20
> Perhaps a 2nd patch to log a similar message if alignment failed due to
> /contiguous/ free space constraints would be good as well?
>=20
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 203e74fa64aa..10f32797e5ca 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2303,8 +2303,12 @@ xfs_alloc_space_available(
>  	/* do we have enough contiguous free space for the allocation? */
>  	alloc_len =3D args->minlen + (args->alignment - 1) + args->minalignsl=
op;
>  	longest =3D xfs_alloc_longest_free_extent(pag, min_free, reservation)=
;
> -	if (longest < alloc_len)
> +	if (longest < alloc_len) {
> +		/* Did we fail only due to alignment? */
> +		if (longest >=3D args->minlen)
> +			args->alignfail =3D 1;
>  		return false;
> +	}
> =20
>  	/*
>  	 * Do we have enough free space remaining for the allocation? Don't
> @@ -3067,8 +3071,10 @@ xfs_alloc_vextent(
>  	agsize =3D mp->m_sb.sb_agblocks;
>  	if (args->maxlen > agsize)
>  		args->maxlen =3D agsize;
> -	if (args->alignment =3D=3D 0)
> +	if (args->alignment =3D=3D 0) {
>  		args->alignment =3D 1;
> +		args->alignfail =3D 0;
> +	}
>  	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
>  	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
>  	ASSERT(args->minlen <=3D args->maxlen);
> @@ -3227,6 +3233,13 @@ xfs_alloc_vextent(
> =20
>  	}
>  	xfs_perag_put(args->pag);
> +	if (!args->agbp && args->alignment > 1 && args->alignfail) {
> +		xfs_warn_once(args->mp,
> +"Failed %s allocation due to %u-block alignment constraint",
> +			XFS_RMAP_NON_INODE_OWNER(args->oinfo.oi_owner) ?
> +			  "metadata" : "data",
> +			args->alignment);
> +	}
>  	return 0;
>  error0:
>  	xfs_perag_put(args->pag);
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index a851bf77f17b..29d13cd5c9ac 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -73,6 +73,7 @@ typedef struct xfs_alloc_arg {
>  	int		datatype;	/* mask defining data type treatment */
>  	char		wasdel;		/* set if allocation was prev delayed */
>  	char		wasfromfl;	/* set if allocation is from freelist */
> +	char		alignfail;	/* set if alloc failed due to alignmt */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
>  } xfs_alloc_arg_t;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fda13cd7add0..808060649cad 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3563,6 +3563,7 @@ xfs_bmap_btalloc(
>  	args.mp =3D mp;
>  	args.fsbno =3D ap->blkno;
>  	args.oinfo =3D XFS_RMAP_OINFO_SKIP_UPDATE;
> +	args.alignfail =3D 0;
> =20
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen =3D min(ap->length, mp->m_ag_max_usable);
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 7fcf62b324b0..e98dcb8e65eb 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -685,6 +685,7 @@ xfs_ialloc_ag_alloc(
>  		 * but not to use them in the actual exact allocation.
>  		 */
>  		args.alignment =3D 1;
> +		args.alignfail =3D 0;
>  		args.minalignslop =3D igeo->cluster_align - 1;
> =20
>  		/* Allow space for the inode btree to split. */
>=20

