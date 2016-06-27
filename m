Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F30A47CA0
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 04:49:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1F17304039
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 02:49:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UERgCTaW6KXr1FPz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2016 02:49:00 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 19CA07F080
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2016 09:49:00 +0000 (UTC)
Date: Mon, 27 Jun 2016 11:48:55 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_repair: don't call xfs_sb_quota_from_disk twice
Message-ID: <20160627094855.GC29774@redhat.com>
References: <13dd3974-956d-c3af-86ed-f6ce5cc1b996@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <13dd3974-956d-c3af-86ed-f6ce5cc1b996@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 24, 2016 at 04:24:58PM -0500, Eric Sandeen wrote:
> kernel commit 5ef828c4
> xfs: avoid false quotacheck after unclean shutdown
> 
> made xfs_sb_from_disk() also call xfs_sb_quota_from_disk
> by default.
> 
> However, when this was merged to libxfs, existing separate
> calls to libxfs_sb_quota_from_disk remained, and calling it
> twice in a row on a V4 superblock leads to issues, because:
> 
> 
>         if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> ...
>                 sbp->sb_pquotino = sbp->sb_gquotino;
>                 sbp->sb_gquotino = NULLFSINO;
> 
> and after the second call, we have set both pquotino and gquotino
> to NULLFSINO.
> 
> Fix this by making it safe to call twice, and also remove the extra
> calls to libxfs_sb_quota_from_disk.
> 
> This is only spotted when running xfstests with "-m crc=0" because
> the sb_from_disk change came about after V5 became default, and
> the above behavior only exists on a V4 superblock.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index 45db6ae..44f3e3e 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -316,13 +316,16 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
>  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
>  
> -	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> +	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
> +	    sbp->sb_gquotino != NULLFSINO)  {

Although I agree with this check, shouldn't we report some sort of error when it
happens? Once, it's not supposed to happen, and, might be a sign of corruption?

Cheers

>  		/*
>  		 * In older version of superblock, on-disk superblock only
>  		 * has sb_gquotino, and in-core superblock has both sb_gquotino
>  		 * and sb_pquotino. But, only one of them is supported at any
>  		 * point of time. So, if PQUOTA is set in disk superblock,
> -		 * copy over sb_gquotino to sb_pquotino.
> +		 * copy over sb_gquotino to sb_pquotino.  The NULLFSINO test
> +		 * above is to make sure we don't do this twice and wipe them
> +		 * both out!
>  		 */
>  		sbp->sb_pquotino = sbp->sb_gquotino;
>  		sbp->sb_gquotino = NULLFSINO;
> diff --git a/repair/sb.c b/repair/sb.c
> index 3965953..8087242 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -155,7 +155,6 @@ __find_secondary_sb(
>  		for (i = 0; !done && i < bsize; i += BBSIZE)  {
>  			c_bufsb = (char *)sb + i;
>  			libxfs_sb_from_disk(&bufsb, (xfs_dsb_t *)c_bufsb);
> -			libxfs_sb_quota_from_disk(&bufsb);
>  
>  			if (verify_sb(c_bufsb, &bufsb, 0) != XR_OK)
>  				continue;
> @@ -568,7 +567,6 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
>  		do_error("%s\n", strerror(error));
>  	}
>  	libxfs_sb_from_disk(sbp, buf);
> -	libxfs_sb_quota_from_disk(sbp);
>  
>  	rval = verify_sb((char *)buf, sbp, agno == 0);
>  	free(buf);
> diff --git a/repair/scan.c b/repair/scan.c
> index 964ff06..366ce16 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1622,7 +1622,6 @@ scan_ag(
>  		goto out_free_sb;
>  	}
>  	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
> -	libxfs_sb_quota_from_disk(sb);
>  
>  	agfbuf = libxfs_readbuf(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
