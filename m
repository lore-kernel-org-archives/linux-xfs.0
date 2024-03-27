Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B637219EB;
	Wed, 27 Mar 2024 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507405; cv=none; b=elhhR3HKOd1QoZB8DiWrSLbmd9D92oLIYMwIOe9sz5GNzZodWN/k+swTvnyUYr2aktl4CgDmrs+Yp77LgnwM+xANCmyqIu+MxsYbc5iMmQIsBdw5LE9MdnCia5W66yL5P5ImEc8P+9CpwL5qqyJXLXE9+pvcc4vFwHGYsBUlHvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507405; c=relaxed/simple;
	bh=T3dKSwqElnakxlYmwDMfkEVe24cI1fevAxckdQV0WyM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9oHppn8vztFHtHFRLA/xHsD36ETfbETRby/jaimd8eHwXUq/+dB+CRGdlo3cd0y9U8+UOGCbPxAUl038PZMPFsHMfW83UpoKvMgrnIghjFdwdomfPFsz1yzQGQGodmmR9CiNm7cnlhGLFYAeK9xEEKhlYuSHjuwoG0LiFXMndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTcr/Ef8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTcr/Ef8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17031C433C7;
	Wed, 27 Mar 2024 02:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711507405;
	bh=T3dKSwqElnakxlYmwDMfkEVe24cI1fevAxckdQV0WyM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=TTcr/Ef8/xZXFWGDPITP4j+cwz0crnZBNcCFLlM0P+0l64sFCgZdRVQHFwHJzrcaP
	 sDsqgq6opwAoAZZiTqpjocQ3kdB0Xw1IakEpgCFM0byIjB9qrMCnxQbsmKVznc0Pks
	 3Sv/HzCFHZ2oengqAvcEd51Z4PlRkrSrhzydan9x5SPowub6cCMmVCxsOr7ghpCNu2
	 mZVjCC8iNoywOoYh57mXYLabV3ib8Pby/kMYk1XndBxBO72YUnkvAoXdcQziWAltVv
	 soA12t4IJrWXzV1hesa1UtEEEEtqBlyuudb6ggBL8t6cAKMtBTe+rACHnO0SrzQ3dA
	 jPzFdhCAOrdvg==
Subject: [PATCH 1/4] xfs/270: fix rocompat regex
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Date: Tue, 26 Mar 2024 19:43:23 -0700
Message-ID: <171150740360.3286541.8931841089205728326.stgit@frogsfrogsfrogs>
In-Reply-To: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
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

This test fails with the fsverity patchset because the rocompat feature
bit for verity is 0x10.  The regular expression used to check if the
output is hexadecimal requires a single-digit answer, which is no longer
the case.

Fixes: 5bb78c56ef ("xfs/270: Fix ro mount failure when nrext64 option is enabled")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/270 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/270 b/tests/xfs/270
index 4e4f767dc1..16e508035a 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -30,8 +30,9 @@ _require_scratch_shutdown
 # change this case.
 set_bad_rocompat() {
 	ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
-	echo $ro_compat | grep -q -E '^0x[[:xdigit:]]$'
+	echo $ro_compat | grep -q -E '^0x[[:xdigit:]]+$'
 	if [[ $? != 0  ]]; then
+		echo ":$ro_compat:"
 		echo "features_ro_compat has an invalid value."
 		return 1
 	fi

