Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941421AbdDYF1X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 01:27:23 -0400
Date: Tue, 25 Apr 2017 07:27:21 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 08/12] mkfs: replace variables with opts table: -b,d,s
 options
Message-ID: <20170425052721.GL28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-9-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423185503.31415-9-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 23, 2017 at 08:54:59PM +0200, Jan Tulak wrote:
> Remove variables that can be replaced with a direct access to the opts table,
> so we have it all in a single place, acessible from anywhere.
> 
> In future, we can remove some passing of values forth and back, but now limit
> the changes to simple replacement without a change in the logic.

What do you mean passing of values here, as an example with bopts ?

> This is first of multiple similar patches that do the same, but for other
> options.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 814 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 503 insertions(+), 311 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 362c9b4..6857c30 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1485,15 +1480,12 @@ main(
>  	int			argc,
>  	char			**argv)
>  {
> -	uint64_t		agcount;
>  	xfs_agf_t		*agf;
>  	xfs_agi_t		*agi;
>  	xfs_agnumber_t		agno;
> -	uint64_t		agsize;
>  	xfs_alloc_rec_t		*arec;
>  	struct xfs_btree_block	*block;
>  	bool			blflag;

Note: blflag

> -	uint64_t		blocklog;
>  	bool			bsflag;

Note: bsflag

>  	memset(&fsx, 0, sizeof(fsx));
> @@ -1629,6 +1613,7 @@ main(
>  			break;
>  		case 'b':
>  			p = optarg;
> +			uint64_t tmp;
>  			while (*p != '\0') {
>  				char	**subopts =
>  						(char **)opts[OPT_B].subopts;
> @@ -1636,19 +1621,17 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case B_LOG:
> -					blocklog = parse_conf_val(OPT_B, B_LOG,
> -								  value);
> -					blocksize = 1 << blocklog;
> +					tmp = parse_conf_val(OPT_B, B_LOG,
> +							     value);
> +					set_conf_val(OPT_B, B_SIZE, 1 << tmp);
>  					blflag = 1;

This is a collateral variable set when blog is set. If we have to parse the
blog again, it means similar code would be needed.

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
>  					bsflag = 1;

Likewise for bsflag.

> -					set_conf_val(OPT_B, B_LOG, blocklog);
>  					break;
>  				default:
>  					unknown('b', value);

What I'm questioning is whether or not it makes sense instead for parse_conf_val()
to return void and do all this meddling for us, this would require stuffing any
collateral variables into a struct and passing that to parse_conf_val and using
it on main() as well.

  Luis
