Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23A4C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 06:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJTGH6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 02:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJTGH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 02:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB4240038;
        Wed, 19 Oct 2022 23:07:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7834561A02;
        Thu, 20 Oct 2022 06:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C957C433C1;
        Thu, 20 Oct 2022 06:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666246074;
        bh=N3ElL5IotkayQRhqZLFWwXb9ucGkZuUgO1XJXiW9ELM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVZpoNc+5lnhs5HHNRBji3kvJgGmAIKmTGl+Oc0jFl62slUA+eXS/8wuPka/2l3aq
         SXA+1HRzSgPIhNdfkIuy/vw0m6+enlPktOOSW27OiOkc3v/FKRiEcTDoWpNgJ5Ly2M
         9gD7RJim5KQdkH7zAIIn6mTpwRCp8EpbAlt8bsfgFJzJIE0nQli5pooCp6JgxERNoW
         M/QoErifJKYBgTZx1mHM5DrceZMc7s0FWyBCgKHJwBhe0HcukXmclpWcY44kSCjHUZ
         PZfxh81rSuBUmhajOI4fDRZ6+yVUTIOmE4ESJlW2SkafthNFy58jn67MhRskY49Ayy
         chEi9WJ9liWmw==
Date:   Thu, 20 Oct 2022 14:07:50 +0800
From:   Zorro Lang <zlang@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: refactor filesystem directory block size
 extraction logic
Message-ID: <20221020060750.p3flgosbvel66kxc@zlang-mailbox>
References: <166613312194.868141.5162859918517610030.stgit@magnolia>
 <166613313311.868141.4422818901647278371.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166613313311.868141.4422818901647278371.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2022 at 03:45:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a lot of places where we open-code determining the directory
> block size for a specific filesystem.  Refactor this into a single
> helper to clean up existing tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |    4 ++--
>  common/xfs      |    9 +++++++++
>  tests/xfs/099   |    2 +-
>  tests/xfs/100   |    2 +-
>  tests/xfs/101   |    2 +-
>  tests/xfs/102   |    2 +-
>  tests/xfs/105   |    2 +-
>  tests/xfs/112   |    2 +-
>  tests/xfs/113   |    2 +-
>  9 files changed, 18 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 9fa1a06798..23b2fecf69 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -175,7 +175,7 @@ _scratch_xfs_populate() {
>  	_xfs_force_bdev data $SCRATCH_MNT
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
>  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>  	if [ $crc -eq 1 ]; then
>  		leaf_hdr_size=64
> @@ -602,7 +602,7 @@ _scratch_xfs_populate_check() {
>  	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
>  	leaf_lblk="$((32 * 1073741824 / blksz))"
>  	node_lblk="$((64 * 1073741824 / blksz))"
>  	umount "${SCRATCH_MNT}"
> diff --git a/common/xfs b/common/xfs
> index c7496bce3f..6445bfd9db 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -203,6 +203,15 @@ _xfs_is_realtime_file()
>  	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
>  }
>  
> +# Get the directory block size of a mounted filesystem.
> +_xfs_get_dir_blocksize()
> +{
> +	local fs="$1"
> +
> +	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
> +		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'

As you've used escape char of sed, I think it doesn't need two pipe lines
and two sed commands, how about:

	$XFS_INFO_PROG "$fs" | sed -n "s/^naming.*bsize=\([[:digit:]]*\).*/\1/p"

Others looks good to me.

Thanks,
Zorro

> +}
> +
>  # Set or clear the realtime status of every supplied path.  The first argument
>  # is either 'data' or 'realtime'.  All other arguments should be paths to
>  # existing directories or empty regular files.
> diff --git a/tests/xfs/099 b/tests/xfs/099
> index a7eaff6e0c..82bef8ad26 100755
> --- a/tests/xfs/099
> +++ b/tests/xfs/099
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/100 b/tests/xfs/100
> index 79da8cb02c..e638b4ba17 100755
> --- a/tests/xfs/100
> +++ b/tests/xfs/100
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((dblksz / 12))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/101 b/tests/xfs/101
> index 64f4705aca..11ed329110 100755
> --- a/tests/xfs/101
> +++ b/tests/xfs/101
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((dblksz / 12))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/102 b/tests/xfs/102
> index 24dce43058..43f4539181 100755
> --- a/tests/xfs/102
> +++ b/tests/xfs/102
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((16 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/105 b/tests/xfs/105
> index 22a8bf9fb0..002a712883 100755
> --- a/tests/xfs/105
> +++ b/tests/xfs/105
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((16 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/112 b/tests/xfs/112
> index bc1ab62895..e2d5932da6 100755
> --- a/tests/xfs/112
> +++ b/tests/xfs/112
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((16 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/113 b/tests/xfs/113
> index e820ed96da..9bb2cd304b 100755
> --- a/tests/xfs/113
> +++ b/tests/xfs/113
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((128 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> 
