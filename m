Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBE1F151E;
	Thu, 16 Jan 2025 23:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070364; cv=none; b=S2WgG9X8bjBtlTC/iAOuMTJJ5rcPnpJPBlrcbf4GSuEAdHAARu9QbH0IwLd8wPb5PqARHBfLu5OCkZ6aXFFklcoTvqG0kFza29WtgIqrMdkLJfxQjcbbKpNuFH+6hOTLu7OnVHdOy48z6r+4PcJBzkO3+MrRGcjyKQ8/tpMVPec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070364; c=relaxed/simple;
	bh=eGLYfSAS1jPiC8cDgTecQA3TB5seG3X1C2zFLDZPp44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h1Tec/lajcgCCF91Ueop2zvvfXLhtBDk/j5QIqLVHV1aKl456HQwtQqk7qdYWnYBjNPVOLLvrp7hdLuf++sSZyZhfrp61CbaQwtpayMJE8FhYPZdwfD29HES4yTDym0Oet1A3v+kQrLBDUUAN0GQG3PYG33xeXMsihXcHdWPdLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLcUV4bD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLcUV4bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6247CC4CED6;
	Thu, 16 Jan 2025 23:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070364;
	bh=eGLYfSAS1jPiC8cDgTecQA3TB5seG3X1C2zFLDZPp44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eLcUV4bD5svNxjfEaQUFWL4V5ehmo44X9FQcVcgtpLVYRQP65WV9twe+9CJkkHNWU
	 LcVL8g7ppYtmpl2c+pP+4gLnzRFvT3FjlwWxut3Z/mvOgIDPpv4itatXlm01F2EPfv
	 Xouud8387VVb8eFnTIb1a8Gf7aLURwts0TFNM46AaQ35iHb2K71tI2U5UkmWJeg8dB
	 EDlg2InCHRMCsNTzXB5PFXPcnQVyQ8WPan7nQgWpdxSg6izy4dl0tQu8lTQdecMCM3
	 YVlLdlTn+Wm/ciAEI6DbkKXkhf/OV6A4MP1v9qIMWItIgH5oaqaJG/ulygqV4j5ZsZ
	 zGNfzL9F6rYeQ==
Date: Thu, 16 Jan 2025 15:32:43 -0800
Subject: [PATCH 03/11] common/repair: patch up repair sb inode value
 complaints
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975212.1928284.8954448177376997104.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've refactored xfs_repair to be more consistent in how it
reports unexpected superblock inode pointer values, we have to fix up
the fstests repair filters to emulate the old golden output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/repair |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/repair b/common/repair
index 0dae830520f1e9..a79f9b2b3571ce 100644
--- a/common/repair
+++ b/common/repair
@@ -28,6 +28,10 @@ _filter_repair()
 	perl -ne '
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
+s/realtime bitmap inode pointer/realtime bitmap ino pointer/;
+s/sb realtime bitmap inode value/sb realtime bitmap inode/;
+s/realtime summary inode pointer/realtime summary ino pointer/;
+s/sb realtime summary inode value/sb realtime summary inode/;
 s/(pointer to) (\d+)/\1 INO/;
 # Changed inode output in 5.5.0
 s/sb root inode value /sb root inode /;

