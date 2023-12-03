Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F1617993
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqxTEoQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02A1C433C7;
	Sun,  3 Dec 2023 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630334;
	bh=JTtxhVAdnC3MQflyjOUbEBLKzTXzqvonICzNFyzKWig=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HqxTEoQvpHKOZaU1WpLQmYXghASFeo9lW9EWoYw62Gzo7u1HPwDIMTdu9dzQhIUtU
	 LlvBZ5T1esDQQzfxSxi6VB0ZBUyOOsHNUJ4+zq4F+RwV9ZHT8/pPDEP7/bytpTZBsP
	 VwE62CZy+RC1gOsRppxc/yjo9m5QtxNVTu+tyzB2HVBivYKpJUmy5GX0wMO5kofkpr
	 u+AFyzMn4N2ypcweJESVQUEk/p49IJYVwH37Ak41J9HgkmBRJVPu8+xjQwBAU9/FW3
	 m9iNF0laAAYTC9wRx26xvvOX7a/1KYmjry07XpV2r47tZ5tecClp0x5EmX1tHiC8oD
	 3G1w44fqbjDaQ==
Date: Sun, 03 Dec 2023 11:05:34 -0800
Subject: [PATCH 2/3] xfs: fix 32-bit truncation in xfs_compute_rextslog
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990659.3038044.14647028784739611036.stgit@frogsfrogsfrogs>
In-Reply-To: <170162990622.3038044.5313475096294285406.stgit@frogsfrogsfrogs>
References: <170162990622.3038044.5313475096294285406.stgit@frogsfrogsfrogs>
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

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 1c9fed76a356..0626909a2481 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1132,14 +1132,14 @@ xfs_rtbitmap_blockcount(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	return rtextents ? xfs_highbit64(rtextents) : 0;
 }
 
 /*

