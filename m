Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7183CEEA5;
	Tue, 18 Jun 2024 00:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671653; cv=none; b=AsQdi5+cFRdLVM9mlqtTUosiW/Hjc6mqaGHRhmWlbEL7GY0A4oVAh+w+DdcZREvdLQmann8B+60tv1bok6QaW9IJqe8UWICm0sdQCoiIR0TAjcsUle+UhAzd4TJ2JI5KJldVN/tXAg53RMGpwVCNP4lWFydh/37aFGhJiTJ982g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671653; c=relaxed/simple;
	bh=V9gOnn5BI/UZmY8z2G5WlT1v9755M5sAcx7olObhYMo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fsifp75fm9LbD2zLdkdt33bnPv1n1AypojR0UV43ymrkKH3s2SVb/7cIIskh83pXVFiKnBEcjs39P6AzivxroqfI2R4QXWtWZG6D8Fky0EFf4LB6aA6mvTXM4lcEsCg1IdkNOO5C08GJ4MDamwgtunkqPhujV3n+cCRJt5Yif00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/W5WLh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/W5WLh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0346EC2BD10;
	Tue, 18 Jun 2024 00:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671653;
	bh=V9gOnn5BI/UZmY8z2G5WlT1v9755M5sAcx7olObhYMo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V/W5WLh8IIIoz1M0vvhWh3HsqJBKOaOAUoz05ZyFpvL3N0RfXV5rP7xYy/jCY2CnV
	 6NcU09gLE8HiqXxqyfzNQ1AHbIKeWHAbLvIReBbbTXrNyNYqTCVuen7zKWBuKLPPn4
	 KsS7AYDpC9IEgdbyHXu0SHlz5zjuqXmFdmMQdGGQN3MsLTToBYUmEgYru6i/AwUG0Q
	 94mrykPXsuCJnNHw+oQq0RFCUfrzE7pub0jM9AaxkkMEMmqFEXfKK1Va7ks7yWcOqX
	 Ug6os0JLhbw2Rom6BaRL/B3hUSd8sCNCn7RB/FOu4Wu2YX8FfFwMw77iOE0YrvYQDK
	 5z07ZCv/0Y3iw==
Date: Mon, 17 Jun 2024 17:47:32 -0700
Subject: [PATCH 03/10] generic/710: repurpose this for exchangerange vs. quota
 testing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145344.793463.2045134533110555641.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The exchange-range implementation is now completely separate from the
old swapext ioctl.  We're deprecating the old swapext ioctl, so let's
move this test to use exchangerange.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/710     |   14 +++++++-------
 tests/generic/710.out |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/tests/generic/710 b/tests/generic/710
index 6c6aa08f63..c344bd898b 100755
--- a/tests/generic/710
+++ b/tests/generic/710
@@ -4,17 +4,17 @@
 #
 # FS QA Test No. 710
 #
-# Can we use swapext to exceed the quota enforcement?
+# Can we use exchangerange to exceed the quota enforcement?
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext quota
+_begin_fstest auto quick fiexchange quota
 
 # Import common functions.
 . ./common/filter
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext
+_require_xfs_io_command exchangerange
 _require_user
 _require_nobody
 _require_quota
@@ -35,14 +35,14 @@ chown nobody $SCRATCH_MNT/b
 # Set up a quota limit
 $XFS_QUOTA_PROG -x -c "limit -u bhard=70k nobody" $SCRATCH_MNT
 
-echo before swapext >> $seqres.full
+echo before exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
 stat $SCRATCH_MNT/* >> $seqres.full
 
-# Now try to swapext
-$XFS_IO_PROG -c "swapext $SCRATCH_MNT/b" $SCRATCH_MNT/a
+# Now try to exchangerange
+$XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/b" $SCRATCH_MNT/a
 
-echo after swapext >> $seqres.full
+echo after exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
 stat $SCRATCH_MNT/* >> $seqres.full
 
diff --git a/tests/generic/710.out b/tests/generic/710.out
index a2aa981919..fcc006c279 100644
--- a/tests/generic/710.out
+++ b/tests/generic/710.out
@@ -1,4 +1,4 @@
 QA output created by 710
-swapext: Disk quota exceeded
+exchangerange: Disk quota exceeded
 Comparing user usage
 Comparing group usage

