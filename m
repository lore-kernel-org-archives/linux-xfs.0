Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A13D502
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302315; cv=none; b=bC4gaEQuXaopI1PYCraIlHkPKlVWCV9SNK+1DWsAqRBBgWyy9D99IaZMB2l+IR5oQGXj0M52fvi9oyU7KZFYmK1huHqVkJUe8/OBozt7OiwYiKjARAKjSEqqb/x2wGKNPjwZwi2JbpbPRh+Vj9xVqJey6YTQu79BRBO0IIZpd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302315; c=relaxed/simple;
	bh=39WB5NaJM51hDmCFZ/Xm5rsWeDbWi3TJ/3sCJs66TOo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d/MCxcqQBNE6ik/2GSmnAs1xW0lMJfslUcq5gilzHUw5dhZYWzgFCfWWG28/n37M5I2Ofn5FK0kYWBGqdQ+PbU7SEg7O1wbAv845cS5q9KTI1eip/0nOgnKNmCjOScCYLsxHgSbzOUIUeU+1Mwo3HXAk0QVkdD31z1Jf5kJUbG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YvmLbgyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YvmLbgyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F84C32786;
	Tue, 30 Jul 2024 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302315;
	bh=39WB5NaJM51hDmCFZ/Xm5rsWeDbWi3TJ/3sCJs66TOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YvmLbgyYNXYavGxJVlYrZFgN/PhL380N/zcdCPeZJn6jPWOpYlaTSzZI7K+Erzu3D
	 YGirPrVAlDtRbizcwq5a4YGON/6jNRw4xJiXtXB8k36lqywozNFtBpSNetYeu6+ztc
	 5mOthk6UpqIzdIrGIK/mmnmX+85bocypFwWfN9VCRfwapWW+E9yIHLNe5EdMTIc8QU
	 V8JFsx6jsdHZEHRPAodkZR0lc62wCyURDLiCrKJNk0c+sTIxRISq+FAiQiC+IpEwj/
	 sUo4txCoLetiN83VarYi9tXqcgBDUHMFFpmS13+WFcXw4V9xXLa2zc6bos7CsC76cA
	 tV7tQWOsDNCDQ==
Date: Mon, 29 Jul 2024 18:18:35 -0700
Subject: [PATCH 5/6] xfs_repair: enforce one namespace bit per extended
 attribute
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172229850130.1350643.14668236146679133676.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
References: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
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

Enforce that all extended attributes have at most one namespace bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/attr_repair.c     |   15 +++++++++++++++
 2 files changed, 16 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cc670d93a..2d858580a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -36,6 +36,7 @@
 
 #define xfs_ascii_ci_hashname		libxfs_ascii_ci_hashname
 
+#define xfs_attr_check_namespace	libxfs_attr_check_namespace
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 0f2f7a284..a756a40db 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -291,6 +291,13 @@ process_shortform_attr(
 			}
 		}
 
+		if (!libxfs_attr_check_namespace(currententry->flags)) {
+			do_warn(
+	_("multiple namespaces for shortform attribute %d in inode %" PRIu64 "\n"),
+				i, ino);
+			junkit = 1;
+		}
+
 		/* namecheck checks for null chars in attr names. */
 		if (!libxfs_attr_namecheck(currententry->flags,
 					   currententry->nameval,
@@ -641,6 +648,14 @@ process_leaf_attr_block(
 			break;
 		}
 
+		if (!libxfs_attr_check_namespace(entry->flags)) {
+			do_warn(
+	_("multiple namespaces for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
+				i, da_bno, ino);
+			clearit = 1;
+			break;
+		}
+
 		if (entry->flags & XFS_ATTR_INCOMPLETE) {
 			/* we are inconsistent state. get rid of us */
 			do_warn(

