Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6C647F62
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389878; cv=none; b=JKPtsG1rCx0Fs4kY1ziRu0ItAKo0lBwtow3wj2S+gxXM5ygdfRwsE9FqWOvSv1n88/gLQlrNJdNC23uOq32imluLUwzuDV6wTHUgdB7JAgXr51tYXFcs0PRVa02arS2Izdp65B/dFqI6j9lYj+toC8Wwhqx7gZsKjnzLzMgU6ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389878; c=relaxed/simple;
	bh=ypt8NmLmxZ8rglpVjt9MV0fCP+IpOrKs+Cm3vw1shWI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XTEMw0qiU+rLqaDZCGdCgUZP/9LGExtxaiYMuuRlmcjGaabdtxSQLKAJvmgrUHsDf0lyzbUWW+pTfSRdg4NOA6hLm1/AGFRRr8RhSyuI9EmKRAq+pTD36L3ADBugSdszE+WkRWDlG86KspxH1mom2AZUf+1wccWtppioktdbKKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BcHMQ29z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcHMQ29z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC03CC072AA;
	Wed, 17 Apr 2024 21:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389877;
	bh=ypt8NmLmxZ8rglpVjt9MV0fCP+IpOrKs+Cm3vw1shWI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BcHMQ29zqKrRfRNrtfSB5AWy3iI0fK/WKrheHxDGpxwMOXM+5f7Q7UzTo6xIaGtRm
	 Ey0LojFO5P5fEfGGGfn99vpLjET2l7ovp0pEmjA8CYFGltvk/8zpCn6yKaXM1I2YAS
	 v3W5WEThTYEu3gxJsiTtn8kNQ0OoM7H1LaEiRopjv+RFRJkzmdTF4WUcJ0SMU9DPwi
	 8kf1VPF/Xaad4/xnC4dXPOF7BP8kBAWwQTDbsHtEkMmx4y0BkvoAWSLm6ybpu6Kqk9
	 NolLQ4lhO6qSL6Pfz+mDXudGzcycf2ionduUTirMvQDRdVP3EscWUZ8pcfg5aFfeDb
	 KvvCPbhku0p5A==
Date: Wed, 17 Apr 2024 14:37:57 -0700
Subject: [PATCH 62/67] xfs: turn the XFS_DA_OP_REPLACE checks in
 xfs_attr_shortform_addname into asserts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843271.1853449.15769007156745438916.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 378b6aef9de0f7c3d0de309ecc61c11eb29e57da

Since commit deed9512872d ("xfs: Check for -ENOATTR or -EEXIST"), the
high-level attr code does a lookup for any attr we're trying to set,
and does the checks to handle the create vs replace cases, which thus
never hit the low-level attr code.

Turn the checks in xfs_attr_shortform_addname as they must never trip.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 055d20410..1419846bd 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1070,8 +1070,7 @@ xfs_attr_shortform_addname(
 	if (xfs_attr_sf_findname(args)) {
 		int		error;
 
-		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			return -EEXIST;
+		ASSERT(args->op_flags & XFS_DA_OP_REPLACE);
 
 		error = xfs_attr_sf_removename(args);
 		if (error)
@@ -1085,8 +1084,7 @@ xfs_attr_shortform_addname(
 		 */
 		args->op_flags &= ~XFS_DA_OP_REPLACE;
 	} else {
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			return -ENOATTR;
+		ASSERT(!(args->op_flags & XFS_DA_OP_REPLACE));
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||

