Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C238A22339;
	Fri, 22 Nov 2024 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294337; cv=none; b=FIOYttvapJwDlj3UCQZ+BLFCWIQudZ17PIkIqfC9yb9IP6tdSEelWSHiuSBRGozRVnj+35MKVx75TsV+hwKv5d8NGXPHBd/pJ6kW5WxhKow/uf9nmMnlAu7LGS3tS5jYCsSS99hQncI0jSbEMDoDDZtjOVGt/KC85toub9mbpOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294337; c=relaxed/simple;
	bh=cSj5vLFu+VCywZD0eb6RbpiB0kdG47gWWWDsOEAE7yw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVaSKOjT3VPSuQYYMyPTSLqA1aWgmQK4qgBQLW3nvtMAZhJR6undvLdA8yoB4IbowVQFHevluYzQNjLUVPgOLsMg4P4zZs+C9WGZiNLGKkjo3pdlL8mm2/Eqq7ccuPgNmEogEJmwJycB6JQtD0Vm4aRvWlMyYUuHJ7zLznU1DqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qE2MYcly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qE2MYcly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4362BC4CECE;
	Fri, 22 Nov 2024 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294337;
	bh=cSj5vLFu+VCywZD0eb6RbpiB0kdG47gWWWDsOEAE7yw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qE2MYclydg2KBzz6FWrA8KEr00zqEoTIm//eY2PM9lnGHdnQ802+NReFKQ1hFJkMT
	 qTN8DNXkWG8VpYxO8uFsPdoPS5li8nAMKWsTC4EJJrZ+t+jnA59Yx1XnZrDkiEkK78
	 ZymRt20mtEZ//wXHmklPkejuoRycLNCXDCokl4Yrfc60eGiJ4tGEMerYcOLDgN6+Wm
	 wkymdxJonBt4JTFen1acMUi5XurrlQ/HtRl/obRTkmHQNBNe6qpVOf45+gaL5HuqcP
	 tK3pg9e6LTF9xh9rE9Tiw2tOlvAPq1wsnHKCPVqm7DChqMZ7ssbUewwFzzfFYCIurL
	 8/P1tEbXQ7vng==
Date: Fri, 22 Nov 2024 08:52:16 -0800
Subject: [PATCH 07/17] xfs/508: fix test for 64k blocksize
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420117.358248.8488570912527103936.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It turns out that icreate transactions will try to reserve quite a bit
of space on a 64k fsblock filesystem -- enough to handle the worst case
parent directory expansion, a new inode chunk, and these days a parent
pointer as well.  This can work out to quite a bit of space:

fsblock		reservation
1k		172K
4k		368K
16k		1136K
64k		3650K

Unfortunately, this test sets its block quota limits at 1-2MB, so we
can't even create a child file.  Bump the limits up by 10x so that this
test will pass even if there's more metadata size creep in the future.

Fixes: f769a923f576df ("xfs: project quota ineritance flag test")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/508 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/508 b/tests/xfs/508
index ee1a0371db7d6d..1bd13e98c9f641 100755
--- a/tests/xfs/508
+++ b/tests/xfs/508
@@ -44,7 +44,7 @@ do_quota_nospc()
 	local exp=$2
 
 	echo "Write $file, expect $exp:" | _filter_scratch
-	$XFS_IO_PROG -t -f -c "pwrite 0 5m" $file 2>&1 >/dev/null | \
+	$XFS_IO_PROG -t -f -c "pwrite 0 50m" $file 2>&1 >/dev/null | \
 		_filter_xfs_io_error
 	rm -f $file
 }
@@ -56,7 +56,7 @@ _require_prjquota $SCRATCH_DEV
 
 mkdir $SCRATCH_MNT/dir
 $QUOTA_CMD -x -c 'project -s test' $SCRATCH_MNT >>$seqres.full 2>&1
-$QUOTA_CMD -x -c 'limit -p bsoft=1m bhard=2m test' $SCRATCH_MNT
+$QUOTA_CMD -x -c 'limit -p bsoft=10m bhard=20m test' $SCRATCH_MNT
 
 # test the Project inheritance bit is a directory only flag, and it's set on
 # directory by default. Expect no complain about "project inheritance flag is

