Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46103A1AC;
	Thu, 19 Sep 2024 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726776792; cv=none; b=QnBG5P5WbR+pIa4azQxNspSJB8EVWXl7J4FXTb6sX+mAFmMg1nJjjXclUASPVe8/DOhzufc7Zcxr4nwhgEBOZ3QFId7z2W4a8fQcf11MKf5cCeRAYNhgo3kqz3Y+iKW9xPSlEgF4t8rdJocE1PUAtHsIW5Wp/cGiTvpP3jEjCNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726776792; c=relaxed/simple;
	bh=gWqu0caasJYRq5B0Vjhqbg09uOFenaZa8N/mrImzzsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+QASEi+MpybsBLdhWStKiFg82wsDNPTVOAmNX3GReQ7Q0LSrnfGkfgZ1sE4VW+yD29a4HE16WERXCJNAsUljjK7huofG1nR/Ndkj4UVVahTIaXLuhhihBPB4RTS+TGmUH6+caMY3/l6Vom3VInPGJgIGyPK5x0WJ7aJi1ancEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnsAoAQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnsAoAQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E11C4CEC4;
	Thu, 19 Sep 2024 20:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726776791;
	bh=gWqu0caasJYRq5B0Vjhqbg09uOFenaZa8N/mrImzzsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gnsAoAQhQXpT1oyxY6g1iOJY4/vm3MZyapEV91llOLG5GRQegPh0fsvEYyQ0KMAmt
	 43gZui1mo26zZEHBDCUnCfJk+QlW2xHODvSBIpSNeRkWlPJu4c8Lhm5JkXjH+HJuzl
	 A7v/9m2hSfHfWFd5NrO/uWqRnilf8Yzn1JQvvXTEl9PHVT6MXwnOajE97g0d3wG1Gj
	 TgNcyvk4jpAdnpYCNfTv0wEMMcZR2jFtMtvJTjc/wyVK7vLZ6Vqvsrseoc1BDU7LUA
	 UFK7FwPLAvsT7+xtBBYBK5w71bs88sYsMScQF0Fvu8W6RDoTMQFRhPq9nViOIaWyjp
	 vBIW1IfercQ7w==
Date: Thu, 19 Sep 2024 13:13:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: add a regression test for sub-block fsmap
 queries
Message-ID: <20240919201310.GL182218@frogsfrogsfrogs>
References: <172669301283.3083764.4996516594612212560.stgit@frogsfrogsfrogs>
 <172669301299.3083764.15063882630075709199.stgit@frogsfrogsfrogs>
 <20240919200703.xyn5tqv5knqzgiq3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919200703.xyn5tqv5knqzgiq3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Sep 20, 2024 at 04:07:03AM +0800, Zorro Lang wrote:
> On Wed, Sep 18, 2024 at 01:57:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Zizhi Wo found some bugs in the GETFSMAP implementation if it is fed
> > sub-fsblock ranges.  Add a regression test for this.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/1954     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1954.out |   15 +++++++++
> >  2 files changed, 94 insertions(+)
> >  create mode 100755 tests/generic/1954
> >  create mode 100644 tests/generic/1954.out
> > 
> > 
> > diff --git a/tests/generic/1954 b/tests/generic/1954
> > new file mode 100755
> > index 0000000000..cfdfaf15e2
> > --- /dev/null
> > +++ b/tests/generic/1954
> > @@ -0,0 +1,79 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1954
> > +#
> > +# Regression test for sub-fsblock key handling errors in GETFSMAP.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rmap fsmap
> > +
> > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > +	"xfs: Fix the owner setting issue for rmap query in xfs fsmap"
> > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > +	"xfs: Fix missing interval for missing_owner in xfs fsmap"
> 
> These 2 patches have been merged:
> 
>   68415b349f3f xfs: Fix the owner setting issue for rmap query in xfs fsmap
>   ca6448aed4f1 xfs: Fix missing interval for missing_owner in xfs fsmap
> 
> I'll help to update the commit id when I merge it.

Oops, will go fix that.

> > +
> > +. ./common/filter
> > +
> > +_require_xfs_io_command "fsmap"
> > +_require_scratch
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +
> > +blksz=$(_get_block_size "$SCRATCH_MNT")
> > +if ((blksz < 2048)); then
> > +	_notrun "test requires at least 4 bblocks per fsblock"
> 
> What if the device is hard 4k sector size?

