Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19051130E52;
	Thu, 25 Jan 2024 19:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209502; cv=none; b=ZokPGvQvHEbUmEvfJyGI/d3266fW7faI+XjXzgcttVTeheZsKnU/UumBf9JfXXfBz7pwO8E89znUHVQwMsxOqHoD1mqbad22B1kEPlp+STfmJ4blHP2rf9WQAPnk9rWdeMw2ElCYHiMN1mEtjIo+vPR4fKG1PxL5tqsFpe1uxHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209502; c=relaxed/simple;
	bh=YIo9Fz1LaXEbfE5IIpbp5yfR31HNfAz9ZnlfHPqmXuk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+XxbTiQqtfxv/7Iq5R7nojW3zesSRBuzWiUtkmSz96F57mM2agiD1Dlb2ZRXRXkduP4aBcMpTAZnlxGV+vUBIh9XCpGjYrHKy/oFK21sy3q/SQGmHY0745UHxK3a20vqulQBZrj0VMS++9w9fkJ5aeJdRH0XdA5mW+RVG6qQEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPospv4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPospv4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8560CC43394;
	Thu, 25 Jan 2024 19:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209501;
	bh=YIo9Fz1LaXEbfE5IIpbp5yfR31HNfAz9ZnlfHPqmXuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YPospv4fGm2CXkNHrUiCKxt4zSXzELYlYfRbJ/CRqRgnZmogJNU+2oNfkf3xEfsTN
	 WPU71kHstKSXvRn/Y5xZC+qZInlpUDt2KLsmmLg7T++XKwg05zpHg1bcgeFFDoBRdK
	 CMXhjIBQHrsH8JUKq4nbSNQqWHqUUFlUR7VeCXShhQsaF8h41X09lXVFnx61z1AMSb
	 SXYu8X9xDh4G471g50iZkpZLTfvcjNjbkJsxloLp5e6Poar+FeqKKqzasrQl3x1Xru
	 vGpcJzJ7WkQVb+4Mk3zo6gFONT3kMmVEyDKQIUINyUiiKcxqHXM9M8Zn7+1ML6xkfG
	 rY887Rjd0znZA==
Date: Thu, 25 Jan 2024 11:05:01 -0800
Subject: [PATCH 04/10] xfs/336: fix omitted -a and -o in metadump call
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924420.3283496.6869276450141660418.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

Commit e443cadcea reworked _xfs_metadump to require that all callers
always pass the arguments they want -- no more defaulting to "-a -o".
Unfortunately, a few got missed.  Fix some of them now; the rest will
get cleaned up in the next patch.

Fixes: e443cadcea ("common/xfs: Do not append -a and -o options to metadump")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/284 |    4 ++--
 tests/xfs/336 |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/284 b/tests/xfs/284
index 58f330035e..443c375759 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -42,12 +42,12 @@ COPY_FILE="${TEST_DIR}/${seq}_copyfile"
 # xfs_metadump should refuse to dump a mounted device
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
-_scratch_xfs_metadump $METADUMP_FILE 2>&1 | filter_mounted
+_scratch_xfs_metadump $METADUMP_FILE -a -o 2>&1 | filter_mounted
 _scratch_unmount
 
 # Test restore to a mounted device
 # xfs_mdrestore should refuse to restore to a mounted device
-_scratch_xfs_metadump $METADUMP_FILE
+_scratch_xfs_metadump $METADUMP_FILE -a -o
 _scratch_mount
 _scratch_xfs_mdrestore $METADUMP_FILE 2>&1 | filter_mounted
 _scratch_unmount
diff --git a/tests/xfs/336 b/tests/xfs/336
index 43b3790cbb..3c30f1a40b 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -62,7 +62,7 @@ _scratch_cycle_mount
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_xfs_metadump $metadump_file -a
+_scratch_xfs_metadump $metadump_file -a -o
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"

