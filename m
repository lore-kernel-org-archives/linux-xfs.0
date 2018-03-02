Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56926 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163203AbeCBDMf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 22:12:35 -0500
Subject: Re: [PATCH] xfs_io: Add missing perror for write_once (-O)
References: <20171206183633.2415-1-rgoldwyn@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8d1f1d59-c741-7e16-d88c-eebabc4f8077@sandeen.net>
Date: Thu, 1 Mar 2018 21:12:33 -0600
MIME-Version: 1.0
In-Reply-To: <20171206183633.2415-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>

On 12/6/17 12:36 PM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This got missed in the last set of patches.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Sorry for missing this until now.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/pwrite.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index a89edfd0..afbe4284 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -271,8 +271,10 @@ write_once(
>  {
>  	ssize_t bytes;
>  	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
> -	if (bytes < 0)
> +	if (bytes < 0) {
> +		perror("pwrite");
>  		return -1;
> +	}
>  	*total = bytes;
>  	return 1;
>  }
> 
