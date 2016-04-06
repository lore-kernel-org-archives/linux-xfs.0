Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 161567CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 17:23:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFA0D304032
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 15:23:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MR9B177EclsC9uCD for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 15:23:33 -0700 (PDT)
Received: from Liberator.local (erlite [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 327F316C150
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 17:23:33 -0500 (CDT)
Subject: Re: [PATCH 19/19] mkfs: add optional 'reason' for illegal_option
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-20-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57058C64.2010105@sandeen.net>
Date: Wed, 6 Apr 2016 17:23:32 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-20-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Jan Tulak <jtulak@redhat.com>
> 
> Allow us to tell the user what exactly is wrong with his options.

"with the specified options" ;)

> For example, that the value is too small, instead of just generic
> "bad option."
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 680c6c4..76e193d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1550,11 +1550,18 @@ static __attribute__((noreturn)) void
>  illegal_option(
>  	const char	*value,
>  	struct opt_params	*opts,
> -	int		index)
> +	int		index,
> +	const char *reason)
                   ^ tab that out to match.
>  {
> -	fprintf(stderr,
> -		_("Illegal value %s for -%c %s option\n"),
> -		value, opts->name, opts->subopts[index]);
> +	if(reason == NULL){
          ^space          ^space
> +		fprintf(stderr,
> +			_("Illegal value %s for -%c %s option\n"),
> +			value, opts->name, opts->subopts[index]);
> +	} else {
> +		fprintf(stderr,
> +			_("Illegal value %s for -%c %s option: %s\n"),
> +			value, opts->name, opts->subopts[index], reason);
> +	}

>  	usage();
>  }
> 
> @@ -1646,16 +1653,18 @@ getnum(
> 
>  		c = strtoll(str, &str_end, 0);
>  		if (c == 0 && str_end == str)
> -			illegal_option(str, opts, index);
> +			illegal_option(str, opts, index, NULL);
>  		if (*str_end != '\0')
> -			illegal_option(str, opts, index);
> +			illegal_option(str, opts, index, NULL);
>  	}
> 
>  	/* Validity check the result. */
> -	if (c < sp->minval || c > sp->maxval)
> -		illegal_option(str, opts, index);
> +	if (c < sp->minval)
> +		illegal_option(str, opts, index, "value is too small");
> +	else if (c > sp->maxval)
> +		illegal_option(str, opts, index, "value is too large");
>  	if (sp->is_power_2 && !ispow2(c))
> -		illegal_option(str, opts, index);
> +		illegal_option(str, opts, index, "value has to be power of 2");

                                                 "value must be a power of 2"


The "reason" strings should be translatable strings too, right? :  _(" ... ")

-Eric

>  	return c;
>  }
> 
> --
> 2.6.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
