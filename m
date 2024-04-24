Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E134E129A9C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929358; cv=none; b=NIuhJ9KjwLy5p/+vqnjSoqC8mUfOHPHGEjmEKjl5d92RshzxIiXSO5+0LSNnHIOqowpI/sF/Tz3jsgtQEkDGoWRhiOuLzzQHXoaiDzcJH1YzoTizlsrJxmuShmNEyG/JHJfOoVNM6FR0cRTeqlJjyhNwGYQxw9IKYtk4MKqHR0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929358; c=relaxed/simple;
	bh=5Ymv9HE+1oTIIWmqPa1cizDlxl+EvUwHX4ovKSYDi7A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QFi/V71hhNRKkdeetUAD8i5utDcx8w5qmNdw2mnQ2QZ7YhFenAdE0dvilytWDMUe76aLdRahJl/NK3JH0FEgdMO6qjPdnX+SoZXAlt9nnKZUlQHDsCdbq4J3iSfHS5Ku3dBNa1nsb5W5IgnFzu3RgIHDSawADU5V9TlcxwGueLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVv5X5SW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVv5X5SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEE9C116B1;
	Wed, 24 Apr 2024 03:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929357;
	bh=5Ymv9HE+1oTIIWmqPa1cizDlxl+EvUwHX4ovKSYDi7A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cVv5X5SWrY86sZM6ZUDhDyjUrBws05bKTo8tQJ/jXj6sFzGzmlDLD9UbhbBKDfAdT
	 /4qQv85rD62RITfsxGuL3RgzpMiny5mrvxUXjelXNKJPmEZ8Ja/jwLED4EKsdR6b5d
	 JwhUml5mAYQFFwkgfxSKWV3vJHmrV5XWr+uzQZgadTDahAL3zYn0Fzha/F9n2O8mji
	 a8xeJFlpuy4Ukl29Mn6KmkWFAxV1ct9dQrBGxUYhGa+rYlL2uk/a9lDnfdMCuXwv/E
	 aF292SvZF4YGHCkQG2dd3QxSeIokow2wdtjOLUGRq7474o0ukrRw/hxVT9xDRKSA54
	 8lkBP6yDdr5vw==
Date: Tue, 23 Apr 2024 20:29:17 -0700
Subject: [PATCH 2/4] xfs: fix iunlock calls in xrep_adoption_trans_alloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786430.1907482.10478321489362698566.stgit@frogsfrogsfrogs>
In-Reply-To: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
References: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
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

If the transaction allocation in xrep_adoption_trans_alloc fails, we
should drop only the locks that we took.  In this case this is
ILOCK_EXCL of both the orphanage and the file being repaired.  Dropping
any IOLOCK here is incorrect.

Found by fuzzing u3.sfdir3.list[1].name = zeroes in xfs/1546.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/orphanage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index b1c6c60ee1da..2b142e6de8f3 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -382,7 +382,7 @@ xrep_adoption_trans_alloc(
 out_cancel:
 	xchk_trans_cancel(sc);
 	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
-	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 	return error;
 }
 

