Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38966 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934689AbdCYAbO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Mar 2017 20:31:14 -0400
Subject: Re: [PATCH 06/22] mkfs: add cross-section conflict checks
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-7-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7e15965f-1f31-9d3d-701f-cca982a871a8@sandeen.net>
Date: Fri, 24 Mar 2017 19:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <20170315160017.27805-7-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 3/15/17 11:00 AM, Jan Tulak wrote:
> Checks are modified to work with cross-section conflicts (data, metada, log, ...).

More information in the changelog please; this doesn't
tell us a whole lot about what this is actually doing.
 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 43 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7e0a4159..0877c196 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -744,6 +744,9 @@ struct opt_params {
>  	},
>  };
>  
> +static void conflict_struct(struct opt_params 	*opt, struct subopt_param *subopt,

weird tabs there

> +			struct subopt_conflict 	*conflict);

"conflict_struct" seems like a variable name, not a function name.  :)

What does this function actually do?

> +
>  #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
>  #define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
>  #define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
> @@ -1351,10 +1354,9 @@ check_opt(
>  			break;
>  		if (conflict_opt.test_values)
>  			break;
> -		if (opt->subopt_params[conflict_opt.subopt].seen ||
> -		    opt->subopt_params[conflict_opt.subopt].str_seen) {
> -			conflict(opt->name, (char **)opt->subopts,
> -				 conflict_opt.subopt, index);
> +		if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
> +		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) {
> +			conflict_struct(opt, sp, &conflict_opt);
>  		}
>  	}
>  }
> @@ -1379,13 +1381,12 @@ check_opt_value(
>  			break;
>  		if (!conflict_opt.test_values)
>  			break;
> -		if ((opt->subopt_params[conflict_opt.subopt].seen ||
> -				    opt->subopt_params[conflict_opt.subopt].str_seen) &&
> -		    opt->subopt_params[conflict_opt.subopt].value
> +		if ((opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
> +		     opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) &&
> +		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value
>  				== conflict_opt.invalid_value &&
>  		    value == conflict_opt.at_value) {
> -			conflict(opt->name, (char **)opt->subopts,
> -				 conflict_opt.subopt, index);
> +			conflict_struct(opt, sp, &conflict_opt);
>  		}
>  	}
>  }
> @@ -3586,12 +3587,36 @@ conflict(
>  	char		*tab[],
>  	int		oldidx,
>  	int		newidx)
> +

that newline should not be here ...

>  {
>  	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
>  		opt, tab[oldidx], opt, tab[newidx]);
>  	usage();
>  }

A comment about what this function actually /does/ would be good.

All it really does is printf, I guess - so a function name more
like show_conflict() might make more sense?  conflict_struct just
isn't a good descriptive name.

> +static void
> +conflict_struct(
> +	struct opt_params 	*opt,
> +	struct subopt_param	*subopt,
> +	struct subopt_conflict 	*conflict)
> +{
> +	if(conflict->message) {
> +		fprintf(stderr, _("Cannot specify both -%c %s and -%c %s: %s\n"),
> +			opt->name,
> +			opt->subopts[subopt->index],
> +			opts[conflict->opt].name,
> +			opts[conflict->opt].subopts[conflict->subopt],
> +			_(conflict->message));
> +	} else {
> +		fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
> +			opt->name,
> +			opt->subopts[subopt->index],
> +			opts[conflict->opt].name,
> +			opts[conflict->opt].subopts[conflict->subopt]);
> +	}

I wonder if this can be done w/o the cut and paste?

> +	usage();
> +}
> +
>  
>  static void
>  illegal(
> 
