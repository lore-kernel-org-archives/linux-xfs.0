Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A3A2FD681
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428070; cv=none; b=uLj3q5dZ+8FuBsgWaifysEqKAvLYZobBxBGHQ0oC9yCp67dQaRvVmEqFaTmkZ7D6hr/vo2F5RxyssTwu0BFdndnZn4b2Z1afUAgp+z+vfaiQwQ+cpJ2jbJWgHKIeHCg7ltNkcorpeLXu3nErK2BCjMLKySOQXR7a50utpVz5jX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428070; c=relaxed/simple;
	bh=YedcH+4JFCiYIOatn5kBV0odAWcaO/+S9XkzLraZ0fM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kp5gpiZ/qMvEmVpOQjWLM1SIgUcEnldspuHxMLHrWEKmr7FB+AfG6HZiPgYJ+Xg/X5IyP8aSsWNpmOci32AbqmQoNEg1zvN+577DttuWgdVDG0XGWwd/i7Asre66uZRsvIp3nzXQqTFXpYj5PGMTi07jGxcXHrAd2VD9xw2HsPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l796xeZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l796xeZX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1FFC71F000E9;
	Thu, 25 Jun 2026 22:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428069;
	bh=C3HRKuj1mXvBwlqofmIOuXwvd6vJCvZUPnrU8U+nzV0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=l796xeZXkCjMDwOPnYKNNFlDFsRzEVVSGOnwCMPlYihrkyZI/gLoNhLcT6RxqiD1x
	 +4cngXKqY76Zd2uizcCXtA8vtI/QGltp/SxCq19uEL0hzWbVG1lozH9COYW/SPQx9K
	 5absCFhoeEb76BRRHkUWFG0WhnTQ6hrD4RZWdAhMbEaR+jFxvHGKDqkClK0cgue0UE
	 +FTpKDkfS4VU+GfHRGhsILcaMvC5nJLlXJZjLH7SekUOkGHQztFUvcMbWpfbvL5n6J
	 OSz7HxCA0F9tS1qmGkVx3kxctN4VGhoVtNCBP9pEB2Ucs/2mpGjeEc6msISMSTTwQT
	 lJa7k+pmu6oyQ==
Date: Thu, 25 Jun 2026 15:54:28 -0700
Subject: [PATCH 1/8] xfs_scrub: stop user file scan if caller already aborte
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801323.1981574.6328414059926266139.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that scrub_scan_user_files keeps calling
scan_user_bulkstat in a loop even if something else aborts the scan.
That's rather pointless, so fix that.

Cc: <linux-xfs@vger.kernel.org> # v6.14.0
Fixes: 279b0d0e8d73f1 ("xfs_scrub: call bulkstat directly if we're only scanning user files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 7ce5f7ffeb62a1..7dee938c0a45cb 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -879,7 +879,7 @@ scrub_scan_user_files(
 		return -1;
 	}
 
-	while ((ret = scan_user_bulkstat(ctx, &si, &ino)) == 1) {
+	while (!si.aborted && (ret = scan_user_bulkstat(ctx, &si, &ino)) == 1) {
 		/* empty */
 	}
 

