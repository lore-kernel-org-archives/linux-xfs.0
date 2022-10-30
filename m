Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0A5FA3743
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 03:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJ3DaL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 23:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ3DaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 23:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84646859
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 20:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667100549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BF+JrY8YdtTEJujRzdlRAbzKK1KcUUNxwiz/HAD9FxU=;
        b=g/b39Warfd0oDGWSr3SSOZEDir5ztQEOmCuZgpZm5rrdBD1E4jMKo+jpSAx7prtrg3UORb
        sRxubrk2c5Ae1GTKAmq/xUqp9vTbAuFOjYetCudoS3Fg7ZR744GMb0N6CmeENS9X2kvT7C
        4STzHFmekiEgPodyk8wO1liw1gCslZ0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-hGa67n68MgqUAZz04Aro1A-1; Sat, 29 Oct 2022 23:29:07 -0400
X-MC-Unique: hGa67n68MgqUAZz04Aro1A-1
Received: by mail-qk1-f199.google.com with SMTP id i11-20020a05620a404b00b006eeb0791c1aso6743621qko.10
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 20:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BF+JrY8YdtTEJujRzdlRAbzKK1KcUUNxwiz/HAD9FxU=;
        b=4dxmOCxrHJwmEM2GgUqzXkweT2vlydCnDpilswu96p6jTzn1neybArXbNWkp9on7WS
         /YmUWvfR79tz+G/BNGW4vG6jeT4lHv65+CfR9esY1wONFaI9q4fCLeHyg60yR5FPjMEw
         7efWRrmnJKttoHptYcb6wPL7PR9iHpd2LPAOqYokksHqK4VVagTjc4hJ3ElLDvRGBPhh
         Nw6IefhTgxeeAVOTFgsSKH97d8qfmzioXXhRdNDD7TMUrfCaSEH2J6KAbVi3VeuWoB/f
         qm3Q5eoYwUP77l26Aks9ZyL0AeDNzwQeV047x95sT47b2jgWA2DgH5ozmC+TEUONVHX1
         c8zw==
X-Gm-Message-State: ACrzQf3pgu3ykV7pSwA+IJpWstifEZqxp1ZDju6xPRsObkkmEtQe10at
        ZxqcDxBEy1+ReWYvTvV7OHDhfIiV/3lSyUdMuD4Pa4TO3/VSr2jHraj5sCyCFys43FZIjghnRtw
        0YXgcBpVaV/tatOL2afDg
X-Received: by 2002:a05:620a:1a17:b0:6ce:7c1b:c27f with SMTP id bk23-20020a05620a1a1700b006ce7c1bc27fmr4928857qkb.42.1667100546516;
        Sat, 29 Oct 2022 20:29:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ldRj6njtxWVrwifRAMmb8j/CnDdbG0Lb9xOscJJhkwxuzo9uczeC+j2j3AP1Ku+JdvO9egQ==
X-Received: by 2002:a05:620a:1a17:b0:6ce:7c1b:c27f with SMTP id bk23-20020a05620a1a1700b006ce7c1bc27fmr4928848qkb.42.1667100546252;
        Sat, 29 Oct 2022 20:29:06 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id bt4-20020ac86904000000b0039bde72b14asm1668185qtb.92.2022.10.29.20.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 20:29:05 -0700 (PDT)
Date:   Sun, 30 Oct 2022 11:29:01 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: refactor filesystem feature detection logic
Message-ID: <20221030032901.wslzkjl6qkfilsu2@zlang-mailbox>
References: <166697890818.4183768.10822596619783607332.stgit@magnolia>
 <166697891394.4183768.6502837738759035236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166697891394.4183768.6502837738759035236.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 10:41:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a lot of places where we open-code detecting features of a
