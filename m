Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D08184E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300091; cv=none; b=JhzsMS1ic/c3WXixThvX8zUVC0kg4ApeF9rkDJLl8vA1ej5ljqAbEo1gI3B4bUM95iUINJFl9bT8UpqsBIshHBZih0YxSpxBys0F45AsPN6UKQ9cb+yYoZHbJRkI2BqeNqeFQxoG9pcFRlPWORqJNpTsT/a3WLbgar7jEbX3XiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300091; c=relaxed/simple;
	bh=8XlkJuSJdf7VN6ryXv0r7pIlDITttpcUJXqLIcjobVc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7cCM2ktmaOKUCy4pfFl9tkChxaiHHK+I9pbN3E9+Tz5NmGiR45mwugbrX/Y1y8gJO0F5Ah9dtnjInQazGYUHvdVnCM9FCoM4nz+GQK6uU7kno+MJre/jZU41Aq8qtSskrwSk66+kNJ2ODzCf81Y9DMjn+d9bWsvrNw/liOWMqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/VoEgyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/VoEgyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EC5C32786;
	Tue, 30 Jul 2024 00:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300091;
	bh=8XlkJuSJdf7VN6ryXv0r7pIlDITttpcUJXqLIcjobVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e/VoEgyZkuLIYOsxdID0HcdByKS2QFapLajg0dEDkAqWlFMrr2OCyRdXqqKI6sv64
	 Wus9vBdhKOg0hmhTectSfu0ACYC/u22NivruCTHXZ5ZW3xzvqeV8r5GKwbTtg5S0YO
	 mjFZpS6bb+7phKWU4jIGhlXn8vw4pzOLIyucw+rMCMrxVsKDZmm+azx0okfDyjws94
	 ozDBiPizE+JKMshAmfhtVp7BRtNucHcGQDUuJlXMXjXAep30V0YIvwffp3Hp1Da4Uj
	 DCuTT+j09dDjRW7aRvu4fp3xa88//t3VRZVpUIz58XF5rQMYkOYGSIAizZgogYZx8c
	 YchdTrt4rhR7w==
Date: Mon, 29 Jul 2024 17:41:30 -0700
Subject: [PATCH 068/115] xfs: don't return XFS_ATTR_PARENT attributes via
 listxattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843401.1338752.22200803405477761.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: daf9f884906bcfcffe26967aee9ece893fba019b

Parent pointers are internal filesystem metadata.  They're not intended
to be directly visible to userspace, so filter them out of
xfs_xattr_put_listent so that they don't appear in listxattr.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Inspired-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: change this to XFS_ATTR_PRIVATE_NSP_MASK per fsverity patchset]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 1395ad193..ebde6eb1d 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -726,6 +726,9 @@ struct xfs_attr3_leafblock {
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT)
 
+/* Private attr namespaces not exposed to userspace */
+#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT)
+
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
 				 XFS_ATTR_INCOMPLETE)

