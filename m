Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B48443E4E;
	Tue,  4 Aug 2026 09:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836782; cv=none; b=KdGXtNNA/kPANprSwuQVBkVO6k7bVqroO8RB3o/O4CvvXAE71418uA8fbOl2UWd4GwdlcKVZjP0Sdu9SlJBgLLZSoa1Mv+//+iPOjeVkxgaOmPnLa764rV1c71J6FwHe4oc0pboI3yFXV4A6DGyjbnAEVrIr8ch+HMeOVhu9ofA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836782; c=relaxed/simple;
	bh=yA8BgOH6CKTpoVpmwQuEwca7Vt9peEfZ5FZfaUAxHuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPkfI2QPe8XiW3g88ilUa7g+inv49I3UGbkZJVeMVS48WlxV/dEcVCGmpvFCx006ETULtAuxjQaBdqIOQP4JAVyB6LeSIW/FGkiir/LEC47vnM1iVEtHz1KjRatrzmuPYQ3WgtFiIxRN6cjeJ/5sOl2GDcmZEUyRKtXG1dEZAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URU7TPax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URU7TPax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547BF1F00A3D;
	Tue,  4 Aug 2026 09:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836781;
	bh=KD3nQlzzgPQMXfG3TkWBP0YqCUulLthOljSvVABaabw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URU7TPaxCYuX3zvG2RUYaJB4XVRkC5Dkz8/zAz09dFQxc6oQA5Oudxc8uJYWD5+Kb
	 Psj+QoM8EAQ5LSKGMkoOlYCKr+O0VdQUpFwq6NSLb0DXWK49A1h1ycIREg8b3lWDZG
	 b86yq7AURMP4S98OV6niLAydXWCGZJKXudkkxHTsyNPNGUBIvlJrsIKh5/CNm7PbQW
	 j7J95Ealrh1Qc40xCD1N6CmBrZTVSxvhwCr+qGXnIOfExDixbPn/fDJp+kziNIOmCj
	 ycDsy0d5A3lGxpXRpGqIzsMv1cuU1K00sAaey64XtlozNpirONb0PegCoTxuB2462+
	 kIoA/5nNMOJUw==
From: cem@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 5/5] capability: unexport has_capability_noaudit
Date: Tue,  4 Aug 2026 11:45:55 +0200
Message-ID: <20260804094602.84766-6-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>
References: <20260804094602.84766-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This has been originally exported to be used in xfs. Giving we are not
using it anymore, unexport for consistency.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 kernel/capability.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index f4a7f1963c9d..90e6ab62f6db 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -326,7 +326,6 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
 {
 	return has_ns_capability_noaudit(t, &init_user_ns, cap);
 }
-EXPORT_SYMBOL(has_capability_noaudit);
 
 static bool ns_capable_common(struct user_namespace *ns,
 			      int cap,
-- 
2.55.0

