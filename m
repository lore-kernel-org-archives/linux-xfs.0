Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3859B132117
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178638; cv=none; b=mKY40em5LaAfjCzAN5z1GcpYjYRYlnUyOoJH8VSc/UB/H30gTd7INNmS9qXAB325i9jot+gdfaphYUBLgn+qQSA1fO41FOrsQan+7H+pSOE3w3EeVwO5c/V9+nmzhOqikmoSHxjXyt8cVYPxCwJo2IJmjn394UK9ZSljTArVmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178638; c=relaxed/simple;
	bh=j2XZFQ6ALMTKBoDCdV/0MxUvCd/1Nc6so8FYIGe0KYc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfQlBPPWFGwC/B15ZOiA1IUAMIDivn7Wj5Xy8cWhF7txp2cG2h31iqzPi5D9KXSuHf7ATR9ZtYzYmUOYH0RRmpwDBY0u/a6lcDopeULokgdZgpM8Brfvx8tDtdiQoJsDAu3nhq9V0LyNJNklP+A0sqs45z99uJEUhjoUJd0PUR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLxVSoRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLxVSoRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104B2C4CEE7;
	Thu, 23 Oct 2025 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178638;
	bh=j2XZFQ6ALMTKBoDCdV/0MxUvCd/1Nc6so8FYIGe0KYc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HLxVSoRYfjVcV6hdx52T4ecH3XXPYmFKI+PG/QGembrQ7NGKUxfe1FTh5X+Tuf9/j
	 i20OxAtMkhVO89sQUEbgLP/IHeh9tzo22s+DaWgs8TvEx066wJYg9Y5LTIxsOkSlZt
	 8mzI7pF1PowM/upXyJ1wgEksxkiLZefmuOO7aE77X7cXPKYEO0t3uy1Mo1wLsQA4N4
	 Qluyu4RtPuW4eKBqZ+na5GQPi0ypjwokot5P9S++jclJQv8VGHrVRRLv1ZtqK/1ADW
	 S2UBsZZjmlVXuuKv4G6XLP4F/1RUiDzqmibEK/Yr9P8Tjkmr97Xvr03kMk0Mr9kZ76
	 tEmdqSlVspcHA==
Date: Wed, 22 Oct 2025 17:17:17 -0700
Subject: [PATCH 19/19] debian/control: pull in build dependencies for
 xfs_healer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117748614.1029045.1323345829393315088.stgit@frogsfrogsfrogs>
In-Reply-To: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
References: <176117748158.1029045.18328755324893036160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Pull in the build dependencies for xfs_healer so that we can build the
much nicer Rust version.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/control |   16 ++++++++++++++++
 debian/rules   |    1 +
 2 files changed, 17 insertions(+)


diff --git a/debian/control b/debian/control
index 01bdefd60f661f..9b8c04c6e86ad5 100644
--- a/debian/control
+++ b/debian/control
@@ -4,16 +4,32 @@ Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
 Build-Depends: debhelper (>= 12),
+ cargo-web | cargo,
+ clang,
  gettext,
  libblkid-dev (>= 2.17),
  libdevmapper-dev,
  libedit-dev,
  libicu-dev,
  libinih-dev (>= 53),
+ librust-anyhow-dev,
+ librust-clap-derive-dev,
+ librust-clap-dev,
+ librust-derive-more-dev,
+ librust-enumset-derive-dev,
+ librust-enumset-dev,
+ librust-gettext-rs-dev,
+ librust-nix-dev,
+ librust-serde-json-dev,
+ librust-strum-dev,
+ librust-strum-macros-dev,
+ librust-threadpool-dev,
  libtool,
  liburcu-dev,
  linux-libc-dev,
  pkg-config,
+ rustc-web | rustc,
+ rustfmt-web | rustfmt,
  systemd-dev | systemd (<< 253-2~),
  uuid-dev
 Standards-Version: 4.0.0
diff --git a/debian/rules b/debian/rules
index d13ff5cf954cd2..2f66e92c6532a6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -41,6 +41,7 @@ configure_options = \
 	--enable-lto \
 	--enable-release \
 	--with-system-crates \
+	--disable-crate-checks \
 	--localstatedir=/var
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \

