Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1C12571C3;
	Tue, 29 Jul 2025 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819789; cv=none; b=fNZiS40AN8pJCVipBbQY3b+xyvL4jvLAJurGNmtrPcQgSQpBpOvmFf74SmP9ylOJj65B6U+z4JQk8ifKH3YoLkhMoqClNISUIr4h/SoemD6ysHSNUKvWIyVuZpGvt9xFmw1ye0iE/ctgLLIXRseOzqfHue8asevPK/s/tQCfr+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819789; c=relaxed/simple;
	bh=U14m81c6SpDL3KOSbnQNUlbuP1kXEcn40Irqpzq1ab8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrYEZx13O9J3w0selEw6yXQ8gmnbxY31FNuSxbm+qFH1hodvHz60DzCVPKm5hl5UBjb71BlEDjqEIKgnsxnFB6VLWJJfdl5B8HamiDxOopq9dqyG0tkidnZvAy5skKmsA7m4egmSRmreI7eNVX4QpU6MrtOQTW1QjVG6RgxSXwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCpka+Ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCpka+Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71C9C4CEEF;
	Tue, 29 Jul 2025 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819788;
	bh=U14m81c6SpDL3KOSbnQNUlbuP1kXEcn40Irqpzq1ab8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jCpka+RaIrQaCKVr37H930FztgERtAPPNRXUXlY+lN3AmTxii1FmoRXtJM9phBnw9
	 OcdkK/Pnz/ysdpLMtGDBybsn8VAYb0/zCSV4irHn86hvtdiPC+Kz2BSPGAcXIrEEZd
	 Qh7kN+YqigIMl6XbXOa5PtEURPTKESelAPk8Vy56mm0NZTow+zIlboLZaTOAc4qdwN
	 qw+Kt9N1HMFcXVCdOBiEZFXPleW1W2BoQGZnPa+VAh8sOAMQ2DOX/Rba3B+VM/9KHi
	 GjOZxlp9CNBcET46JZlQ3swnFcoVKPZqu+0fhTPYBmrCcV/UYvhA2FDtM0DvQPs9/5
	 I7lV4/O1omY6A==
Date: Tue, 29 Jul 2025 13:09:48 -0700
Subject: [PATCH 6/7] xfs/838: actually force usage of the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <175381958010.3020742.15091248211656555031.stgit@frogsfrogsfrogs>
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Actually force the filesystem to create testfile as a realtime file so
that the test does anything useful.

Cc: <fstests@vger.kernel.org> # v2025.07.13
Fixes: 7ca990e22e0d61 ("xfs: more multi-block atomic writes tests")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/838 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/838 b/tests/xfs/838
index 73e91530b53a67..84e6a750eb07ab 100755
--- a/tests/xfs/838
+++ b/tests/xfs/838
@@ -23,6 +23,7 @@ $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_xfs_force_bdev realtime $SCRATCH_MNT
 
 testfile=$SCRATCH_MNT/testfile
 touch $testfile

