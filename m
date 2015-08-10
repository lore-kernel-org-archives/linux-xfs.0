Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16F8B7F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 07:38:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B204AC004
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 05:38:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EEDV7jIhKkBvXb3W (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 05:38:05 -0700 (PDT)
Date: Mon, 10 Aug 2015 08:38:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/11] xfs: ensure EFD trans aborts on log recovery
	extent free failure
Message-ID: <20150810123803.GC18933@bfoster.bfoster>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-5-git-send-email-bfoster@redhat.com>
	<20150809075311.GD3163@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150809075311.GD3163@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Aug 09, 2015 at 12:53:11AM -0700, Christoph Hellwig wrote:
> > +		/*
> > +		 * Log the EFD before error handling to ensure the EFD aborts
> > +		 * (and releases the EFI) on error.
> > +		 */
> >  		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
> >  		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
> >  					 extp->ext_len);
> 
> Given that we now always need to log the extents in the EFD even on
> error maybe it's time to move the call to xfs_free_extent into
> xfs_trans_log_efd_extent and rename it to xfs_trans_free_extent?
> 
> Or even better convert xfs_bmap_finish to also walk the extents in the
> EFI instead of xfs_bmap_free list and have a xfs_trans_free_extents helper
> ala:
> 

Good idea, I'll incorporate something like this.

Brian

> int
> xfs_trans_free_extents(
> 	struct xfs_trans	*tp,
> 	struct xfs_efi_log_item	*efip)
> {
> 	struct xfs_efd_log_item	*efdp;
> 	int			error = 0, i;
> 
> 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> 		struct xfs_extent *extp = &efip->efi_format.efi_extents[i];
> 
> 		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
> 		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
> 					extp->ext_len);
> 
> 		if (error)
> 			break;
> 	}
> 
> 	return error;
> }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
