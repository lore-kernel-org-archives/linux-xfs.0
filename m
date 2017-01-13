Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751104AbdAMVU7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jan 2017 16:20:59 -0500
Received: from smtp.corp.redhat.com (int-mx16.intmail.prod.int.phx2.redhat.com [10.5.11.28])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 646F361BA4
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2017 21:21:00 +0000 (UTC)
Date: Fri, 13 Jan 2017 15:20:57 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 10/22] mkfs: change when to mark an option as seen
Message-ID: <20170113212057.GD4176@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-11-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481117249-21273-11-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 02:27:17PM +0100, Jan Tulak wrote:
> Make the check for seen option more useful for new conflict detection
> by moving it's logic to new place - we are no longer doing the
> respecification as before.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 40 +++++++++++-----------------------------
>  1 file changed, 11 insertions(+), 29 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d11fad6..b3625ed 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -152,10 +152,6 @@ unsigned int		sectorsize;
>   *     Do not set this flag when definning a subopt. It is used to remeber that
>   *     this subopt was already seen, for example for conflicts detection.
>   *
> - *   str_seen INTERNAL
> - *     Do not set. It is used internally for respecification, when some options
> - *     has to be parsed twice - at first as a string, then later as a number.
> - *
>   *   convert OPTIONAL
>   *     A flag signalling whether the user-given value can use suffixes.
>   *     If you want to allow the use of user-friendly values like 13k, 42G,
> @@ -212,7 +208,6 @@ struct opt_params {
>  	struct subopt_param {
>  		int		index;
>  		bool		seen;
> -		bool		str_seen;
>  		bool		convert;
>  		bool		is_power_2;
>  		struct subopt_conflict {
> @@ -1375,7 +1370,7 @@ static void
>  check_subopt_conflicts(
>  	struct opt_params	*opt,
>  	int			index,
> -	bool			str_seen)
> +	bool			seen)
>  {
>  	struct subopt_param	*sp = &opt->subopt_params[index];
>  	int			i;
> @@ -1387,23 +1382,6 @@ check_subopt_conflicts(
>  		reqval(opt->name, (char **)opt->subopts, index);
>  	}
>  
> -	/*
> -	 * Check for respecification of the option. This is more complex than it
> -	 * seems because some options are parsed twice - once as a string during
> -	 * input parsing, then later the string is passed to getnum for
> -	 * conversion into a number and bounds checking. Hence the two variables
> -	 * used to track the different uses based on the @str parameter passed
> -	 * to us.
> -	 */
> -	if (!str_seen) {
> -		if (sp->seen)
> -			respec(opt->name, (char **)opt->subopts, index);
> -		sp->seen = true;
> -	} else {
> -		if (sp->str_seen)
> -			respec(opt->name, (char **)opt->subopts, index);
> -		sp->str_seen = true;
> -	}
>  
>  	/* check for conflicts with the option */
>  	for (i = 0; i < MAX_CONFLICTS; i++) {
> @@ -1413,8 +1391,7 @@ check_subopt_conflicts(
>  			break;
>  		if (conflict_opt.test_values)
>  			break;
> -		if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
> -		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) {
> +		if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen) {
>  			conflict_struct(opt, sp, &conflict_opt);
>  		}
>  	}
> @@ -1440,8 +1417,7 @@ check_subopt_value(
>  			break;
>  		if (!conflict_opt.test_values)
>  			break;
> -		if ((opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
> -		     opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) &&
> +		if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen &&
>  		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value
>  				== conflict_opt.invalid_value &&
>  		    value == conflict_opt.at_value) {
> @@ -1462,7 +1438,11 @@ check_opt(
>  	int index;
>  	struct opt_params *opt = &opts[opti];
>  	for (index = 0; index < MAX_SUBOPTS; index++) {
> +		if (opt->subopts[index] == NULL)
> +			break;
>  		struct subopt_param *sp = &opt->subopt_params[index];
> +		if (!sp->seen)
> +			continue;
>  		check_subopt_conflicts(opt, index, false);
>  		check_subopt_value(opt, index, sp->value);
>  	}
> @@ -1489,9 +1469,12 @@ getnum(
>  	if (!str || *str == '\0') {
>  		if (sp->defaultval == SUBOPT_NEEDS_VAL)
>  			reqval(opts->name, (char **)opts->subopts, index);
> +		sp->seen = true;
>  		return sp->defaultval;
>  	}
>  
> +	sp->seen = true;
> +
>  	if (sp->minval == 0 && sp->maxval == 0) {
>  		fprintf(stderr,
>  			_("Option -%c %s has undefined minval/maxval."
> @@ -1540,11 +1523,10 @@ getstr(
>  	struct opt_params	*opts,
>  	int			index)
>  {
> -	check_subopt(opts, index, true);
> -
>  	/* empty strings for string options are not valid */
>  	if (!str || *str == '\0')
>  		reqval(opts->name, (char **)opts->subopts, index);
> +	opts->subopt_params[index].seen = true;
>  	return str;
>  }
>  
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
