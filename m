Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54534 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729714AbfDDVvg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 17:51:36 -0400
Subject: Re: [PATCH 40/36] xfs_io: fix label parsing and validation
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193608.GD1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b60b97a7-eafc-a40e-a9d2-6d9343c34d3e@sandeen.net>
Date: Thu, 4 Apr 2019 16:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193608.GD1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're trying to set a new label, check the length to make sure we
> won't overflow the label size, and size label[] so that we can use
> strncpy without static checker complaints.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Oh there it is :)  Yeah, this is better than what i had, which
just truncated a too-long label IIRC.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/label.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/io/label.c b/io/label.c
> index 602ece89..72e07964 100644
> --- a/io/label.c
> +++ b/io/label.c
> @@ -40,7 +40,7 @@ label_f(
>  {
>  	int		c;
>  	int		error;
> -	char		label[FSLABEL_MAX];
> +	char		label[FSLABEL_MAX + 1];
>  
>  	if (argc == 1) {
>  		memset(label, 0, sizeof(label));
> @@ -54,7 +54,13 @@ label_f(
>  			label[0] = '\0';
>  			break;
>  		case 's':
> -			strncpy(label, optarg, sizeof(label));
> +			if (strlen(optarg) > FSLABEL_MAX) {
> +				errno = EINVAL;
> +				error = 1;
> +				goto out;
> +			}
> +			strncpy(label, optarg, sizeof(label) - 1);
> +			label[sizeof(label) - 1] = 0;

Hm, so this can send up to FSLABEL_MAX chars to the kernel w/o a null
termination (the null term is at FSLABEL_MAX+1 right?)

But, I guess that's for the kernel to guard against if it accepts a
label that long, if it even cares.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  			break;
>  		default:
>  			return command_usage(&label_cmd);
> 
