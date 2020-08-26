Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AC8C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0525A20678
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgHZWVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:21:17 -0400
Received: from sandeen.net ([63.231.237.45]:37996 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHZWVP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 18:21:15 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C830E48C6A5;
        Wed, 26 Aug 2020 17:21:02 -0500 (CDT)
Subject: Re: [PATCH 3/3] mkfs: hook up suboption parsing to ini files
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200826015634.3974785-1-david@fromorbit.com>
 <20200826015634.3974785-4-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5da00b2e-69e1-09e2-89d2-63623494d244@sandeen.net>
Date:   Wed, 26 Aug 2020 17:21:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826015634.3974785-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/25/20 8:56 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have the config file parsing hooked up and feeding in
> parameters to mkfs, wire the parameters up to the existing CLI
> option parsing functions. THis gives the config file exactly the
> same capabilities and constraints as the command line option
> specification.

And as such, as you already mentioned, respecifications on the command
line will fail.  That can be documented in the man page :)

The section names will need to be documented too.

(In a very much not-bikeshedding way, we could consider [b] rather than
[block] so you can cover it with "the section names match the option
characters, i.e. for -b one would use section name [b]" but I really don't
care and will not mention this again because as long as it's documented
it's fine.)

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/linux.h |   2 +-
>  mkfs/xfs_mkfs.c | 121 +++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 95 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 57726bb12b74..03b3278bb895 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -92,7 +92,7 @@ static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
>  	uuid_unparse(*uu, buffer);
>  }
>  
> -static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
> +static __inline__ int platform_uuid_parse(const char *buffer, uuid_t *uu)
>  {
>  	return uuid_parse(buffer, *uu);
>  }
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6a373d614a56..deaed551b6d1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -142,6 +142,13 @@ enum {
>   * name MANDATORY
>   *   Name is a single char, e.g., for '-d file', name is 'd'.
>   *
> + * ini_name MANDATORY
> + *   Name is a string, not longer than MAX_INI_NAME_LEN, that is used as the
> + *   section name for this option set in INI format config files. The only
> + *   option set this is not required for is the command line config file
> + *   specification options, everything else must be configurable via config
> + *   files.

Nothing actually enforces this MANDATORY, right, this is just documentation.
So the fact that struct opt_params copts doesn't have it, is fine.

> @@ -967,13 +984,24 @@ respec(
>  
>  static void
>  unknown(
> -	char		opt,
> -	char		*s)
> +	const char	opt,
> +	const char	*s)

(can all of the constification could maybe go in its own patch just to cut
down on the patch doomscrolling or does it have to go with the other changes?)

>  {
>  	fprintf(stderr, _("unknown option -%c %s\n"), opt, s);
>  	usage();
>  }
>  
> +static void
> +unknown_cfgfile_opt(
> +	const char	*section,
> +	const char	*name,
> +	const char	*value)
> +{
> +	fprintf(stderr, _("unknown config file option: [%s]:%s=%s\n"),
> +		section, name, value);

If we allow more than one -c subopt in the future we might want to print
the filename. Wouldn't /hurt/ to do so now, or just remember to do it if
we ever add a 2nd -c subopt.

> +	usage();
> +}
> +
>  static void
>  check_device_type(
>  	const char	*name,
> @@ -1379,7 +1407,7 @@ getnum(
>   */
>  static char *
>  getstr(
> -	char			*str,
> +	const char		*str,
>  	struct opt_params	*opts,
>  	int			index)
>  {
> @@ -1388,14 +1416,14 @@ getstr(
>  	/* empty strings for string options are not valid */
>  	if (!str || *str == '\0')
>  		reqval(opts->name, opts->subopts, index);
> -	return str;
> +	return (char *)str;

(what's the cast for?)


> @@ -1682,23 +1710,22 @@ sector_opts_parser(
>  }
>  
>  static struct subopts {
> -	char		opt;
>  	struct opt_params *opts;
>  	int		(*parser)(struct opt_params	*opts,
>  				  int			subopt,
> -				  char			*value,
> +				  const char		*value,
>  				  struct cli_params	*cli);
>  } subopt_tab[] = {
> -	{ 'b', &bopts, block_opts_parser },
> -	{ 'c', &copts, cfgfile_opts_parser },
> -	{ 'd', &dopts, data_opts_parser },
> -	{ 'i', &iopts, inode_opts_parser },
> -	{ 'l', &lopts, log_opts_parser },
> -	{ 'm', &mopts, meta_opts_parser },
> -	{ 'n', &nopts, naming_opts_parser },
> -	{ 'r', &ropts, rtdev_opts_parser },
> -	{ 's', &sopts, sector_opts_parser },
> -	{ '\0', NULL, NULL },
> +	{ &bopts, block_opts_parser },
> +	{ &copts, cfgfile_opts_parser },
> +	{ &dopts, data_opts_parser },
> +	{ &iopts, inode_opts_parser },
> +	{ &lopts, log_opts_parser },
> +	{ &mopts, meta_opts_parser },
> +	{ &nopts, naming_opts_parser },
> +	{ &ropts, rtdev_opts_parser },
> +	{ &sopts, sector_opts_parser },
> +	{ NULL, NULL },
>  };
>  
>  static void
> @@ -1712,12 +1739,12 @@ parse_subopts(
>  	int		ret = 0;
>  
>  	while (sop->opts) {
> -		if (sop->opt == opt)
> +		if (opt && sop->opts->name == opt)
>  			break;
>  		sop++;
>  	}
>  
> -	/* should never happen */
> +	/* Should not happen */

ok? :)

Overall this seems remarkably tidy, thanks.

-Eric

