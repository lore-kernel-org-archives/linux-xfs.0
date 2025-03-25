Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE39B666;
	Tue, 25 Mar 2025 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742865636; cv=none; b=UmLis7wnJTrJ1tYOtwFUFI5oNzFkbflR8cqLAEJb9aBo2zqO8z8lcuCTSkLHA1v/r620YNZ2j/09qGt9iazU/rjHrsWK6K9v2DwaaFWksYvoFC3Rjx9DZy2hIKwT2XV+acRlcDPmyPdM5f+2tRSTqHUWD+10VcNCpF4mrFRMo8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742865636; c=relaxed/simple;
	bh=kq6Vt2/xd35olKy2ixyVBcjCZPe92NLPuxzfgG+kBTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A98ktzwkPvLqQvkzvBVNet51TeJSYJc11Qi86JTFP+SCuwWDAZIaQLlrKoKw810NveTf1afg/o2/PgWqVt9z1LIQCHE88KT7TPF5F67MnlhGoyLHbqR11mes9IO1W80NFYNBRPyy6dsLHDU9oyYGGuP0lkptkPOAm5Us04UOo/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h555OcMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h555OcMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576F2C4CEDD;
	Tue, 25 Mar 2025 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742865635;
	bh=kq6Vt2/xd35olKy2ixyVBcjCZPe92NLPuxzfgG+kBTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h555OcMWFTBR5Kgs2MCz1ziWdb8N5AQMQD27u3w/HQHNKfE1nHjDcmD44b1HV+vdS
	 aUQTxnV2rZjlSqTDEvd92Yqj0EK6aEwnMUuGtCARFmUDnOZIdNhBs6TXjs+lHx/ncq
	 Q9JKXtfoefGoEEbEAVu3qMglrmFmlgvJ669/HGCx1Oj7Lx1lPgittDXKVBUmRFrvra
	 FHpXE4txVti/H9TEWs1ze4Rv03O398o7kqbPUCAlpuZ/5iGqdEAKD9uoXROECvuZLd
	 9B285pURIqMNvZKpfhRme8X2TGTbKdFFXWjBHZBNGXrNzLdQODaG9gGVkFw5OYFMxe
	 LTVbNzfbTWRng==
Date: Mon, 24 Mar 2025 18:20:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test filesystem recovery with rdump
Message-ID: <20250325012034.GJ89034@frogsfrogsfrogs>
References: <174259233514.743419.14108043386932063353.stgit@frogsfrogsfrogs>
 <174259233533.743419.11473495762149004746.stgit@frogsfrogsfrogs>
 <20250322200429.7xtqnvss64qbt4ib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250325005026.GI4001511@frogsfrogsfrogs>
 <20250325010851.3lzh3wclopjpygso@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325010851.3lzh3wclopjpygso@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Mar 25, 2025 at 09:08:51AM +0800, Zorro Lang wrote:
> On Mon, Mar 24, 2025 at 05:50:26PM -0700, Darrick J. Wong wrote:
> > On Sun, Mar 23, 2025 at 04:04:29AM +0800, Zorro Lang wrote:
> > > On Fri, Mar 21, 2025 at 02:27:07PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Test how well we can dump a fully populated filesystem's contents.
> > > > 
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1895.out |    6 ++
> > > >  2 files changed, 159 insertions(+)
> > > >  create mode 100755 tests/xfs/1895
> > > >  create mode 100644 tests/xfs/1895.out
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/1895 b/tests/xfs/1895
> > > > new file mode 100755
> > > > index 00000000000000..18b534d328e9fd
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1895
> > > > @@ -0,0 +1,153 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2025 Oracle, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 1895
> > > > +#
> > > > +# Populate a XFS filesystem, ensure that rdump can "recover" the contents to
> > > > +# another directory, and compare the contents.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto scrub
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> > > 
> > > I'm wondering why you always do "command -v _kill_fsstress &>/dev/null" before
> > > _kill_fsstress, isn't _kill_fsstress a common helper in common/rc ?
> > 
> > Yeah, I probably copy-pasta'd that from common/preamble.  Will remove it
> > before the next posting, assuming you don't decide to fix+merge it.
> 
> I can "fix+merge" that:) if you don't have more changes, except:
> 
>   - command -v _kill_fsstress &>/dev/null && _kill_fsstress
>   + _kill_fsstress

