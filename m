Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43358 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbeJPGxM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Oct 2018 02:53:12 -0400
Subject: Re: [PATCH] xfs_scrub: lack of kernel support is not a service
 failure
References: <20181015160344.GJ28243@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6ab73dae-c61c-8f16-83fd-628933bad8e7@sandeen.net>
Date: Mon, 15 Oct 2018 18:05:49 -0500
MIME-Version: 1.0
In-Reply-To: <20181015160344.GJ28243@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 10/15/18 11:03 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't treat a lack of kernel support for scrubbing as an automated
> service failure because we have not actually determined that there's
> anything wrong with the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

makes sense to me

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/xfs_scrub.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 33b83a5f..6a0304d2 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -779,9 +779,15 @@ main(
>  	 * for capturing all the log messages if the scrub fails, because the
>  	 * fail service uses the service name to gather log messages for the
>  	 * error report.
> +	 *
> +	 * Note: We don't count a lack of kernel support as a service failure
> +	 * because we haven't determined that there's anything wrong with the
> +	 * filesystem.
>  	 */
>  	if (is_service) {
>  		sleep(2);
> +		if (!ctx.scrub_setup_succeeded)
> +			return 0;
>  		if (ret != SCRUB_RET_SUCCESS)
>  			return 1;
>  	}
> 
