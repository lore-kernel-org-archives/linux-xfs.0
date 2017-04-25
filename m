Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45906 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S978405AbdDYDk5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 23:40:57 -0400
Date: Tue, 25 Apr 2017 05:40:55 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 06/12] mkfs: create get/set functions for opts table
Message-ID: <20170425034055.GJ28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-7-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423185503.31415-7-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 23, 2017 at 08:54:57PM +0200, Jan Tulak wrote:
> Add functions that can be used to get/set values to opts table.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> ---
>  mkfs/xfs_mkfs.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index c2ffd91..4caf93c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -786,6 +786,38 @@ get_conf_raw(int opt, int subopt)
>  	return opts[opt].subopt_params[subopt].raw_input;
>  }
>  
> +static uint64_t getnum(const char *str, struct opt_params *opts, int index);

Why not just move getnum() above here. Forward declarations IMHO should not be
needed unless we have odd inclusion issues and I don't think that's the case
here ?

> +
> +/*
> + * Get and set values to the opts table.
> + */
> +static inline uint64_t
> +get_conf_val(int opt, int subopt)
> +{
> +	return opts[opt].subopt_params[subopt].value;
> +}
> +
> +static void
> +set_conf_val(int opt, int subopt, uint64_t val)
> +{
> +	struct subopt_param *sp = &opts[opt].subopt_params[subopt];
> +
> +	sp->value = val;
> +}
> +
> +/*
> + * A wrapper for getnum and set_conf_val.
> + */
> +static inline uint64_t
> +parse_conf_val(int opt, int subopt, char *value)
> +{
> +	uint64_t num = getnum(value, &opts[opt], subopt);
> +
> +	set_conf_val(opt, subopt, num);
> +	return num;
> +}

Very nice thanks!

  Luis
