Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF4DD502
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301846; cv=none; b=c8aSazHf8LoBJM92QV+geHcS+YZWzDEcVz7S2wJtbv7TBixcSZRK0uvBzgAG9EB+geTKnWelU2ePnmS4PoZupjipRwEY6uhIpNpNL1DMv8mFN2uWRZxHZxUrE0TY58hx0QgJ0oc+xCxU9AGVn6VPcMbiL0+vCjS3WB+uy9w0D1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301846; c=relaxed/simple;
	bh=KSXMI0hWNh6vzD2vnemy+0fpUODX5Uh5r9Oumx1NoWA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uc63tmZGZ5hlR/KV9b5LRCO25q1npNuhdZ70voei/u7di18//k8ICh63S7cy9WtSQ60b36uuu7B2FZFDSicTs7r1FxSZS4ykJWfkRK2/a+y1OPQ+HtEBeHYFAZFng+xtIBCTQprpXDwnbAPQEkVwIngDeyHju6FDaVdDyCdU6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5/hv1lG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5/hv1lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2DBC32786;
	Tue, 30 Jul 2024 01:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301845;
	bh=KSXMI0hWNh6vzD2vnemy+0fpUODX5Uh5r9Oumx1NoWA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C5/hv1lGwC3TII60Er3dkdH+R7BoDPXXo5pbSUASfV9fHftCsS9Uz5fno6TbKO8lV
	 Kk7su5gSHDe5UXRoGJqqsW/6MKPdtiy14k92xNNpfHkOmqS6GIEc3udZsXrtq4g6ry
	 EDLYR2HjeQoOea1V/ztUQpxTkJSnPON61smCBzL8HAV0CfFCYEPrZa4AC3RQYxlc0J
	 exwpTUY2AExK7NCN7ur1p5dFXzWM66Wip9KVXjTJ/2YTnUFSX/ovdHHaAWq9I1gm4F
	 lfkN5j9XSvL5wbTdZwRrstjltD+8ee479JvpJdRKaQ4WotEnHraG3uiN9p8Yn2XVkf
	 jdRcCQr8ywCTw==
Date: Mon, 29 Jul 2024 18:10:45 -0700
Subject: [PATCH 6/7] xfs_scrub: don't call FITRIM after runtime errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848123.1349330.4056000330400170809.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
References: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
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

Don't call FITRIM if there have been runtime errors -- we don't want to
touch anything after any kind of unfixable problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase8.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 288800a76..75400c968 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -39,6 +39,9 @@ fstrim_ok(
 	if (ctx->unfixable_errors != 0)
 		return false;
 
+	if (ctx->runtime_errors != 0)
+		return false;
+
 	return true;
 }
 

