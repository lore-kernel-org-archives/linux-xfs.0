Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6F419F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416138; cv=none; b=EthiYWh8T1KUKnbRzPcLrt01KbwC2CvkhveNMPQ8Kmwnr44niz+V+1uj7SjGxC0zSMt6B9jUm1D+Mk9LD6ylPEnUfshHWgyYQupWcbMzU3vGeAg+Df/h62X3WCrmCLF9forfpaG+zBhSUAKwxbIR5U+dhgXEjCNdFcBdA0Kqz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416138; c=relaxed/simple;
	bh=TZ7PdVmUBavRMaqPeLY+6pWGngpv4zjn3ds1Oja8kNQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=akUlaMoMFjDLM59xrUg1opnnpays7I2HjpkDM6Dc5G6WEP4l/gUlOHNmRDD+FLCD+z1r1NZBtHx80UJsueZbbpvvs1E41GHJ+3sa5EtyWjNNMRhe5rmU79V52efsgNIrqMBnnifWiM0Ah8YS9Dlgh5GQwPCNp5rBRxkYOqnzuNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVlJSzGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVlJSzGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E6BC4CED1;
	Thu, 31 Oct 2024 23:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416138;
	bh=TZ7PdVmUBavRMaqPeLY+6pWGngpv4zjn3ds1Oja8kNQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dVlJSzGiempHL2jT1wRxk9YkMYulUJ/ChK5rIsApdo+XPNyD0AIgjZt4wgDvTic2j
	 2H5HEew5d4XRD74D/CL/g+NjIyCFHd2Kci6wO8bGptROLrYI/xqbTy/KXS5beWqo4R
	 Hf5jzBtogxCmzbhCLdpBa32mrlLIdmu+ayZCWqspoLwqW/CT2dow9gRA8zt6OWSvnm
	 M1SCwcfRhpVY057fYBKoL75bOeCqJO1u5SaVjQs/DbI7kaclpa2mX6noCU3NGWP8hA
	 YqZ0Esp1fC4KDMvzVNzVA624qem4nPPn12uyC/LCMsjBuNHbNVaMJAa8QJ9AJW2tIH
	 3O6FyNwaB9JJQ==
Date: Thu, 31 Oct 2024 16:08:57 -0700
Subject: [PATCH 01/41] libxfs: require -std=gnu11 for compilation by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041565936.962545.8816035398454923868.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

