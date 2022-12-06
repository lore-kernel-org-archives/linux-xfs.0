Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430B2C352A1
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 17:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiLFR35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 12:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiLFR34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 12:29:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273B132064;
        Tue,  6 Dec 2022 09:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E19617E3;
        Tue,  6 Dec 2022 17:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1764FC433C1;
        Tue,  6 Dec 2022 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670347795;
        bh=ZPgd/wxE7HeJh6snrWE+aeZsC9INsvn4dtVjHdPyINo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SjaU2FS4kPh606M1YYtxULhp2rOt6Su5rNwkBoFXhLnTEG0bG7XbWQPHNzhTlQXBr
         owTbqzrE1kP+fY8gkl135y1tCXHS6+prBcexjOxMOZJMmbQCEmwBg+DzzX+j7aMiZm
         X2Gp/LBChxsj8AfUUaYLUJkt0B2kDuhXN104kguWtpmaY/XAHKb4c0uAXAVddZkF9z
         rd+xX1FWReZFgudhddlcI4XND5D5537SZRDGyssahjNxJhToZuPSFDPUlPCV03C9Ga
         dfY+7cmHCqfyoooGtG49oqnflDbUBjWNbPOnDzUj1c6ueiGoRUD2xcE/4ZVQL0UY6O
         0jf5i4efSTWCA==
Date:   Tue, 6 Dec 2022 09:29:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com, allison.henderson@oracle.com
Subject: Re: [PATCH V3 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <Y498Ej35Bf9Oi6Wx@magnolia>
References: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
 <20221206100517.1369625-3-ZiyangZhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206100517.1369625-3-ZiyangZhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2022 at 06:05:17PM +0800, Ziyang Zhang wrote:
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
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> ---
>  common/populate | 28 +++++++++++++++++++++++++++-
>  common/xfs      |  9 +++++++++
>  2 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/common/populate b/common/populate
> index 6e004997..1ca76459 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -71,6 +71,31 @@ __populate_create_dir() {
>  	done
>  }
>  
> +# Create a large directory and ensure that it's a btree format
> +__populate_xfs_create_btree_dir() {
> +	local name="$1"
> +	local isize="$2"
> +	local icore_size="$(_xfs_inode_core_bytes)"
> +	# We need enough extents to guarantee that the data fork is in
> +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> +	# watch for when the extent count exceeds the space after the
> +	# inode core.
> +	local max_nextents="$(((isize - icore_size) / 16))"
> +
> +	mkdir -p "${name}"
> +	d=0
> +	while true; do
> +		creat=mkdir
> +		test "$((d % 20))" -eq 0 && creat=touch
> +		$creat "${name}/$(printf "%.08d" "$d")"
> +		if [ "$((d % 40))" -eq 0 ]; then
> +			nextents="$(_xfs_get_fsxattr nextents $name)"
> +			[ $nextents -gt $max_nextents ] && break
> +		fi
> +		d=$((d+1))
> +	done
> +}
> +
>  # Add a bunch of attrs to a file
>  __populate_create_attr() {
>  	name="$1"
> @@ -176,6 +201,7 @@ _scratch_xfs_populate() {
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> +	isize="$(_xfs_inode_size "$SCRATCH_MNT")"
>  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>  	if [ $crc -eq 1 ]; then
>  		leaf_hdr_size=64
> @@ -226,7 +252,7 @@ _scratch_xfs_populate() {
>  
>  	# - BTREE
>  	echo "+ btree dir"
> -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"

The new helper function omits the "missing" parameter, which means that
it no longer creates the directory entry blocks with a lot of free space
in them, unlike current TOT.

--D

>  
>  	# Symlinks
>  	# - FMT_LOCAL
> diff --git a/common/xfs b/common/xfs
> index 5180b9d3..744f0040 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
>  			_notrun 'xfsrestore does not support -x flag.'
>  }
>  
> +# Number of bytes reserved for a full inode record, which includes the
> +# immediate fork areas.
> +_xfs_inode_size()
> +{
> +	local mntpoint="$1"
> +
> +	$XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g'
> +}
> +
>  # Number of bytes reserved for only the inode record, excluding the
>  # immediate fork areas.
>  _xfs_inode_core_bytes()
> -- 
> 2.18.4
> 
