Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbeBBVij (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 16:38:39 -0500
Subject: Re: [PATCH 1/4] mkfs: don't create realtime filesystems with reflink
 enabled
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
 <151760738718.29371.2619485698764869314.stgit@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <87e7cea3-57a1-4424-2efe-04947766eef2@redhat.com>
Date: Fri, 2 Feb 2018 15:38:38 -0600
MIME-Version: 1.0
In-Reply-To: <151760738718.29371.2619485698764869314.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 2/2/18 3:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't support reflink on the realtime device, so don't let people
> create such things.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 219b209..b20e3d6 100644
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
> 

