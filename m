Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ADFC4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Dec 2022 19:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLKTTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Dec 2022 14:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLKTTQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2022 14:19:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E0C754;
        Sun, 11 Dec 2022 11:19:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1F1960C5E;
        Sun, 11 Dec 2022 19:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350E2C433D2;
        Sun, 11 Dec 2022 19:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670786354;
        bh=eiTaqLNP+WiR2YpG6gtfHIwh4WeVK2WffQCML2Rj5GI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsweEBpBU+rhw9I13zFWt7Xy7LeGT9xHXjIBiWD+eBSPrSb3EouL+0AYNFmyOeB8p
         OEVJUG1r6mTxLFGoYInm83WnZzGZPCBFyGVhNJ7+jvkiZh3DTu5mJyiadAYLaXToNY
         X7DNNt/F5CcA8zAk59roaosz5Mg08YudFwnBQs32Nmp3wi/Hk2dmHpyd9T9ANyyynH
         vqf7EA/bOGw71qHcecDKlJvQ8uoXziEBuQZVsDZUm7W8T6FkakBrX+dn98U0vtJloc
         bGljchilq83zjZOMfyc73drYHU80tMpcEee/x762EsO9oiiwxRBMrb+DQbHZr5e8nh
         LRgQguM7BYpfA==
