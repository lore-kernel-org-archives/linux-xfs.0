Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71B615E89;
	Thu, 11 Jan 2024 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKcnE1fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF9CC43390;
	Thu, 11 Jan 2024 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704974372;
	bh=KrcwIHRNBrvWhmypIQpphTw4zTRmmmsGsm5ScFnFkyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKcnE1fhPqImZOUV6SxBERPF6WH/ndewAfwCVSI8vjKlmhH8ewvstn3CyiWpy2a1V
	 GYXIKKLq0Npe0MSvPC94ZYPQuoQGllJptnsB8kRfmrq3eJeds1qFiVebdPnCQ2T4mj
	 X0ljF5q7+S1XcRVe1JXf6guyLD7YkkI3Az3JnvtYLa8LbuxPiwzVfHEjFig+b0xxRs
	 eW0XBvDatm0eb9UcQHOk8ZQKZdXaVmIhgvXGzF/cBvcRjNs73UviSvOKZyN4j8FD4t
	 mX4x72GZH6MOlSxAfDQDI5E0QWg34SIg7678GVtyT97cB5hxRqFdU+015m6JPkDGg9
	 HC6STkJqFE/5w==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V3 2/5] common/xfs: Add function to detect support for metadump v2
Date: Thu, 11 Jan 2024 17:28:26 +0530
Message-ID: <20240111115913.1638668-3-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111115913.1638668-1-chandanbabu@kernel.org>
References: <20240111115913.1638668-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit defines a new function to help detect support for metadump v2.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 common/xfs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/xfs b/common/xfs
index 38094828..fc744489 100644
--- a/common/xfs
+++ b/common/xfs
@@ -698,6 +698,12 @@ _xfs_mdrestore() {
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
+_scratch_metadump_v2_supported()
+{
+	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
+		grep -q "Metadump version to be used"
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {
-- 
2.43.0

