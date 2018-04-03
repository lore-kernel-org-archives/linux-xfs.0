Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55112 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbeDCRt5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 13:49:57 -0400
Subject: Re: [PATCH 02/14] xfs_scrub: only run ascii name checks if unicode
 name checker
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160359247.8288.11181593031135733955.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0bff333c-4688-b65d-f435-fde753a0d831@sandeen.net>
Date: Tue, 3 Apr 2018 12:49:56 -0500
MIME-Version: 1.0
In-Reply-To: <152160359247.8288.11181593031135733955.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/20/18 10:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Skip the ASCII name checks if the Unicode name checker is going to run,
> since the latter covers everything that the former does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems fine.  Since you already have some layers of wrappers it might
be nice to just call i.e. xfs_scrub_check_xattr_name(uc, ctx, descr, keybuf)
and let it sort out the uc / not-uc cases, but unless you're super
excited about that idea, this is fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  scrub/phase5.c |   24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 36821d0..decda02 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -113,11 +113,11 @@ xfs_scrub_scan_dirents(
>  
>  	dentry = readdir(dir);
>  	while (dentry) {
> -		moveon = xfs_scrub_check_name(ctx, descr, _("directory"),
> -				dentry->d_name);
> -		if (!moveon)
> -			break;
> -		moveon = unicrash_check_dir_name(uc, descr, dentry);
> +		if (uc)
> +			moveon = unicrash_check_dir_name(uc, descr, dentry);
> +		else
> +			moveon = xfs_scrub_check_name(ctx, descr,
> +					_("directory"), dentry->d_name);
>  		if (!moveon)
>  			break;
>  		dentry = readdir(dir);
> @@ -163,7 +163,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
>  	char				keybuf[ATTR_NAME_MAX + 1];
>  	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
>  	struct attrlist_ent		*ent;
> -	struct unicrash			*uc;
> +	struct unicrash			*uc = NULL;
>  	bool				moveon = true;
>  	int				i;
>  	int				error;
> @@ -183,11 +183,13 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
>  			ent = ATTR_ENTRY(attrlist, i);
>  			snprintf(keybuf, ATTR_NAME_MAX, "%s.%s", attr_ns->name,
>  					ent->a_name);
> -			moveon = xfs_scrub_check_name(ctx, descr,
> -					_("extended attribute"), keybuf);
> -			if (!moveon)
> -				goto out;
> -			moveon = unicrash_check_xattr_name(uc, descr, keybuf);
> +			if (uc)
> +				moveon = unicrash_check_xattr_name(uc, descr,
> +						keybuf);
> +			else
> +				moveon = xfs_scrub_check_name(ctx, descr,
> +						_("extended attribute"),
> +						keybuf);
>  			if (!moveon)
>  				goto out;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
