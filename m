Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751451AbdG0Q1y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 12:27:54 -0400
Date: Thu, 27 Jul 2017 18:27:52 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
Message-ID: <20170727162752.GK18884@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-2-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720092932.32580-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 11:29:26AM +0200, Jan Tulak wrote:
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a69190b9..4b030101 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -107,6 +107,11 @@ unsigned int		sectorsize;
>   *     sets what is used with simple specifying the subopt (-d file).
>   *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
>   *     value in any case.
> + *
> + *   raw_input INTERNAL
> + *     Filled raw string from the user, so we never lose that information e.g.
> + *     to print it back in case of an issue.
> + *
>   */
>  struct opt_params {
>  	const char	name;
> @@ -122,6 +127,7 @@ struct opt_params {
>  		long long	minval;
>  		long long	maxval;
>  		long long	defaultval;
> +		const char	*raw_input;
>  	}		subopt_params[MAX_SUBOPTS];
>  };
>  
> @@ -729,6 +735,18 @@ struct opt_params mopts = {
>   */
>  #define WHACK_SIZE (128 * 1024)
>  
> +static inline void
> +set_conf_raw(struct opt_params *opt, int subopt, const char *value)
> +{
> +	opt->subopt_params[subopt].raw_input = value;
> +}

There are no bounds check on the array here, I think set_conf_raw()
should return int and we would check the return value. It could
return -EINVAL if the subopt is invalid for instance.

> +
> +static inline const char *
> +get_conf_raw(const struct opt_params *opt, int subopt)
> +{
> +	return opt->subopt_params[subopt].raw_input;
> +}
> +
>  /*
>   * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.

These are not pass by value.

The usage of set_conf_raw() and get_conf_raw() therefore have strict
constraints and can be only used within certain contexts:

  o Since they are pointers the lifetime usage of these functions
    are limited to the lifetime of the pointers                                 
  o Since they are *currently* used on main() this is fine but this would
    limit its use. In the future if we want to defer access to these
    pointers outside of main() or if main() uses a library which would
    parse some string and free it we'd have to make another change
    yet again.

Even if its *OK* today, if some helpers are used later which for instance call
set_conf_raw() and then free the passed pointer right away we are screwed,
leading to potentially using random values.  An alternative to limiting the use
of these routines would be to instead have set_conf_raw() to use strdup() and
have it return an int in case of -ENOMEM.

  Luis
