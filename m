Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D962054E1;
	Tue,  4 Feb 2025 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704639; cv=none; b=GCLFh/SytRlXu6ZsTNFE1R0fMGH+/T6xnXoBTsJ/P1kimDdbdYmyURgp5xeiL30DReMLLLtcPsraRuOH7etGhgttv1QP3Mx5HNyMzH05bbD3s8LteUAT4ov526FQESmSWDlL4zq/m4qm/b5gUhCbdxu7f8WzGRrqEi9HTOcf6pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704639; c=relaxed/simple;
	bh=ExA+nv15OfBnKqCbJsgUZa5Drkgtlc9Ce98OoeW8MTI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VHUHIug3oloBFwT4NK5ZhNg/IU3bf4D9yIx37s/z4QIz5Tz2rJJBu/yslpi6SceM5uY3qYPAnxQPOUGhtdw4SyWFi7/yv/aKgFiHwrYM31crbaHtVzDI8sAb40EV/3S/6DJ+1jblibz0Xu68uVb4dc7VQ/1tFh+Hfjst2DCOKE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JC64UDPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JC64UDPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88996C4CEDF;
	Tue,  4 Feb 2025 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704639;
	bh=ExA+nv15OfBnKqCbJsgUZa5Drkgtlc9Ce98OoeW8MTI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JC64UDPqN2kWeaF0me4B8ndf6geflhXQzwMIkfSeWiu0gOqg2cYpZby35mj/25e3W
	 BZipRW+jKBe9Y2AIW4C2rl1y07bdpETr1u2P+JFWEQ8xp9bhByL9XXu6+1ySoi6qe/
	 ErObP6024e70wUA330Bu8dZUny540CVjf1izlqatW1ZfNVvBtgsHj4rAn5AVaceRBh
	 JX4MX8gpCSUwQFlGrIhdVok/a4o529Lr2mISWnqTvPbKdz0SgAkoaVpbrBqquUHEwn
	 BDUr7EcVeWu7uXsr6lIim/udIwAroDvtzUCwPQxGGIOyIkNrRrGIc1Gv4A2YXnoTmZ
	 OivqvA6unM/jg==
Date: Tue, 04 Feb 2025 13:30:39 -0800
Subject: [PATCH 32/34] common/config: add $here to FSSTRESS_PROG
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406595.546134.7063206926113803976.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In general we're supposed to specify full paths to fstests binaries with
$here so that subtests can change the current working directory without
issues.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/config b/common/config
index 77f3fc153eb731..ae9aa3f4b0b8fc 100644
--- a/common/config
+++ b/common/config
@@ -128,7 +128,7 @@ export MOUNT_PROG="$(type -P mount)"
 export UMOUNT_PROG="$(type -P umount)"
 [ "$UMOUNT_PROG" = "" ] && _fatal "umount not found"
 
-export FSSTRESS_PROG="./ltp/fsstress"
+export FSSTRESS_PROG="$here/ltp/fsstress"
 [ ! -x $FSSTRESS_PROG ] && _fatal "fsstress not found or executable"
 
 export PERL_PROG="$(type -P perl)"

