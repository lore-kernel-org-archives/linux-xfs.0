Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F43BA49
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fj94cSPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D88C433C8;
	Sun, 31 Dec 2023 22:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060388;
	bh=GfKtRIymmsMLQEYJ2gKpGz5GBJzCw2Ib1JLdcVbFO/g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fj94cSPqtFJuWqRtPXAZtqpHdGcubuem1X8dLJIZZxDg0pgxCzFpzL8Cy/ysT94tv
	 TOhu/69HLf2sDdbj8LNdL+hoUsMZ4I4JXj9Kg4qfY6UUs3lmcSdlwVc+ZGpbGkmPf8
	 e2EjxvE84VZmxTK15plGdgycmyRX5jESI9ugHcKCZJTpxxPkOMDuul78pWgsAsPGao
	 6Mbej4p/bmcG+f11izxV1J4027vo2GwmlcQvZeZ4AzLkQDn+f3s2e9KNHSLrEfSbuT
	 IEGkgAvgBFIs3Mlq8OSXJVWQcB+n2DGubo1mk2SczYzYLTqxQkgKdnhchf+y2kpsEs
	 EQEvKclkNfFHg==
Date: Sun, 31 Dec 2023 14:06:28 -0800
Subject: [PATCH 2/3] xfs: create a predicate to determine if two xfs_names are
 the same
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990129.1793320.14034009986995240605.stgit@frogsfrogsfrogs>
In-Reply-To: <170404990101.1793320.2115612026823880865.stgit@frogsfrogsfrogs>
References: <170404990101.1793320.2115612026823880865.stgit@frogsfrogsfrogs>
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

Create a simple predicate to determine if two xfs_names are the same
objects or have the exact same name.  The comparison is always case
sensitive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.h |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 7d7cd8d808e..ac3c264402d 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -24,6 +24,15 @@ struct xfs_dir3_icleaf_hdr;
 extern const struct xfs_name	xfs_name_dotdot;
 extern const struct xfs_name	xfs_name_dot;
 
+static inline bool
+xfs_dir2_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	return n1 == n2 || (n1->len == n2->len &&
+			    !memcmp(n1->name, n2->name, n1->len));
+}
+
 /*
  * Convert inode mode to directory entry filetype
  */

