Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 047A7C83F3D
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 20:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjHaUC5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 16:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjHaUC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 16:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402ABEA
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 13:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693512134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLgD/rgftMMueaUjX0qoZNgWIPNemV5IukfMTcZhUS8=;
        b=Ro8J//sCJltmALOpwKwbGVEaNQXw6zz/xgTcFwdCXBX8UOGjCLoMcKp3xLowifhGCRT1FA
        eEIJt5rgwNwNxEWHQI9cuhL6RmNYYr0XzdP+c0xCmUepDIvHGN2bevohaVH/VGu4ccch1I
        5vsQdxbrC2VunyX5gApbKoc7fkGOJzU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-683-gvAEXJKrMUO4pzsYnK55QQ-1; Thu, 31 Aug 2023 16:02:11 -0400
X-MC-Unique: gvAEXJKrMUO4pzsYnK55QQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 832B7101A52E;
        Thu, 31 Aug 2023 20:02:10 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 271D9492C13;
        Thu, 31 Aug 2023 20:02:10 +0000 (UTC)
Date:   Thu, 31 Aug 2023 15:02:08 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 2/2] xfs_db: create unlinked inodes
Message-ID: <ZPDxwD5clg4gY2+s@redhat.com>
References: <20230830152659.GJ28186@frogsfrogsfrogs>
 <20230830232529.GL28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830232529.GL28186@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2023 at 04:25:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an expert-mode debugger command to create unlinked inodes.
