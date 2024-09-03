Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121091A0BC6;
	Tue,  3 Sep 2024 09:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725357556; cv=none; b=Fxp+a08voG1NuftbvqmqWUzbUmGJGp7jGePU5Q1wRlOMfVNWtkGLAxWmdxCeSrU2kmAQ1nX0K3cRYSBoDUcvpSMEkmTwmX17XlpQfq63M7JvxJ3G0kYk+RDIUdRMH1EuR2CRsKYm5nB9qBHOWZux4jFY8zf9DgvfPOz555EmKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725357556; c=relaxed/simple;
	bh=92HOKrc+FF3iMGsMq6TdS8V0rw2rCv+/h4iwd8p1KBY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=pPMiDAs557ofOu4NFWCSwWsJAyWEwbV5oVJrIO9yFA+7BVneJFH/SGQ4tsx1Or9HHcOArbHLZ44pRaM0/121KMWHVuVt0Z01ilAaT5qE5UQQMr5vikuJoJj+RcqyiCCdbuV3cyxwEPiX+AuJFFLCV4GitWzYKhPmBfmDeUm6I3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OepdFj+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OepdFj+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D5DC4CEC4;
	Tue,  3 Sep 2024 09:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725357555;
	bh=92HOKrc+FF3iMGsMq6TdS8V0rw2rCv+/h4iwd8p1KBY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=OepdFj+cGeEAv7ArruHtbA5Yh0E0bzUXw1hzh0ryRjgql/WjT9jLmSksMFHarWu9Q
	 XgEL5vDOZR3NuzcS5wvZZY9+sxNVf8Ac8gYuBXcwSqE+PM+VjI7u05xd/mDWv1v2qF
	 uT4nJHlBQiKDgPjEpIeLxCKZHJNawfAsc5/9arAVPHU2t9UQOKHHvI5tXXf56R250g
	 90h0yv46vjQ7dWP25ciXvdiHYBRdTJJQbLnVOfN1SfH210cLAnl44pMc1CahTHfH+5
	 kGDIag4u06zOilNpFebg8u9qHNER4bpXQAimFX36COrD1iT9fv/Ivk/iOp4Bjz8kex
	 ljm2R4hIXscFw==
References: <202409031358.2c34ad37-oliver.sang@intel.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Zizhi Wo <wozizhi@huawei.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
 linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs] ca6448aed4: xfstests.xfs.556.fail
Date: Tue, 03 Sep 2024 15:17:04 +0530
In-reply-to: <202409031358.2c34ad37-oliver.sang@intel.com>
Message-ID: <87cyllys5s.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Sep 03, 2024 at 01:18:35 PM +0800, kernel test robot wrote:
> Hello,
>
> kernel test robot noticed "xfstests.xfs.556.fail" on:
>
> commit: ca6448aed4f10ad88eba79055f181eb9a589a7b3 ("xfs: Fix missing interval for missing_owner in xfs fsmap")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>
> [test failed on linus/master      431c1646e1f86b949fa3685efc50b660a364c2b6]
> [test failed on linux-next/master 985bf40edf4343dcb04c33f58b40b4a85c1776d4]
>
> in testcase: xfstests
> version: xfstests-x86_64-d9423fec-1_20240826
> with following parameters:
>
> 	disk: 4HDD
> 	fs: xfs
> 	test: xfs-556
>
>
>
> compiler: gcc-12
> test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202409031358.2c34ad37-oliver.sang@intel.com
>
> 2024-09-01 09:27:55 export TEST_DIR=/fs/sda1
> 2024-09-01 09:27:55 export TEST_DEV=/dev/sda1
> 2024-09-01 09:27:55 export FSTYP=xfs
> 2024-09-01 09:27:55 export SCRATCH_MNT=/fs/scratch
> 2024-09-01 09:27:55 mkdir /fs/scratch -p
> 2024-09-01 09:27:55 export SCRATCH_DEV=/dev/sda4
> 2024-09-01 09:27:55 export SCRATCH_LOGDEV=/dev/sda2
> 2024-09-01 09:27:55 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
> 2024-09-01 09:27:55 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
> 2024-09-01 09:27:55 echo xfs/556
> 2024-09-01 09:27:55 ./check xfs/556
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.11.0-rc5-00007-gca6448aed4f1 #1 SMP PREEMPT_DYNAMIC Sun Sep  1 16:52:26 CST 2024
> MKFS_OPTIONS  -- -f /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /fs/scratch
>
> xfs/556       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/556.out.bad)
>     --- tests/xfs/556.out	2024-08-26 19:09:50.000000000 +0000
>     +++ /lkp/benchmarks/xfstests/results//xfs/556.out.bad	2024-09-01 09:28:17.532120817 +0000
>     @@ -1,12 +1,21 @@
>      QA output created by 556
>      Scrub for injected media error (single threaded)
>     +Corruption: disk offset 106496: media error in unknown owner. (phase6.c line 400)
>      Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
>      SCRATCH_MNT: unfixable errors found: 1
>     +SCRATCH_MNT: corruptions found: 1
>     +SCRATCH_MNT: Unmount and run xfs_repair.
>     ...
>     (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/556.out /lkp/benchmarks/xfstests/results//xfs/556.out.bad'  to see the entire diff)
> Ran: xfs/556
> Failures: xfs/556
> Failed 1 of 1 tests

Hi,

I am unable to recreate the failure reported above. I am using xfsprogs v6.9.0
and Linux kernel v6.11-rc6 on my test system.

I am using a test environment created by Kdevops. However, I have made sure
that SCRATCH_XFS_LIST_METADATA_FIELDS and SCRATCH_XFS_LIST_FUZZ_VERBS are set
to values mentioned in the above bug report.

# uname -r
6.11.0-rc6

# xfs_repair -V
xfs_repair version 6.9.0

# ./naggy-check.sh --section xfs_reflink_modified -c 1 xfs/556
SCRATCH_XFS_LIST_METADATA_FIELDS = u3.sfdir3.hdr.parent.i4
SCRATCH_XFS_LIST_FUZZ_VERBS = random
SECTION       -- xfs_reflink_modified
RECREATING    -- xfs on /dev/loop16
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xfs-reflink 6.11.0-rc6 #2 SMP PREEMPT_DYNAMIC Tue Sep  3 09:34:50 GMT 2024
MKFS_OPTIONS  -- -f /dev/loop5
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop5 /media/scratch

xfs/556 6s ...  5s
Ran: xfs/556
Passed all 1 tests

SECTION       -- xfs_reflink_modified
=========================
Ran: xfs/556
Passed all 1 tests

naggy-check.sh is a wrapper around xfstests' "check" script. I have modified
it to print the values of the environment variables
SCRATCH_XFS_LIST_METADATA_FIELDS and SCRATCH_XFS_LIST_FUZZ_VERBS.

-- 
Chandan
