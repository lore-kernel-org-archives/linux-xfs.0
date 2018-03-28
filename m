Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeC1MNX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 08:13:23 -0400
Date: Wed, 28 Mar 2018 08:13:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs/278: find sfdir inode field prefix
Message-ID: <20180328121321.GB37735@bfoster.bfoster>
References: <152182406249.14523.2186010254497227366.stgit@magnolia>
 <152182408764.14523.16193613645363841396.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152182408764.14523.16193613645363841396.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@linux.alibaba.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Mar 23, 2018 at 09:54:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the xfs set/get metadata field helpers to detect the correct sfdir
> field name prefix on v4-v5 filesystems.  This enables us to test inode
> link count corrections on a (deliberately) disconnected directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/278 |   38 ++++++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/tests/xfs/278 b/tests/xfs/278
> index b94ee9c..47012a3 100755
> --- a/tests/xfs/278
> +++ b/tests/xfs/278
> @@ -61,17 +61,39 @@ _scratch_unmount
>  
>  echo "Silence is goodness..."
>  
> +get_sfdir_prefix() {
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
> +set_ifield() {
> +	_scratch_xfs_set_metadata_field "$1" 0 "inode $2" >> $seqres.full
> +}

[zero|clear|reset]_ifield() might be more clear, but otherwise looks
fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +sfdir_prefix="$(get_sfdir_prefix "$DIR_INO" || \
> +	_fail "Cannot determine sfdir prefix")"
> +
>  # Corrupt DIR
> -_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0"  >> $seqres.full
> -_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0"  >> $seqres.full
> -_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0"  >> $seqres.full
> -_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0"  >> $seqres.full
> -_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0"  >> $seqres.full
> -_scratch_xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0"  >> $seqres.full
> +
> +set_ifield "${sfdir_prefix}.list[0].inumber.i4" "$DIR_INO"
> +set_ifield "${sfdir_prefix}.list[0].name" "$DIR_INO"
> +set_ifield "${sfdir_prefix}.list[0].offset" "$DIR_INO"
> +set_ifield "${sfdir_prefix}.list[0].namelen" "$DIR_INO"
> +set_ifield "${sfdir_prefix}.hdr.parent.i4" "$DIR_INO"
> +set_ifield "core.nlinkv2" "$DIR_INO"
>  
>  # Corrupt SUBDIR
> -_scratch_xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0"  >> $seqres.full
> -_scratch_xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0"  >> $seqres.full
> +set_ifield "${sfdir_prefix}.hdr.parent.i4" "$SUBDIR_INO"
> +set_ifield "core.nlinkv2" "$SUBDIR_INO"
>  
>  echo "===== BEGIN of xfs_repair =====" >> $seqres.full
>  echo "" >>$seqres.full
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
