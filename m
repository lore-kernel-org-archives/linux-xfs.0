Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9D97D3EC;
	Thu, 20 Jun 2024 20:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916985; cv=none; b=ZydvLqaXrDR8VWmHH0iAidIYqd575Yl4X2GfE6dMtHngW4KjjufCW3TZta42Xvcb+6K4Iu8yZGrn5q+p9ta1/a4FTCr1iZ8IUUmfhPV3ostEZpOW63UG4qXi8aX3pBD83BWDS7V8sET5TXDRBrYiHlI2si2gcY7v1ENWKmsSEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916985; c=relaxed/simple;
	bh=bFwqhNuHERJqNF70IA4ZqT8dPRy9FK388CWFy1GELx8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJFnsgSU5rBlaroE6QHyOQJaHi5Jsn9xThqqxMZEU8P+Q7BsuRb1IOlKBffWCfp5+uhYlaEemi87ZrOZfT9g89sF/DTCTM1PBW9Htpg5LE1LfEhSDK3i6nDSpxf7lzCDhkZWzbFveA0No2Gdc1ThXVOasgLMQgef8xoorX7ToP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uq3joVC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uq3joVC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80FEC2BD10;
	Thu, 20 Jun 2024 20:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916984;
	bh=bFwqhNuHERJqNF70IA4ZqT8dPRy9FK388CWFy1GELx8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uq3joVC2b6mA3vJHBpzp7ifBQu7EqOHBF3r6CZqgWIJl6hHWr+r46XMpA3JSJv21Y
	 y/znZ+c5pdrexOZlX64QPqNkZYriImKOVNad5/M8A94i8yUBK0P3F+70A01/Dy2t4L
	 9E58ZEdsWWhFY5LArqWRtPd0S+Kwt3go7JA9tN8kE7SQbLLKwrvwgFSog2ojI4obSd
	 sFm/ZwF7SHxol3VrrLTqs31jq6jflNnpwUms0BnKg2gTDzXNvRAnKcCmle7WyCEiX4
	 qcaQWK1qJQ0hMY/z/DCl0UYgTKy+1FylcoPBfDBkw4nMs7BqxWW2Cax8/Dh+MFK+/N
	 UMoZes9XbtFtg==
Date: Thu, 20 Jun 2024 13:56:24 -0700
Subject: [PATCH 09/11] xfs/122: fix for exchrange conversion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669249.3034840.8867712702649291413.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

