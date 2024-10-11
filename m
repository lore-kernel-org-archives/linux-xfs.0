Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB1117548
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610687; cv=none; b=fQQIhTnk+CTikN5I7zd6gQKos4h9j96OS/kDrVrzUWIGidyJcRq2IhhIDXYnmOyM4PSl+pH1yDPnwknHSbLvs2XbVHPVNSVgFMpMRUZMIwvbpc+8gjtuc2hTUrfs7QTEaKnOsJDC26bPAO2mPxrKzG5s0qNtgNNcEyKScIVEhk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610687; c=relaxed/simple;
	bh=82wGGPQ5aYx23Io9iRyCmiVPZtKEEGUucpG+xHQJ1Hg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcOMzgezBzy2JUv9YxdIRGCmOt9rzThaB0RYP4TWph4KF1SJN5wOB7TiTCYgTILbEOQNcS6RxUpkMFI4fqo7XoBqxE7AgrmupMxnTnurg4ZGClToBqcvhzpp0cBzF60Qolr/5Li4SBcMswUbCor6qVauM9xD+bNxsCamG3k93Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ql479//8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ql479//8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B99FC4CEC5;
	Fri, 11 Oct 2024 01:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610687;
	bh=82wGGPQ5aYx23Io9iRyCmiVPZtKEEGUucpG+xHQJ1Hg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ql479//8kXq9i4iqIsG5BeNqYH6VJbLcrdtydDFogew12k3kNLX+XIiwTOqRid1/t
	 HPhxurmSyw6DeBhxhai6IftNSbvAZVtDaxkf98NNZQ/RyM+uHIkBn4ZmhlRr8h60Gu
	 fn2mu4BHDGXYpyw2RqE4AKhngWk3p3QRqVV8E7Ak31ZcQUbtZ/i+PLNniqeGott5Xl
	 2l0WQhAR9zeqrEa5af9e8XQ2br9/tpU155dbmRkFVC2p6uSgmj1ufccu83LPZ+BzDN
	 Ndi8rXCe5JUPZ3KDN9i3p5ZgCDGJBW8zA4plkK6M5W3VLXrlxROJ2zi4fATM5oJKYa
	 dtMpJ2mTKiwAw==
Date: Thu, 10 Oct 2024 18:38:07 -0700
Subject: [PATCH 2/2] mkfs: enable rt quota options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656849.4186363.16336831193757684419.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656815.4186363.7149995381387622443.stgit@frogsfrogsfrogs>
References: <172860656815.4186363.7149995381387622443.stgit@frogsfrogsfrogs>
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

Now that the kernel supports quota and realtime devices, allow people to
format filesystems with permanent quota options.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0e1260ec70829c..c5e6c760c6f772 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2650,12 +2650,6 @@ _("cowextsize not supported without reflink support\n"));
 		cli->sb_feat.exchrange = true;
 	}
 
-	if (cli->sb_feat.qflags && cli->xi->rt.name) {
-		fprintf(stderr,
-_("persistent quota flags not supported with realtime volumes\n"));
-				usage();
-	}
-
 	/*
 	 * Persistent quota flags requires metadir support because older
 	 * kernels (or current kernels with old filesystems) will reset qflags

