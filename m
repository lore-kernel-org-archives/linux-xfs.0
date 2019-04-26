Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfDZXji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Apr 2019 19:39:38 -0400
Subject: Re: [PATCH] xfs: add missing error check in xfs_prepare_shift()
References: <20190426120633.36420-1-bfoster@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <767fe955-e286-eeaa-e09a-e68122447742@oracle.com>
Date: Fri, 26 Apr 2019 16:39:24 -0700
MIME-Version: 1.0
In-Reply-To: <20190426120633.36420-1-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Looks ok to me.  You can add my review:

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 4/26/19 5:06 AM, Brian Foster wrote:
> xfs_prepare_shift() fails to check the error return from
> xfs_flush_unmap_range(). If the latter fails, that could lead to an
> insert/collapse range operation over a delalloc range, which is not
> supported.
> 
> Add an error check and return appropriately. This is reproduced
> rarely by generic/475.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_bmap_util.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2db43ff4f8b5..06d07f1e310b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1193,6 +1193,8 @@ xfs_prepare_shift(
>   	 * about to shift down every extent from offset to EOF.
>   	 */
>   	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
> +	if (error)
> +		return error;
>   
>   	/*
>   	 * Clean out anything hanging around in the cow fork now that
> 
