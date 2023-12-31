Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A5C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQS/iboK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CEFC433C8;
	Sun, 31 Dec 2023 22:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063219;
	bh=EzPoZV9/dsKmTzrH9rtXyDruww8MaA3YrKz9NvOpb0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SQS/iboKvHU74hsNBT29HmmUPjKioWuP1AsPf7wEKhA9uqnvhzxhUZpeqvkU9HwDU
	 ArJ+0+3zxE4vSip7cL82meNMcdnfyzB8gGGJYXAqqXH8+VDgb84rMby7wQ4RcLKw0Y
	 XoOgizgb074C5eDkxOMQ7Iulc0FBGRgNpx862fkG75dj6om6GTQqVLI3lVps87oPTd
	 MPDc84povfZ2cNzwlXYQr/Pd7PoE2EfInx50t3yLSN991cillUCGxNzcKC6wL4yZh0
	 iIcNej/EQbS3cjN1iHY55PhlSQ50jLarnNdZ10aIgXgwCx1tvL/TbjnQjLn0leQq5D
	 VhoZW8iUq5nnw==
Date: Sun, 31 Dec 2023 14:53:38 -0800
Subject: [PATCH 5/9] xfs_scrub_fail: return the failure status of the mailer
 program
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405001911.1800712.1452013057147421398.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
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

We should return the exit code of the mailer program sending the scrub
failure reports, since that's much more important to anyone watching the
system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_fail.in |    1 +
 1 file changed, 1 insertion(+)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index d6a3d92159b..d3275f9897c 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -33,3 +33,4 @@ So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
 A log of what happened follows:
 ENDL
 systemctl status --full --lines 4294967295 "${scrub_svc}") | "${mailer}" -t -i
+exit "${PIPESTATUS[1]}"

