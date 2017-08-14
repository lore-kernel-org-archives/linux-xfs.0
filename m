Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17302 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdHNXH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 19:07:28 -0400
Date: Mon, 14 Aug 2017 16:07:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] mkfs: move getnum within the file
Message-ID: <20170814230722.GI4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170811123037.15962-6-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811123037.15962-6-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 02:30:36PM +0200, Jan Tulak wrote:
> Move getnum, check_opt and illegal_option within the file. We have to do
> this to avoid dependency issues with the following patch. There is no
> other change in this patch, just cut&paste of these functions.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 236 ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 118 insertions(+), 118 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e3f7d345..3e7ba5f0 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -813,6 +813,124 @@ get_conf_raw_safe(const int opt, const int subopt)
>  	return str;
>  }
>  
> +static __attribute__((noreturn)) void
> +illegal_option(

How about declaring the functions at the top and leaving the definitions
where they are?

--D

> +	const char		*value,
> +	struct opt_params	*opts,
> +	int			index,
> +	const char		*reason)
> +{
> +	fprintf(stderr,
> +		_("Illegal value %s for -%c %s option. %s\n"),
> +		value, opts->name, opts->subopts[index],
> +		reason ? reason : "");
> +	usage();
> +}
> +
> +/*
> + * Check for conflicts and option respecification.
> + */
> +static void
> +check_opt(
> +	struct opt_params	*opts,
> +	int			index,
> +	bool			str_seen)
> +{
> +	struct subopt_param	*sp = &opts->subopt_params[index];
> +	int			i;
> +
> +	if (sp->index != index) {
> +		fprintf(stderr,
> +	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
> +			sp->index, index);
> +		reqval(opts->name, (char **)opts->subopts, index);
> +	}
> +
> +	/*
> +	 * Check for respecification of the option. This is more complex than it
> +	 * seems because some options are parsed twice - once as a string during
> +	 * input parsing, then later the string is passed to getnum for
> +	 * conversion into a number and bounds checking. Hence the two variables
> +	 * used to track the different uses based on the @str parameter passed
> +	 * to us.
> +	 */
> +	if (!str_seen) {
> +		if (sp->seen)
> +			respec(opts->name, (char **)opts->subopts, index);
> +		sp->seen = true;
> +	} else {
> +		if (sp->str_seen)
> +			respec(opts->name, (char **)opts->subopts, index);
> +		sp->str_seen = true;
> +	}
> +
> +	/* check for conflicts with the option */
> +	for (i = 0; i < MAX_CONFLICTS; i++) {
> +		int conflict_opt = sp->conflicts[i];
> +
> +		if (conflict_opt == LAST_CONFLICT)
> +			break;
> +		if (opts->subopt_params[conflict_opt].seen ||
> +		    opts->subopt_params[conflict_opt].str_seen)
> +			conflict(opts->name, (char **)opts->subopts,
> +				 conflict_opt, index);
> +	}
> +}
> +
> +static long long
> +getnum(
> +	const char		*str,
> +	struct opt_params	*opts,
> +	int			index)
> +{
> +	struct subopt_param	*sp = &opts->subopt_params[index];
> +	long long		c;
> +
> +	check_opt(opts, index, false);
> +	set_conf_raw(opts->index, index, str);
> +	/* empty strings might just return a default value */
> +	if (!str || *str == '\0') {
> +		if (sp->flagval == SUBOPT_NEEDS_VAL)
> +			reqval(opts->name, (char **)opts->subopts, index);
> +		return sp->flagval;
> +	}
> +
> +	if (sp->minval == 0 && sp->maxval == 0) {
> +		fprintf(stderr,
> +			_("Option -%c %s has undefined minval/maxval."
> +			  "Can't verify value range. This is a bug.\n"),
> +			opts->name, opts->subopts[index]);
> +		exit(1);
> +	}
> +
> +	/*
> +	 * Some values are pure numbers, others can have suffixes that define
> +	 * the units of the number. Those get passed to cvtnum(), otherwise we
> +	 * convert it ourselves to guarantee there is no trailing garbage in the
> +	 * number.
> +	 */
> +	if (sp->convert)
> +		c = cvtnum(blocksize, sectorsize, str);
> +	else {
> +		char		*str_end;
> +
> +		c = strtoll(str, &str_end, 0);
> +		if (c == 0 && str_end == str)
> +			illegal_option(str, opts, index, NULL);
> +		if (*str_end != '\0')
> +			illegal_option(str, opts, index, NULL);
> +	}
> +
> +	/* Validity check the result. */
> +	if (c < sp->minval)
> +		illegal_option(str, opts, index, _("value is too small"));
> +	else if (c > sp->maxval)
> +		illegal_option(str, opts, index, _("value is too large"));
> +	if (sp->is_power_2 && !ispow2(c))
> +		illegal_option(str, opts, index, _("value must be a power of 2"));
> +	return c;
> +}
> +
>  /*
>   * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
>   */
> @@ -1337,124 +1455,6 @@ sb_set_features(
>  
>  }
>  
> -static __attribute__((noreturn)) void
> -illegal_option(
> -	const char		*value,
> -	struct opt_params	*opts,
> -	int			index,
> -	const char		*reason)
> -{
> -	fprintf(stderr,
> -		_("Illegal value %s for -%c %s option. %s\n"),
> -		value, opts->name, opts->subopts[index],
> -		reason ? reason : "");
> -	usage();
> -}
> -
> -/*
> - * Check for conflicts and option respecification.
> - */
> -static void
> -check_opt(
> -	struct opt_params	*opts,
> -	int			index,
> -	bool			str_seen)
> -{
> -	struct subopt_param	*sp = &opts->subopt_params[index];
> -	int			i;
> -
> -	if (sp->index != index) {
> -		fprintf(stderr,
> -	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
> -			sp->index, index);
> -		reqval(opts->name, (char **)opts->subopts, index);
> -	}
> -
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
> -			respec(opts->name, (char **)opts->subopts, index);
> -		sp->seen = true;
> -	} else {
> -		if (sp->str_seen)
> -			respec(opts->name, (char **)opts->subopts, index);
> -		sp->str_seen = true;
> -	}
> -
> -	/* check for conflicts with the option */
> -	for (i = 0; i < MAX_CONFLICTS; i++) {
> -		int conflict_opt = sp->conflicts[i];
> -
> -		if (conflict_opt == LAST_CONFLICT)
> -			break;
> -		if (opts->subopt_params[conflict_opt].seen ||
> -		    opts->subopt_params[conflict_opt].str_seen)
> -			conflict(opts->name, (char **)opts->subopts,
> -				 conflict_opt, index);
> -	}
> -}
> -
> -static long long
> -getnum(
> -	const char		*str,
> -	struct opt_params	*opts,
> -	int			index)
> -{
> -	struct subopt_param	*sp = &opts->subopt_params[index];
> -	long long		c;
> -
> -	check_opt(opts, index, false);
> -	set_conf_raw(opts->index, index, str);
> -	/* empty strings might just return a default value */
> -	if (!str || *str == '\0') {
> -		if (sp->flagval == SUBOPT_NEEDS_VAL)
> -			reqval(opts->name, (char **)opts->subopts, index);
> -		return sp->flagval;
> -	}
> -
> -	if (sp->minval == 0 && sp->maxval == 0) {
> -		fprintf(stderr,
> -			_("Option -%c %s has undefined minval/maxval."
> -			  "Can't verify value range. This is a bug.\n"),
> -			opts->name, opts->subopts[index]);
> -		exit(1);
> -	}
> -
> -	/*
> -	 * Some values are pure numbers, others can have suffixes that define
> -	 * the units of the number. Those get passed to cvtnum(), otherwise we
> -	 * convert it ourselves to guarantee there is no trailing garbage in the
> -	 * number.
> -	 */
> -	if (sp->convert)
> -		c = cvtnum(blocksize, sectorsize, str);
> -	else {
> -		char		*str_end;
> -
> -		c = strtoll(str, &str_end, 0);
> -		if (c == 0 && str_end == str)
> -			illegal_option(str, opts, index, NULL);
> -		if (*str_end != '\0')
> -			illegal_option(str, opts, index, NULL);
> -	}
> -
> -	/* Validity check the result. */
> -	if (c < sp->minval)
> -		illegal_option(str, opts, index, _("value is too small"));
> -	else if (c > sp->maxval)
> -		illegal_option(str, opts, index, _("value is too large"));
> -	if (sp->is_power_2 && !ispow2(c))
> -		illegal_option(str, opts, index, _("value must be a power of 2"));
> -	return c;
> -}
> -
>  /*
>   * Option is a string - do all the option table work, and check there
>   * is actually an option string. Otherwise we don't do anything with the string
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
