Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D7E6FB0;
	Thu, 18 Apr 2024 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452151; cv=none; b=jhiOjwryB7LQuG4QAqYZFVIayTBtnSFJzFGeUAmbWQ4qybdxsYEj8a+i3PwySjRQP7XdLhtPV3qL2HPfCIE3MZ6CB1vSJzUSfR2ykPjQ5XhRrUrJu2xgG7M4sqoWv2g+MS5s76INf9WBjvZiesjRS4AHDEpt7aIadKhVYABLMOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452151; c=relaxed/simple;
	bh=Zxjq73avWmiu7xkyhYX6hSNq1YU+LPkAx5wt+wcppDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sc9ZTlyBN4pl0YgaaaTbcUu3jsiNVVbbEjD9WYFclAUuYx5VkNfgMixWUcbsbwuI+6aSxDBPBjo94FGCsx0tT4tDkoBFetqUMprCfKsLY3+TsVXRzLr8xiZRUcWvkYM+VgCXb65PWUAIYx3+HfZjCDJVL3FTNLrsvOjf8XSHSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ5SK1r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ5SK1r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0C0C113CC;
	Thu, 18 Apr 2024 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713452150;
	bh=Zxjq73avWmiu7xkyhYX6hSNq1YU+LPkAx5wt+wcppDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EZ5SK1r/8IAd3v4/skEHvQg0Fhq4vwIqwk2IDqPj4jk+1nfsk7DaoYp9InRFnS/I9
	 zFZSsurFcJmzIpw+Ye0aymEcET3A9acaO4/xS/jDkz2nh14cKPUvSVzoEkHabvJTFv
	 1BZxJp4/2dTk9pl6Sr/zya0FXhvSuIkPHUlXfdaLg/hMNqwT6yMrt9HVvfuEDM5rhd
	 YB5kDQUR7+0Ihs8o2MvmJAbbH1amdMlWdMoiOmSC6mJVJiqHHnzEdsMzi7Mryq56OI
	 xuiWLDjqBpF6t6tIXClzcUWqhCU5pCJCKD1t9+xv+W9IZA6Jm9SvvtD+RHKPjnhbaP
	 A348jkOQC3spg==
Date: Thu, 18 Apr 2024 07:55:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs/263: split out the v4 test
Message-ID: <20240418145550.GG11948@frogsfrogsfrogs>
References: <20240418074046.2326450-1-hch@lst.de>
 <20240418074046.2326450-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418074046.2326450-3-hch@lst.de>

