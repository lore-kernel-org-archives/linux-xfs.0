Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D9366;
	Tue, 26 Nov 2024 01:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584048; cv=none; b=but/IYYfJGNcEOVgl33W4R4XFwJCHcCi+2/EmWYZhSwLqGMno2+c8HPp3WFHV4VDYOtwKFaLlTARCUdNb0GjS0lvLfZwqAriVWHMM1wUDVdmCVZSQ9SuMEtrpL77pAJ2CxMj54NVUwzbdpnX+LG0Rb6LBKQ/y5Oo/OdLEUMgNao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584048; c=relaxed/simple;
	bh=118F3cLeQLECfTPe2n1rCyAfJUReJzNfz7TOatchghk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7BoaF2KIYtOn6iR5IWf/x07fxBBGHu2i0/Ph0SD4nChQlmjDq0JWbivrFS4ZD1iIrKmqZTTbEMSKZCsAJV7iDL+59Vv3P/KRLdxGNdnlX/jHGiEQHnAuh4hFPb5lX+/ZCf1tfS2Dktq/19agP7X5ZgJve6c0lOECCDafyrlHPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3DTKTPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3DTKTPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1404CC4CECE;
	Tue, 26 Nov 2024 01:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584048;
	bh=118F3cLeQLECfTPe2n1rCyAfJUReJzNfz7TOatchghk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E3DTKTPLk8idIiXl45llLT53UVm4akjJ7AHJrBV74aP7KNAtKAOxcnQAzZfvcp/6J
	 tXu6qg3sTK7pwYU0QyPUJZFqqW3b4FuIN52cogkJwpbl3DZIpT8Es5L59APUGPai7E
	 1aAvuu5Gp/dJMHxxKyXt/BE7B6JM0A/ylITKqr6MCljQYANkdtWSp2YUK7HZ6fAoIM
	 zMX7grPZ+XsAn7VmkO595OPAMpDF6KhdqhAFo3agsVS/gmhAUkPTSPRmSha2GaBMnS
	 oy/l+uxieGOLqvc8fwvwgpfTfRB6uRJsV7EbWP/B5sED0REdJZ5e4KKm187ybjBKJO
	 U5TnE5NByn1NQ==
Date: Mon, 25 Nov 2024 17:20:47 -0800
Subject: [PATCH 01/16] generic/757: fix various bugs in this test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395086.4031902.11102441101818456621.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this test so the check doesn't fail on XFS, and restrict runtime to
100 loops because otherwise this test takes many hours.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/757 |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/generic/757 b/tests/generic/757
index 0ff5a8ac00182b..37cf49e6bc7fd9 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
 cur=$(_log_writes_find_next_fua $prev)
 [ -z "$cur" ] && _fail "failed to locate next FUA write"
 
-while [ ! -z "$cur" ]; do
+while _soak_loop_running $((100 * TIME_FACTOR)); do
 	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
 
+	# xfs_repair won't run if the log is dirty
+	if [ $FSTYP = "xfs" ]; then
+		_scratch_mount
+		_scratch_unmount
+	fi
 	_check_scratch_fs
 
 	prev=$cur

