Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D51607B9;
	Wed,  1 May 2024 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588901; cv=none; b=n6bTbcUvcXI8/n955PZsUNPrGuaEywbxnLa9sVqHeccSxxjfzguaSDeqOOXpGed8ozSCeSUDacuEzqjr+Cx9LldxM1MEuw+JexaZMY6AZjYNPmSwCgYPRAR75kMhofWldtKwcaXOnjQ2Is4Ob7ptcTQv3j9na0CScQyxAmQZEt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588901; c=relaxed/simple;
	bh=dyIaBsz/IqJcHxd3/0H8Ya5K55WCQPYRywcAlXaDF8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhKOUmidmyYmb3lYSVHiL12AwGm0ipmsAuzwaUCROSAjSuj+EyzCWvZ9KwbL/HJW6/BxpkX+gxyKS9fUbyWx5laKsEXVvsempK6kI5yMwYPyseAGpVbkyIjbCZA3z1BCGQDs3BFKf4jhgp/Acq1t3VX0s4OKi94ZkvSnlHfnqrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVr5H0Tn; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVr5H0Tn"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f074520c8cso6758212b3a.0;
        Wed, 01 May 2024 11:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588899; x=1715193699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJgn8j/TEKDVe2h7+z3zhezXdiNMFYRL3vFEyqQSEB8=;
        b=jVr5H0TnVTcs+okchkk8jICwaB12kmdm/TbixU+SVGSKp0kKvTraRgiMhzIvagM4d9
         RkOTvxsaPCgTUizA2KO2coaLJgPgc7p5GtrfOo+DPPbpaDyTijfojFdulLSHwo5mXiJg
         5DMIp1QaX7BFDWwS+fyYzj01+KISAr2eUE/C8T5SkN0db3YfEHugSYxgJnatasjyvno7
         iwMeIkagIHHwoHEOL4iz1u7lcf/pF12g9kEYbLmHnsujAaB2TcH8FiNq+lrfNTxBHkOv
         q0QxT6wkM2yiwuLMBfxiaJd0jpLE3x3nUHAHw1Aahy2PBuXjVEI5KThgoA7OXd1I2uFj
         5b4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588899; x=1715193699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJgn8j/TEKDVe2h7+z3zhezXdiNMFYRL3vFEyqQSEB8=;
        b=X7JDgyJg6VE7H179dUaWRkqxyqZ6iB0IKbfDmZimB1bLB8xqifd8LVahJHj5P0aa1R
         D+/WmC8krECLwkE7/GSN5MCpx5W64psY30WkjgLKfVlfn1u0VyFcG4U+xcVsWpK6SRgU
         z4MEArhKbetJbtCYStK31qkknf0wANgFHzW0P2/kVwzbCfnh5w/HtU79qYHZnvdX/vj4
         Wx7uPsqmanbvSiPdSdKm2b3RztJSFAAPFeGwj207xwmH1XpjNRv3atm3z+y+AwCJ5mEe
         4WWG7+zdpM3ddcC65VXurGtsFnpOaRIBSP+sm+PyWKu1UkBvL3H5akO62Zno4pScadB+
         rpRQ==
X-Gm-Message-State: AOJu0YzBAc3Gp81qXj029Dp2qJM9WtvLHm+rTe0qQHwdzUM1Iqfv3ZB6
	6eYdvy3QivyNLRBe/BLAAuRUZdOzOwWSeqvw6FhG3QW2g9+VFHc3lLAJyGeb
X-Google-Smtp-Source: AGHT+IHXCVkfMA8g7AMobeluYCLW6vTYnBlwWd++hPhKHYLBEfYgqKd3E2LY0wLJJuGFRyuNe53TGA==
X-Received: by 2002:a05:6a21:32a1:b0:1af:38ab:e2bb with SMTP id yt33-20020a056a2132a100b001af38abe2bbmr4263574pzb.3.1714588899477;
        Wed, 01 May 2024 11:41:39 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:39 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 21/24] xfs: allow inode inactivation during a ro mount log recovery
Date: Wed,  1 May 2024 11:41:09 -0700
Message-ID: <20240501184112.3799035-21-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 76e589013fec672c3587d6314f2d1f0aeddc26d9 ]

In the next patch, we're going to prohibit log recovery if the primary
superblock contains an unrecognized rocompat feature bit even on
readonly mounts.  This requires removing all the code in the log
mounting process that temporarily disables the readonly state.

Unfortunately, inode inactivation disables itself on readonly mounts.
Clearing the iunlinked lists after log recovery needs inactivation to
run to free the unreferenced inodes, which (AFAICT) is the only reason
why log mounting plays games with the readonly state in the first place.

Therefore, change the inactivation predicates to allow inactivation
during log recovery of a readonly mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..54b707787f90 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1652,8 +1652,11 @@ xfs_inode_needs_inactive(
 	if (VFS_I(ip)->i_mode == 0)
 		return false;
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		return false;
 
 	/* If the log isn't running, push inodes straight to reclaim. */
@@ -1713,8 +1716,11 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

