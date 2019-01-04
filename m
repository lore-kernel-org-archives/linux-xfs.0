Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfADDtr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jan 2019 22:49:47 -0500
Subject: Re: [PATCH] xfs_repair: fix off by one error when rebuilding high
 keys
References: <20190103223333.GI20475@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <f7cf633a-6771-3d04-f963-f88f6807752a@redhat.com>
Date: Thu, 3 Jan 2019 21:49:46 -0600
MIME-Version: 1.0
In-Reply-To: <20190103223333.GI20475@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 1/3/19 4:33 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix an off-by-one error when scanning a rmap btree block for high keys
> as part of rebuilding rmap btrees during phase 5.  This causes
> xfs_repair to emit a corrupt filesystem, which is bad.
> 
> This can be reproduced pretty easily by exporting
> TEST_XFS_REPAIR_REBUILD=1 and running generic/051 with a 1k block size.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

changing the weird 1-indexing does sound like a good idea tho.

> ---
>  repair/phase5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 85d1f4fb..1bacfc7f 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -1500,7 +1500,7 @@ prop_rmap_highkey(
>  		bt_key->rm_offset = cpu_to_be64(
>  				libxfs_rmap_irec_offset_pack(&high_key));
>  
> -		for (i = 1; i < numrecs - 1; i++) {
> +		for (i = 1; i <= numrecs; i++) {
>  			bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, i);
>  			key.rm_startblock = be32_to_cpu(bt_key->rm_startblock);
>  			key.rm_owner = be64_to_cpu(bt_key->rm_owner);
> 
