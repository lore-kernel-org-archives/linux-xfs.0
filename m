Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6E629415;
	Tue, 31 Dec 2024 23:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689521; cv=none; b=gAfv7dFnhavgaTiURSG92oV0P80O6ZsRuSgGCVcRyopPepT2ML2/doiKP9pa2rtw0fqXexVdWnJajN9aIrIgnupyTJAvcoVkRFpEpqy3IylvTC1pWTkejhoxg7hX1tHgUBuvc0rZWH5N3q/CtNMuFIph6i81UQ095yx7JUp0930=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689521; c=relaxed/simple;
	bh=uV5ghpmc8yYFqqL4a3TgkX3Fv7cQIYrQJjOz0cnPieA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eeex3x/7kZP96F8aV9bX79/tHdAvefa4StSF2lFpgXgyacAfANZyufWey89gZ6GN0r7ekh6/ojDI3LKjliIgyJjZBR/0hF3zNKtBOgg90JAMAOH4X1CFykKWOl2bAY3LH5+DN9fKBysW7rTk6FElbUAuBtWCrmFjwlLh/VqDEzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFQz0lbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFQz0lbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD28C4CED2;
	Tue, 31 Dec 2024 23:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689520;
	bh=uV5ghpmc8yYFqqL4a3TgkX3Fv7cQIYrQJjOz0cnPieA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QFQz0lbo02/9TATS2NCEqLxPHcXwAsYiPEXmlpoU+MlrUsWl+bYnzM1yZjOPuF8rk
	 lKCN/brpDtmxyq+5yQX7057m0BJvrgHOgXWf7ni/cj5aWw8Jrt7bFd1d9viFalC5Bt
	 NkB7gnq+xfVlBsrwlyZ7R5/PXhn+Y5eTJDrUcsluR/1ImwUuV/3xqaH0XTwHajUAAI
	 ZgBvRyq+qCxwL68DjUUktFqEHSEurjYaIJLJb5anz7QaYaeQav2pG7LALhvrui0t9K
	 f1PF8rpN6qbO7voKNxUQPRQYPpbH9RDFMIaxHp5OVh2xDW0pkELY9kXLNNq/OgI+AJ
	 wam3HjHtrgHrw==
Date: Tue, 31 Dec 2024 15:58:39 -0800
Subject: [PATCH 1/3] xfs/1856: add metadir upgrade to test matrix
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783563.2712510.13869756633643609993.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
References: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add metadata directory trees to the features that this test will try to
upgrade.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1856 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/1856 b/tests/xfs/1856
index 7524a449c3af00..fedeb157dbd9bb 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -188,6 +188,7 @@ else
 	check_repair_upgrade reflink && FEATURES+=("reflink")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+	check_repair_upgrade metadir && FEATURES+=("metadir")
 fi
 
 test "${#FEATURES[@]}" -eq 0 && \

