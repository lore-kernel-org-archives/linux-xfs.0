Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEEE1D0F76
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 21:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729547952; cv=none; b=LMyM4CChLGI3l/5VOoDv1+fKJ+aowMTtfNI0yYk2sg89msie9wI3jPzBq22xHyszhPJ34aM4GJDuY1IEN6cmiaUWOEFXg+PJiNb97dx0mGs9VxDVjPTVlCNn27OgpLY8LTRf3ZiBNKiiCMtVCDCFfFVYQgZpVZwUaxpXGpJT8R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729547952; c=relaxed/simple;
	bh=MwDHne73kBPcwK+qWYDuoanEycpw9K1O6FnhZSmNozg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJ9j8hQezply1v1scNbmbPzOepnjATfUC8NFJUvPAsWzfMR8D/TJYFmbaHPgNBE7JNSvGrdWigkX5m+7KfbtX23st6DuDNC+yk4ZLXGZrJxvEBKEDtsFXnAT9BlXhGBXXiszkoHZ4kg+9AqU8EfQAwP2VPLUcBJBGDDMx2KeOKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6meZg8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6meZg8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88E9C4CEC3;
	Mon, 21 Oct 2024 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729547951;
	bh=MwDHne73kBPcwK+qWYDuoanEycpw9K1O6FnhZSmNozg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R6meZg8G27h9Ch3o+3GrT98TdQZlyOp6LmbBF5vknahIDULxlFUWnf77cSkk5R1Pf
	 QxGHaCdBHkIOubqrejcD4LSqw3Z3y+t/DnUUpXz/P4Mj6E4wRQjWQnJwORulcOgThV
	 tmtUkOS+wQbGcVC7g6/NXiKBQWp+CycGAlyVuARfngE5A4U5A9XV2exzpdmZnxwtya
	 JXbLllXlQsPQkruEIyutawPlDbuCMOOOWnhFZaAEP05E+PL48HQFlsHl+NkBjerWHj
	 aDgR0loYjGxtcKLKpqzS+Bzb3sbrc2homluW7rYNgueZ1tek88FgY4ym7dYT+QZQ5i
	 QebIzjtZKplIA==
Date: Mon, 21 Oct 2024 14:59:11 -0700
Subject: [PATCH 01/37] libxfs: require -std=gnu11 for compilation by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783487.34558.3883793884591579863.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The kernel now builds with -std=gnu11, so let's make xfsprogs do that by
default too.  Distributions can still override the parameters by passing
CFLAGS= and BUILD_CFLAGS= to configure, just as they always have.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/configure.ac b/configure.ac
index 901208a8d273eb..b75f7d9e7563b2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,6 +5,11 @@ AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
 AC_PREFIX_DEFAULT(/usr)
 
+# Default CFLAGS if nobody specifies anything else
+if test "${CFLAGS+set}" != "set"; then
+	CFLAGS="-g -O2 -std=gnu11"
+fi
+
 AC_PROG_INSTALL
 LT_INIT
 
@@ -22,7 +27,7 @@ if test "${BUILD_CFLAGS+set}" != "set"; then
   if test $cross_compiling = no; then
     BUILD_CFLAGS="$CFLAGS"
   else
-    BUILD_CFLAGS="-g -O2"
+    BUILD_CFLAGS="-g -O2 -std=gnu11"
   fi
 fi
 

