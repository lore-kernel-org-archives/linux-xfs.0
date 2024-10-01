Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF201C9B81;
	Tue,  1 Oct 2024 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727801337; cv=none; b=UJMmyjlaTd7v91RLXFCj24DdkoRlIMGG0vA6tIZ7Kg0uCPgpMdFlEqTB5jqCj26d/akqZo/lJGLtsg6sEMbj0HFEK9Barew90HtFuTzDMAKhU34vD3wTCof6uhTddT1/eT9SylKPKqx9x4C5XCckrTjH9fd6vOZ7lW5ntCOozHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727801337; c=relaxed/simple;
	bh=MZOfFUn6Wtf3aQuZvzQYGjvQtsd5sCz2MVZv0PWumhE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMVBLLxvt7g1Kv73sMlKf3uA56JrwUYlB7BTRmlG9nAAu6IBPFr7yLkFemWRukAsvXMRjyx/ZaatojzHEsxfMZHhV3dJDC4WuCtWhcvuCtiKlyg5w1LHnbYn9gxH1v7ZxiayG7ChJ1p+dhCihvrP0ELKPLbmAxvvLTiLNRKx+1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqv/y9A+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqv/y9A+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DEAC4CEC6;
	Tue,  1 Oct 2024 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727801336;
	bh=MZOfFUn6Wtf3aQuZvzQYGjvQtsd5sCz2MVZv0PWumhE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sqv/y9A+CmRphmzZm5h70biIabFj3LdKXsoGA4dH+xxJfoSMaTXiNlg5f4qd9GQHo
	 JiY2j9k5hUFWnYuEDrtlmeBmQwRmzEKC6nbIljvLzZ0ocdKXwWu+qPjvbdWrgjJtaU
	 0Pwvp38j7RyxvY+Qr5SYUo+NsZesL2o06OEVzE/uIr7hpaHehTuV5fz0cvI1JUCT96
	 i5wQjpRRiUi/GxMBurw7YEKCZAeUbvQcUOrNWpkBNuW7Ju6h5td2sIyHqc45FxKwrb
	 AjopXW+dLAizMzJflp04VTWsmMfcm/5Ueegp1h51M8pZVuDbDotO9uKwwJt5pnIkHE
	 CUVbJBPLxcIdA==
Date: Tue, 01 Oct 2024 09:48:56 -0700
Subject: [PATCH 1/1] common/populate: fix bash syntax error in _fill_fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: allison.henderson@oracle.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172780125692.3586386.8156040885377148056.stgit@frogsfrogsfrogs>
In-Reply-To: <172780125677.3586386.15055943889531479456.stgit@frogsfrogsfrogs>
References: <172780125677.3586386.15055943889531479456.stgit@frogsfrogsfrogs>
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

In bash, one does not set a variable by prepending the dollar sign to
the variable name.  Amazingly, this was copied verbatim from generic/256
in 2016 and hasn't been caught since its introduction in 2011. :(

Cc: allison.henderson@oracle.com
Fixes: 815015e9ee ("generic: make 17[1-4] work well when btrfs compression is enabled")
Fixes: b55fb0807c ("xfstests: Add ENOSPC Hole Punch Test")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index 9fda19df06..88c8ba2b32 100644
--- a/common/populate
+++ b/common/populate
@@ -945,7 +945,7 @@ _fill_fs()
 	echo $testio | grep -q "Operation not supported" && use_falloc=0
 
 	if [ $file_size -lt $block_size ]; then
-		$file_size = $block_size
+		file_size=$block_size
 	fi
 
 	while [ $file_size -ge $block_size ]; do