> This will hopefully aid in simulation of leaked unlinked inode handling
> in the kernel and elsewhere.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  db/iunlink.c             |  196 ++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_api_defs.h |    1 
>  man/man8/xfs_db.8        |   11 +++
>  3 files changed, 208 insertions(+)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index 303b5daf..d87562e3 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -197,8 +197,204 @@ static const cmdinfo_t	dump_iunlinked_cmd =
>  	  N_("[-a agno] [-b bucket] [-q] [-v]"),
>  	  N_("dump chain of unlinked inode buckets"), NULL };
>  
> +/*
> + * Look up the inode cluster buffer and log the on-disk unlinked inode change
> + * we need to make.
> + */
> +static int
> +iunlink_log_dinode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*ibp;
> +	int			offset;
> +	int			error;
> +
> +	error = -libxfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
> +	if (error)
> +		return error;
> +
> +	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
> +
> +	dip->di_next_unlinked = cpu_to_be32(next_agino);
> +	offset = ip->i_imap.im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	libxfs_dinode_calc_crc(mp, dip);
> +	libxfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> +	return 0;
> +}
> +
> +static int
> +iunlink_insert_inode(
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		*agibp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_agi		*agi = agibp->b_addr;
> +	xfs_agino_t		next_agino;
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> +	int			offset;
> +	int			error;
> +
> +	/*
> +	 * Get the index into the agi hash table for the list this inode will
> +	 * go on.  Make sure the pointer isn't garbage and that this inode
> +	 * isn't already on the list.
> +	 */
> +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> +	if (next_agino == agino || !xfs_verify_agino_or_null(pag, next_agino))
> +		return EFSCORRUPTED;
> +
> +	if (next_agino != NULLAGINO) {
> +		/*
> +		 * There is already another inode in the bucket, so point this
> +		 * inode to the current head of the list.
> +		 */
> +		error = iunlink_log_dinode(tp, ip, pag, next_agino);
> +		if (error)
> +			return error;
> +	}
> +
> +	/* Update the bucket. */
> +	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
> +	offset = offsetof(struct xfs_agi, agi_unlinked) +
> +			(sizeof(xfs_agino_t) * bucket_index);
> +	libxfs_trans_log_buf(tp, agibp, offset,
> +			offset + sizeof(xfs_agino_t) - 1);
> +	return 0;
> +}
> +
> +/*
> + * This is called when the inode's link count has gone to 0 or we are creating
> + * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
> + *
> + * We place the on-disk inode on a list in the AGI.  It will be pulled from this
> + * list when the inode is freed.
> + */
> +static int
> +iunlink(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_perag	*pag;
> +	struct xfs_buf		*agibp;
> +	int			error;
> +
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
> +
> +	pag = libxfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +
> +	/* Get the agi buffer first.  It ensures lock ordering on the list. */
> +	error = -libxfs_read_agi(pag, tp, &agibp);
> +	if (error)
> +		goto out;
> +
> +	error = iunlink_insert_inode(tp, pag, agibp, ip);
> +out:
> +	libxfs_perag_put(pag);
> +	return error;
> +}
> +
> +static int
> +create_unlinked(
> +	struct xfs_mount	*mp)
> +{
> +	struct cred		cr = { };
> +	struct fsxattr		fsx = { };
> +	struct xfs_inode	*ip;
> +	struct xfs_trans	*tp;
> +	unsigned int		resblks;
> +	int			error;
> +
> +	resblks = XFS_IALLOC_SPACE_RES(mp);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create_tmpfile, resblks,
> +			0, 0, &tp);
> +	if (error) {
> +		dbprintf(_("alloc trans: %s\n"), strerror(error));
> +		return error;
> +	}
> +
> +	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG | 0600, 0, 0, &cr, &fsx,
> +			&ip);
> +	if (error) {
> +		dbprintf(_("create inode: %s\n"), strerror(error));
> +		goto out_cancel;
> +	}
> +
> +	error = iunlink(tp, ip);
> +	if (error) {
> +		dbprintf(_("unlink inode: %s\n"), strerror(error));
> +		goto out_rele;
> +	}
> +
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		dbprintf(_("commit inode: %s\n"), strerror(error));
> +
> +	dbprintf(_("Created unlinked inode %llu in agno %u\n"),
> +			(unsigned long long)ip->i_ino,
> +			XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	libxfs_irele(ip);
> +	return error;
> +out_rele:
> +	libxfs_irele(ip);
> +out_cancel:
> +	libxfs_trans_cancel(tp);
> +	return error;
> +}
> +
> +static int
> +iunlink_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		nr = 1;
> +	int		c;
> +	int		error;
> +
> +	while ((c = getopt(argc, argv, "n:")) != EOF) {
> +		switch (c) {
> +		case 'n':
> +			nr = atoi(optarg);
> +			if (nr <= 0) {
> +				dbprintf(_("%s: need positive number\n"));
> +				return 0;
> +			}
> +			break;
> +		default:
> +			dbprintf(_("Bad option for iunlink command.\n"));
> +			return 0;
> +		}
> +	}
> +
> +	for (c = 0; c < nr; c++) {
> +		error = create_unlinked(mp);
> +		if (error)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static const cmdinfo_t	iunlink_cmd =
> +	{ "iunlink", NULL, iunlink_f, 0, -1, 0,
> +	  N_("[-n nr]"),
> +	  N_("allocate inodes and put them on the unlinked list"), NULL };
> +
>  void
>  iunlink_init(void)
>  {
>  	add_command(&dump_iunlinked_cmd);
> +	if (expert_mode)
> +		add_command(&iunlink_cmd);
>  }
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index ddba5c7c..04277c00 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -149,6 +149,7 @@
>  #define xfs_prealloc_blocks		libxfs_prealloc_blocks
>  
>  #define xfs_read_agf			libxfs_read_agf
> +#define xfs_read_agi			libxfs_read_agi
>  #define xfs_refc_block			libxfs_refc_block
>  #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
>  #define xfs_refcountbt_calc_size	libxfs_refcountbt_calc_size
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 2d6d0da4..f53ddd67 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -840,6 +840,17 @@ Set the current inode number. If no
>  .I inode#
>  is given, print the current inode number.
>  .TP
> +.BI "iunlink [-n " nr " ]"
> +Allocate inodes and put them on the unlinked list.
> +
> +Options include:
> +.RS 1.0i
> +.TP 0.4i
> +.B \-n
> +Create this number of unlinked inodes.
> +If not specified, 1 inode will be created.
> +.RE
> +.TP
>  .BI "label [" label ]
>  Set the filesystem label. The filesystem label can be used by
>  .BR mount (8)
> 

