Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC0384CC1;
	Wed, 13 May 2026 07:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778655701; cv=none; b=sD6PndBPdzHEQWROt/cUhmyYsMgXO2G2a8QYEKjkpdXrY82vsXawZPc+RgRc0rgPea0DgpeKXWu0OkGHesy0UitbSp8nDgl/+JYKakARujmclQRAgPjfUCRBn5G5qaIjpcxsCuZ0ie4D6QSqDaj3SQpr8cyYzt9Vy6ZJTCi+A9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778655701; c=relaxed/simple;
	bh=iBcgic3qoA+nIzFtiMrIQDICnbNG3L6os8QWHU9vXHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IojNArQuMt0kgzsjU6QZz6ZDIBSrA44O0fPWbsOXLUir5zBVuTKuSDTgaIAAeintB7dI/Q9Syik32YOTgRhO12dEiNN3Sg32u3V91J1PlLh2dcps8Mhb2+KXoXDGClTvQzhEDC2EO3DZJ5/BKFWGk8A59jJLcjiMM7Au1FeqLv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kDeNdkCU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kDeNdkCU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HLNtyln6w9GXuQSs3wrn7S3laBBtJl3zSRRksIGTw/I=; b=kDeNdkCUa8JNsMl16yDtRD+wIQ
	o1eEK6vwhtE5cEWlf9/KO/lxw2NEf2AlmU0LCYpsbTHBZcAkcQX/xqOw9soo/nN1d29C9ojxxogPv
	p5AAvItTZbN2dvJK/IK34o1NaZB57uLPhBRl2YwCNc5m4cw7BhGGQWaJaazmqWYWbtELx5EM+OhU6
	1VFjOVjc7I73iHsKgSQKpI9CGNa+/9N+r9D+ktrr7VJp1fUj+Rqkz3iEmerkcvC8udX7rIujeJdl2
	QQq7SOZxh6kKgD/QcGnNfk4UBhL+d9ohFSR7CGTnnMz80tMqQ8X4fGjOWqhIeDDTQ1azASg/HXxMc
	O+xZwt2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN3b4-00000001VdK-2Rqn;
	Wed, 13 May 2026 07:01:34 +0000
Date: Wed, 13 May 2026 00:01:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dai Ngo <dai.ngo@oracle.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix overlapping extents returned for pNFS
 LAYOUTGET
Message-ID: <agQhzg-0aeISwOGW@infradead.org>
References: <20260512172238.2495085-1-dai.ngo@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512172238.2495085-1-dai.ngo@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 12, 2026 at 10:21:53AM -0700, Dai Ngo wrote:
> A single LAYOUTGET request from the client can cause the server to
> issue multiple calls to xfs_fs_map_blocks() for different offsets
> within the same extent. Because the use of XFS_BMAPI_ENTIRE flag,
> these calls can produce overlapping mappings.
> 
> As a result, the LAYOUTGET reply sent to the NFS client may contain
> overlapping extents. This creates ambiguity in extent selection for a
> given file range, which can lead to incorrect device selection,
> inconsistent handling of datastate, and ultimately data corruption or
> protocol violations on the client side.

Please also add a check to the client that catches this and doesn't
use the layout that has extents outside the requested range.  And maybe
warn about it as well.

> Also drop the check for (!error) since it was checked after call to
> xfs_bmapi_read().
> 
> Fixes: cc6c40e09d7b1 ("NFSD/blocklayout: Support multiple extents per LAYOUTGET").
> Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
> ---
>  fs/xfs/xfs_pnfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> - This patch is based on top of the patch:
>   xfs: fix use of uninitialized imap in xfs_fs_map_blocks error path

The error changes should go into that patch, so please resend it with
that fixes.  Maybe as a series together with this patch to keep them
together.

> @@ -172,6 +172,7 @@ xfs_fs_map_blocks(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
>  	lock_flags = xfs_ilock_data_map_shared(ip);
> +	bmapi_flags = 0;	/* return map for requested range only */

Just remove the variable and hard code the 0 in the xfs_bmapi_read call.

