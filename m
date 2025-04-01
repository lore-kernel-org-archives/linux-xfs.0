Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15593203714
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518654; cv=none; b=kKCP0yRtZgx6U6EQ3qbl3NUql7Q08E8gs1NI9m62ikf/texO/g+/haIoDPRBa4jqIJkpOa+TenMl75h3IZjCpgfqc04h8sRrGIbB6z1tcpb68PyNNYwDbqgRuiKValRk53m7vqF7slCDvSbcpNIWbyRtUoRrW5gG2KKhHuhBW+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518654; c=relaxed/simple;
	bh=cgFBw3U8v9m4LO2rQKwDaZb/4a7P77i9d00As1R7RZk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cmNiHfaWTW9bQv240jK5CafHtJgeiILGz2FlPvN6egjpH8IxIQ7M5gZYo5WLcnrc10YUJN91olCjYBgBF8ihKnj9pxxLCK6NOkWdctibNFf3+PmweM06iPjNf8/pB2GJzCbt6NBvA1hAsuKDO4+zpuVI0hjE9hH9TncsesSGKWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjHb1HJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjHb1HJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABDDC4CEE4;
	Tue,  1 Apr 2025 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743518653;
	bh=cgFBw3U8v9m4LO2rQKwDaZb/4a7P77i9d00As1R7RZk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JjHb1HJItx9mymhttuRRehw1mZwddKepzeTjejj28CL/GSkre+rHDRkYne9fSuqT1
	 IUnYvymI9/INkkNbKV7Auug74oKu53/N+4ydZZJOC/zvz4bYvg+J3oUo7G/7rjyJXL
	 UtA8WeHSo6FFqa9enutkVOXXSKKW7aFqwNEp/GDUEC1+BZUlXMUdf7sjlFY2v7nuuJ
	 pKLN2r0e0OurU86/qozMXpsTZ0QdIMbA+V7f1AZe7B3Q5+WzWv7fh1RFbUYwDjoEhH
	 LvTjXtHf82LDaosJXi2G6O6UPVHijsR8jh0ZmalWmCUpeZZ0SHIo8wFeMErcL5uO16
	 7fMs2MIIqw3Iw==
Date: Tue, 01 Apr 2025 07:44:12 -0700
Subject: [PATCH 3/5] Makefile: inject package name/version/bugreport into pot
 file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174351857632.2774496.16341007015708291183.stgit@frogsfrogsfrogs>
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
References: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Inject the package name and version ("xfsprogs") and the bug reporting
URL into the generated gettext .pot file.  This isn't strictly
necessary, it's more just polish.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure.ac         |    1 +
 include/builddefs.in |    1 +
 include/buildrules   |   10 +++++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)


diff --git a/configure.ac b/configure.ac
index f039bc9128fa4b..71596711685a8a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,6 +4,7 @@ AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
 AC_PREFIX_DEFAULT(/usr)
+AC_SUBST(PACKAGE_BUGREPORT)
 
 # Default CFLAGS if nobody specifies anything else
 if test "${CFLAGS+set}" != "set"; then
diff --git a/include/builddefs.in b/include/builddefs.in
index fe2a7824a8653f..04b4e0880a84b8 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -42,6 +42,7 @@ PKG_GROUP	= @pkg_group@
 PKG_RELEASE	= @pkg_release@
 PKG_VERSION	= @pkg_version@
 PKG_DISTRIBUTION= @pkg_distribution@
+PKG_BUGREPORT	= @PACKAGE_BUGREPORT@
 
 prefix		= @prefix@
 exec_prefix	= @exec_prefix@
diff --git a/include/buildrules b/include/buildrules
index 6b76abced9ed0c..ae047ac41fe27c 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -85,9 +85,17 @@ endif
 endif
 
 ifdef POTHEAD
+XGETTEXT_FLAGS=\
+	--language=C \
+	--keyword=_ \
+	--keyword=N_ \
+	--package-name=$(PKG_NAME) \
+	--package-version=$(PKG_VERSION) \
+	--msgid-bugs-address=$(PKG_BUGREPORT)
+
 $(POTHEAD): $(XGETTEXTFILES)
 	@echo "    [GETTXT] $@"
-	$(Q)$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
+	$(Q)$(XGETTEXT) $(XGETTEXT_FLAGS) -o $@ $(XGETTEXTFILES)
 
 # Update translations
 update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)

