Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60734 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1429617AbdDYRi3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 13:38:29 -0400
Subject: Re: [PATCH 01/12] mkfs: Save raw user input field to the opts struct
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-2-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <07ca1359-e5f5-9788-cdd7-5d1c72f60a0f@sandeen.net>
Date: Tue, 25 Apr 2017 12:38:22 -0500
MIME-Version: 1.0
In-Reply-To: <20170423185503.31415-2-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/23/17 1:54 PM, Jan Tulak wrote:
> Save exactly what the user gave us for every option.  This way, we will
> never lose the information if we need it to print back an issue.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Hm but no users yet?  I suppose that's ok.  Just adding the infrastructure
here.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 83a04fc..84674d5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -119,6 +119,10 @@ uint64_t		sectorsize;
>   *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
>   *     value in any case.
>   *
> + *   raw_input INTERNAL
> + *     Filled raw string from the user, so we never lose that information e.g.
> + *     to print it back in case of an issue.
> + *
>   * !!! NOTE ==================================================================
>   *
>   * If you are adding a new option, or changing an existing one,
> @@ -141,6 +145,7 @@ struct opt_params {
>  		uint64_t	minval;
>  		uint64_t	maxval;
>  		uint64_t	defaultval;
> +		const char	*raw_input;
>  	}		subopt_params[MAX_SUBOPTS];
>  };
>  
> @@ -748,6 +753,18 @@ struct opt_params mopts = {
>   */
>  #define WHACK_SIZE (128 * 1024)
>  
> +static inline void
> +set_conf_raw(struct opt_params *opt, int subopt, const char *value)
> +{
> +	opt->subopt_params[subopt].raw_input = value;
> +}
> +
> +static inline const char *
> +get_conf_raw(const struct opt_params *opt, int subopt)
> +{
> +	return opt->subopt_params[subopt].raw_input;
> +}
> +
>  /*
>   * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
>   */
> 
