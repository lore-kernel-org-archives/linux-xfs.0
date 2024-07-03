Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE71191F83
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720042868; cv=none; b=agP662a+d0cj6zxjjNU5N4kpqLhCuUO2yCHPpjv04q2u3T1taNBBFnGC0tIo/bR62xbSOkbTIacUdrh9PKLZsyMtZmlSTbobDe82RvInrpdyywo35JTMmyZGCW92TCPCWbFkkYFW1Oj30gsVqSF+xOGXNuCUSkU7ySpBpHRFz/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720042868; c=relaxed/simple;
	bh=AYOOSL7W0uKzZRbb1C8gXxmaJ90JPSqqLnVnBK+Vvwk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=lGxeoqodNSzEFgyjm1eT2NL4ULzy19jjaEMEVzuq8HDm55PAZlqRs1mSi0RkoIxeJNRt35g9Aw0OCnUdt2XOsOeAQoHPrG7aW05i2VN6UN/zk/Yz+CJZ46L8nrvnh1hO4NfV8F1PmR60oEgTmakeOUbxlFFCpQpu0tOuyoxaTGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGPUfj7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGPUfj7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43772C2BD10;
	Wed,  3 Jul 2024 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720042868;
	bh=AYOOSL7W0uKzZRbb1C8gXxmaJ90JPSqqLnVnBK+Vvwk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rGPUfj7bPMOHfi0NdVcV3S9zBeOlCS9Onqe55DxSEs7S9eY/cCgOFPCzC/fOaKgxl
	 ADnFBBJUJXUC/2/f5BAMGrNplgT/1SxA3mUWy9zui1TBswsDOtupDMp9ajXzP+pxsT
	 /5epp7Rm3GLqKPucKkysZUQZ2tLpRPqv8HWY6Bs1N2n35RWrMZzuLB+Cpf+EQrG/15
	 3+tMjW54FOs424zlhqfKF5Dnpm3/Snkarc91l0JhPwnvkVw5fEjGKlSnRGtnPvyxA+
	 tnfnwEniiKqUuKomS2GrT5Y3nvfVCj6HFw3mb4Vvkm3A8ce3yI9PeCZw/elAaFEwWb
	 8aZ/bpTt5ATpg==
Date: Wed, 03 Jul 2024 14:41:07 -0700
Subject: [GIT PULL 4/4] xfs: refcount log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004279580.3366224.3607002379116232640.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240703211310.GJ612460@frogsfrogsfrogs>
References: <20240703211310.GJ612460@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ea7b0820d960d5a3ee72bc67cbd8b5d47c67aa4c:

xfs: move xfs_rmap_update_defer_add to xfs_rmap_item.c (2024-07-02 11:37:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/refcount-intent-cleanups-6.11_2024-07-02

for you to fetch changes up to 783e8a7c9cab6744ebc5dfe75081248ac39181b2:

xfs: move xfs_refcount_update_defer_add to xfs_refcount_item.c (2024-07-02 11:37:07 -0700)

----------------------------------------------------------------
xfs: refcount log intent cleanups [v3.0 4/4]

This series cleans up the refcount intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (10):
xfs: give refcount btree cursor error tracepoints their own class
xfs: create specialized classes for refcount tracepoints
xfs: pass btree cursors to refcount btree tracepoints
xfs: clean up refcount log intent item tracepoint callsites
xfs: remove xfs_trans_set_refcount_flags
xfs: add a ci_entry helper
xfs: reuse xfs_refcount_update_cancel_item
xfs: don't bother calling xfs_refcount_finish_one_cleanup in xfs_refcount_finish_one
xfs: simplify usage of the rcur local variable in xfs_refcount_finish_one
xfs: move xfs_refcount_update_defer_add to xfs_refcount_item.c

fs/xfs/libxfs/xfs_refcount.c | 150 +++++++++-------------------
fs/xfs/libxfs/xfs_refcount.h |  11 ++-
fs/xfs/xfs_refcount_item.c   | 107 ++++++++++----------
fs/xfs/xfs_refcount_item.h   |   5 +
fs/xfs/xfs_trace.c           |   1 +
fs/xfs/xfs_trace.h           | 229 ++++++++++++++++++++-----------------------
6 files changed, 222 insertions(+), 281 deletions(-)

