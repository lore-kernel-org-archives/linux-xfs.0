Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752033AbdG0QSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 12:18:07 -0400
Date: Thu, 27 Jul 2017 18:18:06 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 6/7] mkfs: extend opt_params with a value field
Message-ID: <20170727161806.GJ18884@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-7-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720092932.32580-7-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 11:29:31AM +0200, Jan Tulak wrote:
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

These are pass by value so its fine to do it this way.

> +
> +	sp->value = val;
> +}
> +
>  static inline void
>  set_conf_raw(int opt, int subopt, const char *value)
>  {
> @@ -880,6 +905,18 @@ getnum(
>  }
>  
>  /*
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

A good comment explaining getnum() will abort if parsing for some reasons fails
is worth it given the way you use parse_conf_val() is rather inconsistent -- in
some places you use the return value, in some other you do not, and someone
reading the code should hopefully get a sense of a relief that error checking
is *not* required given it is already built-in to the helpers used by
parse_conf_val().

This also limits the use of parse_conf_val() in that we won't be able to
customize error messages with better context, so its a good time to evaluate
if we want to continue with that tradition or let parse_conf_val() return
int and if it returns 0 it was successful, otherwise an error value.

Making this return an int and have the return value checked makes this code
IMHO cleaner and subject to growth. Right now this sort of hack IMHO limits
the code to growth, despite the fact that I know this would create more work
at the moment.

Thoughts?

  Luis
