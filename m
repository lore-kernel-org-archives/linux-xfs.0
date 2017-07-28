Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751673AbdG1MwG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jul 2017 08:52:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E0D0C0F9302
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2017 12:52:05 +0000 (UTC)
Date: Fri, 28 Jul 2017 08:52:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_metadump: properly handle obfuscation of all remote
 attribute blocks
Message-ID: <20170728125201.GA12444@bfoster.bfoster>
References: <7862201b-e387-8037-ca99-b6ab3212f4a7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7862201b-e387-8037-ca99-b6ab3212f4a7@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jul 26, 2017 at 03:35:37PM -0500, Eric Sandeen wrote:
> add_remote_vals assumes that it can subtract blocksize
> from each block that it processes, but with CRCs, there
> is a header on each block, so the assumption that each
> block consumes $BLOCKSIZE of the value length is incorrect.
> 
> This causes us to stop adding remote blocks too soon, and
> the missed blocks do not get obfuscated.
> 
> Fix this by accounting for the header size as appropriate,
> depending on whether or not we have a CRC filesystem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 96641e0..c8abfeb 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1602,14 +1602,20 @@ static struct attr_data_s {
>  
>  static inline void
>  add_remote_vals(
> +	struct xfs_mount	*mp,
>  	xfs_dablk_t 		blockidx,
>  	int			length)
>  {
> +	int			hdrsize = 0;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		hdrsize = sizeof(struct xfs_attr3_rmt_hdr);
> +
>  	while (length > 0 && attr_data.remote_val_count < MAX_REMOTE_VALS) {
>  		attr_data.remote_vals[attr_data.remote_val_count] = blockidx;
>  		attr_data.remote_val_count++;
>  		blockidx++;
> -		length -= mp->m_sb.sb_blocksize;
> +		length -= (mp->m_sb.sb_blocksize - hdrsize);

XFS_ATTR3_RMT_BUF_SPACE()?

Brian

>  	}
>  
>  	if (attr_data.remote_val_count >= MAX_REMOTE_VALS) {
> @@ -1716,7 +1722,8 @@ process_attr_block(
>  			if (obfuscate) {
>  				generate_obfuscated_name(0, remote->namelen,
>  							 &remote->name[0]);
> -				add_remote_vals(be32_to_cpu(remote->valueblk),
> +				add_remote_vals(mp,
> +						be32_to_cpu(remote->valueblk),
>  						be32_to_cpu(remote->valuelen));
>  			}
>  			/* zero from end of name[] to next name start */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
