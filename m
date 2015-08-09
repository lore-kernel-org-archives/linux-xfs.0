Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F10DA7F56
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 02:53:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC64F304039
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 00:53:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6upaTieGg75IIiDF (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 00:53:12 -0700 (PDT)
Date: Sun, 9 Aug 2015 00:53:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] xfs: ensure EFD trans aborts on log recovery
	extent free failure
Message-ID: <20150809075311.GD3163@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> +		/*
> +		 * Log the EFD before error handling to ensure the EFD aborts
> +		 * (and releases the EFI) on error.
> +		 */
>  		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
>  		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
>  					 extp->ext_len);

Given that we now always need to log the extents in the EFD even on
error maybe it's time to move the call to xfs_free_extent into
xfs_trans_log_efd_extent and rename it to xfs_trans_free_extent?

Or even better convert xfs_bmap_finish to also walk the extents in the
EFI instead of xfs_bmap_free list and have a xfs_trans_free_extents helper
ala:

int
xfs_trans_free_extents(
	struct xfs_trans	*tp,
	struct xfs_efi_log_item	*efip)
{
	struct xfs_efd_log_item	*efdp;
	int			error = 0, i;

	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
		struct xfs_extent *extp = &efip->efi_format.efi_extents[i];

		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
					extp->ext_len);

		if (error)
			break;
	}

	return error;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
