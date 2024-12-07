Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00FA4A07
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530319; cv=none; b=bdD4unsTXVtYPUKMuGpgZw/aorSgY08jwhDXL5/q27f0ELNuewAwONGMMx/O4iK0B29UEyZu9MHY1e2EFXySiINN+AsYCQCDef/BgrPe4xe1vqISl+Lrs9t/hGigbbdwwquAuP3I8xxTeqG/HEHGgrT+2/VjLyboriXTBx7MC78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530319; c=relaxed/simple;
	bh=qhGHk/bFFHSwI4Z2Z+nXhWnzaI1ZFdmBY6kRJXF3AgE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isYtffA9wkZ+TPsrCeydv4GKlgj/YNKD2DIol4NBViIhMNnvuI4mIwKecMpyD+XuhOhNo0vmWggoCvt6dLVgw1X8rsQDrzG9Su4sxXtHtBbLEHHc3Wlxwe6nPr3T16vh3YLPTiZNpK2aeMiVVqGSc0g//iS289GI1B2rl0kZLzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhUIteXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhUIteXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72610C4CED1;
	Sat,  7 Dec 2024 00:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530318;
	bh=qhGHk/bFFHSwI4Z2Z+nXhWnzaI1ZFdmBY6kRJXF3AgE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OhUIteXA2pBP4/EiCGaeK5E5pq1aZMQ+S9NgrZHRXTJHVyXyyKF7Av2U06XGkh6HT
	 eI45Y4kYFJJMLTbBKeONkzQC/SlHEd0mntXQURkXhiyObsCPoaSaOGY6Fk4O+bVFuZ
	 XaIzQt4DipzzeoRoGuVekB728HfbPlbvWmpGT4TdwQUHtfMBTLeP5oWAXULEUzx244
	 lwCzvHWxAsHpdRoJVKUbv0mTfHnpD3UTofvpUutyidSYN1Xei5p4M5QFXRk/Oj7ILK
	 XEIzV0T+jD6ifF0nO1UK2/2GarQjuEu/Me2gKt5Vne6v0wJvRdiLtdr2q/rPG0QUoC
	 N/Kaq6tHPN6iA==
Date: Fri, 06 Dec 2024 16:11:57 -0800
Subject: [PATCH 27/50] xfs_db: listify the definition of enum typnm
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752357.126362.17852148009193165099.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert the enum definition into a list so that future patches adding
things to enum typnm don't have to reflow the entire thing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/type.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)


diff --git a/db/type.h b/db/type.h
index 411bfe90dbc7e6..397dcf5464c6c8 100644
--- a/db/type.h
+++ b/db/type.h
@@ -11,11 +11,30 @@ struct field;
 
 typedef enum typnm
 {
-	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_REFCBT, TYP_DATA,
-	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
-	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
-	TYP_TEXT, TYP_FINOBT, TYP_NONE
+	TYP_AGF,
+	TYP_AGFL,
+	TYP_AGI,
+	TYP_ATTR,
+	TYP_BMAPBTA,
+	TYP_BMAPBTD,
+	TYP_BNOBT,
+	TYP_CNTBT,
+	TYP_RMAPBT,
+	TYP_REFCBT,
+	TYP_DATA,
+	TYP_DIR2,
+	TYP_DQBLK,
+	TYP_INOBT,
+	TYP_INODATA,
+	TYP_INODE,
+	TYP_LOG,
+	TYP_RTBITMAP,
+	TYP_RTSUMMARY,
+	TYP_SB,
+	TYP_SYMLINK,
+	TYP_TEXT,
+	TYP_FINOBT,
+	TYP_NONE
 } typnm_t;
 
 #define DB_FUZZ  2

