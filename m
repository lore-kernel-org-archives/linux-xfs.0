Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55382 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751075AbcLHX0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 18:26:31 -0500
Date: Fri, 9 Dec 2016 10:15:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: Improvements to copy_range return code handling
Message-ID: <20161208231514.GM4219@dastard>
References: <20161208184447.23020-1-Anna.Schumaker@Netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161208184447.23020-1-Anna.Schumaker@Netapp.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 08, 2016 at 01:44:47PM -0500, Anna Schumaker wrote:
> If copy_file_range() returns 0, then that means no data was copied.  We
> should break out of the loop in this case to prevent looping
> indefinitely.
> 
> Additionally, if an error is returned by copy_file_range() then we need
> to print out the string form to be used by error checking tests in
> xfstests.
> 
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> ---
>  io/copy_file_range.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index eddc634..161bdcf 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -49,8 +49,11 @@ copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
>  
>  	do {
>  		ret = syscall(__NR_copy_file_range, fd, src, file->fd, dst, len, 0);
> -		if (ret == -1)
> +		if (ret == -1) {
> +			fprintf(stderr, _("copy_range: %s\n"), strerror(errno));

perror("copy_range")?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
