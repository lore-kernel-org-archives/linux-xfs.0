Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58194 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755903AbeBABJR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 20:09:17 -0500
Subject: Re: [PATCH] mkfs: don't create realtime filesystems with reflink
 enabled
References: <20180201004745.GL4849@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <709edcf0-40d7-448d-f988-8d773a09e094@sandeen.net>
Date: Wed, 31 Jan 2018 19:09:16 -0600
MIME-Version: 1.0
In-Reply-To: <20180201004745.GL4849@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 1/31/18 6:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't support reflink on the realtime device, so don't let people
> create such things.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

yup ...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(how long 'til we come up with the conflicts matrix for all
this stuff? ;)

> ---
>  mkfs/xfs_mkfs.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f527476..07774ed 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2025,6 +2025,13 @@ _("cowextsize not supported without reflink support\n"));
>  		usage();
>  	}
>  
> +	if (cli->sb_feat.reflink && cli->xi->rtname) {
> +		fprintf(stderr,
> +_("reflink not supported with realtime devices\n"));
> +		usage();
> +		cli->sb_feat.reflink = false;
> +	}
> +
>  	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
>  		fprintf(stderr,
>  _("rmapbt not supported with realtime devices\n"));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
