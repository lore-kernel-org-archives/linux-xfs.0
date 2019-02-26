Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbfBZURk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 15:17:40 -0500
Subject: Re: [PATCH 3/2] xfs/010: use correct type for finobt corrupting
References: <155114852926.9683.4048206997940455508.stgit@magnolia>
 <20190226034628.GB7159@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0ea07e96-bdf0-9b6a-ef70-55c624a97b2e@oracle.com>
Date: Tue, 26 Feb 2019 13:17:35 -0700
MIME-Version: 1.0
In-Reply-To: <20190226034628.GB7159@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On 2/25/19 8:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use 'type finobt' for corrupting the finobt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   tests/xfs/010 |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/010 b/tests/xfs/010
> index ee1595c8..e220a651 100755
> --- a/tests/xfs/010
> +++ b/tests/xfs/010
> @@ -63,14 +63,14 @@ _corrupt_finobt_records()
>   			_filter_dbval`
>   
>   	# Corrupt a freecount value. This should never exceed 64.
> -	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
> +	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
>   		-c "write recs[1].freecount 70" $dev
>   
>   	# Create a corrupted non-free record, which should never appear in the
>   	# finobt.
> -	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
> +	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
>   		 -c "write recs[2].freecount 0" $dev
> -	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
> +	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
>   		-c "write recs[2].free 0" $dev
>   }
>   
> 

Good catch, this looks like a pretty old test too.  Thanks for the fix!

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
