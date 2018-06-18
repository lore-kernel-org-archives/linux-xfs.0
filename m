Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935857AbeFRTLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 15:11:49 -0400
Date: Mon, 18 Jun 2018 12:11:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] common/xfs: Add _scratch_get_sfdir_prefix function
Message-ID: <20180618191133.GG8128@magnolia>
References: <20180618174433.3069-1-mbenatto@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618174433.3069-1-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco Benatto <mbenatto@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@redhat.com

On Mon, Jun 18, 2018 at 02:44:32PM -0300, Marco Benatto wrote:
> Move get_sfdir_prefix function from xfs/278 to commom/xfs
> and rename it to _scratch_get_sfdir_prefix so it can be
> used in other xfs tests.
> 
> This commit also changes xfs/278 to make use of
> _scratch_get_sfdir_prefix instead previous one.
> 
> Signed-off-by: Marco Benatto <mbenatto@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  common/xfs    | 15 +++++++++++++++
>  tests/xfs/278 | 16 +---------------
>  2 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 55cfa94..ecf54bb 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -760,3 +760,18 @@ _require_xfs_spaceman_command()
>  			_notrun "xfs_spaceman $command doesn't support $param"
>  	fi
>  }
> +
> +_scratch_get_sfdir_prefix() {
> +	local dir_ino="$1"
> +
> +	for prefix in "u.sfdir3" "u.sfdir2" "u3.sfdir3"; do
> +		if [ -n "$(_scratch_xfs_get_metadata_field \
> +				"${prefix}.hdr.parent.i4" \
> +				"inode ${dir_ino}")" ]; then
> +			echo "${prefix}"
> +			return 0
> +		fi
> +	done
> +	_scratch_xfs_db -c "inode ${dir_ino}" -c 'p' >> $seqres.full
> +	return 1
> +}
> diff --git a/tests/xfs/278 b/tests/xfs/278
> index 3d2a846..c208e61 100755
> --- a/tests/xfs/278
> +++ b/tests/xfs/278
> @@ -46,25 +46,11 @@ _scratch_unmount
>  
>  echo "Silence is goodness..."
>  
> -get_sfdir_prefix() {
> -	local dir_ino="$1"
> -
> -	for prefix in "u.sfdir3" "u.sfdir2" "u3.sfdir3"; do
> -		if [ -n "$(_scratch_xfs_get_metadata_field \
> -				"${prefix}.hdr.parent.i4" \
> -				"inode ${dir_ino}")" ]; then
> -			echo "${prefix}"
> -			return 0
> -		fi
> -	done
> -	_scratch_xfs_db -c "inode ${dir_ino}" -c 'p' >> $seqres.full
> -	return 1
> -}
>  set_ifield() {
>  	_scratch_xfs_set_metadata_field "$1" 0 "inode $2" >> $seqres.full
>  }
>  
> -sfdir_prefix="$(get_sfdir_prefix "$DIR_INO" || \
> +sfdir_prefix="$(_scratch_get_sfdir_prefix "$DIR_INO" || \
>  	_fail "Cannot determine sfdir prefix")"
>  
>  # Corrupt DIR
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
