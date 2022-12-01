Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F117AC43217
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 15:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiLAPwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 10:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiLAPwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 10:52:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAA417A9A;
        Thu,  1 Dec 2022 07:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5E04B81F0A;
        Thu,  1 Dec 2022 15:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8828DC433D6;
        Thu,  1 Dec 2022 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669909964;
        bh=N69NN84jKEfRgJKvcS8eNJmNLvnfZdUZo3vvMogW0ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0g4ot8fLIxe9BPyr7iMRUZYCqckdaRaKqWQ83qvfwRMk5fa0jf2nR+iQVd7nDjAY
         wqDS/mhk0BEJsNzqmOTMSGPqTPcRYzS+g4jP290chnY+pOIjdNPrHjmgSloDb0pgKH
         jyFVJb8XnZZZkv6okvsC+34soh/R9iOjY9DlcepaMZDfouTmeRjpLU8JuHaftVX9oK
         Jb+iSok9RGp93NP6qbaN8mYcRCREoX/2GUKJml4sZmUnqExIIn5GlFNRV8lackLfaY
         ojfAfTiKzfJYcQwFjlvETRM2EfPBc0IG3p+CSuang9ezuSwOqEvNXUguuwxhTXuA7T
         4ls1q4fiyGHgA==
Date:   Thu, 1 Dec 2022 07:52:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in
 btree format
Message-ID: <Y4jNzE5YJ3wFtsaz@magnolia>
References: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2022 at 04:12:08PM +0800, Gao Xiang wrote:
> Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> 
> Actually we just observed it can fail after apply our inode
> extent-to-btree workaround. The root cause is that the kernel may be
> too good at allocating consecutive blocks so that the data fork is
> still in extents format.
> 
> Therefore instead of using a fixed number, let's make sure the number
> of extents is large enough than (inode size - inode core size) /
> sizeof(xfs_bmbt_rec_t).
> 
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>  common/populate | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/common/populate b/common/populate
> index 6e004997..e179a300 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -71,6 +71,25 @@ __populate_create_dir() {
>  	done
>  }
>  
> +# Create a large directory and ensure that it's a btree format
> +__populate_create_btree_dir() {

Since this encodes behavior specific to xfs, this ought to be called

__populate_xfs_create_btree_dir

or something like that.

> +	name="$1"
> +	isize="$2"

These ought to be local variables, e.g.

	local name="$1"
	local isize="$2"

So that they don't pollute the global name scope.  Yay bash.

> +
> +	mkdir -p "${name}"
> +	d=0
> +	while true; do
> +		creat=mkdir
> +		test "$((d % 20))" -eq 0 && creat=touch
> +		$creat "${name}/$(printf "%.08d" "$d")"
> +		if [ "$((d % 40))" -eq 0 ]; then
> +			nexts="$($XFS_IO_PROG -c "stat" $name | grep 'fsxattr.nextents' | sed -e 's/^.*nextents = //g' -e 's/\([0-9]*\).*$/\1/g')"

_xfs_get_fsxattr...

> +			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break

Only need to calculate this once if you declare this at the top:

	# We need enough extents to guarantee that the data fork is in
	# btree format.  Cycling the mount to use xfs_db is too slow, so
	# watch for when the extent count exceeds the space after the
	# inode core.
	local max_nextents="$(((isize - 176) / 16))"

and then you can do:

			[[ $nexts -gt $max_nextents ]] && break

Also not a fan of hardcoding 176 around fstests, but I don't know how
we'd detect that at all.

# Number of bytes reserved for only the inode record, excluding the
# immediate fork areas.
_xfs_inode_core_bytes()
{
	echo 176
}

I guess?  Or extract it from tests/xfs/122.out?

> +		fi
> +		d=$((d+1))
> +	done
> +}
> +
>  # Add a bunch of attrs to a file
>  __populate_create_attr() {
>  	name="$1"
> @@ -176,6 +195,7 @@ _scratch_xfs_populate() {
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> +	isize="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep meta-data=.*isize | sed -e 's/^.*isize=//g' -e 's/\([0-9]*\).*$/\1/g')"

Please hoist this to common/xfs:

# Number of bytes reserved for a full inode record, which includes the
# immediate fork areas.
_xfs_inode_size()
{
	local mntpoint="$1"

	$XFS_INFO_PROG "$mountpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')"
}

Otherwise this looks reasonable.

--D

>  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>  	if [ $crc -eq 1 ]; then
>  		leaf_hdr_size=64
> @@ -226,7 +246,7 @@ _scratch_xfs_populate() {
>  
>  	# - BTREE
>  	echo "+ btree dir"
> -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> +	__populate_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"
>  
>  	# Symlinks
>  	# - FMT_LOCAL
> -- 
> 2.24.4
> 
