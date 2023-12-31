Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084B3C8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCEhFBvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD36C433C7;
	Sun, 31 Dec 2023 23:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063828;
	bh=e9VinUzSGDqCiO/LqBKPv3BksDcGXS2nYUdbAysZH2A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MCEhFBvj/ey5Jnd0nbH5T7UeZd833nQCcGjumVgedix+3BCrTy56a7y6qgTuacypN
	 SD/0o5tlL8Pseelq75IjyRQPBDu5I3e+fO3Lro1iEJ4FFNX+aOsiWGTsZ5HOw9Zmrx
	 t4PLKtg+O5YrIGssX/unfbqnWdoROR6uQ83UmvSjWHEYTJpAb+f5Yzp3ccYO40mRtI
	 yVpKZ/WhWiolWjOZ7+qEqfP5xCBl0dbR9Rb/hwhjq5h+iKKWJ/nC0nxyRH0/2sNGM8
	 fKsXM7DcXJM6nI+NdNt2+QOUrQupC4BBo4WEfn7vpABUTz2Id0LsQlW1rkEuzJkpiV
	 DF8fQcXRQ/9yg==
Date: Sun, 31 Dec 2023 15:03:48 -0800
Subject: [PATCH 06/11] xfs: use helpers to extract xattr op from opflags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005677.1804370.7940866102891604921.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 273e8dff76c..ca51b93873b 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -529,6 +529,11 @@ struct xfs_attr_intent {
 	struct xfs_bmbt_irec		xattri_map;
 };
 
+static inline unsigned int
+xfs_attr_intent_op(const struct xfs_attr_intent *attr)
+{
+	return attr->xattri_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
 
 /*========================================================================
  * Function prototypes for the kernel.

