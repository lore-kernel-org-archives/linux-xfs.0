Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2C03502AA;
	Tue, 28 Apr 2026 06:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358597; cv=none; b=b2bKlaeRQ8E2L1SkroUtPeLP9i04nbu0Ena4W6wX9CKEYRLxFE0/3bqsDD1C9ZQA3q+SaCDZ8sR5Jbi80UQXUTg9LSHs5W2TMtqznqISnHI9C61zPOmGMwMdglOAZtP/SAinK7Q2o5wAxRjO1adEeUPeKR/RdxIOdsXL3SBBJw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358597; c=relaxed/simple;
	bh=6BaCQwGfKGaGz8lJN9jXSc3z4f3htVh4hN1h+ysPi+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRH3CPhQ0gppG7Iw1hI3NQ7Xw2AgOYvDVh52lPPaulxCoUHmDOI1QtTYGs3Toh33jndERBjNDIzAPdYHRNrmJFIR5LgU9epCCh8evVt9zXAA//6UtrYSy9nfRvwtf64bsaZYxUXS09OvRYLpuXVBU8Pq542QNe19tS32mIJ3v7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFMFYJCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFMFYJCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87906C2BCB6;
	Tue, 28 Apr 2026 06:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358597;
	bh=6BaCQwGfKGaGz8lJN9jXSc3z4f3htVh4hN1h+ysPi+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFMFYJCxqQMk0gaNw1PPsV43ijVnSiWVKLMEeG3HxGmk2qNKeuqKsEOnbVoZS5zla
	 62mdup7fJDPKV5giFmAvK6lMHJXGYv3Yz3wkT3SH1MZeLWrUgDuXRgT8Ztxsw+4CHb
	 cf4ibe6R7+V1vCR1baGk8OvZoMHLLyIdteY797+dFPh/AzXEgUoiOz5Dc/gqLe0T17
	 wOpzfjFnULzkvkjvFyv/BMB7wwuBJ7hZ9e3HruDJwue8WVdnbLLKpDwmaSUDK/2Ws/
	 WJUkF3jmpO2lW3zvf7K6bADQRyKeqvOjly3px+GFyf6ibV34Ekx2oFYvMmPKO6oYZk
	 syfYluGGukjaw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 2/9] fstests: add _clone_mount_option() helper
Date: Tue, 28 Apr 2026 14:42:52 +0800
Message-ID: <9022159c1dad0452f402a7e7659178bdd032c418.1777357321.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777357320.git.asj@kernel.org>
References: <cover.1777357320.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds _clone_mount_option() helper function to handle filesystem-specific
requirements for mounting cloned devices. Abstract the need for -o nouuid
on XFS.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/common/rc b/common/rc
index 754365e80dca..771472d2f8c7 100644
--- a/common/rc
+++ b/common/rc
@@ -397,6 +397,20 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+_clone_mount_option()
+{
+	local mount_opts=""
+
+	case "$FSTYP" in
+	xfs)
+		mount_opts="-o nouuid"
+		;;
+	*)
+	esac
+
+	echo $mount_opts
+}
+
 _supports_filetype()
 {
 	local dir=$1
-- 
2.43.0