> specific filesystem.  Refactor this into a couple of helpers in
> preparation for adding stress tests for online repair and fuzzing.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |   14 ++++++-----
>  common/rc       |    2 +-
>  common/xfs      |   67 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  tests/xfs/097   |    2 +-
>  tests/xfs/151   |    3 +-
>  tests/xfs/271   |    2 +-
>  tests/xfs/307   |    2 +-
>  tests/xfs/308   |    2 +-
>  tests/xfs/348   |    2 +-
>  9 files changed, 70 insertions(+), 26 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 58b07e33be..9fa1a06798 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -131,7 +131,7 @@ _populate_xfs_qmount_option()
>  	fi
>  
>  	# Turn on all the quotas
> -	if $XFS_INFO_PROG "${TEST_DIR}" | grep -q 'crc=1'; then
> +	if _xfs_has_feature "$TEST_DIR" crc; then
>  		# v5 filesystems can have group & project quotas
>  		quota="usrquota,grpquota,prjquota"
>  	else
> @@ -176,7 +176,7 @@ _scratch_xfs_populate() {
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> -	crc="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep crc= | sed -e 's/^.*crc=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>  	if [ $crc -eq 1 ]; then
>  		leaf_hdr_size=64
>  	else
> @@ -315,7 +315,7 @@ _scratch_xfs_populate() {
>  	done
>  
>  	# Reverse-mapping btree
> -	is_rmapbt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')"
> +	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
>  	if [ $is_rmapbt -gt 0 ]; then
>  		echo "+ rmapbt btree"
>  		nr="$((blksz * 2 / 24))"
> @@ -332,7 +332,7 @@ _scratch_xfs_populate() {
>  	fi
>  
>  	# Reference-count btree
> -	is_reflink="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'reflink=1')"
> +	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
>  	if [ $is_reflink -gt 0 ]; then
>  		echo "+ reflink btree"
>  		nr="$((blksz * 2 / 12))"
> @@ -597,9 +597,9 @@ _scratch_xfs_populate_check() {
>  	leaf_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LEAF")"
>  	node_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_NODE")"
>  	btree_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_BTREE")"
> -	is_finobt=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'finobt=1')
> -	is_rmapbt=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')
> -	is_reflink=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'reflink=1')
> +	is_finobt=$(_xfs_has_feature "$SCRATCH_MNT" finobt -v)
> +	is_rmapbt=$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)
> +	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> diff --git a/common/rc b/common/rc
> index f4785c17ca..8060c03b7d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -247,7 +247,7 @@ _supports_filetype()
>  	local fstyp=`$DF_PROG $dir | tail -1 | $AWK_PROG '{print $2}'`
>  	case "$fstyp" in
>  	xfs)
> -		$XFS_INFO_PROG $dir | grep -q "ftype=1"
> +		_xfs_has_feature $dir ftype
>  		;;
>  	ext2|ext3|ext4)
>  		local dev=`$DF_PROG $dir | tail -1 | $AWK_PROG '{print $1}'`
> diff --git a/common/xfs b/common/xfs
> index e1c15d3d04..b2ac78de0c 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -413,6 +413,56 @@ _require_xfs_crc()
>  	_scratch_unmount
>  }
>  
> +# If the xfs_info output for the given XFS filesystem mount mentions the given
> +# feature.  If so, return 0 for success.  If not, return 1 for failure.  If the
> +# third option is -v, echo 1 for success and 0 for not.
> +#
> +# Starting with xfsprogs 4.17, this also works for unmounted filesystems.
> +_xfs_has_feature()
> +{
> +	local fs="$1"
> +	local feat="$2"
> +	local verbose="$3"
> +
> +	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -w -c "$feat=1")"
> +	if [ "$answer" -ne 0 ]; then
> +		test "$verbose" = "-v" && echo 1
> +		return 0
> +	fi
> +
> +	test "$verbose" = "-v" && echo 0
> +	return 1
> +}
> +
> +# Require that the xfs_info output for the given XFS filesystem mount mentions
> +# the given feature flag.  If the third argument is -u (or is empty and the
> +# second argument is $SCRATCH_MNT), unmount the fs on failure.  If a fourth
> +# argument is supplied, it will be used as the _notrun message.
> +_require_xfs_has_feature()
> +{
> +	local fs="$1"
> +	local feat="$2"
> +	local umount="$3"
> +	local message="$4"
> +
> +	if [ -z "$umount" ] && [ "$fs" = "$SCRATCH_MNT" ]; then
> +		umount="-u"
> +	fi
> +
> +	_xfs_has_feature "$1" "$2" && return 0
> +
> +	test "$umount" = "-u" && umount "$fs" &>/dev/null
> +
> +	test -n "$message" && _notrun "$message"
> +
> +	case "$fs" in
> +	"$TEST_DIR"|"$TEST_DEV")	fsname="test";;
> +	"$SCRATCH_MNT"|"$SCRATCH_DEV")	fsname="scratch";;
> +	*)				fsname="$fs";;
> +	esac
> +	_notrun "$2 not supported by $fsname filesystem type: $FSTYP"
> +}
> +
>  # this test requires the xfs kernel support crc feature on scratch device
>  #
>  _require_scratch_xfs_crc()
> @@ -420,7 +470,8 @@ _require_scratch_xfs_crc()
>  	_scratch_mkfs_xfs >/dev/null 2>&1
>  	_try_scratch_mount >/dev/null 2>&1 \
>  	   || _notrun "Kernel doesn't support crc feature"
> -	$XFS_INFO_PROG $SCRATCH_MNT | grep -q 'crc=1' || _notrun "crc feature not supported by this filesystem"
> +	_require_xfs_has_feature $SCRATCH_MNT crc -u \
> +		"crc feature not supported by this filesystem"
>  	_scratch_unmount
>  }
>  
> @@ -739,10 +790,7 @@ _check_xfs_test_fs()
>  _require_xfs_test_rmapbt()
>  {
>  	_require_test
> -
> -	if [ "$($XFS_INFO_PROG "$TEST_DIR" | grep -c "rmapbt=1")" -ne 1 ]; then
> -		_notrun "rmapbt not supported by test filesystem type: $FSTYP"
> -	fi
> +	_require_xfs_has_feature "$TEST_DIR" rmapbt
>  }
>  
>  _require_xfs_scratch_rmapbt()
> @@ -751,10 +799,7 @@ _require_xfs_scratch_rmapbt()
>  
>  	_scratch_mkfs > /dev/null
>  	_scratch_mount
> -	if [ "$($XFS_INFO_PROG "$SCRATCH_MNT" | grep -c "rmapbt=1")" -ne 1 ]; then
> -		_scratch_unmount
> -		_notrun "rmapbt not supported by scratch filesystem type: $FSTYP"
> -	fi
> +	_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
>  	_scratch_unmount
>  }
>  
> @@ -1357,8 +1402,8 @@ _require_scratch_xfs_bigtime()
>  		_notrun "mkfs.xfs doesn't support bigtime feature"
>  	_try_scratch_mount || \
>  		_notrun "kernel doesn't support xfs bigtime feature"
> -	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "bigtime=1" || \
> -		_notrun "bigtime feature not advertised on mount?"
> +	_require_xfs_has_feature $SCRATCH_MNT bigtime -u \
> +		"crc feature not supported by this filesystem"
>  	_scratch_unmount
>  }
>  
> diff --git a/tests/xfs/097 b/tests/xfs/097
> index 4cad7216cd..1df34eeddc 100755
> --- a/tests/xfs/097
> +++ b/tests/xfs/097
> @@ -42,7 +42,7 @@ _scratch_mkfs_xfs -m crc=1,finobt=1 > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -$XFS_INFO_PROG "${SCRATCH_MNT}" | grep -q "finobt=1" || _notrun "finobt not enabled"
> +_require_xfs_has_feature "$SCRATCH_MNT" finobt
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  
>  echo "+ make some files"
> diff --git a/tests/xfs/151 b/tests/xfs/151
> index 66425f6710..b2fe16aefb 100755
> --- a/tests/xfs/151
> +++ b/tests/xfs/151
> @@ -24,8 +24,7 @@ echo "Format filesystem and populate"
>  _scratch_mkfs > $seqres.full
>  _scratch_mount >> $seqres.full
>  
> -$XFS_INFO_PROG $SCRATCH_MNT | grep -q ftype=1 || \
> -	_notrun "filesystem does not support ftype"
> +_require_xfs_has_feature "$SCRATCH_MNT" ftype
>  
>  filter_ls() {
>  	awk '
> diff --git a/tests/xfs/271 b/tests/xfs/271
> index 14d64cd0e5..d67ac4d6c1 100755
> --- a/tests/xfs/271
> +++ b/tests/xfs/271
> @@ -37,7 +37,7 @@ agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
>  # same owner (per-AG metadata) for rmap btree blocks and blocks on the AGFL and
>  # the reverse mapping index merges records, the number of per-AG extents
>  # reported will vary depending on whether the refcount btree is enabled.
> -$XFS_INFO_PROG $SCRATCH_MNT | grep -q reflink=1
> +_require_xfs_has_feature "$SCRATCH_MNT" reflink
>  has_reflink=$(( 1 - $? ))
>  perag_metadata_exts=2
>  test $has_reflink -gt 0 && perag_metadata_exts=$((perag_metadata_exts + 1))
> diff --git a/tests/xfs/307 b/tests/xfs/307
> index ba7204dd00..f3c970fadf 100755
> --- a/tests/xfs/307
> +++ b/tests/xfs/307
> @@ -22,7 +22,7 @@ _require_scratch_reflink
>  echo "Format"
>  _scratch_mkfs > $seqres.full 2>&1
>  _scratch_mount >> $seqres.full
> -is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
> +is_rmap=$(_xfs_has_feature $SCRATCH_MNT rmapbt -v)
>  _scratch_unmount
>  
>  _get_agf_data() {
> diff --git a/tests/xfs/308 b/tests/xfs/308
> index d0f47f5038..6da6622e14 100755
> --- a/tests/xfs/308
> +++ b/tests/xfs/308
> @@ -22,7 +22,7 @@ _require_scratch_reflink
>  echo "Format"
>  _scratch_mkfs > $seqres.full 2>&1
>  _scratch_mount >> $seqres.full
> -is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
> +is_rmap=$(_xfs_has_feature $SCRATCH_MNT rmapbt -v)
>  _scratch_xfs_unmount_dirty
>  
>  _get_agf_data() {
> diff --git a/tests/xfs/348 b/tests/xfs/348
> index faf2dca50b..d1645d9462 100755
> --- a/tests/xfs/348
> +++ b/tests/xfs/348
> @@ -39,7 +39,7 @@ mknod $testdir/CHRDEV c 1 1
>  mknod $testdir/BLKDEV b 1 1
>  mknod $testdir/FIFO p
>  
> -$XFS_INFO_PROG $SCRATCH_MNT | grep -q "ftype=1" && FTYPE_FEATURE=1
> +_xfs_has_feature $SCRATCH_MNT ftype && FTYPE_FEATURE=1
>  
>  # Record test dir inode for xfs_repair filter
>  inode_filter=$tmp.sed
> 

