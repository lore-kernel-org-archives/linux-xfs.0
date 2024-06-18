Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB640322B;
	Tue, 18 Jun 2024 00:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718672102; cv=none; b=U9/a58w18KHkf1NaLAFxDZFhdT/ENwt8w8a7MZqc1DL/x28qhqfG0nrCVshbi0GPlTxWQA7NzDlrp4z8ae+unZD67S8Qos40MrGp4rsAeZEh3xc8TdoEbKyDB3AmSuHgMGMRKpUj70ajCUXs20qG6DpAy5/bMcCQXPZVSk6F/o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718672102; c=relaxed/simple;
	bh=B2/b1isobI7kYHVmPp0Ow8YfRNx6sz9Sbr08YhjCMF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGYMkGsVxtCH6Lhit1M5/fbVKhI9K1NGEmAfJyTKi8ZT75O6CegYwuVMUnYPArq6JX9vZYMZM3BejhbpwrQY92y+PHtHU4llEbTLH7MeleYTmSQYs5HzUWalkvYw6GfLpIzjAY3/7uekY5I5HiBXmK6FRFEdLdOxnVr6jD5a6Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vu4K7UAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vu4K7UAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593DAC2BD10;
	Tue, 18 Jun 2024 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718672101;
	bh=B2/b1isobI7kYHVmPp0Ow8YfRNx6sz9Sbr08YhjCMF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vu4K7UAEeExW/FiIT+KEFVU/fc0I5fcJWixzELeSpJBTLCM0l99lGBlIIv3OClb41
	 pCg6W+tKBtwj/ARWfX3u7Ju4o1rantrXFOot4GaXUvcFc8l3e/iQi8AtIH0xjp8Wfn
	 acTqilFZBkRoDfUHflOn47eLPiH0Yn1vCXNzkCv+qzBgzWQc1skmFJaKkcfGwuha+5
	 AdRo+xHNcJZmLGtH28E5hapxzQYOd8Jzdh2CvEriUXmfLb1SGYLRaQK+uGhTpXWBBB
	 2lqdYnmVevryPcwT5vVflI2trX/YArzze38nn1M9yes8LIC3ZUcKin7EpfnNVikEoK
	 jsgZ/XwWypsUA==
Date: Mon, 17 Jun 2024 17:55:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  38de567906: xfstests.xfs.348.fail
Message-ID: <20240618005500.GC103057@frogsfrogsfrogs>
References: <202406171629.fa23d1c3-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202406171629.fa23d1c3-oliver.sang@intel.com>

On Mon, Jun 17, 2024 at 04:49:07PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "xfstests.xfs.348.fail" on:
> 
> commit: 38de567906d95c397d87f292b892686b7ec6fbc3 ("xfs: allow symlinks with short remote targets")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

Known bug in fstests, will send patch asap...

--D

> [test failed on linus/master      8a92980606e3585d72d510a03b59906e96755b8a]
> [test failed on linux-next/master d35b2284e966c0bef3e2182a5c5ea02177dd32e4]
> 
> in testcase: xfstests
> version: xfstests-x86_64-98379713-1_20240603
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: xfs
> 	test: xfs-348
> 
> 
> 
> compiler: gcc-13
> test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202406171629.fa23d1c3-oliver.sang@intel.com
> 
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20240617/202406171629.fa23d1c3-oliver.sang@intel.com
> 
> 
> 2024-06-07 08:32:34 export TEST_DIR=/fs/sda1
> 2024-06-07 08:32:34 export TEST_DEV=/dev/sda1
> 2024-06-07 08:32:34 export FSTYP=xfs
> 2024-06-07 08:32:34 export SCRATCH_MNT=/fs/scratch
> 2024-06-07 08:32:34 mkdir /fs/scratch -p
> 2024-06-07 08:32:34 export SCRATCH_DEV=/dev/sda4
> 2024-06-07 08:32:34 export SCRATCH_LOGDEV=/dev/sda2
> 2024-06-07 08:32:34 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
> 2024-06-07 08:32:34 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
> 2024-06-07 08:32:34 echo xfs/348
> 2024-06-07 08:32:34 ./check xfs/348
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.10.0-rc1-00005-g38de567906d9 #1 SMP PREEMPT_DYNAMIC Fri Jun  7 04:48:02 CST 2024
> MKFS_OPTIONS  -- -f /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /fs/scratch
> 
> xfs/348       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/348.out.bad)
>     --- tests/xfs/348.out	2024-06-03 12:10:00.000000000 +0000
>     +++ /lkp/benchmarks/xfstests/results//xfs/348.out.bad	2024-06-07 08:33:19.134137710 +0000
>     @@ -240,7 +240,7 @@
>      would have junked entry "EMPTY" in directory PARENT_INO
>      would have junked entry "FIFO" in directory PARENT_INO
>      stat: cannot statx 'SCRATCH_MNT/test/DIR': Structure needs cleaning
>     -stat: cannot statx 'SCRATCH_MNT/test/DATA': Structure needs cleaning
>     +stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
>      stat: cannot statx 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
>      stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/348.out /lkp/benchmarks/xfstests/results//xfs/348.out.bad'  to see the entire diff)
> Ran: xfs/348
> Failures: xfs/348
> Failed 1 of 1 tests
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
