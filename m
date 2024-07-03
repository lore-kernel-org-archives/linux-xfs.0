Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AB72BD19;
	Wed,  3 Jul 2024 21:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720042606; cv=none; b=SNc+W8gtBDwUXd4NZBY3P2A+C3Pvp61CzwZUBe3Xt+VZZKeThmrL1aFdeqx58pGBnDdd0+Jaxnxhn6TWf1KMKNiMtK4AeJcrXWzNKa8ugzGotRb4SxKmUPMvncYkPqQT6I0vFu/etzlvn4vB4ENzxo//ESFHquBc0rcKrNZy6ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720042606; c=relaxed/simple;
	bh=U1MV6yUAgR306zb/bqprnTw60o7sXqKlvLccFhugi60=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gU8r0jk7gSnwhm7NaceywwZLml8eTijh2jyhQ9Bi9wl62+ZNjkhMXe6VVqyR+MXHbvVEVJkhW0FCZZ+UYGxlndpE+TgaSVviHt/TIBpiDufbHOkY4943KajPhTIx9gihRGHF64dVV9/HJAykVXhcx98TGyj/JGe5g3HNxXOpq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jykkvoH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jykkvoH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C17EC2BD10;
	Wed,  3 Jul 2024 21:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720042606;
	bh=U1MV6yUAgR306zb/bqprnTw60o7sXqKlvLccFhugi60=;
	h=Date:From:To:Cc:Subject:From;
	b=jykkvoH+L7upj3dlyIIJnmr2fA7hvDBLcP7mQPQZvAhbvhjo/V4QKWcv/Dgkydqj+
	 rqJOp9qdxwzWgIR4gWUamNzc6Ekto1mNUiAjsK0on0J07iMfr/evBZc52TS0dNSnoL
	 39WGo4HIuKESC8JlmqWJf53evkIPIBNw9mApKdz99T2wtUn5rPC2zYhbXWquXGPn8+
	 XbIpUMEGiiw1bDspVmyelAyqpMjY/R8AmDKAFnw11Mf815cjl5/sO06zEPvlRifn5+
	 P7Xgn1fDl49p+6LHgBB6ENSn5AdufIJpqZRmGTuVOS9xZGifN4UE3iAO7Gvxm05xgO
	 p5VCwY09IOHKw==
Date: Wed, 3 Jul 2024 14:36:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] fiexchange.h: update XFS_IOC_EXCHANGE_RANGE again
Message-ID: <20240703213645.GL103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

We corrected the definition for XFS_IOC_EXCHANGE_RANGE towards the end
of 6.10, so do it again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/fiexchange.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/fiexchange.h b/src/fiexchange.h
index 1f556e69dc..02eb0027d1 100644
--- a/src/fiexchange.h
+++ b/src/fiexchange.h
@@ -52,6 +52,6 @@ struct xfs_exchange_range {
 					 XFS_EXCHANGE_RANGE_DRY_RUN | \
 					 XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
 
-#define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_EXCHANGE_RANGE	     _IOW ('X', 129, struct xfs_exchange_range)
 
 #endif /* _LINUX_FIEXCHANGE_H */
