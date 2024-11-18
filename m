Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E59153BE4;
	Mon, 18 Nov 2024 23:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970931; cv=none; b=Q369R7xSdvQKuNj3uxrC8eQx9xpO9QVMm5zpHN7XRDJHv6YAf/Wh1wlCvMO8u1E/VbIWrB3zzHMNEwXAW83nc6gZ6nt7q+ywTdst0c1XU5ZLDRt3VespbFUHTUu3PcK9CFYduaGyQ3nk6NRkWTb6z6+vRxW9HEmFJnsJZz7Z8ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970931; c=relaxed/simple;
	bh=MtmzBT8p7QNVOATyVBMmzcCHOASFsa1q+9AR3/QhQUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AvAL0kBhzdbMUDBjOWjNkJQQwttxJ4bca098TnzVB9Sj0wirFzhftT7J4EhCU+/S3qZWg8r4DjUb8e3r/zLoSGNlFcx7m11rqa2WcRWHm74C+kcHTRPnqIQY5hAS4teAv2HXlb7ZEVGB0H/3krbrE/ekNuWShzG5hlIgzV73fuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JkCDRu5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JkCDRu5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93AEC4CECC;
	Mon, 18 Nov 2024 23:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970930;
	bh=MtmzBT8p7QNVOATyVBMmzcCHOASFsa1q+9AR3/QhQUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JkCDRu5DQR+u3s0kh0Lu03+Yws2sa2kDOiAzHdzJR6c2f3wOqAr52vHJz9aB2MVzu
	 s8odsCniRvmFXRlhl5xR8J+C9a0DPOxpc60skr8+GcQDAN1Kxrp/e2mOXc8vPRL7z5
	 jgax78QoACJ7MkJm3Bti5g8kKI14uUXXiVVaszFtb3jYSiT/MwZ4CBayaL2RVayqHr
	 w+Xc4cGnjSDcRzKvKNSOD/Y3OJGfmA4ZCbKwudp16K6Rp5MOqe+oQSdytpVsHzYjur
	 Bs78BA7ZBHtwnzL+Q/BDZErBerIOnwWNABWqdoti30ceYa97oeZU9Embo/sVvha+ER
	 Kiqf1iUqm2/uQ==
Date: Mon, 18 Nov 2024 15:02:10 -0800
Subject: [PATCH 03/12] xfs/508: fix test for 64k blocksize
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064471.904310.2680927948887859905.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
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
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

