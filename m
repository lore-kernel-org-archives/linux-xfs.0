Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B743BE64B;
	Thu, 23 Apr 2026 13:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776949965; cv=none; b=QBt22csGPtPxdIHMlybHU0ehmnp98yUTsiYxnqBlovq2a9l3xJUQx59ppzGuVA8Lwr/qj4H1C7MFhaDY+k3B0WgOIGjaBxHXjjuI05zhxNmToO9e56NHvfWog73ROeHP/kFaPuIWSrLO0HnyTz4s9wbSuN15IDySMem4B19kyKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776949965; c=relaxed/simple;
	bh=Q/Z3eU7E7G5VuhyXLGLHVQn/X3HZutM3gSylfnZVEPg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KfsgS7G4OwN7fRA8HPnyHPfrLH40ko016tT/tB7V9I577X36aHbbhpZ+g7DlPn+bmV7YEY394naLFWzLRy/hM5ik7hmhjGs17XpVBcCK8eic1BNwKIIfOiU2YWyb8xKmFiXiK+Ib+HUNFJS7dd3aKaPrO9LQm4ty5P3dOEgs6rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5gScez2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5gScez2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87020C2BCAF;
	Thu, 23 Apr 2026 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776949964;
	bh=Q/Z3eU7E7G5VuhyXLGLHVQn/X3HZutM3gSylfnZVEPg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=b5gScez2YED5kR4UfP7ePXzzEJBb5rUkzl2kaWZ8I3PLFUgBLAbDFoL6fUBrKhQsb
	 vY7VDji9bHDReQ5D8SfrPb4vl99b0Oo3UsSGYWGGc6n9UsMvzFdSxZSJDss0CoTzxm
	 oltz16gygeIH57IBkctp753tNu/+G9aCXfA4LYLnB+fzWUhEYju83IJ+sXU8smvzdP
	 o+gArT4pCLP3Z68PxSt9h0Z8PImmccL9/D2lM0DQUcfIGgWnhyzpGjghvJmtKcZ2CS
	 2Li5JyuynrqBOkmQMrKRlm0LlfT8IpYZyQRNIRA2/V8vsfwlaqqrWEO3GQQBydWlvP
	 pDCsYsSZbsNbw==
From: Chuck Lever <cel@kernel.org>
Date: Thu, 23 Apr 2026 09:12:12 -0400
Subject: [PATCH v10 09/17] xfs: Report case sensitivity in fileattr_get
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260423-case-sensitivity-v10-9-c385d674a6cf@oracle.com>
References: <20260423-case-sensitivity-v10-0-c385d674a6cf@oracle.com>
In-Reply-To: <20260423-case-sensitivity-v10-0-c385d674a6cf@oracle.com>
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
 Chuck Lever <chuck.lever@oracle.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1165;
 i=chuck.lever@oracle.com; h=from:subject:message-id;
 bh=f8bPTEa6xHOGMJ4BkwBw/MA1JRSPvJxuTKAc3AxqaEI=;
 b=owEBbQKS/ZANAwAKATNqszNvZn+XAcsmYgBp6hq080HBIoQoVwdco58yDR8YVIdkIx/l7nWCL
 p17rvkKMhqJAjMEAAEKAB0WIQQosuWwEobfJDzyPv4zarMzb2Z/lwUCaeoatAAKCRAzarMzb2Z/
 ly/ED/9AmddXjVCN3aojVl3dq7vYD4dHLpYLDtV64JoEYigKfl8rORJ11NTU+gqKE1e24B60uJk
 pdFiokvjs9qrW2JRbQFgIwW6hTV815teXb8jU9fS7kXCDGUBNNqBMi1AURxGS0+cKMvJOsG7wvl
 yputvf+P5kAEyAepPLwNZDeQ3ZsFw0aB/O7Wo43QmTRdbwp5K86ykLPGRxjf5QHuw2z9nn4q9XZ
 EvfnjgtzDe+CRaFbZFrJD1YflFdVfMzmJ8y8OhJ3VPs7+SCXwRGJqQ4t7WOPHwHRUxId1+yvGLf
 jlpNGlpLScKmAZy0wex1OROguQuASjnDTEND3+Rnxm7dmTYA08JqC8C9yRPit0M62pGj9Y9V162
 sSMrVUnmNayFOLfJuFGyYOD1C8vpsqsOVB6H47ikng+DKH85GPzl26ob1o/KebclsssdTPgwdzq
 +yVZixdIvTd7o/xyqgFffTVmBgYCW6aG0Wx7eB5CQMmPAcy+0BrbsuRaTuWhzqAVS8OgqfF7X8N
 ZVh4zYhE3s/YMsVzb78E+fwRyV7Gs+2vW5BtzPVat9FZxYtahS7k+5fIlWewHB0u/Ps+LzSnUJT
 Hch9406DJ+hMcAznh9G3hlsmcRQPA7MlqUf7my4whGQPZvztR/OETamaDE6BzniYdfmQ2AAjG9L
 zRv4taVhhDcNCMQ==
X-Developer-Key: i=chuck.lever@oracle.com; a=openpgp;
 fpr=28B2E5B01286DF243CF23EFE336AB3336F667F97

From: Chuck Lever <chuck.lever@oracle.com>

Upper layers such as NFSD need to query whether a filesystem
is case-sensitive. Add FS_XFLAG_CASEFOLD to xfs_ip2xflags()
when the filesystem is formatted with the ASCIICI feature
flag. This serves both FS_IOC_FSGETXATTR (via xfs_fill_fsxattr() in
xfs_fileattr_get()) and XFS_IOC_BULKSTAT (which populates bs_xflags
directly from xfs_ip2xflags()), so bulkstat consumers and per-inode
queries see a consistent view of the filesystem's case-folding
behavior.

XFS always preserves case. XFS is case-sensitive by default, but
supports ASCII case-insensitive lookups when formatted with the
ASCIICI feature flag.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 551fa51befb6..82be54b6f8d3 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -130,6 +130,8 @@ xfs_ip2xflags(
 
 	if (xfs_inode_has_attr_fork(ip))
 		flags |= FS_XFLAG_HASATTR;
+	if (xfs_has_asciici(ip->i_mount))
+		flags |= FS_XFLAG_CASEFOLD;
 	return flags;
 }
 

-- 
2.53.0

