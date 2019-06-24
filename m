Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFXRaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:30:17 -0400
Date: Mon, 24 Jun 2019 10:29:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/10] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190624172943.GV5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134510851.2519.2387740442257250106.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134510851.2519.2387740442257250106.stgit@fedora-28>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Jun 24, 2019 at 10:58:30AM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so
> the options that have values like "10k" etc. still need to
> be converted by the fs.

/me wonders if that ought to be lifted to fs_parser.c, or is xfs the
only filesystem that has mount options with unit suffixes?

--D

> But the value comes to the fs as a string (not a substring_t
> type) so there's a need to change the conversion function to
> take a character string instead.
> 
> After switching to use the new mount-api match_kstrtoint()
> will no longer be called and will be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ab8145bf6fff..14c2a775786c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -166,13 +166,13 @@ static const struct fs_parameter_description xfs_fs_parameters = {
>  };
>  
>  STATIC int
> -suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +suffix_kstrtoint(const char *s, unsigned int base, int *res)
>  {
>  	int	last, shift_left_factor = 0, _res;
>  	char	*value;
>  	int	ret = 0;
>  
> -	value = match_strdup(s);
> +	value = kstrdup(s, GFP_KERNEL);
>  	if (!value)
>  		return -ENOMEM;
>  
> @@ -197,6 +197,20 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> +STATIC int
> +match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +{
> +	const char	*value;
> +	int ret;
> +
> +	value = match_strdup(s);
> +	if (!value)
> +		return -ENOMEM;
> +	ret = suffix_kstrtoint(value, base, res);
> +	kfree(value);
> +	return ret;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -268,7 +282,7 @@ xfs_parseargs(
>  				return -EINVAL;
>  			break;
>  		case Opt_logbsize:
> -			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
> +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
>  				return -EINVAL;
>  			break;
>  		case Opt_logdev:
> @@ -285,7 +299,7 @@ xfs_parseargs(
>  			break;
>  		case Opt_allocsize:
>  		case Opt_biosize:
> -			if (suffix_kstrtoint(args, 10, &iosize))
> +			if (match_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
>  			break;
> 
