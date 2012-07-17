Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H7aluK057472 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 02:36:47 -0500
Date: Tue, 17 Jul 2012 03:36:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: Add pquota fields where gquota is used
Message-ID: <20120717073645.GB24395@infradead.org>
References: <4FFFDDE5.8010403@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FFFDDE5.8010403@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

>  		if (error) {
>  			if (uip)
>  				IRELE(uip);
> @@ -1421,9 +1474,24 @@ xfs_qm_init_quotainos(
>  			return XFS_ERROR(error);
>  		}
>  	}
> +	/* Why not define a XFS_SB_PQUOTINO? */
> +	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> +		error = xfs_qm_qino_alloc(mp, &pip,
> +					  sbflags | XFS_SB_GQUOTINO,
> +					  flags | XFS_QMOPT_PQUOTA);
> +		if (error) {
> +			if (uip)
> +				IRELE(uip);
> +			if (gip)
> +				IRELE(gip);
> +
> +			return XFS_ERROR(error);

It would probably be good to have return labels here so that each
IRELE statements only needs to be written once, e.g.

out_rele_uip:
	if (uip)
		IRELE(uip);
out_rele_gip:
	if (gip)
		IRELE(gip);
out:
	return XFS_ERROR(error);

> +			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)uid,
> +						  XFS_DQ_USER,
> +						  XFS_QMOPT_DQALLOC |
> +						  XFS_QMOPT_DOWARN, &uq))) {

Please move assignments out of conditionals for all code touched, e.g.:

			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)uid,
					     XFS_DQ_USER,
					     XFS_QMOPT_DQALLOC |
					     XFS_QMOPT_DOWARN, &uq);
			if (error) {

Otherwise this looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
