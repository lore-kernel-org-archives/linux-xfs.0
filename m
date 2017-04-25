Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S980231AbdDYDN2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 23:13:28 -0400
Date: Tue, 25 Apr 2017 05:13:26 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 05/12] mkfs: extend opt_params with a value field
Message-ID: <20170425031326.GI28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-6-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423185503.31415-6-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 23, 2017 at 08:54:56PM +0200, Jan Tulak wrote:
> Add a new field int opt_params - value,

Agreed.

> which is filled with user input.

It sounds to me its more than that, its the default value which will be used should
not user input for the option be specified, and if user input value is provided it
will be the passed user input value. If the final value for the respective option.

?

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 513e106..c2ffd91 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -128,6 +128,12 @@ uint64_t		sectorsize;
>   *     Filled raw string from the user, so we never lose that information e.g.
>   *     to print it back in case of an issue.
>   *
> + *   value OPTIONAL
> + *     The value that is to be used if the given subopt is not specified at all.

It seems to be more than that ?

> + *     This is filled with user input 

This is a bit confusing, isn't it first the default value should no user input
value be passed ? And finally if user input value is passed only then will this
be that value ?

> and anything you write here now is
> + *     overwritten if user specifies the subopt. (If the user input is a string
> + *     and not a number, this value is set to a positive non-zero number.)
> + *
>   * !!! NOTE ==================================================================
>   *
>   * If you are adding a new option, or changing an existing one,
> @@ -152,6 +158,7 @@ struct opt_params {
>  		uint64_t	maxval;
>  		uint64_t	flagval;
>  		const char	*raw_input;
> +		uint64_t	value;
>  	}		subopt_params[MAX_SUBOPTS];
>  } opts[MAX_OPTS] = {
>  #define OPT_B	0

It would seem rather unfair to define this this but not use it in the patch ?

  Luis
