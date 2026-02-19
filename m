Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFFB24729A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544878; cv=none; b=tZBZnyQJ9AWdqIASnyvaZsFPmRmvkv7UHbifuGSSv933tiWRq8+L/D0zZRGP7gx2Le7/f33vMkUJa/1ftJrxqgHLR6/4mu/JbaoNB9Q0S+i7xmk48GzIeWZ9nJd/KRB4p+2vRh43FQXDiLzGLHl5GRcOBRPytbdhkOBS5v9zrCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544878; c=relaxed/simple;
	bh=M/O8EwDMbDjWwDWiPIjePQJ0u3/wTVFBpWJFna4WBiY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iRhkYJFJT0jFoZVp1mk518mTr5oV0x/eQUBkq4oFy0+MzU8biN4dehk3Vbw4Gw16LcwgKMVPTnFv/66cPwbH0hJ7tum5cW2sDKwQ2uN3oQiArd3XW3R/72M1wGc9tzRvASitAFwASLEtohqR5XaMUXxPiPk0G38txBsaC4s6izw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMP+1Su8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMP+1Su8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A1BC4CEF7;
	Thu, 19 Feb 2026 23:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544877;
	bh=M/O8EwDMbDjWwDWiPIjePQJ0u3/wTVFBpWJFna4WBiY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PMP+1Su8mVRzqQeWLDve++NeJBa4pH6z5bOxRXlJOqW1NlwGbiwKxjuUpsF9SQe96
	 7arYnP4ZaVADU34LxFZ/z8JxKIu1FPBuFVoFcEKDRZSBJhf1X/JKtYgWeNeNHUVF0V
	 APsUijRV6/tn8lfeU3Vz+tvolm3TFFxok18T2HYm0nHkFoyhJ6rQDCkhI48Ty7orra
	 LmcNbNQ0oUjbM6h47mobeF3vzb0YQPciMe5/cjbxp6w86XUj6DrsUe1LLmes6MHWwW
	 xiN34Mm79LkNrbSF9av/zTxcWZs+XI2q+vggWUPHJWmB6eRzO7ItXTbPHX1D9L2KQG
	 j7mb+BXdUIGLw==
Date: Thu, 19 Feb 2026 15:47:55 -0800
Subject: [PATCH 5/6] debian: don't explicitly reload systemd from postinst
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154457298.1286306.13846777486780636272.stgit@frogsfrogsfrogs>
In-Reply-To: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we use dh_installsystemd, it's no longer necessary to run
systemctl daemon-reload explicitly from postinst because
dh_installsystemd will inject that into the DEBHELPER section on its
own.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 debian/postinst |    3 ---
 1 file changed, 3 deletions(-)


diff --git a/debian/postinst b/debian/postinst
index 2ad9174658ceb4..d11c8d94a3cbe4 100644
--- a/debian/postinst
+++ b/debian/postinst
@@ -8,9 +8,6 @@ case "${1}" in
 		then
 			update-initramfs -u
 		fi
-		if [ -x /bin/systemctl ]; then
-			/bin/systemctl daemon-reload 2>&1 || true
-		fi
 		;;
 
 	abort-upgrade|abort-remove|abort-deconfigure)

