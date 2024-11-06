Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FE9208204
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920782; cv=none; b=RqcCP50aJfCzsR4fPbDNwEy+3+ufthUOmQJdY7S/62+u0t3apTJ3Re8v0o7z6c7z8vIn/EgZp7JvYKkw5dD6A+/JNdNOWY2L7uX7f3HHTkXd3X6qGVzYRbyWQUD3j8eV9tlW6LwNjoSaUHCY4bTaQhXPKa4seoOvsL33Q5CtF4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920782; c=relaxed/simple;
	bh=ilJDkyzt0wvocyOQ1Ctp21j3SclhLFUP3KAWAitX674=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LygPRfp7vBwx4oPfOaWYQrOUXua4OKiY1OmlZTabXGUDlHNVQm7pRDMlv76vUEIPKZh+5hV0JUnPAich7bSseTT2Kz4f4MX/eCDs53DmWVjp490Unaa4dJ68eKAvmGEFUFdEy29dImf5SysmBgH3A3CYk3z0eRJkDsKvApGkqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pJR0uXSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJR0uXSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F04C4CEC6;
	Wed,  6 Nov 2024 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920781;
	bh=ilJDkyzt0wvocyOQ1Ctp21j3SclhLFUP3KAWAitX674=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pJR0uXSASYgAYSRqiMNKs7sJtP5uOZuFC2E6qcYTR+6iUt852CaNAgLBOgY6ztBO7
	 GOWJEbTziIwCwO8s+BeQJ2k3G7WkwjFqKNioUdx5cHUkJ3bmXJ2/DvPFU+mUXNM3kk
	 8LF7Euj1d8rYf01mkXsvDENAbVFs4Oewa7ULt+gpuBXg0FQYb3vZHDgTPv0IJm8A+J
	 2McXNQ3KKoSg2pZ9FmxqxdYnfHWXXlPlTQ9oIlkE+3ZTO73igSGwa5rtY8iDOolBN8
	 AYk39axmTrKlhdcqL0U30pK8cbZBEsYcQflenaijB2b2apGhOJ96Q96URGGJebLXl/
	 DDvnbR35Use4w==
Date: Wed, 06 Nov 2024 11:19:41 -0800
Subject: [PATCH 4/4] design: update metadump v2 format to reflect rt dumps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092059759.2883258.10101323739690762194.stgit@frogsfrogsfrogs>
In-Reply-To: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the metadump v2 format documentation to add realtime device
dumps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 design/XFS_Filesystem_Structure/metadump.asciidoc |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index a32d6423ea6e75..226622c0d2f20e 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -119,7 +119,16 @@ Dump contains external log contents.
 |=====
 
 *xmh_incompat_flags*::
-Must be zero.
+A combination of the following flags:
+
+.Metadump v2 incompat flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_MD2_INCOMPAT_RTDEVICE+	|
+Dump contains realtime device contents.
+
+|=====
 
 *xmh_reserved*::
 Must be zero.
@@ -143,6 +152,7 @@ Bits 55-56 determine the device from which the metadata dump data was extracted.
 | Value		| Description
 | 0		| Data device
 | 1		| External log
+| 2		| Realtime device
 |=====
 
 The lower 54 bits determine the device address from which the dump data was

