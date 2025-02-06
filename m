Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEAB2417C1
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882966; cv=none; b=Fg9zirfjUrust/M94GZErT8i182F+BJFTupJV3CfMXNaDBB3vbYr48pRIeRhwbgewpiEZz4xf0hxCWWfVO9Lea0gxCizl/Sj8sj1h3AJ4KXPnyngrDZbzqdTorxVzXy1YciwDxue/CoH1FknRpnCXeVJ8oeQlDDlZR1fKRmlZi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882966; c=relaxed/simple;
	bh=Z0AR+dGq89xIhQ0EZGVgn8xeKkJ6Av13wmbotU2kCCM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9IPncVEUH0RQ3zj9fKL1yOYOUq8GJJ7zesUghJWCSgnmuLxxPVUW5aDbhHIfySJKfDxGglYLAXYyoExpb9uFiVdDy0vjgZikXCM9PwA1CHOBaWZAA+hwe5ViMA5mcxcCiC87zxX2a+clqD1+3cHf4OAHPTG4VaeGyvq70jRZl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZusymjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZusymjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7A2C4CEDF;
	Thu,  6 Feb 2025 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882966;
	bh=Z0AR+dGq89xIhQ0EZGVgn8xeKkJ6Av13wmbotU2kCCM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZusymjfEnW8Qs8B1pTYDFqsAiZsaYROCRt2lmbGaakNYlXBpcyWUB6hbwpcCe2Cc
	 EnmZDYcPGeJzoaBioUHVgrgLNKUu10Bxa8kVQYEzrgR50nSpwHte93IffF/3slCER7
	 RTH0f6BwOuA0+2Re7p2erGU41A88vrpaPg5Nh/DNeKrdlrv79YciYRJ7kkS3hM8K3G
	 yzPF6DgIru+oabk7M4kW1OnqP4l4RYAA5vWUH9gYPxYvttXDPyqcWBnLpdLLEYFqmT
	 uxR87jG8V9jtYvp9Ws4pM5wE3RhB6my8OOlt4QMy+xsj5hlAzbBNA9ziWMna1APf7v
	 iP/edTtG8ub3A==
Date: Thu, 06 Feb 2025 15:02:45 -0800
Subject: [PATCH 1/4] xfs_db: pass const pointers when we're not modifying them
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089618.2742734.15049031959195578708.stgit@frogsfrogsfrogs>
In-Reply-To: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Pass a const pointer to path_walk since we don't actually modify the
contents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 4eae4e8fd3232c..00610a54af527e 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -140,10 +140,10 @@ path_navigate(
 static int
 path_walk(
 	xfs_ino_t	rootino,
-	char		*path)
+	const char	*path)
 {
 	struct dirpath	*dirpath;
-	char		*p = path;
+	const char	*p = path;
 	int		error = 0;
 
 	if (*p == '/') {

