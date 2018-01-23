Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbeAWXP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 18:15:29 -0500
Date: Tue, 23 Jan 2018 15:15:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_copy: accept CRC version of ABTB_MAGIC in ASSERT
Message-ID: <20180123231522.GS25805@magnolia>
References: <9c888b88-b664-730c-a1ff-50ee438714dd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c888b88-b664-730c-a1ff-50ee438714dd@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Radek Burkat <radek@pinkbike.com>

On Tue, Jan 23, 2018 at 04:59:52PM -0600, Eric Sandeen wrote:
> Not sure how this was missed for so long, but to handle CRC
> filesystems, this ASSERT on block magic must accept CRC magic
> as well.
> 
> Reported-by: Radek Burkat <radek@pinkbike.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I was /about/ to squawk about 'just use the allocbt verifier' but then
remembered that we don't use the xfs_buf infrastructure...

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> (yes, it's > 80 cols but .. so is most of this indented 
> code block o_O)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index fb37375..16ee4d9 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -1140,7 +1140,8 @@ main(int argc, char **argv)
>  				 ((char *) btree_buf.data +
>  				  pos - btree_buf.position);
>  
> -			ASSERT(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC);
> +			ASSERT(be32_to_cpu(block->bb_magic) == XFS_ABTB_MAGIC ||
> +			       be32_to_cpu(block->bb_magic) == XFS_ABTB_CRC_MAGIC);
>  		}
>  
>  		/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
