Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34934 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbdKGRhf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Nov 2017 12:37:35 -0500
Subject: Re: [PATCH] xfs_io: report io error for pwrite -W and -w
References: <20171012204949.8225-1-bo.li.liu@oracle.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2f2e1b89-6fb1-f7d4-5d37-0bce58d58d2a@sandeen.net>
Date: Tue, 7 Nov 2017 11:37:33 -0600
MIME-Version: 1.0
In-Reply-To: <20171012204949.8225-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Liu Bo <bo.li.liu@oracle.com>, linux-xfs@vger.kernel.org

On 10/12/17 3:49 PM, Liu Bo wrote:
> When IO error occurs, xfs_io -c "pwrite -W/w" doesn't report errors
> while xfs_io -c "pwrite" -c "fsync" does.
> 
> This changes "pwrite -W/w" to report errors when it should.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

<after looking at djwong & bfoster's comments>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/pwrite.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 1c5dfca..71bcccc 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -379,11 +379,18 @@ pwrite_f(
>  	}
>  	if (c < 0)
>  		goto done;
> -	if (Wflag)
> -		fsync(file->fd);
> -	if (wflag)
> -		fdatasync(file->fd);
> +	if (Wflag) {
> +		if (fsync(file->fd) < 0) {
> +			perror("fsync");
> +			goto done;
> +		}
> +	}
> +	if (wflag) {
> +		if (fdatasync(file->fd) < 0) {
> +			perror("fdatasync");
> +			goto done;
> +		}
> +	}
>  	if (qflag)
>  		goto done;
>  	gettimeofday(&t2, NULL);
> 