On Thu, Apr 18, 2024 at 09:40:43AM +0200, Christoph Hellwig wrote:
> Move the v4-specific test into a separate test case so that we can still
> run the tests on a kernel without v4 support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Awwright!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/096     | 73 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/096.out | 84 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/263     |  5 ---
>  tests/xfs/263.out | 85 -----------------------------------------------
>  4 files changed, 157 insertions(+), 90 deletions(-)
>  create mode 100755 tests/xfs/096
>  create mode 100644 tests/xfs/096.out
> 
> diff --git a/tests/xfs/096 b/tests/xfs/096
> new file mode 100755
> index 000000000..7eff6cb1d
> --- /dev/null
> +++ b/tests/xfs/096
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 096
> +#
> +# test xfs_quota state command (XFS v4 version)
> +#
> +. ./common/preamble
> +_begin_fstest auto quick quota
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/quota
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +
> +_require_scratch
> +_require_xfs_quota
> +
> +function option_string()
> +{
> +	VAL=$1
> +	# Treat 3 options as a bit field, prjquota|grpquota|usrquota
> +	OPT="rw"
> +	if [ "$((VAL & 4))" -ne "0" ]; then OPT=prjquota,${OPT}; fi;
> +	if [ "$((VAL & 2))" -ne "0" ]; then OPT=grpquota,${OPT}; fi;
> +	if [ "$((VAL & 1))" -ne "0" ]; then OPT=usrquota,${OPT}; fi;
> +	echo $OPT
> +}
> +
> +filter_quota_state() {
> +	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' \
> +	    -e '/max warnings:/d' \
> +	    -e '/Blocks grace time:/d' \
> +	    -e '/Inodes grace time:/d' \
> +		| _filter_scratch
> +}
> +
> +filter_quota_state2() {
> +	sed -e '/User quota state on/d' \
> +	    -e '/ Accounting: /d' \
> +	    -e '/ Enforcement: /d' \
> +	    -e '/ Inode: /d' \
> +	    -e '/Blocks max warnings: /d' \
> +	    -e '/Inodes max warnings: /d' \
> +		| _filter_scratch
> +}
> +
> +function test_all_state()
> +{
> +	for I in `seq 0 7`; do
> +		OPTIONS=`option_string $I`
> +		echo "== Options: $OPTIONS =="
> +		# Some combinations won't mount on V4 supers (grp + prj)
> +		_qmount_option "$OPTIONS"
> +		_try_scratch_mount &>> $seqres.full || continue
> +		$XFS_QUOTA_PROG -x -c "state -u" $SCRATCH_MNT | filter_quota_state
> +		$XFS_QUOTA_PROG -x -c "state -g" $SCRATCH_MNT | filter_quota_state
> +		$XFS_QUOTA_PROG -x -c "state -p" $SCRATCH_MNT | filter_quota_state
> +		$XFS_QUOTA_PROG -x -c "state -u" $SCRATCH_MNT | filter_quota_state2
> +		_scratch_unmount
> +	done
> +}
> +
> +_scratch_mkfs_xfs "-m crc=0 -n ftype=0" >> $seqres.full
> +test_all_state
> +
> +status=0
> +exit
> diff --git a/tests/xfs/096.out b/tests/xfs/096.out
> new file mode 100644
> index 000000000..1deb7a8c3
> --- /dev/null
> +++ b/tests/xfs/096.out
> @@ -0,0 +1,84 @@
> +QA output created by 096
> +== Options: rw ==
> +== Options: usrquota,rw ==
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode: N/A
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode: N/A
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]
> +== Options: grpquota,rw ==
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode #XXX (1 blocks, 1 extents)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode: N/A
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]
> +== Options: usrquota,grpquota,rw ==
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode: N/A
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]
> +== Options: prjquota,rw ==
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode #XXX (1 blocks, 1 extents)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode: N/A
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]
> +== Options: usrquota,prjquota,rw ==
> +User quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: OFF
> +  Enforcement: OFF
> +  Inode: N/A
> +Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> +  Accounting: ON
> +  Enforcement: ON
> +  Inode #XXX (1 blocks, 1 extents)
> +Blocks grace time: [7 days]
> +Inodes grace time: [7 days]
> +Realtime Blocks grace time: [7 days]
> +== Options: grpquota,prjquota,rw ==
> +== Options: usrquota,grpquota,prjquota,rw ==
> diff --git a/tests/xfs/263 b/tests/xfs/263
> index bd30dab11..54e9355aa 100755
> --- a/tests/xfs/263
> +++ b/tests/xfs/263
> @@ -66,11 +66,6 @@ function test_all_state()
>  	done
>  }
>  
> -echo "==== NO CRC ===="
> -_scratch_mkfs_xfs "-m crc=0 -n ftype=0" >> $seqres.full
> -test_all_state
> -
> -echo "==== CRC ===="
>  _scratch_mkfs_xfs "-m crc=1" >>$seqres.full
>  test_all_state
>  
> diff --git a/tests/xfs/263.out b/tests/xfs/263.out
> index 531d45de5..64c1a5876 100644
> --- a/tests/xfs/263.out
> +++ b/tests/xfs/263.out
> @@ -1,89 +1,4 @@
>  QA output created by 263
> -==== NO CRC ====
> -== Options: rw ==
> -== Options: usrquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: grpquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: usrquota,grpquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: prjquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: usrquota,prjquota,rw ==
> -User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Group quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: OFF
> -  Enforcement: OFF
> -  Inode: N/A
> -Project quota state on SCRATCH_MNT (SCRATCH_DEV)
> -  Accounting: ON
> -  Enforcement: ON
> -  Inode #XXX (1 blocks, 1 extents)
> -Blocks grace time: [7 days]
> -Inodes grace time: [7 days]
> -Realtime Blocks grace time: [7 days]
> -== Options: grpquota,prjquota,rw ==
> -== Options: usrquota,grpquota,prjquota,rw ==
> -==== CRC ====
>  == Options: rw ==
>  == Options: usrquota,rw ==
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
> -- 
> 2.39.2
> 
> 
