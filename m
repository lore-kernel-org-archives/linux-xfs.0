Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861B231842
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 17:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770399486; cv=none; b=VmgxL65aVgSYRcXzqiTAbEhl0OKS/V1A8WLLrGKufK2drUSiFZcebD/PIyMZITLpwUt5B7Ly83Qfc8w5r3VWIaXdhWjqscBn0lF3QXpsTjQIq3ePSO1IHOEX+AhuM/b7ZTJaaDyOSayaeJ817jZnIw5scGEKTUdeQdjXQbORxGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770399486; c=relaxed/simple;
	bh=Krv90QfUmppb/+yGhc4V66VNTIEdH25mcsuM9wFbTFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hq7SkDeVDkHUIIJW9OA9YIl/HQiitFBniH+Oto5wDzut1UUqLdT4o+xxJuCIFE14iuLWYc2KSE2ElTVZ+jYYPMqhqNy2yfwpUF8EgsU1nd7QN2rKiv72vEakjV3obE/tYryBFfphM6jYUSWBbLbknAv/+tOVkXUVI8YpCRtkpuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhUq6AxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhUq6AxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C8DC116C6;
	Fri,  6 Feb 2026 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770399486;
	bh=Krv90QfUmppb/+yGhc4V66VNTIEdH25mcsuM9wFbTFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mhUq6AxGbw7kJRF7d/gWfBQA5lWKsYxRi45geSoADwBCb9YjG+/1ApnxsFG3nFMqx
	 pEWKUW29TF86vu3W9n/CNlR2d/C5UeEe/F3sWqfvYD3YmQeLgA3TBPjRcHzaF3vSmR
	 23kXfouSXolL1ubiUT7maxxD3dEYnlIos27GgPDnsejcGyvhjfcX2oAXpp/3M/zQPQ
	 gmnnFCCWwcYq/rLC//vV2WO3oJ/Bb6d+2ETku9MQggqN0nvTmwMDslA4XCMwaIYqRY
	 RX9D8Vco/9sxGU1jgnUIL+EO646/zOWBcBiUm0Qc+dWZ+Nc82juAhArvqmB633/vdx
	 rOi6cIu1CBC6A==
Date: Fri, 6 Feb 2026 09:38:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Message-ID: <20260206173805.GY7712@frogsfrogsfrogs>
References: <aYWobEmDn0jSPzqo@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYWobEmDn0jSPzqo@shinmob>

On Fri, Feb 06, 2026 at 08:40:07AM +0000, Shinichiro Kawasaki wrote:
> Hello Darrick,
> 
> Recently, my fstests run for null_blk (8GiB size) as SCRATCH_DEV failed at
> xfs/802 [3]. I took a look and observed following points:
> 
> 1) xfs_scrub_all command ran as expected. Even though SCRATCH_DEV is mounted,
>    it did not scrub SCRATCH_DEV. Hence the failure.
> 2) xfs_scrub_all uses lsblk command to list all mounted xfs filesystems [1].
>    However, lsblk command does not report that SCRATCH_DEV is mounted as xfs.
> 3) I leanred that lsblk command refers to udev database [2], and udev database
>    sometimes fails to update the filesystem information. This is the case for
>    the null_blk as SCRATCH_DEV on my test nodes.

Hrm.  I wonder if we're starting xfs_scrub_all too soon after the
_scratch_cycle_mount?  It's possible that if udev is running slowly,
it won't yet have poked blkid to update its cache, in which case lsblk
won't show it.

If you add _udev_wait after _scratch_cycle_mount, does the "Health
status has not beel collected" problem go away?  I couldn't reproduce
this specific problem on my test VMs, but the "udev hasn't caught up and
breaks fstests" pattern is very familiar. :/

> Based on these observations, I think there are two points to improve:
> 
> 1) I found "blkid -p" command reports that null_blk is mounted as xfs, even when
>    lsblk does not report it. I think xfs_scrub_all can be modified to use
>    "blkid -p" instead of lsblk to find out xfs filesystems mounted.
> 2) When there are other xfs filesystems on the test node than TEST_DEV or
>    SCRATCH_DEV, xfs_scrub_all changes the status of them. This does not sound
>    good to me since it affects system status out of the test targets block
>    devices. I think he test case can be improved to check that there is no other
>    xfs filesystems mounted other than TEST_DEV or SCRATCH_DEV/s. If not, the
>    test case should be skipped.

I wonder if a better solution would be to add to xfs_scrub_all a
--restrict $SCRATCH_MNT --restrict $TEST_DIR option so that it ignores
mounts that aren't under test?

--D

> At this moment, I don't have time to create patches for the improvements above.
> If anyone can work on them, it will be appreciated.
> 
> [1] https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub_all.py.in#n55
> [2] https://unix.stackexchange.com/questions/642598/lsblk-file-system-type-not-appears-from-lsblk#642600
> 
> [3] xfs/802 failure console message
> 
> xfs/802            - output mismatch (see /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/802.out.bad)
>     --- tests/xfs/802.out       2026-02-04 20:44:52.254221182 +0900
>     +++ /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/802.out.bad  2026-02-06 17:04:24.336536185 +0900
>     @@ -2,4 +2,7 @@
>      Format and populate
>      Scrub Scratch FS
>      Scrub Everything
>     +Health status has not been collected for this filesystem.
>     +Please run xfs_scrub(8) to remedy this situation.
>     +cannot find evidence that /var/kts/scratch was scrubbed
>      Scrub Done
>     ...
>     (Run 'diff -u /home/shin/kts/kernel-test-suite/src/xfstests/tests/xfs/802.out /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/802.out.bad'  to see the entire diff)
