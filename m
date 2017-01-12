Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbdALTIa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 14:08:30 -0500
Date: Thu, 12 Jan 2017 13:08:22 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 3/3] libxfs-apply: minor improvements
Message-ID: <20170112190822.GA27976@redhat.com>
References: <056383cb-cf7e-3880-aecf-d97d5516a60f@sandeen.net>
 <7f6aba51-3b6d-0ba2-57b8-344bc7fc32b7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f6aba51-3b6d-0ba2-57b8-344bc7fc32b7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 12, 2017 at 11:15:52AM -0600, Eric Sandeen wrote:
> Three quick improvements to libxfs-apply:
> 
> - Skip already-cross-merged commits, based on the
>   "Source XXX commit" line in the commitlog.
> 
> - Be clearer about which patch failed if it does
> 
> - Clean up guilt better after a failed application
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  tools/libxfs-apply | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 5cf0879..e7d7e0a 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -288,6 +288,7 @@ apply_patch()
>  	local _current_commit=$3
>  	local _new_patch=`mktemp`
>  	local _source="kernel"
> +	local _target="xfsprogs"
>  
>  	# filter just the libxfs parts of the patch
>  	if [ $SOURCE == "xfsprogs" ]; then
> @@ -301,6 +302,7 @@ apply_patch()
>  
>  		filter_kernel_patch $_patch > $_new_patch
>  		_source="xfsprogs"
> +		_target="kernel"
>  	elif [ $SOURCE == "kernel" ]; then
>  
>  		[ -n "$VERBOSE" ] || lsdiff $_patch | grep -q "[ab]/fs/xfs/libxfs/"
> @@ -315,6 +317,13 @@ apply_patch()
>  		fail "Unknown source repo type: $SOURCE"
>  	fi
>  
> +	grep -q "Source $_target commit: " $_patch
> +	if [ "$?" -eq "0" ]; then
> +		echo "$_patch_name already synced up"
> +		echo "$_skipping commit $_current_commit"
> +		return
> +	fi
> +
>  	# now munge the header to be in the correct format.
>  	fixup_header_format $_source $_new_patch > $_new_patch.2
>  
> @@ -338,14 +347,15 @@ apply_patch()
>  		if [ $? -eq 0 ]; then
>  			guilt refresh
>  		else
> -			echo "Guilt push failed!"
> +			echo "Guilt push of $_current_commit $_patch_name failed!"
>  			read -r -p "Skip or Fail [s|F]? " response
>  			if [ -z "$response" -o "$response" != "s" ]; then
>  				echo "Force push patch, fix and refresh."
>  				echo "Restart from commit $_current_commit"
>  				fail "Manual cleanup required!"
>  			else
> -				echo "Skipping. Manual series file cleanup needed!"
> +				echo "Skipping."
> +				guilt delete -f $_patch_name
>  			fi
>  		fi
>  	elif [ $STGIT -eq 1 ]; then
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