Doesn't matter, because the bug is in converting GETFSMAP inputs that
are a multiple of 512 but not a multiple of $fsblocksize.

> > +fi
> > +
> > +$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
> > +
> > +find_freesp() {
> > +	$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | tr '.[]:' '    ' | \
> > +		grep 'free space' | awk '{printf("%s:%s\n", $4, $5);}' | \
> > +		head -n 1
> > +}
> > +
> > +filter_fsmap() {
> > +	_filter_xfs_io_numbers | sed \
> > +		-e 's/inode XXXX data XXXX..XXXX/inode data/g' \
> > +		-e 's/inode XXXX attr XXXX..XXXX/inode attr/g' \
> > +		-e 's/: free space XXXX/: FREE XXXX/g' \
> > +		-e 's/: [a-z].*XXXX/: USED XXXX/g'
> 
> As this's a generic test case, I tried it on btrfs and ext4. btrfs got
> _notrun "xfs_io fsmap support is missing", ext4 got failure as:
> 
>   # diff -u /root/git/xfstests/tests/generic/1954.out /root/git/xfstests/results//default/generic/1954.out.bad
>   --- /root/git/xfstests/tests/generic/1954.out   2024-09-20 03:51:02.545504285 +0800
>   +++ /root/git/xfstests/results//default/generic/1954.out.bad    2024-09-20 03:58:51.505271227 +0800
>   @@ -1,15 +1,11 @@
>    QA output created by 1954
>    test incorrect setting of high key
>   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
>    test missing free space extent
>           XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
>    test whatever came before freesp
>   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
>    test whatever came after freesp
>   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
>    test crossing start of freesp
>           XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
>           XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
>    test crossing end of freesp
>           XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
>   -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX

Yep, we'll still have to patch ext4 for this.  btrfs doesn't support
GETFSMAP.

--D

> Thanks,
> Zorro
> 
> > +}
> > +
> > +$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | filter_fsmap >> $seqres.full
> > +
> > +freesp="$(find_freesp)"
> > +
> > +freesp_start="$(echo "$freesp" | cut -d ':' -f 1)"
> > +freesp_end="$(echo "$freesp" | cut -d ':' -f 2)"
> > +echo "$freesp:$freesp_start:$freesp_end" >> $seqres.full
> > +
> > +echo "test incorrect setting of high key"
> > +$XFS_IO_PROG -c 'fsmap -d 0 3' $SCRATCH_MNT | filter_fsmap
> > +
> > +echo "test missing free space extent"
> > +$XFS_IO_PROG -c "fsmap -d $((freesp_start + 1)) $((freesp_start + 2))" $SCRATCH_MNT | \
> > +	filter_fsmap
> > +
> > +echo "test whatever came before freesp"
> > +$XFS_IO_PROG -c "fsmap -d $((freesp_start - 3)) $((freesp_start - 2))" $SCRATCH_MNT | \
> > +	filter_fsmap
> > +
> > +echo "test whatever came after freesp"
> > +$XFS_IO_PROG -c "fsmap -d $((freesp_end + 2)) $((freesp_end + 3))" $SCRATCH_MNT | \
> > +	filter_fsmap
> > +
> > +echo "test crossing start of freesp"
> > +$XFS_IO_PROG -c "fsmap -d $((freesp_start - 2)) $((freesp_start + 1))" $SCRATCH_MNT | \
> > +	filter_fsmap
> > +
> > +echo "test crossing end of freesp"
> > +$XFS_IO_PROG -c "fsmap -d $((freesp_end - 1)) $((freesp_end + 2))" $SCRATCH_MNT | \
> > +	filter_fsmap
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/1954.out b/tests/generic/1954.out
> > new file mode 100644
> > index 0000000000..6baec43511
> > --- /dev/null
> > +++ b/tests/generic/1954.out
> > @@ -0,0 +1,15 @@
> > +QA output created by 1954
> > +test incorrect setting of high key
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > +test missing free space extent
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> > +test whatever came before freesp
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > +test whatever came after freesp
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > +test crossing start of freesp
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> > +test crossing end of freesp
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> > +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> > 
> > 
> 
