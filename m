Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23846AC0;
	Tue, 18 Jun 2024 00:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671731; cv=none; b=nwqt4VePQMmFA54m3r0k7vFYHeUeHiZKHOSLv6bb5bkna7wy10AZ8re1Mazce5G70rzZoDswuADQ4icosezHrhWWy075u3awjeZNRqGOhU27FZluefjoAGUA5fMrtfHAkn6t2LOGQ9qsLGbROXFom9rGaLRi4jNikM7IEJHtPGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671731; c=relaxed/simple;
	bh=ZsyVYuUsVbVv/KGw6BUQYAbf2An1C0zhfadymfVs9E4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8zV7R7bOKLDqpv4uL9BkjaTQHGyYSIFh+M+w8eDdfAOrQS3HBhuvMW+3vbWQhC1ZToxSIHvB2QRBhI19/IJyHu4o1/xujWh7HdK+0zYv5Uk0AETaVlriBo4LSN93G1z7piCTl9fSPneobkKRKK14DYtgu/W41Ipf47D1NvgCuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L50x1MCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L50x1MCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30903C2BD10;
	Tue, 18 Jun 2024 00:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671731;
	bh=ZsyVYuUsVbVv/KGw6BUQYAbf2An1C0zhfadymfVs9E4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L50x1MCYmaSPmcboQtz402OfoULpkz8TXDN0+FFmJDHya+Q7XuJePg9wQUMH6a/DT
	 naxRmtizqmQxupxCxc+55DXOi25knAfq4TRS4hvBW9Njbi2SpdN21UHDlLcU6WkRH2
	 xbAJFg13IJlhDpOSJZHI/jmglHxoM1aU2YBU88bIptz3kFxDfBdUo/3Bs2gYurdJsF
	 7TAdEbnDsgN6kj5Aol5YzXURA5twFENr7yf2qXeTLNXKC65ttn1iPp5+oywcZsrXNZ
	 NsEFJQGP4G0oeSBQWUgyViE0joWArwx24aV2yP6nbPjDxzAawHByG9GQZkrK9C7nJP
	 ZpIk556pvYQjg==
Date: Mon, 17 Jun 2024 17:48:50 -0700
Subject: [PATCH 08/10] xfs/122: fix for exchrange conversion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145421.793463.13590004698802326563.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
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

Fix this test for the swapext -> exchrange conversion.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index a2b57cfb9b..86c806d4b5 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -92,7 +92,7 @@ sizeof(struct xfs_disk_dquot) = 104
 sizeof(struct xfs_dqblk) = 136
 sizeof(struct xfs_dsb) = 264
 sizeof(struct xfs_dsymlink_hdr) = 56
-sizeof(struct xfs_exch_range) = 120
+sizeof(struct xfs_exchange_range) = 40
 sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
@@ -121,9 +121,9 @@ sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
 sizeof(struct xfs_swap_extent) = 64
-sizeof(struct xfs_sxd_log_format) = 16
-sizeof(struct xfs_sxi_log_format) = 80
 sizeof(struct xfs_unmount_log_format) = 8
+sizeof(struct xfs_xmd_log_format) = 16
+sizeof(struct xfs_xmi_log_format) = 88
 sizeof(union xfs_rtword_raw) = 4
 sizeof(union xfs_suminfo_raw) = 4
 sizeof(xfs_agf_t) = 224

