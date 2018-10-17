Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48610 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:34:43 -0400
Date: Wed, 17 Oct 2018 01:40:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/26] xfs: support returning partial reflink results
Message-ID: <20181017084002.GI16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966005536.3607.787445581785795364.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966005536.3607.787445581785795364.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> @@ -1415,11 +1419,17 @@ xfs_reflink_remap_range(
>  
>  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>  
> +	if (len == 0) {
> +		ret = 0;
> +		goto out_unlock;
> +	}
> +

As pointed out last time this check is superflous, right above we have
this check:

	if (ret < 0 || len == 0)
		return ret;

>  	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> -			pos_out + len);
> +			&remappedfsb, pos_out + len);
> +	remapped_bytes = min_t(loff_t, len, XFS_FSB_TO_B(mp, remappedfsb));

I still think returning the bytes from the function would be saner,
but maybe that's just me.
