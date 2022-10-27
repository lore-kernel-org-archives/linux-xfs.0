Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910F0FA3746
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 16:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbiJ0Q71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 12:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbiJ0Q70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 12:59:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2169D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 09:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666889964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZPtu0bdAfAnjR37WZNZzRhWNywto4mM7TZLRvnepYk=;
        b=Vzoxf/QUHKLa0wSMvV7ZbPb2F9v81OVmLmMLI2RJa2BH7M37iDWZYwz+R8dIpvtX8t2MEx
        AfLj/9Mm4si4FoKVgrS0FUty68BIf11l02/hV7GACPEXeQIzg1sf5fQUY7GEHGFo7ky3RE
        bVlYABEvLQAHy5bvY1BK3Jf86u+3Jd4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-463-K9Csa0HNNweJniVRv8QfEA-1; Thu, 27 Oct 2022 12:59:23 -0400
X-MC-Unique: K9Csa0HNNweJniVRv8QfEA-1
Received: by mail-qv1-f70.google.com with SMTP id g1-20020ad45101000000b004bb5eb9913fso1294905qvp.16
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 09:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZPtu0bdAfAnjR37WZNZzRhWNywto4mM7TZLRvnepYk=;
        b=q6Azt52qsOsrpj4NyOnm7axSlgNWqnq+J+V2k4xC9gKosdYhs2oByHb9a5WCyLTAbb
         E3XJ8gNqy03pV2I2jN/ExPBDD/CNi86Q2qKfDnwkvlZDpx5qTcyBU4tPTZv8m+7s5paw
         eGNQ4dZTQIVp1WwxliecnZjJFzIwuxwDorh3e8zGy+M3QZGZVm5n3SRs2p+wpKTKQ3nM
         0Ggly7u1Yk/gfoyEZyl4vDrhAofJEMUObBF2xyYAdnxh0lOLbo42wpoibTUxK5SZ65fB
         9dgZ0XB5wTm5mSG4uxhiX1lT2jCJT1LwGq0lju1egL66NrVdk59SUahYQZ6tPXn8nxfw
         vM9g==
X-Gm-Message-State: ACrzQf3MaDMJJAAlIycH6DGIS2pDpdTQykoYRGnTx5bSfIS0xdqOAuMx
        gPjdqRY8ufebAOro0BYYiAYPx7U9R26TAhRa5im+hfgWk/lTrCmn334NU5HMBsd6z/0Qi8JMRU0
        pP5eroLVz2YzODofQ0RZg
X-Received: by 2002:ac8:4e33:0:b0:39c:f34b:2eee with SMTP id d19-20020ac84e33000000b0039cf34b2eeemr41058374qtw.283.1666889962362;
        Thu, 27 Oct 2022 09:59:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6tVDHdcGnvcLW+qAm2MChREv6BFxlXr43MRSEMB+M3Z9Dj94Sci7jwuBXctXx4U+6SYXYUCw==
X-Received: by 2002:ac8:4e33:0:b0:39c:f34b:2eee with SMTP id d19-20020ac84e33000000b0039cf34b2eeemr41058352qtw.283.1666889962065;
        Thu, 27 Oct 2022 09:59:22 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u30-20020a37ab1e000000b006f9fee855f2sm820562qke.67.2022.10.27.09.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 09:59:21 -0700 (PDT)
Date:   Fri, 28 Oct 2022 00:59:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor filesystem directory block size
 extraction logic
Message-ID: <20221027165916.4ttwfx7g66pznsrt@zlang-mailbox>
References: <166681099421.3403789.78493769502226810.stgit@magnolia>
 <166681100562.3403789.14498721397451474651.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166681100562.3403789.14498721397451474651.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 12:03:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a lot of places where we open-code determining the directory
> block size for a specific filesystem.  Refactor this into a single
> helper to clean up existing tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hmm... sorry I failed to merge this patchset:

$ git am ./20221026_djwong_fstests_refactor_xfs_geometry_computation.mbx
Applying: xfs: refactor filesystem feature detection logic
Applying: xfs: refactor filesystem directory block size extraction logic
error: sha1 information is lacking or useless (common/xfs).
error: could not build fake ancestor
Patch failed at 0002 xfs: refactor filesystem directory block size extraction logic
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

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

