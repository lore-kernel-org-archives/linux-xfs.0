Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01375C10F1E
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 16:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLIQho (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 11:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLIQhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 11:37:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E7363CB;
        Fri,  9 Dec 2022 08:37:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98CD462086;
        Fri,  9 Dec 2022 16:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0A0C433D2;
        Fri,  9 Dec 2022 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670603862;
        bh=smMrJqewc25T3hIhHjn4GyGcB83IzCz5LNVh5ACbXKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDiVfSp8F4RjwIS96HmtyBz2TGj/iEIHUttErzaXVb3AJIOVRWoJ6SoVV69wC0ufA
         hhwfq5WgeDoI41ARbAVvIritt6uPKbFkQKuueNIUZKCu60SIYNiq2ZlAo/a7vdVxB+
         VNCXNk8HSZ27loqvASXgy+nN4+ZHTNKAxsg7zEuln4WGVCGNLBkeHWvN6DTy8EROKl
         rTdh5QYrB25121GudWYjJcSoKLEUvRbBJaObp+46wpoIA6fAOCdrTcqAXjs/HN1Bw/
         FUxA7wVpTuQzi16jsHvRoKis5mVUa8bp3fGmdw/+ttOYP+bthviDiVRcWuSRs0nc/9
         nYlZHTDmEsXzw==
Date:   Fri, 9 Dec 2022 08:37:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        zlang@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com,
        allison.henderson@oracle.com
Subject: Re: [PATCH V5 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <Y5NkVRNhQgZpWNMj@magnolia>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
 <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 08, 2022 at 03:28:43PM +0800, Ziyang Zhang wrote:
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
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> ---
>  common/populate | 34 +++++++++++++++++++++++++++++++++-
>  common/xfs      |  9 +++++++++
>  2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/common/populate b/common/populate
> index 6e004997..0d334a13 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -71,6 +71,37 @@ __populate_create_dir() {
>  	done
>  }
>  
> +# Create a large directory and ensure that it's a btree format
> +__populate_xfs_create_btree_dir() {
> +	local name="$1"
> +	local isize="$2"
> +	local missing="$3"
> +	local icore_size="$(_xfs_inode_core_bytes)"

Doesn't this helper require a path argument now?

--D

> +	# We need enough extents to guarantee that the data fork is in
> +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> +	# watch for when the extent count exceeds the space after the
> +	# inode core.
> +	local max_nextents="$(((isize - icore_size) / 16))"
> +	local nr=0
> +
> +	mkdir -p "${name}"
> +	while true; do
> +		local creat=mkdir
> +		test "$((nr % 20))" -eq 0 && creat=touch
> +		$creat "${name}/$(printf "%.08d" "$nr")"
> +		if [ "$((nr % 40))" -eq 0 ]; then
> +			local nextents="$(_xfs_get_fsxattr nextents $name)"
> +			[ $nextents -gt $max_nextents ] && break
> +		fi
> +		nr=$((nr+1))
> +	done
> +
> +	test -z "${missing}" && return
> +	seq 1 2 "${nr}" | while read d; do
> +		rm -rf "${name}/$(printf "%.08d" "$d")"
> +	done
> +}
> +
>  # Add a bunch of attrs to a file
>  __populate_create_attr() {
>  	name="$1"
> @@ -176,6 +207,7 @@ _scratch_xfs_populate() {
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> +	isize="$(_xfs_get_inode_size "$SCRATCH_MNT")"
>  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>  	if [ $crc -eq 1 ]; then
>  		leaf_hdr_size=64
> @@ -226,7 +258,7 @@ _scratch_xfs_populate() {
>  
>  	# - BTREE
>  	echo "+ btree dir"
> -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
>  
>  	# Symlinks
>  	# - FMT_LOCAL
> diff --git a/common/xfs b/common/xfs
> index 674384a9..7aaa63c7 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
>  			_notrun 'xfsrestore does not support -x flag.'
>  }
>  
> +# Number of bytes reserved for a full inode record, which includes the
> +# immediate fork areas.
> +_xfs_get_inode_size()
> +{
> +	local mntpoint="$1"
> +
> +	$XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'
> +}
> +
>  # Number of bytes reserved for only the inode record, excluding the
>  # immediate fork areas.
>  _xfs_get_inode_core_bytes()
> -- 
> 2.18.4
> 
