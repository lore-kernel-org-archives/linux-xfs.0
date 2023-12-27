Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9232F41;
	Mon,  1 Jan 2024 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtT6Hcfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD70C433C8;
	Mon,  1 Jan 2024 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070492;
	bh=33Lv/Rut4oqa7LfxmjrpCbkgeM4NUqWAHdK29d55p3s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PtT6HcfjAXHiG9yvxIKINhX4vfl5PX+tC62nNDW5+f+xmd7GbUo8Uau5Sk4Ntd+PH
	 miRwPGwR9x8vJfbG0Cx4kP+u/RopQoZjCtpgGUEK4lAY5mmek29khp2WEIMYZys5iO
	 d4ffTyuJSzHsxuLJGbN9sUSjL2mK9VsRQ4/Sak9ysnQEWe4FdSqEadZTZQovNiCi20
	 jRsyu4Xk0DkRk9QWVEOv43DO0+rBFMUH8RgIgePRXbAYA5kprwk+t32QWzFc8jClgo
	 Ox09CvUIr8ULNTpySjgscpunxNGxNdDt+DsgbxWTLUFqiyz24kOZrJTXzoHBN65PJ1
	 EB8ahtIA4x5pA==
Date: Sun, 31 Dec 2023 16:54:51 +9900
Subject: [PATCH 08/17] xfs/206: update mkfs filtering for rt groups feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030442.1826350.17132703785254421022.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

Filter out the new mkfs lines that show the rtgroup information, since
this test is heavily dependent on old mkfs output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index 9fd9400daf..4aceb12715 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -66,7 +66,8 @@ mkfs_filter()
 	    -e "/.*crc=/d" \
 	    -e "/^Default configuration/d" \
 	    -e 's/, parent=[01]//' \
-	    -e '/metadir=.*/d'
+	    -e '/metadir=.*/d' \
+	    -e '/rgcount=/d'
 }
 
 # mkfs slightly smaller than that, small log for speed.

