Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 504DA7F51
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 02:46:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFBA8AC004
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 00:46:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 1Bcui2NX31nHXNZN (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 00:46:35 -0700 (PDT)
Date: Sun, 9 Aug 2015 00:46:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] xfs: fix efi/efd error handling to avoid fs
	shutdown hangs
Message-ID: <20150809074635.GC3163@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-4-git-send-email-bfoster@redhat.com>
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

>  STATIC void
>  xfs_efi_item_unpin(
> @@ -141,14 +147,6 @@ xfs_efi_item_unpin(
>  	int			remove)
>  {
>  	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
> -
> -	if (remove) {
> -		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
> -		if (lip->li_desc)
> -			xfs_trans_del_item(lip);
> -		xfs_efi_item_free(efip);
> -		return;
> -	}
>  	xfs_efi_release(efip);

After this the buf iterm is the last one looking a the remove
argument.  I wonder if it might need similar treatment.

> -	return (xfs_lsn_t)-1;
> +
> +	return (xfs_lsn_t) -1;

This changes the style away from the most common style in Linux and XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
