Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC26A33B6E3;
	Wed, 22 Apr 2026 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900638; cv=none; b=d62QAdlPHIYQrf4NcXMQyi0Pk138Dy3mYWV2gbPsJVLnK8greI7ujtgmQs2/KCxm4RlRlahOUi72OlB37WbZbNMHXJ5XEGO/TEQSAxPy702ShoKwjmVro2ZD2rfDyQog82cv7Ipf/RSjGkJUf8/qLrTZQaFtVXtrsJbuw6vkjFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900638; c=relaxed/simple;
	bh=4whuDT2NAsASpb7E7T4HhtgZB89kNBSY63z1QOF+oEY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pBnR1XvABcmLBn2KsxSMYbrB9tkQonRH4jUD9uwe+ku2r7dpFWY7TKRzNl+T5t/71sVnMRVeQc0Y6VT6YtiBN4xTj/2LCPux2cuKMeqkUIhrCnDQzFarOtZ3QrenwHJNJPltBa3BeC6fv/z3XeJUud3zx9CeLtnF1mR9bHZZWoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnaHnaYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnaHnaYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B45EC19425;
	Wed, 22 Apr 2026 23:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900638;
	bh=4whuDT2NAsASpb7E7T4HhtgZB89kNBSY63z1QOF+oEY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bnaHnaYi6wS+dpu4hSGk2aKp6qWM+jKNpuqCfpZRt7jst7HBdWHgzDl7X+21Z/6uf
	 cto4ohY7BMSTPGHMk2cc3hVzoceQb0zbLF3JaCb1Sb0ndNJYFttAe0Q8eKVRidzVuh
	 CZtKE0NvGuVe87n5/qDmH0l2r+LHLSX3OkdmM3LnrkUsaLwtINnpDvxocW1PF5ERI4
	 aDGy/w75tRNo9KeRxkTCQq1p4MehJ9Qat1kR9j5gQ7RFVwlRK3npGvkl00FSwlq/Eq
	 85ZHETH2V6C+Zi2OY/436EF/x+rlQ4RsrZ60NCkp3vxAH6MsmS7q7/qT105SEPEWsR
	 3jULWrtGjAI5Q==
From: Chuck Lever <cel@kernel.org>
Date: Wed, 22 Apr 2026 19:30:03 -0400
Subject: [PATCH v9 09/17] xfs: Report case sensitivity in fileattr_get
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260422-case-sensitivity-v9-9-be023cc070e2@oracle.com>
References: <20260422-case-sensitivity-v9-0-be023cc070e2@oracle.com>
In-Reply-To: <20260422-case-sensitivity-v9-0-be023cc070e2@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
 almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
 glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
 adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
 trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
 hansg@kernel.org, senozhatsky@chromium.org, 
 Chuck Lever <chuck.lever@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1083;
 i=chuck.lever@oracle.com; h=from:subject:message-id;
 bh=DjIMkqqMWUIzhkQeoXVo4WlkiMfqV3S6x//RMb6YZuo=;
 b=owEBbQKS/ZANAwAKATNqszNvZn+XAcsmYgBp6VoFgb8ribB+nCo/33ADy8UGh/WTW9EVvYLDJ
 ZhkLdMmkQKJAjMEAAEKAB0WIQQosuWwEobfJDzyPv4zarMzb2Z/lwUCaelaBQAKCRAzarMzb2Z/
 l/25D/9aqXIUuRxOQWtD0dWT+Q9W3mQd7Y+VY6UFS1LAtmd1vn5g34iB5NU7sM2wxTgYLOK+5/h
 vwoPHpOVaqxvhA6GsenrcETy2xMwbv4PRm6tnvS/4sMYQB6c0PKf9dHVao8x51/6EAQjfhUPPMY
 414gODPEKknMS6bazcGhAiXDJYerPC6pDphIuSsR/PWJWUnOXaDDrBXVgRWxPFfcpdmLmPix+IB
 FtSX59MZOv1IxHSU5cHLjIjSobLGSVYwk7xbu57GH5tp8TQSXvXds7I6J2Lr0gjvdVNbnUbo3Q6
 4xTbfvX28p3m4mKCt3F46liurf+8mcdIkheGpzRFgTcFsq7gwsXX7qR4WAHTD/tM0XN/SXBIubE
 f5ewBjam/sAh+aN3Tr/w2Bt8HXMJOxeUt5W1UL55JgDCLAyaqXP3qDI5VcnfV7wEJe2hh1lqKI3
 S9a2Al02PjUj5s9ZqlbrleD7oOAd1aApbGRdkd3p/o7v6kI0qUlEfVi4IiQMxfCAZxZ+F92nJ/5
 xZtIFCiKxhvUK+GgddMEDsV37U7T7xpubEwcJ1othGDQmliP89lZI2sfdliv3YjargSsSanVWXC
 37e5iAy9sqxBdaj5HqhnLjaiOWTjRBt+/CeMx7uAaav5VUyva44vS/JPXv14RdHDgctXgOF/nAG
 xFtrEcKzj1PPhlw==
X-Developer-Key: i=chuck.lever@oracle.com; a=openpgp;
 fpr=28B2E5B01286DF243CF23EFE336AB3336F667F97

From: Chuck Lever <chuck.lever@oracle.com>

Upper layers such as NFSD need to query whether a filesystem is
case-sensitive. Report case sensitivity via the FS_XFLAG_CASEFOLD
flag in xfs_fileattr_get(). XFS always preserves case. XFS is
case-sensitive by default, but supports ASCII case-insensitive
lookups when formatted with the ASCIICI feature flag.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ed9b4846c05f..b3c46a7ece62 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -537,6 +537,13 @@ xfs_fileattr_get(
 	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
+	/*
+	 * FS_XFLAG_CASEFOLD indicates case-insensitive lookups with
+	 * case preservation. This matches ASCIICI behavior: lookups
+	 * fold ASCII case while filenames remain stored verbatim.
+	 */
+	if (xfs_has_asciici(ip->i_mount))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 

-- 
2.53.0

