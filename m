Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67BEC2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apuFp2tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C92C433C7;
	Sun, 31 Dec 2023 23:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066908;
	bh=CoLZ5vSgNfPAE/ou3DKvCnnCtz9TbpzKqJPNH5W08Sg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=apuFp2tp27nk75xd75oKYTzuSL4//zzfDm+tzzCyw0cFjOqgwFXakvkQwbVNvtVY9
	 snbqsnzAwr6F8WxQdATY+OQApu7bOORGPQP6N+Xgps1AdHeLdJGISu0OKZ/5rVwheC
	 upahYMNrlq+5iQU46sP0GcRadvrRcHV46Q2P8HgtVi4KXeXXr2vSA+68ng4lJ0Ze62
	 en0p9vn3JAKbhXnrJv0eFd5C4RnE3QCrioi5Ifms7alZgfSlqD8m+27RjUYEQMUqPy
	 zdudVrZqJb1DsNzNf5G6RqhTSCrrSlT0doXFsbRQcTT5CDSOHoykITet1FpMqOi6hQ
	 brHmdJEkDGolA==
Date: Sun, 31 Dec 2023 15:55:07 -0800
Subject: [PATCH 29/52] xfs_db: listify the definition of enum typnm
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012554.1811243.14137514903971365431.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Convert the enum definition into a list so that future patches adding
things to enum typnm don't have to reflow the entire thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/type.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)


diff --git a/db/type.h b/db/type.h
index 411bfe90dbc..397dcf5464c 100644
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