Date:   Sun, 11 Dec 2022 11:19:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com
Subject: Re: [PATCH V5 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <Y5YtMYtZyj7AhNLd@magnolia>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
 <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
 <Y5NkVRNhQgZpWNMj@magnolia>
 <20221210135724.owsxdqiirtkqsv6e@zlang-mailbox>
 <Y5VAss77Xm8JUu4r@magnolia>
 <20221211110125.zpc4csv6hw5ibsbu@zlang-mailbox>
 <20221211112331.pumrysfc4khgw3rr@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221211112331.pumrysfc4khgw3rr@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 11, 2022 at 07:23:31PM +0800, Zorro Lang wrote:
> On Sun, Dec 11, 2022 at 07:01:25PM +0800, Zorro Lang wrote:
> > On Sat, Dec 10, 2022 at 06:30:10PM -0800, Darrick J. Wong wrote:
> > > On Sat, Dec 10, 2022 at 09:57:24PM +0800, Zorro Lang wrote:
> > > > On Fri, Dec 09, 2022 at 08:37:41AM -0800, Darrick J. Wong wrote:
> > > > > On Thu, Dec 08, 2022 at 03:28:43PM +0800, Ziyang Zhang wrote:
> > > > > > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > > > > > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > > > > > 
> > > > > > Actually we just observed it can fail after apply our inode
> > > > > > extent-to-btree workaround. The root cause is that the kernel may be
> > > > > > too good at allocating consecutive blocks so that the data fork is
> > > > > > still in extents format.
> > > > > > 
> > > > > > Therefore instead of using a fixed number, let's make sure the number
> > > > > > of extents is large enough than (inode size - inode core size) /
> > > > > > sizeof(xfs_bmbt_rec_t).
> > > > > > 
> > > > > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > > > > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > > > > > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > > > > Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > > > > > ---
> > > > > >  common/populate | 34 +++++++++++++++++++++++++++++++++-
> > > > > >  common/xfs      |  9 +++++++++
> > > > > >  2 files changed, 42 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/common/populate b/common/populate
> > > > > > index 6e004997..0d334a13 100644
> > > > > > --- a/common/populate
> > > > > > +++ b/common/populate
> > > > > > @@ -71,6 +71,37 @@ __populate_create_dir() {
> > > > > >  	done
> > > > > >  }
> > > > > >  
> > > > > > +# Create a large directory and ensure that it's a btree format
> > > > > > +__populate_xfs_create_btree_dir() {
> > > > > > +	local name="$1"
> > > > > > +	local isize="$2"
> > > > > > +	local missing="$3"
> > > > > > +	local icore_size="$(_xfs_inode_core_bytes)"
> > > > > 
> > > > > Doesn't this helper require a path argument now?
> > > > 
> > > > What kind of "path" argument? I think he copy it from __populate_create_dir(),
> > > > and keep using the "name" as the root path to create files/dir.
> > > 
> > > This path argument, from
> > > https://lore.kernel.org/fstests/20221208072843.1866615-2-ZiyangZhang@linux.alibaba.com/T/#u
> > > 
> > > +# Number of bytes reserved for only the inode record, excluding the
> > > +# immediate fork areas.
> > > +_xfs_get_inode_core_bytes()
> > > +{
> > > +	local dir="$1"
> > > +
> > > +	if _xfs_has_feature "$dir" crc; then
> > 
> > Oh, sorry I thought you mean __populate_xfs_create_btree_dir() require a path
> > argument...
> > 
> > Yes, and this helper's name should be _xfs_get_inode_core_bytes(), not
> > _xfs_inode_core_bytes(). I didn't find _xfs_inode_core_bytes from current
> > fstests. So it should be:
> > 
> >   local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
> 
> Hmm... wait a moment. The work directory of __populate_xfs_create_btree_dir() is
> "local name=$1", but the "$name" maybe not a mountpoint.
> 
> So we need to get the fs dev/mnt before calling _xfs_get_inode_core_bytes:
> 
> 	local icore_size="$(_xfs_get_inode_core_bytes `_df_dir $name | awk '{print $1}'`)"
> 
> Or use $TEST_MNT directly?

The __populate* functions only modify the scratch filesystem, so your
original suggestion is correct:

	local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"

--D

> Thanks,
> Zorro
> 
> > 
> > Hi Ziyang,
> > 
> > Please modify this place, and check all other places which call
> > _xfs_get_inode_core_bytes and _xfs_get_inode_size, to make sure
> > they're all changed correctly.
> > 
> > Thanks,
> > Zorro
> > 
> > 
> > > 
> > > --D
> > > 
> > > > > 
> > > > > --D
> > > > > 
> > > > > > +	# We need enough extents to guarantee that the data fork is in
> > > > > > +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > > > > > +	# watch for when the extent count exceeds the space after the
> > > > > > +	# inode core.
> > > > > > +	local max_nextents="$(((isize - icore_size) / 16))"
> > > > > > +	local nr=0
> > > > > > +
> > > > > > +	mkdir -p "${name}"
> > > > > > +	while true; do
> > > > > > +		local creat=mkdir
> > > > > > +		test "$((nr % 20))" -eq 0 && creat=touch
> > > > > > +		$creat "${name}/$(printf "%.08d" "$nr")"
> > > > > > +		if [ "$((nr % 40))" -eq 0 ]; then
> > > > > > +			local nextents="$(_xfs_get_fsxattr nextents $name)"
> > > > > > +			[ $nextents -gt $max_nextents ] && break
> > > > > > +		fi
> > > > > > +		nr=$((nr+1))
> > > > > > +	done
> > > > > > +
> > > > > > +	test -z "${missing}" && return
> > > > > > +	seq 1 2 "${nr}" | while read d; do
> > > > > > +		rm -rf "${name}/$(printf "%.08d" "$d")"
> > > > > > +	done
> > > > > > +}
> > > > > > +
> > > > > >  # Add a bunch of attrs to a file
> > > > > >  __populate_create_attr() {
> > > > > >  	name="$1"
> > > > > > @@ -176,6 +207,7 @@ _scratch_xfs_populate() {
> > > > > >  
> > > > > >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > > >  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > > > > > +	isize="$(_xfs_get_inode_size "$SCRATCH_MNT")"
> > > > > >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> > > > > >  	if [ $crc -eq 1 ]; then
> > > > > >  		leaf_hdr_size=64
> > > > > > @@ -226,7 +258,7 @@ _scratch_xfs_populate() {
> > > > > >  
> > > > > >  	# - BTREE
> > > > > >  	echo "+ btree dir"
> > > > > > -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> > > > > > +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
> > > > > >  
> > > > > >  	# Symlinks
> > > > > >  	# - FMT_LOCAL
> > > > > > diff --git a/common/xfs b/common/xfs
> > > > > > index 674384a9..7aaa63c7 100644
> > > > > > --- a/common/xfs
> > > > > > +++ b/common/xfs
> > > > > > @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
> > > > > >  			_notrun 'xfsrestore does not support -x flag.'
> > > > > >  }
> > > > > >  
> > > > > > +# Number of bytes reserved for a full inode record, which includes the
> > > > > > +# immediate fork areas.
> > > > > > +_xfs_get_inode_size()
> > > > > > +{
> > > > > > +	local mntpoint="$1"
> > > > > > +
> > > > > > +	$XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'
> > > > > > +}
> > > > > > +
> > > > > >  # Number of bytes reserved for only the inode record, excluding the
> > > > > >  # immediate fork areas.
> > > > > >  _xfs_get_inode_core_bytes()
> > > > > > -- 
> > > > > > 2.18.4
> > > > > > 
> > > > > 
> > > > 
> > > 
> 
