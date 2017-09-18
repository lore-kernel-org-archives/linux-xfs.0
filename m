Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932336AbdIRMos (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 08:44:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B81A264360
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 12:44:48 +0000 (UTC)
Date: Mon, 18 Sep 2017 08:44:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsprogs/db: version command misses RMAPBT feature string
Message-ID: <20170918124446.GB29965@bfoster.bfoster>
References: <20170918071335.19365-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918071335.19365-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 03:13:35PM +0800, Zorro Lang wrote:
> When I create a XFS with "rmapbt=1,reflink=1", "xfs_db -c version"
> didn't show RMAPBT feature. But REFLINK can be found.
> 
>   # mkfs/mkfs.xfs -f -m rmapbt=1,reflink=1 /dev/sda3
>   # db/xfs_db -c version /dev/sda3
>   versionnum [0xb4a5+0x18a] = V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,REFLINK
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/sb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/db/sb.c b/db/sb.c
> index 8e7722cd..01d94a66 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -694,6 +694,8 @@ version_string(
>  		strcat(s, ",SPARSE_INODES");
>  	if (xfs_sb_version_hasmetauuid(sbp))
>  		strcat(s, ",META_UUID");
> +	if (xfs_sb_version_hasrmapbt(sbp))
> +		strcat(s, ",RMAPBT");
>  	if (xfs_sb_version_hasreflink(sbp))
>  		strcat(s, ",REFLINK");
>  	return s;
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
