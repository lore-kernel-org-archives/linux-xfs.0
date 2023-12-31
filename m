Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B684C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rngDTx4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161CAC433C8;
	Sun, 31 Dec 2023 23:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063907;
	bh=Q8Raf/qaui75K0YXpRdV+CyGxv1OvElKBNrmPljuyqY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rngDTx4y0uCg9Dgs2cBwFtTz2HkvA39j9xibFxSkgr+wrt36IrsEWyIYE6lfOP/z8
	 r6+1COGUvNz9MAntkQbnDi33TaK+JFq98Jc5ryYjpizggSrbW7fteLjC/5IzlD7ixI
	 +GqHBMsZM9nnpTOH2E8q5+1l6it0OTO5uUS1hCUoe3XYjWPM5HlNfegZoTAnEn1JbM
	 9FEVsYWQfTNgohCqlXnp0tb62nB9ey7UTop/nhaxn+k6XqSiWiSjQXTt99bqorESSX
	 CpHtVP97hgcDeXclDXC1ZeEQiv+of9XEGZQQVjOE850aCFwxeiz65KN1qfCP4m3HTp
	 RYmNAv0/9YQfw==
Date: Sun, 31 Dec 2023 15:05:06 -0800
Subject: [PATCH 11/11] xfs_logprint: print missing attri header fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005743.1804370.6059457019562722590.stgit@frogsfrogsfrogs>
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

Not sure why logprint doesn't print the op flags, inode, or attr filter
fields.  Make it do that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 7531c6117bd..e6401bb293e 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -725,8 +725,11 @@ xlog_print_trans_attri(
 		value_len     = src_f->alfi_value_len;
 	}
 
-	printf(_("ATTRI:  #regs: %d	name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, attr_filter: 0x%x, name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
 			src_f->alfi_size,
+			src_f->alfi_op_flags,
+			(unsigned long long)src_f->alfi_ino,
+			src_f->alfi_attr_filter,
 			name_len,
 			new_name_len,
 			value_len,
@@ -853,8 +856,11 @@ xlog_recover_print_attri(
 		value_len     = f->alfi_value_len;
 	}
 
-	printf(_("ATTRI:  #regs: %d	name_len: %u, new_name_len: %u, value_len: %d, new_value_len: %u  id: 0x%llx\n"),
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, attr_filter: 0x%x, name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
 			f->alfi_size,
+			f->alfi_op_flags,
+			(unsigned long long)f->alfi_ino,
+			f->alfi_attr_filter,
 			name_len,
 			new_name_len,
 			value_len,

