Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB3EC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Dec 2022 11:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLKLCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Dec 2022 06:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLKLC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2022 06:02:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3173810061
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2022 03:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670756493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tvg1c2fe5jvcGOidQhKvA/hsq4UiFy6wbEw+wHd57EM=;
        b=cfLemtJ5/r76Yn3XqUE7aokxvm6UjCa8rKKRkLT+MFZx9LKty6tUywMaVR0C8mU2yQobF6
        8irDvTFeZl5eIVXOOTnbhSO3uleenjUKzeTIoRFbBBpTOf4UUo1poWoWNdvlesyvfCJToL
        VqdwQNtKdxbJoyDb3eDFGo7oXpn91xQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-e2OSMM-VMuuhX8g1BdSwog-1; Sun, 11 Dec 2022 06:01:32 -0500
X-MC-Unique: e2OSMM-VMuuhX8g1BdSwog-1
Received: by mail-pf1-f199.google.com with SMTP id v16-20020a62a510000000b005745a58c197so6316312pfm.23
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2022 03:01:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvg1c2fe5jvcGOidQhKvA/hsq4UiFy6wbEw+wHd57EM=;
        b=gtd6ZtXl+A11lLOl8aPVtPBDn9WSzyLILNwoUUecazIcAymx0sQvWOmNK/z5csupbI
         MgBCZFvBcssvN+xFG5oJMjiL98y3O3HX4UAmTPbFtBpVFDz+8/PddWn2cu89/TxIWC2L
         /Yf9fKB503RczdKnPXEdKkCHKw5O1uu9KngLeJegupmZDxlyJP+0YhFL1fJeqOFz+yTd
         9i/kFGjfznCc1T2SGOCtgK2hWVg4ALIn8MSrugW4PUwT2oWFzC21rMnJs8I1z281cCyi
         wL4yMyIG7rq9TUFxp4fUuMuyuKjlBlvcX25k9SOxMH1n/B9F6ZOZHJHnFUYhePuC6CqT
         4CLg==
X-Gm-Message-State: ANoB5pnT8PrvCQsxhoJ7W6r1wF+g/4K7wW08f/EFADfjFOm1e36ZpZj/
        TjoHBecTCtHnzHtqQ2yWXj/UUS1l0xWbAXcVl2BxdDDUBvawp/Ho8hR3tZ0C4fLpyfsGALFNZ6Z
        wIm3mErXsC/0av3pkqOe1
X-Received: by 2002:a05:6a21:9992:b0:ad:394f:50c7 with SMTP id ve18-20020a056a21999200b000ad394f50c7mr11413675pzb.3.1670756491190;
        Sun, 11 Dec 2022 03:01:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7wHpqAHNBX/n2TUR1lirbqCr/m/vhvGyiGoWKtGzgso4VCWwXzVZVAcHvjkXk0CCesc/Fsrg==
X-Received: by 2002:a05:6a21:9992:b0:ad:394f:50c7 with SMTP id ve18-20020a056a21999200b000ad394f50c7mr11413634pzb.3.1670756490831;
        Sun, 11 Dec 2022 03:01:30 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 195-20020a6217cc000000b00574cf11aaf3sm3834585pfx.208.2022.12.11.03.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 03:01:30 -0800 (PST)
Date:   Sun, 11 Dec 2022 19:01:25 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com
Subject: Re: [PATCH V5 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <20221211110125.zpc4csv6hw5ibsbu@zlang-mailbox>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
 <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
 <Y5NkVRNhQgZpWNMj@magnolia>
 <20221210135724.owsxdqiirtkqsv6e@zlang-mailbox>
 <Y5VAss77Xm8JUu4r@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5VAss77Xm8JUu4r@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 10, 2022 at 06:30:10PM -0800, Darrick J. Wong wrote:
> On Sat, Dec 10, 2022 at 09:57:24PM +0800, Zorro Lang wrote:
> > On Fri, Dec 09, 2022 at 08:37:41AM -0800, Darrick J. Wong wrote:
> > > On Thu, Dec 08, 2022 at 03:28:43PM +0800, Ziyang Zhang wrote:
> > > > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > > > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > > > 
> > > > Actually we just observed it can fail after apply our inode
> > > > extent-to-btree workaround. The root cause is that the kernel may be
> > > > too good at allocating consecutive blocks so that the data fork is
> > > > still in extents format.
> > > > 
> > > > Therefore instead of using a fixed number, let's make sure the number
> > > > of extents is large enough than (inode size - inode core size) /
> > > > sizeof(xfs_bmbt_rec_t).
> > > > 
> > > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > > > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > > Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > > > ---
> > > >  common/populate | 34 +++++++++++++++++++++++++++++++++-
> > > >  common/xfs      |  9 +++++++++
> > > >  2 files changed, 42 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/common/populate b/common/populate
> > > > index 6e004997..0d334a13 100644
> > > > --- a/common/populate
> > > > +++ b/common/populate
> > > > @@ -71,6 +71,37 @@ __populate_create_dir() {
> > > >  	done
> > > >  }
> > > >  
> > > > +# Create a large directory and ensure that it's a btree format
> > > > +__populate_xfs_create_btree_dir() {
> > > > +	local name="$1"
> > > > +	local isize="$2"
> > > > +	local missing="$3"
> > > > +	local icore_size="$(_xfs_inode_core_bytes)"
> > > 
> > > Doesn't this helper require a path argument now?
> > 
> > What kind of "path" argument? I think he copy it from __populate_create_dir(),
> > and keep using the "name" as the root path to create files/dir.
> 
> This path argument, from
> https://lore.kernel.org/fstests/20221208072843.1866615-2-ZiyangZhang@linux.alibaba.com/T/#u
> 
> +# Number of bytes reserved for only the inode record, excluding the
> +# immediate fork areas.
> +_xfs_get_inode_core_bytes()
> +{
> +	local dir="$1"
> +
> +	if _xfs_has_feature "$dir" crc; then

Oh, sorry I thought you mean __populate_xfs_create_btree_dir() require a path
argument...

Yes, and this helper's name should be _xfs_get_inode_core_bytes(), not
_xfs_inode_core_bytes(). I didn't find _xfs_inode_core_bytes from current
fstests. So it should be:

  local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"

Hi Ziyang,

Please modify this place, and check all other places which call
_xfs_get_inode_core_bytes and _xfs_get_inode_size, to make sure
they're all changed correctly.

Thanks,
Zorro


> 
> --D
> 
> > > 
> > > --D
> > > 
> > > > +	# We need enough extents to guarantee that the data fork is in
> > > > +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > > > +	# watch for when the extent count exceeds the space after the
> > > > +	# inode core.
> > > > +	local max_nextents="$(((isize - icore_size) / 16))"
> > > > +	local nr=0
> > > > +
> > > > +	mkdir -p "${name}"
> > > > +	while true; do
> > > > +		local creat=mkdir
> > > > +		test "$((nr % 20))" -eq 0 && creat=touch
> > > > +		$creat "${name}/$(printf "%.08d" "$nr")"
> > > > +		if [ "$((nr % 40))" -eq 0 ]; then
> > > > +			local nextents="$(_xfs_get_fsxattr nextents $name)"
> > > > +			[ $nextents -gt $max_nextents ] && break
> > > > +		fi
> > > > +		nr=$((nr+1))
> > > > +	done
> > > > +
> > > > +	test -z "${missing}" && return
> > > > +	seq 1 2 "${nr}" | while read d; do
> > > > +		rm -rf "${name}/$(printf "%.08d" "$d")"
> > > > +	done
> > > > +}
> > > > +
> > > >  # Add a bunch of attrs to a file
> > > >  __populate_create_attr() {
> > > >  	name="$1"
> > > > @@ -176,6 +207,7 @@ _scratch_xfs_populate() {
> > > >  
> > > >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > >  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > > > +	isize="$(_xfs_get_inode_size "$SCRATCH_MNT")"
> > > >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> > > >  	if [ $crc -eq 1 ]; then
> > > >  		leaf_hdr_size=64
> > > > @@ -226,7 +258,7 @@ _scratch_xfs_populate() {
> > > >  
> > > >  	# - BTREE
> > > >  	echo "+ btree dir"
> > > > -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> > > > +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
> > > >  
> > > >  	# Symlinks
> > > >  	# - FMT_LOCAL
> > > > diff --git a/common/xfs b/common/xfs
> > > > index 674384a9..7aaa63c7 100644
> > > > --- a/common/xfs
> > > > +++ b/common/xfs
> > > > @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
> > > >  			_notrun 'xfsrestore does not support -x flag.'
> > > >  }
> > > >  
> > > > +# Number of bytes reserved for a full inode record, which includes the
> > > > +# immediate fork areas.
> > > > +_xfs_get_inode_size()
> > > > +{
> > > > +	local mntpoint="$1"
> > > > +
> > > > +	$XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'
> > > > +}
> > > > +
> > > >  # Number of bytes reserved for only the inode record, excluding the
> > > >  # immediate fork areas.
> > > >  _xfs_get_inode_core_bytes()
> > > > -- 
> > > > 2.18.4
> > > > 
> > > 
> > 
> 

