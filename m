Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01641CD1B
	for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2024 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469977; cv=none; b=uhaw3q8FE5CDdJFCdO5Rjcad1PaAxW1PJD3BxJ+SP9XnbJtnsumPjyqix10k+rhmZgR5IIEKiQPBwRphTDASjiwBs2APlfbu/e4uLjRsdDbRWOOMz9swqk3yiolyU4FWFfJYDfoAQMzdhjZRKtFvYof+9SImMZRlr5fAiulfTJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469977; c=relaxed/simple;
	bh=KdpE23xZazr88GuUgSqErxCnLDFFNqY0F9QQvx+HfMo=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=rO2hZlWr0ZOmCS1/479//l0HZTQRlamlNZrnWWG0KUVemAYxlxINTnuB2i9KpdrRJQNhaQktDaFJleOR5o0lO4GvGsTO4+wRW6E/rp/s3MlKe8FDwcVtUNxeblGksCzAW8BQA2Fguzf/14aFNknQtK7Ni0TWOi3WGdGj8oFj3JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjLTK33e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjLTK33e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA08C32786;
	Thu, 27 Jun 2024 06:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719469977;
	bh=KdpE23xZazr88GuUgSqErxCnLDFFNqY0F9QQvx+HfMo=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=pjLTK33enI0FEFlqCZv9EITcSEASzRK5LQJt/M8rzN/aEMTDKGr/VrXNtdLDo9+20
	 NLLKtLPvwkHE+PWEgHipWmz7ie/LkjE8NPOkfv502dhUPBUI0bZrrGzl99tYbsVnD0
	 q9RFTby+n4XtPNs9l3c87GW5DmvvyOxEBU7la4E8flMjEnw61vDmuBfpISrRK62RLW
	 Es9O6m8zJ0rm3YG8IAuhWw86ftd5qXr4YwiUGuVx2h8IHRYGLrwSkeUNaaNm6YK+Li
	 QyLjK29ttvtS+Mnxkb4N06r//pEBmRpvoQjWFgMG6qm0+6GMugeiMrX4sWDEra6DaM
	 GmYImAnqNKuMw==
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
 <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs>
 <20240624150421.GC3058325@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2 1/1] xfs: enable FITRIM on the realtime device
Date: Thu, 27 Jun 2024 11:43:42 +0530
In-reply-to: <20240624150421.GC3058325@frogsfrogsfrogs>
Message-ID: <87y16qhp4a.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Jun 24, 2024 at 08:04:21 AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Implement FITRIM for the realtime device by pretending that it's
> "space" immediately after the data device.  We have to hold the
> rtbitmap ILOCK while the discard operations are ongoing because there's
> no busy extent tracking for the rt volume to prevent reallocations.
>

Darrick, This patch causes generic/260 to fail in configuration using a
realtime device as shown below,

export TEST_DEV=/dev/loop0
export TEST_DIR=/mnt/test
export TEST_RTDEV=/dev/loop2
export SCRATCH_DEV=/dev/loop1
export SCRATCH_MNT=/mnt/scratch
export SCRATCH_RTDEV=/dev/loop3

export USE_EXTERNAL=yes

MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'

export MKFS_OPTIONS="-i nrext64=1 -m rmapbt=0,reflink=0 -d rtinherit=1"


Here is the test execution log,

# ./check generic/260
RECREATING    -- xfs on /dev/loop0
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 fstest 6.10.0-rc5-gb62c1dbbb6cb #9 SMP PREEMPT_DYNAMIC Thu Jun 27 11:51:06 IST 2024
MKFS_OPTIONS  -- -f -rrtdev=/dev/loop3 -i nrext64=1 -m rmapbt=0,reflink=0 -d rtinherit=1 /dev/loop1
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota -ortdev=/dev/loop3 /dev/loop1 /mnt/scratch

generic/260 2s ... [failed, exit status 1]- output mismatch (see /root/repos/xfstests-dev/results//generic/260.out.bad)
    --- tests/generic/260.out   2022-01-12 11:19:21.869941572 +0530
    +++ /root/repos/xfstests-dev/results//generic/260.out.bad   2024-06-27 11:59:47.980946925 +0530
    @@ -11,4 +11,5 @@
     [+] Default length with start set (should succeed)
     [+] Length beyond the end of fs (should succeed)
     [+] Length beyond the end of fs with start set (should succeed)
    +After the full fs discard 42871967744 bytes were discarded however the file system is 21474836480 bytes long.
     Test done
    ...
    (Run 'diff -u /root/repos/xfstests-dev/tests/generic/260.out /root/repos/xfstests-dev/results//generic/260.out.bad'  to see the entire diff)
Ran: generic/260
Failures: generic/260
Failed 1 of 1 tests

-- 
Chandan
