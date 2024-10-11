Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F28CC2ED;
	Fri, 11 Oct 2024 01:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610703; cv=none; b=qD4eyLQyloK/rKtZ1+qcZeA6Eqs1fjWgx1M2p5rauvraSyLEtShFtT4dnDptPCBxJHxDBrTpQmFN8LHls7n3OsL38zDWYFG1dQMRxPzXZ6xcFp7S0WQMpD3whhS6qjfCDtZ3XPdFHdcECrW6Qgn8k6PbIzWes4Whhf6bRz4LCCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610703; c=relaxed/simple;
	bh=/9VC27kp4jgzUR7bN9SnlYVuFvuR9zzbblpr9dxsNOQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGpxJawFQceyptnfCABNQbkVu0LYD5M21ZVLbUeJPOdakBwsNxTJTkR5uoIxg/xBYdVZ8IXARLHpkUhse0Nhq296DkB9Pjb/h4IS5pnsr0x4rCQxGKWqyxfur5AFU7fNAuVXcBKL0GVqd10w+LZA1Tn4tAcLniUH7stoTJ4nPpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsZc11eB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsZc11eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D843C4CEC5;
	Fri, 11 Oct 2024 01:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610703;
	bh=/9VC27kp4jgzUR7bN9SnlYVuFvuR9zzbblpr9dxsNOQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PsZc11eBBCgtXJredt8bY7UgAF3NtIUyQ36WB6uQa9JE1nr73hDvDebv7x1hFYJzc
	 Ntv6hl+IemsXiK4+lzC2y6hSuvG93ldQW4uwT4Yhql6NA89yDDtJf8H9Nf++FDbiaI
	 I2klQ2d6VCTQDbZgqxdMa7xoI8Tox8F65ET80ZZfR5UjjKFmrxesvn1nKpXRBM7fOm
	 ExjziCrlaqKMC4foFFqXIdNBuSAUyrxhW3kXg5IP0UfEz/vuY9+iI88b/xLQ+GvYG/
	 5yk/OcxjbSDAecVWh0KSamridDRdRG6NHRVogGxUzfFWUorN/xQX2jfFkuRTOOpc2i
	 6Vn48ojpK9jTg==
Date: Thu, 10 Oct 2024 18:38:22 -0700
Subject: [PATCH 01/11] xfs/122: fix metadirino
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658013.4187056.15782325436304198634.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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

Fix xfs/122 to work properly with metadirino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 4dc7d7d0a3602b..64109489896fd5 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -35,6 +35,7 @@ offsetof(xfs_sb_t, sb_logsunit) = 196
 offsetof(xfs_sb_t, sb_lsn) = 240
 offsetof(xfs_sb_t, sb_magicnum) = 0
 offsetof(xfs_sb_t, sb_meta_uuid) = 248
+offsetof(xfs_sb_t, sb_metadirino) = 264
 offsetof(xfs_sb_t, sb_pquotino) = 232
 offsetof(xfs_sb_t, sb_qflags) = 176
 offsetof(xfs_sb_t, sb_rblocks) = 16

