Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E06EDDB3;
	Wed,  7 Feb 2024 02:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272332; cv=none; b=iWunw7lC1ifWkqNgtygHraCcYGtzTwpinL/gtIkTYaEKXzksQvDQmhfIL4G9WEo3/T7WP/RLI6CQJyQVTeov5kA23jc35kBgag9PF+C/dokvFDcEUS7SPzvL1r5SZFhFSN7Afq5d5OmhVhepYdm7iU7YAglcummWag7X+jFpWNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272332; c=relaxed/simple;
	bh=iGY7XRQ1s4xARR/pMbr9fB7mn/vLdaqW1moTfoSqxIw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVY6nxd/X5rHZ0sRW1sZr6Ed0wDWYqwa/1W5kNnkvnKmo5IDp0nzOy1OtSLv1B6EzHJlZQ8bjc9tb5lQ462faVgDaWh/lq0YQ5CcVETX9b3MjkAqLSn/8E5w84WJmBjm6+Lo7qPMStRDry9BXQ/WZWy7lO3ikUFpUXC28K0axMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQA7eCXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQA7eCXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B801C433F1;
	Wed,  7 Feb 2024 02:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272331;
	bh=iGY7XRQ1s4xARR/pMbr9fB7mn/vLdaqW1moTfoSqxIw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VQA7eCXqk9PDQj4YfBCV2k66D+pCw2rBy+sgYivORQJ/CHv298xwsMPakI/8ef0Wa
	 GJP48LSPiYDSZtHMDJn8Tiuu45R4YkhblE8+GTTNZ18feQ094tBV04CqkG7azDTwq4
	 QBkRq17V62Yvse4CUTxK27pGoTgRJi/+FhrjzTGJMfpGLO2gLE8R3Ca4o1w/Mc7u1/
	 CVhLnJUoICB9C70OZZINqJnCjxDKFye2pBiZtHjpKWbtop1qNmMv0kowD1volE4UAS
	 TG3X4m47+r048E/cl20ksKmDfnWtF8GSA4FZgbZ6ZmO4QUTiDuFOcsS/dn9GdcGMQH
	 pdRoPgKjRNUUA==
Subject: [PATCH 03/10] common/populate: always metadump full metadata blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:18:51 -0800
Message-ID: <170727233097.3726171.8150749815178513838.stgit@frogsfrogsfrogs>
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

Commit e443cadcea pushed the -a and -o options to the
_scratch_xfs_metadump callsites.  Unfortunately, it missed the
_xfs_metadump callsite in common/populate, so fix that now.

Fixes: e443cadcea ("common/xfs: Do not append -a and -o options to metadump")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index cfbfd88a7f..33f2db8d4a 100644
--- a/common/populate
+++ b/common/populate
@@ -1029,7 +1029,7 @@ _scratch_populate_cached() {
 			logdev=$SCRATCH_LOGDEV
 
 		_xfs_metadump "$POPULATE_METADUMP" "$SCRATCH_DEV" "$logdev" \
-			compress
+			compress -a -o
 		;;
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@

