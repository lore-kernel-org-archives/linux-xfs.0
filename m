Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeFVGmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:42:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6coTj029660
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:42:32 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2jrp8hrp7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:42:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6gVxC017322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:42:31 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5M6gV1K000560
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:42:31 GMT
Subject: Re: [PATCH 8/8] xfs: ensure post-EOF zeroing happens after zeroing
 part of a file
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960591330.26246.305971181988789033.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c00b5dfd-5758-9cd4-be8a-ad5d9dd37161@oracle.com>
Date: Thu, 21 Jun 2018 23:42:21 -0700
MIME-Version: 1.0
In-Reply-To: <152960591330.26246.305971181988789033.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks ok to me. Thx!

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a user asks us to zero_range part of a file, the end of the range is
> EOF, and not aligned to a page boundary, invoke writeback of the EOF
> page to ensure that the post-EOF part of the page is zeroed.  This
> ensures that we don't expose stale memory contents via mmap, if in a
> clumsy manner.
> 
> Found by running generic/127 when it runs zero_range and mapread at EOF
> one after the other.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_bmap_util.c |   15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index abc37b0899c0..c94d376e4152 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1208,7 +1208,20 @@ xfs_free_file_space(
>   		return 0;
>   	if (offset + len > XFS_ISIZE(ip))
>   		len = XFS_ISIZE(ip) - offset;
> -	return iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
> +	error = iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If we zeroed right up to EOF and EOF straddles a page boundary we
> +	 * must make sure that the post-EOF area is also zeroed because the
> +	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
> +	 * Writeback of the eof page will do this, albeit clumsily.
> +	 */
> +	if (offset + len < XFS_ISIZE(ip) || ((offset + len) & PAGE_MASK) == 0)
> +		return 0;
> +	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> +			(offset + len) & ~PAGE_MASK, LLONG_MAX);
>   }
>   
>   /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=wue-_aW-3CpAS-pXEQXCk8gKGGwIqQ1nh1DhJ-3JtBU&s=q874s9Hzp4N6x29WZ6DqXxY7xh1oCZSwFHNb6ZqnTs4&e=
> 
