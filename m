Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F293C47089
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 18:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLGS37 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGS36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 13:29:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0815445B
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 10:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670437738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W4Jx+GEGNZ2JEoHrDHA1U0w6DOaeZGtq2aqaKx440V0=;
        b=aYgTEuOlYKj7DOoCMYRe0uesmTY7Qt0ngqsT85xFKLDuLoixS04pq79z4FpUI0lVTR027r
        picj9fujPnQKjx2G9vfI8fZDRszWRWKnnjtqNuAUPeGvTsuLdmayO5e08hpgQjKQ0kg/eN
        LATUlmC/XCb7QfREiBxNUIjvpt3ngtA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-187-rwU8Md4lO4uK1pTJCPuzmQ-1; Wed, 07 Dec 2022 13:28:57 -0500
X-MC-Unique: rwU8Md4lO4uK1pTJCPuzmQ-1
Received: by mail-pf1-f199.google.com with SMTP id bd20-20020a056a00279400b0057340fe1658so15690423pfb.6
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 10:28:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4Jx+GEGNZ2JEoHrDHA1U0w6DOaeZGtq2aqaKx440V0=;
        b=3y7Wj97LXArj8vTyp4XwAfhZbeS5MEKvHDMQflM9XajLNWkRh1/wGeJz5a/J41DUVr
         SVeab9sUBeuPEpY/SkK53ywrrB4hNOA0aoZkxaVozfZlGooMljIr6VWG5JM5+B3J1TQY
         fVoiA+3BDx6SqYfz3tFJlKqqSpMFKnbbzoCYlsStaRixBUyCUU0lNrmyFeVvHWlaRmpF
         1wTkEphpSsrYrdy5qFtqPoIjuG+CZFVNznQqq+515ZQuggHTZvtGCdbLegwKBP56hDJL
         9PoUMHDX9fmb8zVK01D3dzVjnlWeKHMlshkJZ/+hhlIBfxGHOTV1IDtWdzk1jAu2JD4x
         RUKw==
X-Gm-Message-State: ANoB5plf4exsUB/WXrmFknwC0/T4RYRuAnTylFYsbmefj6zmhInOB1rh
        whjsFomRRVDMzmDy/IvRmMd1jO7LmmEp4t1FTkeCQKn51K7kFkgneRIfDeV5zvXNpbJ7FDvuy2w
        YCryZWwmWRLE1itLkwbhi
X-Received: by 2002:a17:90b:46ce:b0:219:e613:9006 with SMTP id jx14-20020a17090b46ce00b00219e6139006mr814642pjb.41.1670437735547;
        Wed, 07 Dec 2022 10:28:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7dukhYd5n9Snaum/roBFOcGuBEaOK01yYkWvmc/HmWG5WTm24btjeCkwOzxQ0jAuVhOu3Tcg==
X-Received: by 2002:a17:90b:46ce:b0:219:e613:9006 with SMTP id jx14-20020a17090b46ce00b00219e6139006mr814631pjb.41.1670437735210;
        Wed, 07 Dec 2022 10:28:55 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r6-20020a635146000000b0043b565cb57csm11796498pgl.73.2022.12.07.10.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 10:28:54 -0800 (PST)
Date:   Thu, 8 Dec 2022 02:28:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, hsiangkao@linux.alibaba.com,
        allison.henderson@oracle.com
Subject: Re: [PATCH V4 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <20221207182850.lnuijxc3qipwtnof@zlang-mailbox>
References: <20221207093147.1634425-1-ZiyangZhang@linux.alibaba.com>
 <20221207093147.1634425-3-ZiyangZhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207093147.1634425-3-ZiyangZhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2022 at 05:31:47PM +0800, Ziyang Zhang wrote:
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
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> ---
>  common/populate | 34 +++++++++++++++++++++++++++++++++-
>  common/xfs      |  9 +++++++++
>  2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/common/populate b/common/populate
> index 6e004997..95cf56de 100644
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
> +	# We need enough extents to guarantee that the data fork is in
> +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> +	# watch for when the extent count exceeds the space after the
> +	# inode core.
> +	local max_nextents="$(((isize - icore_size) / 16))"
> +
> +	mkdir -p "${name}"
> +	nr=0
> +	while true; do
> +		creat=mkdir
> +		test "$((nr % 20))" -eq 0 && creat=touch
> +		$creat "${name}/$(printf "%.08d" "$nr")"
> +		if [ "$((nr % 40))" -eq 0 ]; then
> +			nextents="$(_xfs_get_fsxattr nextents $name)"
> +			[ $nextents -gt $max_nextents ] && break
> +		fi
> +		nr=$((nr+1))
> +	done
> +
> +	test -z "${missing}" && return
> +	seq 1 2 "${nr}" | while read d; do
> +		rm -rf "${name}/$(printf "%.08d" "$d")"
> +	done

Oh, you've done this change in V4, sorry I just reviewed an old version. A
little picky review points as below:

This function makes sense to me, just the "local" key word is used so randomly,
some variables have, some doesn't :)

> +}
> +
>  # Add a bunch of attrs to a file
>  __populate_create_attr() {
>  	name="$1"
> @@ -176,6 +207,7 @@ _scratch_xfs_populate() {
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> +	isize="$(_xfs_inode_size "$SCRATCH_MNT")"
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
> index 5074c350..3bfe8566 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
>  			_notrun 'xfsrestore does not support -x flag.'
>  }
>  
> +# Number of bytes reserved for a full inode record, which includes the
> +# immediate fork areas.
> +_xfs_inode_size()

Generally common/xfs names this kind of helpers as _xfs_get_xxxx(), likes
_xfs_get_rtextents()
_xfs_get_rtextsize()
_xfs_get_dir_blocksize()
...

> +{
> +	local mntpoint="$1"
> +
> +	$XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g'

It can be done with one pipe:
$XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'

With above changes you can have:
Reviewed-by: Zorro Lang <zlang@redhat.com>

> +}
> +
>  # Number of bytes reserved for only the inode record, excluding the
>  # immediate fork areas.
>  _xfs_inode_core_bytes()
> -- 
> 2.18.4
> 