No changes other than applying hch's rvb that he attached to the other
thread.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +	cd /
> > > > +	test -e "$testfiles" && rm -r -f $testfiles
> > > > +}
> > > > +
> > > > +_register_cleanup "_cleanup" BUS
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/filter
> > > > +. ./common/populate
> > > > +. ./common/fuzzy
> > > > +
> > > > +_require_xfs_db_command "rdump"
> > > > +_require_test
> > > > +_require_scratch
> > > > +_require_scrub
> > > > +_require_populate_commands
> > > > +
> > > > +make_md5()
> > > > +{
> > > > +	(cd $1 ; find . -type f -print0 | xargs -0 md5sum) > $tmp.md5.$2
> > > > +}
> > > > +
> > > > +cmp_md5()
> > > > +{
> > > > +	(cd $1 ; md5sum --quiet -c $tmp.md5.$2)
> > > > +}
> > > > +
> > > > +make_stat()
> > > > +{
> > > > +	# columns:	raw mode in hex,
> > > > +	# 		major rdev for special
> > > > +	# 		minor rdev for special
> > > > +	# 		uid of owner
> > > > +	# 		gid of owner
> > > > +	# 		file type
> > > > +	# 		total size
> > > > +	# 		mtime
> > > > +	# 		name
> > > > +	# We can't directly control directory sizes so filter them.
> > > > +	# Too many things can bump (or not) atime so don't test that.
> > > > +	(cd $1 ; find . -print0 |
> > > > +		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' |
> > > > +		sed -e 's/ directory [1-9][0-9]* / directory SIZE /g' |
> > > > +		sort) > $tmp.stat.$2
> > > > +}
> > > > +
> > > > +cmp_stat()
> > > > +{
> > > > +	diff -u $tmp.stat.$1 $tmp.stat.$2
> > > > +}
> > > > +
> > > > +make_stat_files() {
> > > > +	for file in "${FILES[@]}"; do
> > > > +		find "$1/$file" -print0 | xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n'
> > > > +	done | sed \
> > > > +		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
> > > > +		-e "s| $1| DUMPDIR|g" \
> > > > +		| sort > $tmp.stat.files.$2
> > > > +}
> > > > +
> > > > +cmp_stat_files()
> > > > +{
> > > > +	diff -u $tmp.stat.files.$1 $tmp.stat.files.$2
> > > > +}
> > > > +
> > > > +make_stat_dir() {
> > > > +	find "$1" -print0 | \
> > > > +		xargs -0 stat -c '%f %t:%T %u %g %F %s %Y %n' | sed \
> > > > +		-e 's/ directory [1-9][0-9]* / directory SIZE /g' \
> > > > +		-e "s| $1| DUMPDIR|g" \
> > > > +		| sort > $tmp.stat.dir.$2
> > > > +}
> > > > +
> > > > +cmp_stat_dir()
> > > > +{
> > > > +	diff -u $tmp.stat.dir.$1 $tmp.stat.dir.$2
> > > > +}
> > > > +
> > > > +FILES=(
> > > > +	"/S_IFDIR.FMT_INLINE"
> > > > +	"/S_IFBLK"
> > > > +	"/S_IFCHR"
> > > > +	"/S_IFLNK.FMT_LOCAL"
> > > > +	"/S_IFIFO"
> > > > +	"/S_IFDIR.FMT_INLINE/00000001"
> > > > +	"/ATTR.FMT_EXTENTS_REMOTE3K"
> > > > +	"/S_IFREG.FMT_EXTENTS"
> > > > +	"/S_IFREG.FMT_BTREE"
> > > > +	"/BNOBT"
> > > > +	"/S_IFDIR.FMT_BLOCK"
> > > > +)
> > > > +DIR="/S_IFDIR.FMT_LEAF"
> > > > +
> > > > +testfiles=$TEST_DIR/$seq
> > > > +mkdir -p $testfiles
> > > > +
> > > > +echo "Format and populate"
> > > > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +_run_fsstress -n 500 -d $SCRATCH_MNT/newfiles
> > > > +
> > > > +make_stat $SCRATCH_MNT before
> > > > +make_md5 $SCRATCH_MNT before
> > > > +make_stat_files $SCRATCH_MNT before
> > > > +make_stat_dir $SCRATCH_MNT/$DIR before
> > > > +_scratch_unmount
> > > > +
> > > > +echo "Recover filesystem"
> > > > +dumpdir1=$testfiles/rdump
> > > > +dumpdir2=$testfiles/sdump
> > > > +dumpdir3=$testfiles/tdump
> > > > +rm -r -f $dumpdir1 $dumpdir2 $dumpdir3
> > > > +
> > > > +# as of linux 6.12 fchownat does not work on symlinks
> > > > +_scratch_xfs_db -c "rdump / $dumpdir1" | sed -e '/could not be set/d'
> > > > +_scratch_xfs_db -c "rdump ${FILES[*]} $dumpdir2" | sed -e '/could not be set/d'
> > > > +_scratch_xfs_db -c "rdump $DIR $dumpdir3" | sed -e '/could not be set/d'
> > > > +
> > > > +echo "Check file contents"
> > > > +make_stat $dumpdir1 after
> > > > +cmp_stat before after
> > > > +cmp_md5 $dumpdir1 before
> > > > +
> > > > +echo "Check selected files contents"
> > > > +make_stat_files $dumpdir2 after
> > > > +cmp_stat_files before after
> > > > +
> > > > +echo "Check single dir extraction contents"
> > > > +make_stat_dir $dumpdir3 after
> > > > +cmp_stat_dir before after
> > > > +
> > > > +# remount so we can check this fs
> > > > +_scratch_mount
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1895.out b/tests/xfs/1895.out
> > > > new file mode 100644
> > > > index 00000000000000..de639ed3fc7e38
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1895.out
> > > > @@ -0,0 +1,6 @@
> > > > +QA output created by 1895
> > > > +Format and populate
> > > > +Recover filesystem
> > > > +Check file contents
> > > > +Check selected files contents
> > > > +Check single dir extraction contents
> > > > 
> > > 
> > > 
> > 
> 
