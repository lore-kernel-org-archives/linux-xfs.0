Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B299C1E8846;
	Mon, 18 Nov 2024 23:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970899; cv=none; b=cpvzMJELhto2chfhGMxUaatXlFtDVCXhW1RtofbBMNWmxmioxqCAEF2nrMBPGXeb1Of/Ij4+xifpxFWJfZmAoa9q9soF9yAHK0G7E15UrBMF5UonhuoofZmKJ5p7xbSpntmi+HuK4p3L8nJ8apE6mcCso3bJ3y89SUYOcLmW29k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970899; c=relaxed/simple;
	bh=SQ8hEz0+P+LezKybCrG9BVBvg+dEV9Gmh832ak8B2d0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cW8KuJwStlhPsfr3IiILDtsLZAKvKJfZE4R6iDveHTPH/HDmKZN+Gs81GgmXM2J69aTSQX1ZWLX9iy19BPsTua74c5XBN34b9CeVJBbx6VDuLonnKGg64u7dZL6ZalpQTKiu/E9nWcn8xrElDYXSPSJzR75mTwNPM9TLA86Kes0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIaXRvfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIaXRvfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B73C4CECC;
	Mon, 18 Nov 2024 23:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970899;
	bh=SQ8hEz0+P+LezKybCrG9BVBvg+dEV9Gmh832ak8B2d0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WIaXRvfyOkIDiaeMaSFqKi7t/+xjmTkRbH1colSnqac0DDaKdb0PBh3Q6wn6eFFOJ
	 Q666EF9GxKSWhoNtkOgqtCzLaHybZcjg8gsmZfRlnBHoPx82HKBUAVpxdizUqiAPst
	 rUYUx6M4pV6yW02H9u06dSF7Z6gaxZRo2PFXali5yqD8Kdw2n+21iDRoHOwuv7LdrJ
	 zvGrVFKuLKc+PZcc+KHY2g5xKdigisRRXcfXh8w+pHRSMlFwP6n4B+ILXo+l9xR3pT
	 Ux4Nf59xUqzDXsEUUMHsI6um1b1HvCJ+7ZgSV96QlMOb1+5yYJaIiFlA9Tc8zZOwFh
	 dn7sd6kSmw0Sw==
Date: Mon, 18 Nov 2024 15:01:38 -0800
Subject: [PATCH 01/12] generic/757: fix various bugs in this test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
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

Fix this test so the check doesn't fail on XFS, and restrict runtime to
100 loops because otherwise this test takes many hours.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/757 |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/generic/757 b/tests/generic/757
index 0ff5a8ac00182b..9d41975bde07bb 100755
--- a/tests/generic/757
+++ b/tests/generic/757
@@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
 cur=$(_log_writes_find_next_fua $prev)
 [ -z "$cur" ] && _fail "failed to locate next FUA write"
 
-while [ ! -z "$cur" ]; do
+for ((i = 0; i < 100; i++)); do
 	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
 
+	# xfs_repair won't run if the log is dirty
+	if [ $FSTYP = "xfs" ]; then
+		_scratch_mount
+		_scratch_unmount
+	fi
 	_check_scratch_fs
 
 	prev=$cur

