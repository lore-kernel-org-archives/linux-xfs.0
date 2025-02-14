Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B371C861D;
	Fri, 14 Feb 2025 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567544; cv=none; b=AaQ61BTkEc7CY9a9f+x0mtWymPaY5v9AC9K501DI4joKVS26xl6sL+Cy5nY17KF+qIxghgE3AdydTuzawW14aMi1noz+PvMqvdLFpwIwsUVkQzVsWo/2bE2g7XgJRw7nFQLv5MgjHxnqSTbn9vPod5pZ5yRId3GXkAkBof8oGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567544; c=relaxed/simple;
	bh=4S7tJobB4PKXGlizQaG5akxNUt6bPNk899FxQq2I+KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmbxR/eXgy6S6ZX3xrB8i48hhV6m8sWFeoiH5FaOLaGSXKMYL+BJmQpix6LQW5EHstLeI5+dViv4r1kWwogDTHaY2wZwOAYL++BnWxx4BkkkxZBCpqjRURe0uUiYBTxPw+snOiH48//HqD6jc77AwZQCp7WhZa2uPunHBn0GURg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSSCHUQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSSCHUQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FEDC4CED1;
	Fri, 14 Feb 2025 21:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739567543;
	bh=4S7tJobB4PKXGlizQaG5akxNUt6bPNk899FxQq2I+KI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bSSCHUQktVAgSJceF9suKsvYDiEdJApRtjT58HbWw3qopMOVKwWIAJpjH6y4mVTpG
	 i5rdFGUcFuuJiyUjos4d/bwNwmYupIttRRr2jy4KBWGxkoRnA1A3Mg3FD1aQtR2WJi
	 a6oMvdbvNPYbyP5FcekQXwZxGybVmiqFZZ52psEQrGfYAr+tMIq/kOGouQKUP2camU
	 ojYF3EvmYlIARnY1uAZI7ZOFuqht9uWwjuHhtj2eHoQb3LY0f+3UyY46+g8yhvId/i
	 W+w54Mnn7Q32ShPsA1MDS6uspoFvwaXaS1TWx3/1MMHeGJWexVY/lncrvaLtObtaQ0
	 HnnYy0hc4+xOQ==
Date: Fri, 14 Feb 2025 13:12:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 13.99/34] tools: add a Makefile separate session
Message-ID: <20250214211222.GE21799@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Add a Makefile to the tools/ directory so that we can put helper scripts
in there and have them installed at make install time.  The makefile
comes from a conversation that Zorro and I had over IRC, hence the RH
copyright.

Suggested-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 Makefile       |    2 +-
 tools/Makefile |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 tools/Makefile

diff --git a/Makefile b/Makefile
index d4b77c1cd17787..e2e47ffc2e6e07 100644
--- a/Makefile
+++ b/Makefile
@@ -40,7 +40,7 @@ LDIRT += $(SRCTAR)
 endif
 
 LIB_SUBDIRS = include lib
-TOOL_SUBDIRS = ltp src m4 common
+TOOL_SUBDIRS = ltp src m4 common tools
 
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
 
diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 00000000000000..3ee532a7e563a9
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,17 @@
+#
+# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+TOOLS_DIR = tools
+
+include $(BUILDRULES)
+
+default:
+
+install: default
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(TOOLS_DIR)
+
+install-dev install-lib:
