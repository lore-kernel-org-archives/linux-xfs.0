Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeJOBWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Oct 2018 21:22:55 -0400
Date: Sun, 14 Oct 2018 10:41:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/25] ocfs2: support partial clone range and dedupe range
Message-ID: <20181014174108.GB6400@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938929813.8361.16702022670128567518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938929813.8361.16702022670128567518.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> @@ -2531,14 +2531,11 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  				     struct file *file_out, loff_t pos_out,
>  				     loff_t len, unsigned int remap_flags)
>  {
> -	int ret;
> -
>  	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
>  		return -EINVAL;
>  
> -	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> -					len, remap_flags);
> -	return ret < 0 ? ret : len;
> +	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> +			len, remap_flags);

Seems like ocfs2_remap_file_range and ocfs2_reflink_remap_range should
be merged now.
