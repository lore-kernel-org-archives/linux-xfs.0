Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B965C4708D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 19:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLGTiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 14:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGTiQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 14:38:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184D427CD0;
        Wed,  7 Dec 2022 11:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0451B81DD6;
        Wed,  7 Dec 2022 19:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7DAC433C1;
        Wed,  7 Dec 2022 19:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670441892;
        bh=GLdw+tZCjmAAj1Pe7vrX5W4b2j/An0rEq/0XNqtgmJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mlCQANgtM3vAK4JOUNRhyOjt4N0Rv8xgZOWd1cWPD511E2Q0DP4xgQhxBcUjhoh0r
         ebWocuCEw4H9i6L1mfhORoIm1aF939e4Hu+L0AjSOPoDRa4vK4MqyVTv2YhHF9DOWp
         Hbrky9jrBkUH6bJNjjOddYdA1ME72K3K7QXsxZWCTFOjp9puev6TAZ7EpDGc7O2vR1
         zroglxvKQAY35zCPfKSy7VYUNG2xTQjG5Ave13sJLF+LEshSpK3ZkrfqUA4Dnf6zbA
         aVE7OUowkPafMmzDrAHGBOx68ASzitG+CEK0kOBJ2dXQUvCYm1rLl4XneFIdbn4t2p
         bcNbMxFVCSunQ==
Date:   Wed, 7 Dec 2022 11:38:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com, allison.henderson@oracle.com
Subject: Re: [PATCH V4 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Message-ID: <Y5Dro1PUBZ+2juSx@magnolia>
References: <20221207093147.1634425-1-ZiyangZhang@linux.alibaba.com>
 <20221207093147.1634425-3-ZiyangZhang@linux.alibaba.com>
 <20221207182850.lnuijxc3qipwtnof@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207182850.lnuijxc3qipwtnof@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 08, 2022 at 02:28:50AM +0800, Zorro Lang wrote:
> On Wed, Dec 07, 2022 at 05:31:47PM +0800, Ziyang Zhang wrote:
> > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > 
> > Actually we just observed it can fail after apply our inode
> > extent-to-btree workaround. The root cause is that the kernel may be
> > too good at allocating consecutive blocks so that the data fork is
> > still in extents format.
> > 
> > Therefore instead of using a fixed number, let's make sure the number
> > of extents is large enough than (inode size - inode core size) /
> > sizeof(xfs_bmbt_rec_t).
> > 
> > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > ---
> >  common/populate | 34 +++++++++++++++++++++++++++++++++-
> >  common/xfs      |  9 +++++++++
> >  2 files changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/populate b/common/populate
> > index 6e004997..95cf56de 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -71,6 +71,37 @@ __populate_create_dir() {
> >  	done
> >  }
> >  
> > +# Create a large directory and ensure that it's a btree format
> > +__populate_xfs_create_btree_dir() {
> > +	local name="$1"
> > +	local isize="$2"
> > +	local missing="$3"
> > +	local icore_size="$(_xfs_inode_core_bytes)"
> > +	# We need enough extents to guarantee that the data fork is in
> > +	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > +	# watch for when the extent count exceeds the space after the
> > +	# inode core.
> > +	local max_nextents="$(((isize - icore_size) / 16))"
> > +
> > +	mkdir -p "${name}"
> > +	nr=0
> > +	while true; do
> > +		creat=mkdir
> > +		test "$((nr % 20))" -eq 0 && creat=touch
> > +		$creat "${name}/$(printf "%.08d" "$nr")"
> > +		if [ "$((nr % 40))" -eq 0 ]; then
> > +			nextents="$(_xfs_get_fsxattr nextents $name)"
> > +			[ $nextents -gt $max_nextents ] && break
> > +		fi
> > +		nr=$((nr+1))
> > +	done
> > +
> > +	test -z "${missing}" && return
> > +	seq 1 2 "${nr}" | while read d; do
> > +		rm -rf "${name}/$(printf "%.08d" "$d")"
> > +	done
> 
> Oh, you've done this change in V4, sorry I just reviewed an old version. A
> little picky review points as below:
> 
> This function makes sense to me, just the "local" key word is used so randomly,
> some variables have, some doesn't :)

All variables inside a helper function *should* be using 'local', unless
the goal is to set variables in an ancestor scope.  Note that this can
mean variables in the top level namespace, or a different function
further up in the call stack.

Unfortunately, I didn't know about this bashism when I started writing
fstests, which is why it's inconsistent all over the place. :(

This little script:

#!/bin/bash

moo=5

bar() {
	moo=$((moo + 1))
}

fubar() {
	bar
}

cow() {
	local moo=7
	bar
	echo "cow $moo"
}

grud() {
	local moo=11
	fubar
	echo "grud $moo"
}

cow
bar
echo "global $moo"
grud
echo "global $moo"
fubar
echo "global $moo"

Prints this on output:

$ ./demo.sh
global 5
cow 8
global 5
global 6
grud 12
global 6
global 7

--D

> > +}
> > +
> >  # Add a bunch of attrs to a file
> >  __populate_create_attr() {
> >  	name="$1"
> > @@ -176,6 +207,7 @@ _scratch_xfs_populate() {
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > +	isize="$(_xfs_inode_size "$SCRATCH_MNT")"
> >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> >  	if [ $crc -eq 1 ]; then
> >  		leaf_hdr_size=64
> > @@ -226,7 +258,7 @@ _scratch_xfs_populate() {
> >  
> >  	# - BTREE
> >  	echo "+ btree dir"
> > -	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
> > +	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
> >  
> >  	# Symlinks
> >  	# - FMT_LOCAL
> > diff --git a/common/xfs b/common/xfs
> > index 5074c350..3bfe8566 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
> >  			_notrun 'xfsrestore does not support -x flag.'
> >  }
> >  
> > +# Number of bytes reserved for a full inode record, which includes the
> > +# immediate fork areas.
> > +_xfs_inode_size()
> 
> Generally common/xfs names this kind of helpers as _xfs_get_xxxx(), likes
> _xfs_get_rtextents()
> _xfs_get_rtextsize()
> _xfs_get_dir_blocksize()
> ...
> 
> > +{
> > +	local mntpoint="$1"
> > +
> > +	$XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g'
> 
> It can be done with one pipe:
> $XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'
> 
> With above changes you can have:
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> > +}
> > +
> >  # Number of bytes reserved for only the inode record, excluding the
> >  # immediate fork areas.
> >  _xfs_inode_core_bytes()
> > -- 
> > 2.18.4
> > 
> 
