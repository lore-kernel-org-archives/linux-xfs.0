Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdAMVS2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 16:18:28 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79BD5C03BD7B
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2017 21:18:14 +0000 (UTC)
Date: Fri, 13 Jan 2017 15:18:11 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 06/22] mkfs: add cross-section conflict checks
Message-ID: <20170113211811.GA4176@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-7-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481117249-21273-7-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 02:27:13PM +0100, Jan Tulak wrote:
> Checks are modified to work with cross-section conflicts (data, metada, log, ...).
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 43 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3bb9f09..e46b55c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -744,6 +744,9 @@ struct opt_params {
>  	},
>  };
>  
> +static void conflict_struct(struct opt_params 	*opt, struct subopt_param *subopt,
> +			struct subopt_conflict 	*conflict);
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
>  {
>  	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
>  		opt, tab[oldidx], opt, tab[newidx]);
>  	usage();
>  }
>  
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
> +	usage();
> +}
> +
>  
>  static void
>  illegal(
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
