Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C783147C9B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638881; cv=none; b=NFT8bEEwaiIhmOXQzdO2Y3fPFIjNihzyp1Ac1jG9cHLK/hK8tmDsVR11MKdjJVxL3jvwOwBujzoU0wynqzNEhypBg3ajL7BO7Dyok25r9YzdbUjGDaSdSlvztO7+DTct3IPfjKS4iHWhoWrOK2VRNK77UzQ9OEriREw1swFaXlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638881; c=relaxed/simple;
	bh=tbGQAlosmlg/5uZ1xsKittDTTEF1uVPmlXA+/x9VE+4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBhmE3L7C+9WX4UUTVurq4REhhA43jSWDGV8cGCzGpCRN9iuByTZQFcLf0qUyETCP65IgHC51Z7XvmK9VuXYBLS177VSGvAJgRnk5Pn5XsPiAK3Yjvi/Qkb6rWSoUQMdfTRc4XfmBCD3j/yLN607IvTwwVhiH38KwSlH+D+tZ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGLKa3/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGLKa3/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2ABC4CEF1;
	Tue,  2 Dec 2025 01:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638881;
	bh=tbGQAlosmlg/5uZ1xsKittDTTEF1uVPmlXA+/x9VE+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VGLKa3/n+3YS38j1nlDR8jz1d7e/p7anFixiKla3JYIR7Z7K8aOCI47vl+5fUE60F
	 es0yBW0mVzmChFlD5OqG6lHVVhQfyIgBTX4/VDPo0D+3tHMsRSDomjC6r/AxEdEEzO
	 X4jFSyQ50I9JLiw3W4a7YJMfzajlV98NMLXtTnTc5xOCQZehq5Dx+j1aVoAwOqROIu
	 NykEq05yLCVgLoc3UnNEtmMaILdWUPkMFkY9KNinn7Hx1QF13tTr2EPT/yid7YzU0K
	 JDrPdfl8kk5K9uxtTEBfZkheMt0FfrmhhGjLxjX+nUkhz4MnQuuQC+lChdnYz9adQc
	 Xz3vRHX/Pg34w==
Date: Mon, 01 Dec 2025 17:28:00 -0800
Subject: [PATCH 3/3] man2: fix getparents ioctl manpage
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176463876154.839737.15121592187004060239.stgit@frogsfrogsfrogs>
In-Reply-To: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
References: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a silly typo in the manual page for the GETPARENTS ioctl.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: a24294c252d4a6 ("man: document the XFS_IOC_GETPARENTS ioctl")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_getparents.2 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/man/man2/ioctl_xfs_getparents.2 b/man/man2/ioctl_xfs_getparents.2
index 5bb9b96a0c95b1..f739c115ed4ead 100644
--- a/man/man2/ioctl_xfs_getparents.2
+++ b/man/man2/ioctl_xfs_getparents.2
@@ -35,7 +35,7 @@ .SH DESCRIPTION
 	__u64                       gp_buffer;
 };
 
-struct xfs_getparents {
+struct xfs_getparents_by_handle {
 	struct xfs_handle           gph_handle;
 	struct xfs_getparents       gph_request;
 };

