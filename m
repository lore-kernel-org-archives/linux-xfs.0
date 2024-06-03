Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43610250EC;
	Mon,  3 Jun 2024 20:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445532; cv=none; b=u7QS7v0nYs6pSWDdUqCXDAM7v9x32Yr74aoMvk0vuuu9485d+Glu7i77hr+aKWcfhDyHlP5qlwNwBV0P9H43rgQ6IKSIsCCV5RTdmd9vOv3r3vvxhgFpb2odjFvD/rSMt8NyPNX6b0SskTgOWLb+Jv7Pq8eNiiw8vm9ZbrA+6Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445532; c=relaxed/simple;
	bh=+yvJ+R6LqINWme+roZSNBamGx4+9puu38wcqUkzAnTI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4/ZTIfDatmdCJMOvM+R3Vf+JjTDP6PBLATHLGmGuSwQsOPC/EKc7/MNh6vUlYxFWdKCFFJuiobwCbjEPn7GOP6IRlQhX4r7iJcL4f9sSHmMs9dKl+KoI3O1P1erP8n7G2rhfD1Zknvn4JTx9y8nQ9w/yL2E1mO3Eehyio3x7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arfiGh/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arfiGh/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B3CC2BD10;
	Mon,  3 Jun 2024 20:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445532;
	bh=+yvJ+R6LqINWme+roZSNBamGx4+9puu38wcqUkzAnTI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=arfiGh/H5aywaoNWF2VNBj35SHKwlSgJ22Na9dUZG0BpzcZAc8mNgemPsHuBZB4cu
	 fu26LUnIgtF0T2sJdrojIUwOEmgrj8TOmbfA8BmzVZn2iD8I4XPceQkMpOn/9NqLF+
	 NN/jNnKB6qA9ncA7DJ1V3povyPmGyJJWJgNp5LPHAkd90EgTiSExPvf6nJacBjk2j7
	 OUzgSNnqNvkZ6JETdmtJ+hMcQOTl9C43IIxo3km3NmTP+dQEQzlVio/VogoAI5Ht65
	 p+eEzQAACgEuzBerotilIKoIfLaHNaCLN2igWbcWhc7O/obix62YrTAukdVE3Gd4cG
	 qUWftB85uaaPw==
Date: Mon, 03 Jun 2024 13:12:11 -0700
Subject: [PATCH 1/1] generic/747: redirect mkfs stderr to seqres.full
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525128.1531941.8755552045266618674.stgit@frogsfrogsfrogs>
In-Reply-To: <171744525112.1531941.9108432191411440408.stgit@frogsfrogsfrogs>
References: <171744525112.1531941.9108432191411440408.stgit@frogsfrogsfrogs>
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

ext4 fails on this test with:

--- /tmp/fstests/tests/generic/747.out	2024-05-13 06:05:59.727025928 -0700
+++ /var/tmp/fstests/generic/747.out.bad	2024-05-21 18:34:51.836000000 -0700
@@ -1,4 +1,5 @@
 QA output created by 747
+mke2fs 1.47.2~WIP-2024-05-21 (21-May-2024)
 Starting fillup using direct IO
 Starting mixed write/delete test using direct IO
 Starting mixed write/delete test using buffered IO

The reason for this is that mke2fs annoyingly prints the program version
to stderr, which messes up the golden output.  Fix this by redirecting
stderr like all the othe tests, even though this doesn't seem like a
great solution...

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/747 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/747 b/tests/generic/747
index 50b7ae1160..bae1c84237 100755
--- a/tests/generic/747
+++ b/tests/generic/747
@@ -99,7 +99,7 @@ seed=$RANDOM
 RANDOM=$seed
 echo "Running test with seed=$seed" >>$seqres.full
 
-_scratch_mkfs_sized $((8 * 1024 * 1024 * 1024)) >>$seqres.full
+_scratch_mkfs_sized $((8 * 1024 * 1024 * 1024)) &>>$seqres.full
 _scratch_mount
 
 echo "Starting fillup using direct IO"

