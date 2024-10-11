Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5C917591
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610187; cv=none; b=QBzYDqwW+Jq59a2YuNvec0ibgYgZiczkHRsaCTPYfrQaLNpBkv/AKgjS4gX2zRWwD1OFGqfmpy1jwv+LzYiQER+9OlGubOCDqGU571c07l3uJZyBssB8sT+pQJXqt9haYStE1GE9gIq69UGPybuTPv7sHVs4X6X7ZCvcz6hGdEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610187; c=relaxed/simple;
	bh=6gY3cTbi6EL5RwQFTWHnkzS+KKOvddUGb6+567xsi+s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XfKvAV7RIwJ1BppFr07JA/gy+Lm2EusXAVzqM4PE09RVGk/oygW5vgcpE1GesOV0rWZSD1fq+PJl+vMxWyqezxKlnMKQoVI1CaY7MPzBa3JiFv330+GERadditNVgs0OPqSgzKIqtt83bAZ67mzqV4oPPFYZoD8Xdu+8crGmwr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHi41/7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHi41/7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B8C4CEC5;
	Fri, 11 Oct 2024 01:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610187;
	bh=6gY3cTbi6EL5RwQFTWHnkzS+KKOvddUGb6+567xsi+s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uHi41/7nPC0MVUp5tnV6JRbsEJtiwxRGl+lHx0WwlbrBhe1bh3wRxYV7thrJ2aiN0
	 ZUL1Lp6HfbDy3C2lsNHBXTFQJHNxXlbXxebefpSXioZPnoKA8QPBUpf72CkIHcwgUa
	 uvGLIQQa0zEAJEhEGzXr87xYVApJQuz5NHoqAWLuIbRvaL6vIpwsuVN5F/1QrwNZBS
	 hZ8J4eAiPDvAk+bfynD2Eim5Moq7Ik/tBZTyczjutus5cgO6xWzFh4N67vVj8CU6Xb
	 uNCxYqKCpJrOpYoCCh3IooRa6ueONEvwMwOk7bsTM1XBORQjJYqWL4IZPVOrllppS3
	 r+dBGj/qw3qkQ==
Date: Thu, 10 Oct 2024 18:29:46 -0700
Subject: [PATCH 20/43] xfs_db: listify the definition of enum typnm
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655673.4184637.11980982869224364428.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

