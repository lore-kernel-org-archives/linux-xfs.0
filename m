Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE722DF58;
	Wed,  7 Feb 2024 02:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272337; cv=none; b=L1dbAgvIaEuBjbp6wImoHLpPBf559pK5xXAllIII9O/kHTlaEXu3bCbLV8ikb7p3OS5gytwV9nOD3geZ37JsNQY44SgCag1+OyDQEsGigaUCK9W7jy3YOLD6CSA7H2XdLaAUUdGmsF/UIjWdZEqYhql4mY3kJDbtTcvFPAF+dKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272337; c=relaxed/simple;
	bh=1IOiy2rQ0ddq1L/rGnXUtiLoMFwslmoiw31g8QGGKsk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rylpMJejnNfAdIPKnvEWbyhxmfkdd3c6UzjTq8F6ESZtVfBsu/tKHOFuDpMpdH5Ilezs+SvZswdJ9dCx+lGh6NEbJsVohGMUCgDTnb5s19lcFXrLcQJZc0jm/SBA4MJZrNUvn3uGIuOzudjfLKAEmrt4F/q7KyrY1pURrKy/04Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyKjFh7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyKjFh7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E25C433F1;
	Wed,  7 Feb 2024 02:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272337;
	bh=1IOiy2rQ0ddq1L/rGnXUtiLoMFwslmoiw31g8QGGKsk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=qyKjFh7Ksm3TCyMRPppinkwkafyLMh47aUiK+JQ4Uy4wdPoxTGGWLGX0vZq/leHbO
	 fU8ySJYpoawh/W+uqCU+S1iiCOqL3w4ZCZj7bRYaGo84zkB7IiaGxfhFwvAD4/+g7C
	 yUwsZowawlQEu5hXVrjFAyz1rst5frHWjF2uw/Au4hRF4MeifAekbSgwh8Z/xa8iNb
	 eUqkyizqJbsTBrFUnWMf1gjTmPSBPids4oSIPSMAvIh5HjGQmWVRCb9MfT4QWASw+J
	 /tLvrFF5jGANcjnC9JeoaARQ9GTIWXBqlUpdPY/hqw91mjhSXtbXUwAI844+t/g+IX
	 tM+Iz2PQf7R8Q==
Subject: [PATCH 04/10] xfs/336: fix omitted -a and -o in metadump call
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:18:56 -0800
Message-ID: <170727233668.3726171.7285378887952888883.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
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

