Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6811DFF7;
	Fri, 20 Feb 2026 01:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549247; cv=none; b=LB0gyOsd/UdQIZ8XziUcC/8kk/afOVJi/RQaJguorZy1Aquc6e+whLx6tqhOMOjifa0B9EnjPtpJld2W5PQCkfmoSly7mVL9jSBV492QijLL9+gog/cXGWsn49BIch7gS+Lmw243HP1Ji82KbKOZLQbpIlqnGJK+oPANGCkKMPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549247; c=relaxed/simple;
	bh=7YjorkG2TwZ6exYzlncIPJFNRaN16o5Dpt06f/CvBSs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SiRK5hYNXolRs7Txsp4mHTT07Tazdwm8Rj1V9KsDhQLOvezu2P1/yCJTuyxeRY+LwG6CO5uJTe0/IzNUzRR6LJKKzsmJsFrmOGlOv4lyX7czd+FEWEPFqB6Ox3hiPJNbmb52JTqd4zpKlr4t2j3UAUuCwEtfZa1fF93Nz38236w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+MnGjvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+MnGjvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59808C4CEF7;
	Fri, 20 Feb 2026 01:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549247;
	bh=7YjorkG2TwZ6exYzlncIPJFNRaN16o5Dpt06f/CvBSs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s+MnGjvqsBREJDC93B2UIlkZ2sPFTxETF7S5qwcXIpTupUenof+gu0Qr5FVcraol9
	 pUTDGVeRFYuKhenX2kWztYXa2UtJ4Vjt5x+QQKkuc7BKSs1R1LhSi+SNJKzxmOktDy
	 5gIWdB3w0+yQvfdsveqGiJ5IJlONS9z6JHLS31UnRrk8Ea359oNe4xCvYsXiaqhS4Y
	 7nk3OLAuO3Elz1q8QipwTpQUP0kxFm/4rFzHP/z0NvtA2ReXnVTlKk1ob95tcYIFCO
	 ZaYOXFix3j9LLrCrrIsR8u5fyq2AnWSIDmPO2UV5AJEx3vAwpj4lo75uDrX8qebuXT
	 2XRssg24tccCw==
Date: Thu, 19 Feb 2026 17:00:46 -0800
Subject: [PATCH 3/6] xfs: fix xfs_group release bug in
 xfs_dax_notify_dev_failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, stable@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <177154903727.1351708.2138879525463955738.stgit@frogsfrogsfrogs>
In-Reply-To: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
References: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Chris Mason reports that his AI tools noticed that we were using
xfs_perag_put and xfs_group_put to release the group reference returned
by xfs_group_next_range.  However, the iterator function returns an
object with an active refcount, which means that we must use the correct
function to release the active refcount, which is _rele.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_notify_failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 6be19fa1ebe262..64c8afb935c261 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -304,7 +304,7 @@ xfs_dax_notify_dev_failure(
 
 			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
 			if (error) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 
@@ -340,7 +340,7 @@ xfs_dax_notify_dev_failure(
 		if (rtg)
 			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 		if (error) {
-			xfs_group_put(xg);
+			xfs_group_rele(xg);
 			break;
 		}
 	}

