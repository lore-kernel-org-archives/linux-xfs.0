Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EBB8F40
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302097; cv=none; b=JEEzagG5cSl1Eyc1Avk8nnsOY8lH8EmnUwWKYAjzoPXHe+7keVtvcZfruRdFTTaT8N3c2ELSY3zXZg6qvmNqt70diR2bcBHkMFdPhH68Ecb47yqbc5J/oS57uoN1VGCFcsVYETv5mKi/Nl5x7/ytIau7DILMjO4qOS2xMFDPu7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302097; c=relaxed/simple;
	bh=twE7QfeBFmCQsbI8pyGf5U8axmg/NA/KYQRh2fP0bCo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mp/tq0bjuK3SW2e84Gf26oAIgWoLdQrl+S7OpzfSIVRyW7GjizBgvaQ7PU2BsgijpZ2GOGpGmnnQgD8k8SEtyN342zAVUhoe/09lcirvsGtfkW0UAu8P2TB30taxdU60DiksLA5ISI/ELl1iHCrthAHtHy0mC+0MlbdRh4/8J50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=id7Q11a7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="id7Q11a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718C4C32786;
	Tue, 30 Jul 2024 01:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302096;
	bh=twE7QfeBFmCQsbI8pyGf5U8axmg/NA/KYQRh2fP0bCo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=id7Q11a74IdqttL1dvI7MDNok2PHy2prclQp8NYI8wIZiG6S3cgQKtt25vnwIvzTG
	 uFg4sEUGutJpVmMHLVNUEm9oiwOGn8MCqMwJFd0URLbZEGlCLwqp+x/9huMcUFDKbN
	 YsTF1t2QtZS6+PhlzfehG50keDIAtZ4d1EvVCx7jks43PplnT93GiRe8BENGMmgJDd
	 H8AbXSuOH0GEBeP+77uPhLSRJjq43GXTSoOL2fHD0A1vJ9bK0peT/ahRoVrsap6UBF
	 VYs5/IwJ2Cteh2ZE8k/lDPnmKgtirCyDFXkHB0keDoMcUZljWdU9sjr7lG6Ee10SZX
	 XHZPc1v/7PPsg==
Date: Mon, 29 Jul 2024 18:14:55 -0700
Subject: [PATCH 2/6] xfs_scrub_all: remove journalctl background process
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849276.1350165.9133033700785877949.stgit@frogsfrogsfrogs>
In-Reply-To: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
References: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
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

Now that we only start systemd services if we're running in service
mode, there's no need for the background journalctl process that only
ran if we had started systemd services in non-service mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   14 --------------
 1 file changed, 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index f27251fa5..fc7a2e637 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -261,17 +261,6 @@ def main():
 
 	fs = find_mounts()
 
-	# Tail the journal if we ourselves aren't a service...
-	journalthread = None
-	if 'SERVICE_MODE' not in os.environ:
-		try:
-			cmd=['journalctl', '--no-pager', '-q', '-S', 'now', \
-					'-f', '-u', 'xfs_scrub@*', '-o', \
-					'cat']
-			journalthread = subprocess.Popen(cmd)
-		except:
-			pass
-
 	# Schedule scrub jobs...
 	running_devs = set()
 	killfuncs = set()
@@ -308,9 +297,6 @@ def main():
 	while len(killfuncs) > 0:
 		wait_for_termination(cond, killfuncs)
 
-	if journalthread is not None:
-		journalthread.terminate()
-
 	# See the service mode comments in xfs_scrub.c for why we do this.
 	if 'SERVICE_MODE' in os.environ:
 		time.sleep(2)

