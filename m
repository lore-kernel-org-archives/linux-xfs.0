Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12D1128839
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422922; cv=none; b=Kt9l2J7VdnMDBjHWh0aWnMZ7CNovl85nCwrzSO/VfVrglyIMAyGLLKAwjHiOIjBijIupP9y0GQqE77aZL804Ul2OI+52iryZGrJ96om0RSsXusB5myWPLXfvEALNKRPejNYTiWO3lYdMMYCRMGQYWvOcdbbVJIUAnVQ3VA+dP/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422922; c=relaxed/simple;
	bh=FInAuFYwAz7HpRcEQwYk5/5DYyYkHzae8Q0dw6lN2L8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBrJ9taUadefJlsTtZ+AdPUtlDT806gTi7B9XeH1he3qKTC5BuGPXTMES/Zv6SPkm4ZD1fqaX/vdiCHgFUVmq0tTee9z4eyIS0VBSjkw8Cpzfpc381V2PUw6Jhbn408EfxkxI3PItwCeohvAH6uwTajmfgZC5GODv3IHsjeye/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFSarb1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFSarb1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83F1C43399;
	Tue, 26 Mar 2024 03:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422922;
	bh=FInAuFYwAz7HpRcEQwYk5/5DYyYkHzae8Q0dw6lN2L8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FFSarb1Lnzmt4ldwb7E1vXB4j4oltBctCrECkXGVs/ORdRqm1Vtb1wwis/03hJJoe
	 C9JxY/ioJ1fBIPS8iFPzAVOnX+PJSxPiYwHA9DFmGY/LTEx0xUsHsfoM7rI+Aw/VRc
	 F0M1FoTNchV2VQk21iaz/cNDsNugKM5xUYJayZMJFS5rDb5vXIuTNo0AFciihXlgPw
	 lN+Y8cRn+45ol4BW+Q/k4MsZL/SZTxTO+AvYtj8pZ/02ag1UwCjGG7VYM+4z5ktPBS
	 5sEgiCD5NNDE/UwQ+125RE2VSegYfBAxNkhDYGblvqiEbqFRgrbA08C5zWuHD4/Ioo
	 8RP0obD+Uj4Mw==
Date: Mon, 25 Mar 2024 20:15:21 -0700
Subject: [PATCH 48/67] xfs: return -ENOSPC from xfs_rtallocate_*
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127648.2212320.6854165527532312580.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ce42b5d37527b282d38413c1b5f7283253f6562d

Just return -ENOSPC instead of returning 0 and setting the return rt
extent number to NULLRTEXTNO.  This is turn removes all users of
NULLRTEXTNO, so remove that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_types.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 035bf703d719..20b5375f2d9c 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -51,7 +51,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
 #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
 #define	NULLFILEOFF	((xfs_fileoff_t)-1)
-#define	NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)

