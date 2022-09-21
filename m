Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C91AC6FA82
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Sep 2022 00:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiIUAss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 20:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiIUAsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 20:48:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC7979A57
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 17:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4313CE1C03
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 00:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAEEC433D6;
        Wed, 21 Sep 2022 00:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663721322;
        bh=m3Trpq84zyI1plwXjoclrE+5xh6TM6LfkgHkcnuod58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ayEDh+fEE4Ga+ants/CuWJXFhj0FfxwFUEubKgDBIMasgByYcFzJZLv8rYJF9rjat
         S72CKHL2DgGjnioscYLOQo4nM8Lq8qc+AcNKzjskTCMA1y5LMcBczPTpI+TAZ6cUG0
         aePL6k1UCoOAn6ky/Wowz9adbd1Wc7sbvOB85ULOr1HKm+fa4GB+xFa/qkd7b7z86T
         T/WpMSunQS7CshQ5U9H5AypdEpOdoU0eDJ4nuqNDYJJ/BQaDGJFclWQ1Y32rQEQyRQ
         ltrgNRSZWQaoMdbkY8fOYX6LXMcocjLTQMqOATKsUmef/q95PTE87fAQxlJ56LZ9iZ
         yQocRqejQbwvQ==
Date:   Tue, 20 Sep 2022 17:48:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     dchinner@redhat.com, chandan.babu@oracle.com,
        yang.guang5@zte.com.cn, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: trim the mapp array accordingly in
 xfs_da_grow_inode_int
Message-ID: <YypfaXzd3usW6b5i@magnolia>
References: <20220918064808.1206441-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220918064808.1206441-1-zhangshida@kylinos.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 18, 2022 at 02:48:08PM +0800, Stephen Zhang wrote:
> Take a look at the for-loop in xfs_da_grow_inode_int:
> ======
> for(){
>         nmap = min(XFS_BMAP_MAX_NMAP, count);
>         ...
>         error = xfs_bmapi_write(...,&mapp[mapi], &nmap);//(..., $1, $2)
>         ...
>         mapi += nmap;
> }
> =====
> where $1 stands for the start address of the array,
> while $2 is used to indicate the size of the array.
> 
> The array $1 will advance by $nmap in each iteration after
> the allocation of extents.
> But the size $2 still remains unchanged, which is determined by
> min(XFS_BMAP_MAX_NMAP, count).
> 
> It seems that it has forgotten to trim the mapp array after each
> iteration, so change it.
> 
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>

I think this look correct...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changes from v1:
> - Using the current calculation to calculate the remaining number of
>   blocks is enough, as suggested by Dave.
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index e7201dc68f43..e576560b46e9 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2192,8 +2192,8 @@ xfs_da_grow_inode_int(
>  		 */
>  		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
> -			nmap = min(XFS_BMAP_MAX_NMAP, count);
>  			c = (int)(*bno + count - b);
> +			nmap = min(XFS_BMAP_MAX_NMAP, c);
>  			error = xfs_bmapi_write(tp, dp, b, c,
>  					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
>  					args->total, &mapp[mapi], &nmap);
> -- 
> 2.27.0
> 
