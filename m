Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbdHAQxQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 12:53:16 -0400
Date: Tue, 1 Aug 2017 12:53:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs_metadump: properly handle obfuscation of all
 remote attribute blocks
Message-ID: <20170801165311.GB31130@bfoster.bfoster>
References: <7862201b-e387-8037-ca99-b6ab3212f4a7@redhat.com>
 <1e034d9f-0e21-637d-c0e6-09d1b7e95027@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e034d9f-0e21-637d-c0e6-09d1b7e95027@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 01, 2017 at 11:39:19AM -0500, Eric Sandeen wrote:
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

Reviewed-by: Brian Foster <bfoster@redhat.com>

> V2: Use helper macro, don't send mp as arg (it's a global (!))
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 96641e0..f60bd32 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1609,7 +1609,7 @@ add_remote_vals(
>  		attr_data.remote_vals[attr_data.remote_val_count] = blockidx;
>  		attr_data.remote_val_count++;
>  		blockidx++;
> -		length -= mp->m_sb.sb_blocksize;
> +		length -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
>  	}
>  
>  	if (attr_data.remote_val_count >= MAX_REMOTE_VALS) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
