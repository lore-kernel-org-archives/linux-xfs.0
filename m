Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44G6WpK053536 for <xfs@oss.sgi.com>; Fri, 4 May 2012 11:06:32 -0500
Date: Fri, 4 May 2012 11:09:53 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfsprogs: Add new field pquotaino to  on disk
	superblock
Message-ID: <20120504160953.GR16881@sgi.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173258.31735.97984.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173258.31735.97984.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:32:58AM -0600, Chandra Seetharaman wrote:
> >From e0df4087facfd89e59183f4b8003196396d1a6d3 Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Tue, 13 Dec 2011 16:06:33 -0600
> Subject: [PATCH 2/4] Add a new field sb_pquotino to the on-disk superblock data structure
>  and add accompanying code.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looking pretty good.  Again, if you could be more specific about what the patch
does in your commit header it'd be helpful.

...

> @@ -174,11 +192,36 @@ xfs_sb_to_disk(
>  	xfs_sb_field_t	f;
>  	int		first;
>  	int		size;
> +	__be16		saved_qflags = 0;
>  
>  	ASSERT(fields);
>  	if (!fields)
>  		return;
>  
> +	if (!xfs_sb_version_hasnooquota(from) &&
> +		    (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD))) {
> +
> +		if (from->sb_qflags & XFS_PQUOTA_ACCT) {
> +			from->sb_gquotino = from->sb_pquotino;
> +			from->sb_pquotino = 0;
> +		}
> +		/*
> +		 * in-core version of qflags do not have XFS_OQUOTA.*, whereas
> +		 * the on-disk version does. So, save the in-core sb_qflags
> +		 * and restore it after we modify and copy it to the buffer
> +		 * to be copied to disk.
> +		 */
> +		saved_qflags = from->sb_qflags;
> +
> +		if (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +			from->sb_qflags |= XFS_OQUOTA_ENFD;
> +		if (from->sb_qflags & (XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> +			from->sb_qflags |= XFS_OQUOTA_CHKD;
> +		from->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> + 	}
> +
>  	while (fields) {
>  		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
>  		first = xfs_sb_info[f].offset;
> @@ -209,6 +252,14 @@ xfs_sb_to_disk(
>  
>  		fields &= ~(1LL << f);
>  	}
> +	/* Revert to the old saved values */
> +	if (saved_qflags) {
> +		from->sb_qflags = saved_qflags;
> +		if (from->sb_qflags & XFS_PQUOTA_ACCT) {
> +			from->sb_pquotino = from->sb_gquotino;
> +			from->sb_gquotino = 0;
> +		}
> +	}
>  }
>

I'd really prefer not modifying 'from' temporarily.  If possible use a temporary
variable and do the conversion manually for qflags as you have done in the
kernel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
