Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43744 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdFUWVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 18:21:05 -0400
Date: Wed, 21 Jun 2017 15:20:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: new libxfs-apply option for Signed-off-by: tag
Message-ID: <20170621222059.GT4733@birch.djwong.org>
References: <09b8530a-6b35-bc05-130e-6dfd35889f2b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09b8530a-6b35-bc05-130e-6dfd35889f2b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, May 11, 2017 at 02:35:43PM -0500, Eric Sandeen wrote:
> Technically when a maintainer moves a patch from another project,
> they should add their Signed-off-by: tag.  Add an option to
> libxfs-apply to make that easy when cross-porting libxfs
> patches.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index e7d7e0a..b594ccb 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -8,7 +8,7 @@ usage()
>  	echo $*
>  	echo
>  	echo "Usage:"
> -	echo "	libxfs-apply [--verbose] --source <repodir> --commit <commit_id>"
> +	echo "	libxfs-apply [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
>  	echo "	libxfs-apply --patch <patchfile>"
>  	echo
>  	echo "libxfs-apply should be run in the destination git repository."
> @@ -73,6 +73,7 @@ while [ $# -gt 0 ]; do
>  	--source)	REPO=$2 ; shift ;;
>  	--patch)	PATCH=$2; shift ;;
>  	--commit)	COMMIT_ID=$2 ; shift ;;
> +	--sob)		SIGNED_OFF_BY=$2 ; shift ;;

I wonder, under what circumstances does the user /not/ want to have
their S-o-b added to the commit?  It seems to me that this ought to be
the default, since the $maintainer is importing code from another
libxfs, which (to me anyway) doesn't seem all that different from
pulling in regular patches from the mailing list or wherever.

Second, can we just pull the name and email from the output of git
config --get user.{name,email} unless the user explicitly provided a sob
line?

>  	--verbose)	VERBOSE=true ;;
>  	*)		usage ;;
>  	esac
> @@ -274,6 +275,14 @@ fixup_header_format()
>  			print $0
>  		}' > $_hdr.new
>  
> +	# Remove the last line if it contains only whitespace
> +	sed -i '${/^ *$/d;}' $_hdr.new
> +
> +	# Add Signed-off-by: header if specified
> +	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
> +		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
> +	fi

Third, we could detect that the patch already has the particular S-o-b
that we'd be adding here, and avoid adding a duplicate.

--D

> +
>  	# now output the new patch
>  	cat $_hdr.new $_diff
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
