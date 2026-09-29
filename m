Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D6B32470F;
	Tue, 29 Sep 2026 01:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646881; cv=none; b=jw4Z/QlSr1lac3tZV7WMGcHdPfuhiP/m56SoEE62RDBLUYFkbl9PC985DukPt5Eq2KhVVWDIIdXCk5He1rzKjBtFbCS1JHFfRZj+ZKgMAykj9SHh3dezD5PBELJDfk163u8aUJjg3Q82gnjR1V1+1Obj5t2bPB+Ptp34nL+LIoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646881; c=relaxed/simple;
	bh=ydjm6v7Knrk6nqgP/w8Wp210wVbT+aYm1xxtm0seZJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8QDC7vUDWWgfHkqIYeeXNErszn3xlxE67sUbEXTu265DAaSZvOZrvnZgyZR0hfZFEX7XcFKxuySeigdKfzIKFrU3Ef9McAUX+l4X9z89BXDbLRibwisP+q3I9rm3AGl566ck+/LDrEZ9DgrQBVceVKWNfemvXugsk7wRauyOW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4M0s5sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4M0s5sl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 50EBB1F000FF;
	Tue, 29 Sep 2026 01:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790646880;
	bh=ziJ3repSXhXQ6+UiV0x49S22Hjjh+gUbw5mzod4lNDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R4M0s5slRrTlbKN6VMRowdw8alm7Gxv/rJJBRIBhcDSuoXMgX/tUtKuIws8QxfiKh
	 iM1PjLn/U4O0UhoXsnMzO8Ukf7Ta4YbWoRocvz2W2TNfoPaiaZBFtL27Cw9J2HoSau
	 1Qes+QJFT4Y6KJWeupbZANToqAUEhf38C7xmby08nLpD4+fuxxPBr+9aqcadZFHOra
	 kySKFtkEfYPUIRnWmm5/GVfoeaXd0K20oqAY6h4chmiHX8ul7oPT4eEdacfLtAe0We
	 e4JL0Pp2JvR5FSTd7D3eGaF++Xn4UuTa2wjQOwL6aXyqlywmj/uvGXqJGSXKzVQabb
	 dONRbXI+UTiRQ==
Date: Mon, 28 Sep 2026 18:54:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs/2303: test that data checksums detect data
 misplacement
Message-ID: <20260929015439.GK2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-9-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:49PM +0200, Christoph Hellwig wrote:
> Test that data checksums detect data corruption due to misplacement
> by changing the backing files for two zones using the zloop driver.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2303     | 88 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2303.out |  5 +++
>  2 files changed, 93 insertions(+)
>  create mode 100755 tests/xfs/2303
>  create mode 100644 tests/xfs/2303.out
> 
> diff --git a/tests/xfs/2303 b/tests/xfs/2303
> new file mode 100755
> index 000000000000..7f53fdf94bff
> --- /dev/null
> +++ b/tests/xfs/2303
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig
> +#
> +# FS QA Test No. 2303
> +#
> +# Test that data checksums detect data corruption due to misplacement
> +# by changing the backing files for two zones using the zloop driver.
> +#
> +. ./common/preamble
> +. ./common/filter
> +. ./common/renameat2
> +. ./common/zoned
> +
> +_begin_fstest auto zone quick datacsum
> +
> +_cleanup()
> +{
> +	[ -n "$mnt" ] && _unmount $mnt 2>/dev/null
> +	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
> +	_destroy_zloop $zloop_dev
> +	cd /
> +	rm -rf $loopfile $zloopdir $mnt
> +}
> +
> +_require_test
> +_require_renameat2 "exchange"
> +_require_loop
> +_require_zloop
> +# hack to only run for block based file systems
> +_require_block_device $SCRATCH_DEV
> +
> +loopfile="$TEST_DIR/loopfile"
> +zloopdir="$TEST_DIR/zloop"
> +mnt="$TEST_DIR/mnt"
> +
> +rm -rf $loopfile $zloopdir $mnt
> +mkdir -p $mnt
> +truncate -s 1g $loopfile
> +
> +loop_dev=$(_create_loop_device $loopfile)
> +zloop_dev=$(_create_zloop $zloopdir 256 0)
> +zloop_id=$(echo $zloop_dev | grep -oE '[0-9]+$')
> +
> +_try_mkfs_dev $loop_dev -r rtdev=$zloop_dev,csum=crc32c \
> +	>> $seqres.full 2>&1 || \
> +	_notrun "cannot mkfs filesystem with data checksums"
> +_mount $loop_dev -o rtdev=$zloop_dev $mnt
> +
> +dd if=/dev/urandom of=$mnt/file1 bs=4k count=1 conv=fsync >/dev/null 2>&1
> +dd if=/dev/zero of=$mnt/file2 bs=4k count=1 conv=fsync >/dev/null 2>&1
> +
> +xfs_bmap -v $mnt/file1 >> $seqres.full 2>&1
> +xfs_bmap -v $mnt/file2 >> $seqres.full 2>&1
> +
> +rg1=`xfs_bmap -v $mnt/file1 | head -n 3 | _filter_bmap_gno`
> +rg2=`xfs_bmap -v $mnt/file2 | head -n 3 | _filter_bmap_gno`
> +if [ "$rg1" == "$rg2" ]; then
> +	_fail "both files placed in same RG: $rg1 $rg2"
> +fi
> +
> +zloop_filename1=$(printf "seq-%06u\n" $rg1)
> +backing_file1="$zloopdir/$zloop_id/$zloop_filename1"
> +zloop_filename2=$(printf "seq-%06u\n" $rg2)
> +backing_file2="$zloopdir/$zloop_id/$zloop_filename2"
> +
> +_unmount $mnt 2>/dev/null
> +_destroy_zloop $zloop_dev
> +
> +# intentionally corrupt data by swapping the two zone files
> +ls -i $backing_file1 $backing_file2 >> $seqres.full
> +echo "swapping file $backing_file1 and $backing_file2" >> $seqres.full
> +$here/src/renameat2 -x $backing_file1 $backing_file2
> +ls -i $backing_file1 $backing_file2 >> $seqres.full

Heh, this is an amusing way to induce a data checksum verification
failure -- switching the zone backing files. :)  Given that one of the
previous tests directly writes to the rt dev I think this one is less
important, but I guess that's one way to simulate an evil-maid device.

(Same nitpicks as the previous test)

--D

> +
> +zloop_dev=$(_create_zloop $zloopdir 256 0)
> +zloop_id=$(echo $zloop_dev | grep -oE '[0-9]+$')
> +_mount $loop_dev -o rtdev=$zloop_dev $mnt
> +
> +# should return an error on buffered read
> +echo "Reading file1 using cat - should fail"
> +cat $mnt/file1 > /dev/null | _filter_test_dir
> +
> +# same with direct I/O
> +echo "Reading file2 using O_DIRECT - should fail"
> +xfs_io -d $mnt/file2 -c 'pread 0 200M' | _filter_test_dir
> +
> +_exit 0
> diff --git a/tests/xfs/2303.out b/tests/xfs/2303.out
> new file mode 100644
> index 000000000000..fca2c4830e3c
> --- /dev/null
> +++ b/tests/xfs/2303.out
> @@ -0,0 +1,5 @@
> +QA output created by 2303
> +Reading file1 using cat - should fail
> +cat: /mnt/test/mnt/file1: Input/output error
> +Reading file2 using O_DIRECT - should fail
> +pread: Input/output error
> -- 
> 2.53.0
> 
> 
