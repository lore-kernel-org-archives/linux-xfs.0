Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42104 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbeFAAgT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 20:36:19 -0400
Subject: Re: [PATCH] xfs_io: fix signed comparison problem in copy_file_range
References: <20180601001139.GG7825@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <48284374-1214-c269-97ca-55bfd73344ef@sandeen.net>
Date: Thu, 31 May 2018 19:36:17 -0500
MIME-Version: 1.0
In-Reply-To: <20180601001139.GG7825@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 5/31/18 7:11 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> cvtnum() returns a signed long long, so the type of 'len' should be a
> signed type so that a user entering a negative length doesn't produce
> some huge positive integer.  The negative len check demands it anyway.
> 
> Coverity-id: 1435895
> Fixes: 25b4549c8b54134106cff094aa098eab9e86eee7
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

*sigh* I actually looked at the first two long longs, verified that's
what cvtnum returned, and moved on before spot-checking the 3rd o_O.

Thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/copy_file_range.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index ebd1ec76..4d0770ef 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -91,7 +91,7 @@ copy_range_f(int argc, char **argv)
>  {
>  	long long src = 0;
>  	long long dst = 0;
> -	size_t len = 0;
> +	long long len = 0;
>  	int opt;
>  	int ret;
>  	int fd;

