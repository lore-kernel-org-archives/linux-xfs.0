Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F161B14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528520; cv=none; b=uYy4jHfg/IG0q+gL0mFIxCzsqv2pgFV8RQHLUmHTmzjhZun5spGdzz3oPgq5V5Zrcda/+0HwDcNIBSolMmU/PjaZR+ofP8+tQZq1YClX6dgbn7mgGoGvB3BD3KAemSlG24qS8Pg/BWZa6MHHTJnVUTC1LYO0dBJtiYy5yp/XGIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528520; c=relaxed/simple;
	bh=orBFsH4K4ZU65U9WcWhUx9/sMtn9Cp/xp73Pa8EH1dc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8V+vTlMXxhnqLmVgsu4I+xCG//G0hjpNVGHTqbb9ibxSHqPm1i673qXQOTRf/lheUh92jM9ciHLDjOL+c88v7QI9M8qrZZbPjMT4Z+gFyzrTauRUvSSTP5XCtRb5deIQehP3Qi5J38Ok4cAtx//4jKq+pfStCAiyuZrG2fr+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMf4qxzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMf4qxzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD73EC4CED2;
	Fri,  6 Dec 2024 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528519;
	bh=orBFsH4K4ZU65U9WcWhUx9/sMtn9Cp/xp73Pa8EH1dc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bMf4qxzYE3QFbh2cRh27598pH3/PC3vjNvOcRxul4XDGX/8yAcZLo8lwqN+6yloy6
	 v6YJLhKfNY4nG3FLEqzvPoCYYZIe8jna1DvvCITQy/DIsRt2LKxUDpP6mNiroJsoBe
	 9oTfVjn1K5lLJUBR4y2x6obSto9sUKwiWvCVl14LFEmz+gKLFzHhDMfcaaEczL+8Rd
	 Fam05QeAveTnj33h9hSQ47eXgC09uPE3YJQ1/tl8j6dO7wWneTeEiUTrWjfRRGGH/v
	 YmZFr8dPyG1JEfX8zQjWLSs3QbcjHmZUsdAfJY5c63m2hptVs5A7wF5iejnGSCp6WI
	 wyfS55m4GvaQg==
Date: Fri, 06 Dec 2024 15:41:59 -0800
Subject: [PATCH 09/41] xfs_db: disable xfs_check when metadir is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748376.122992.14095194470830359878.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As of July 2024, xfs_repair can detect more types of corruptions than
xfs_check does.  I don't think it makes sense to maintain the xfs_check
code anymore, so let's just turn it off for any filesystem that has
metadata directory trees.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/check.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/db/check.c b/db/check.c
index fb7b6cb41a3fbf..37306bd7a6ac2d 100644
--- a/db/check.c
+++ b/db/check.c
@@ -831,6 +831,12 @@ blockget_f(
 		dbprefix = oldprefix;
 		return 0;
 	}
+
+	if (xfs_has_metadir(mp)) {
+		dbprefix = oldprefix;
+		return 0;
+	}
+
 	check_rootdir();
 	/*
 	 * Check that there are no blocks either

