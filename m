Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48279 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750981AbdG0Qjg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 12:39:36 -0400
Date: Thu, 27 Jul 2017 18:39:35 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/5 v2] mkfs: replace variables with opts table: -b,d,s
 options
Message-ID: <20170727163935.GL18884@wotan.suse.de>
References: <20170720095156.35417-2-jtulak@redhat.com>
 <20170721123448.6956-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721123448.6956-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 21, 2017 at 02:34:48PM +0200, Jan Tulak wrote:
> @@ -1609,6 +1593,7 @@ main(
>  			break;
>  		case 'b':
>  			p = optarg;
> +			uint64_t tmp;

Note:

An extra variable added, just so we can get the current value parsed
so we can then convert it to also set similar collateral variables.

>  			while (*p != '\0') {
>  				char	**subopts =
>  						(char **)opts[OPT_B].subopts;
> @@ -1616,19 +1601,17 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case B_LOG:
> -					blocklog = parse_conf_val(OPT_B, B_LOG,
> -								  value);
> -					blocksize = 1 << blocklog;
> +					tmp = parse_conf_val(OPT_B, B_LOG,
> +							     value);
> +					set_conf_val(OPT_B, B_SIZE, 1 << tmp);

So here when BLOG is set we update B_SIZE as collateral.

>  					blflag = 1;
> -					set_conf_val(OPT_B, B_SIZE, blocksize);
>  					break;
>  				case B_SIZE:
> -					blocksize = parse_conf_val(OPT_B,
> -								   B_SIZE,
> -								   value);
> -					blocklog = libxfs_highbit32(blocksize);
> +					tmp = parse_conf_val(OPT_B, B_SIZE,
> +							     value);
> +					set_conf_val(OPT_B, B_LOG,
> +						libxfs_highbit32(tmp));

Here is the reverse, when B_SIZE is set we set B_LOG as well.

>  					bsflag = 1;
> -					set_conf_val(OPT_B, B_LOG, blocklog);
>  					break;
>  				default:
>  					unknown('b', value);
> @@ -1641,18 +1624,17 @@ main(
>  				char	**subopts =
>  						(char **)opts[OPT_D].subopts;
>  				char	*value;
> +				uint64_t tmp;
> +
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case D_AGCOUNT:
> -					agcount = parse_conf_val(OPT_D,
> -								 D_AGCOUNT,
> -								 value);
> +					parse_conf_val(OPT_D, D_AGCOUNT,
> +						       value);

If parse_conf_val() could just update the collateral values for us then main()
would be much cleaner.

Here parse_conf_val() is used only to update D_AGCOUNT based on the parsed
value. But note that the return value is ignored. In some other places the
return value is used. This is inconsistent, and I realize that the reason
we ignore errors is that getnum() is used, however now is a good time to
consider if we should just allow the caller to check the error value and
return a proper error message and bail on their own. This would allow for
better contextual error messages as the code grows. We can discuss this in
the patch that adds parse_conf_val().

> @@ -2464,10 +2517,20 @@ _("rmapbt not supported with realtime devices\n"));
>  		sb_feat.log_version = 2;
>  	}
>  
> -	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
> +	int dsunit = get_conf_val(OPT_D, D_SUNIT);
> +	int dswidth = get_conf_val(OPT_D, D_SWIDTH);

Is int proper here?

  Luis
