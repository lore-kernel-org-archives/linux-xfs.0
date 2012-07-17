Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H7WRJu057082 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 02:32:27 -0500
Date: Tue, 17 Jul 2012 03:32:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Message-ID: <20120717073221.GA24395@infradead.org>
References: <4FFFDDB8.6000406@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FFFDDB8.6000406@oracle.com>
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
Cc: Ben Myers <bpm@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

> +	if ((to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> +	    (to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +			      XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> +		xfs_notice(mp, "Super block has XFS_OQUOTA bits along with "
> +			"XFS_PQUOTA and/or XFS_GQUOTA bits. Fixing it.\n");
> +	}
> +	if (to->sb_qflags & XFS_OQUOTA_ENFD)
> +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> +	if (to->sb_qflags & XFS_OQUOTA_CHKD)
> +		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> +	to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);

It's suggest factoring this into a xfs_quota_flags_from_disk helper,
which a) makes this code more clear, and b) can get a comment about what
is going on.

> +			/*
> +			 * The in-core version of sb_qflags do not have
> +			 * XFS_OQUOTA_* flags, whereas the on-disk version
> +			 * does.  Save the in-core sb_qflags temporarily,
> +			 * removing the new XFS_{PG}QUOTA_* flags and re-apply
> +			 * the old on-disk flags.
> +			 */
> +			tmp16 = from->sb_qflags &
> +					~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +					  XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> +			if (from->sb_qflags &
> +					(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +				tmp16 |= XFS_OQUOTA_CHKD;
> +			*(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);

Same here for the other direction.

> + * Start differentiating group quota and project quota in-core
> + * using distinct flags, instread of using the combined OQUOTA flags.
> + *
> + * Conversion to and from the combined OQUOTA flag (if necessary)
> + * is done only in xfs_sb{to, from}_disk()
> + */
> +#define XFS_GQUOTA_ENFD	0x0080	/* group quota limit enforced */
> +#define XFS_GQUOTA_CHKD 0x0100	/* quotacheck run on group quotas */
> +#define XFS_PQUOTA_ENFD	0x0200	/* project quota limits enforced */
> +#define XFS_PQUOTA_CHKD	0x0800	/* quotacheck run on project quotas.
> +				 * FIXME: here we cannot using 0x0400
> +				 * because it is already reserved for
> +				 * XFS_GQUOTA_ACTIVE.  Otherwise,
> +				 * XFS_IS_GQUOTA_ON() is also true
> +				 * although it does not enabled.
> +				 */

Seems like all te 0x0?00 values are used for XFS_U?UOTA_ACTIVE flags.
Why not move it to the 0x?000 range?

Otherwise these changes look good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
