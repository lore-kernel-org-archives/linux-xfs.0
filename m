Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9874A2356D9;
	Sat, 25 Apr 2026 01:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777082036; cv=none; b=TwIbwBQUyu1AJl7v+6w/uly/EntfOZY0vnnMhvPi6dRKEgQYTkUif14duynXpofjeKO6UUN2p3FOHTm64KLmUsGBVvHXnJFTNP49zqOGCJ7iMQD+pPhIQ6griUQBqqcpSi88TMxcSfARY0If//4KGV7b75kK4/fLa2WsNG7sOl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777082036; c=relaxed/simple;
	bh=OyLhtXrNpz8D2WvRJaUa8omBuZCmPi2gdz7MuhZWO2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U8fH1EHQEH4mo03iqIBNshUD9M/V/vzez1QEplyd8w27cehtgAvrqQkZBul2qkVOh9QmVeOuxzSh4iHJJEkDng8RUOERanVoTp2/CBbuoW4LBVV9xyMXUdsBZlGFIuk5CCbwO7Wr6ss3cmiFYM6yRkYONqEXbQAeKN/DqMJ2Zuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5ls4ajC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5ls4ajC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ED3C19425;
	Sat, 25 Apr 2026 01:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777082036;
	bh=OyLhtXrNpz8D2WvRJaUa8omBuZCmPi2gdz7MuhZWO2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=u5ls4ajCrDxaabG/eUULQCayzzn0FxGdJ0h2eF/6yiu1+VEVbpvL3VoFwMiT41uFO
	 45sB5xlpJHd+bD+Blck8AXyyr7y21+0/HL1LZn4Sbb1wjjMsrFbekWY67rP+jZiKay
	 uL+zcojc7UfJR+m01g0rPsZQ2cJIzN1ny90H6yd8WdHpV7EH4GwxWIhcieAlSO42YV
	 Q1kdGrOGtmSKz1IAGXtPVhdwaOAkVBoRbgsYwVyvlKcbwJtrtKdsXpFzp5rnIZBs5g
	 X38GgUl7e0xKM+pyVDn22d86CciPKZ4jQ+xMp0hDvyOw3vHuW7OqaQpNK2++q2pi/w
	 u5xycbXZ8HapA==
From: Chuck Lever <cel@kernel.org>
Date: Fri, 24 Apr 2026 21:53:15 -0400
Subject: [PATCH v11 13/15] nfsd: Report export case-folding via NFSv3
 PATHCONF
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-case-sensitivity-v11-13-de5619beddaf@oracle.com>
References: <20260424-case-sensitivity-v11-0-de5619beddaf@oracle.com>
In-Reply-To: <20260424-case-sensitivity-v11-0-de5619beddaf@oracle.com>
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
 Chuck Lever <chuck.lever@oracle.com>, 
 Roland Mainz <roland.mainz@nrubsig.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4215;
 i=chuck.lever@oracle.com; h=from:subject:message-id;
 bh=YpboDqA/tDvRzcdcF8b8ZwECQrfPFzdzvA+uLgueOwI=;
 b=owEBbQKS/ZANAwAKATNqszNvZn+XAcsmYgBp7B6RVAwGk4HxMo5K1jJ5BigRqDIrVb1SGoayj
 BXjhQVoJ2qJAjMEAAEKAB0WIQQosuWwEobfJDzyPv4zarMzb2Z/lwUCaewekQAKCRAzarMzb2Z/
 l+npD/918vXvKFGss9WIcMGCwoxVEeUj7IKF6YmyR8/POJsszj3LZO2KLLSMMuH8dfwR0HQ5hzz
 zOdB6ehv+nZ5JMtg5HMXZx4kjXRjhipq8WZOrbxpvTsvcqFAUOO4hCkaVjEVSbNt+lEmM6GyT3L
 RJy4JqkUvDTnIFdUgL2mZQ9AP4SeZQnhUq+N5yB0LVltPB9q7YolmuNYjJp8VT2D2Znw3XBJw8a
 G8MR0h2x5mskZ4u+PzHFNtB4bQNpOGOKX3R2AVclVp+sQ6QkBjn+kaW42/yayH9hRsXt1MGws2+
 ybnGk66QcZhVlc2zJNsAjCkvQomr5IGSft8jDMGJ2SbgsrgpLKqSwWlTvXmsH8ROPvzBpAkFS+M
 9Eafbt8Rn3JrUz342Zv5hcio0q0owOFYBDZZfVUz5Y4G2pTXB1Yo/txdVUO01dGpq1JgtHjuDDW
 3LuqteJkf2fLyrlsCuPrwxU+JvhwIOmHCMefTPKBHANcJVVdgcdvjnqctZVBxgtFBNovGRNI7tk
 VTDn1ycm/0EAb3cUMSXwcRJNNnsK0GvnZMTx3GyZpZmiWhMRBmrfX/YvuRbl3Q3i0y8++F5Bum3
 2XODwbWBqsVLBc//Zt9MSwWreXXM/pL5Hw0cXCVw7A5xcKx/Yhz/srW4iOaH/tOb9ivdqMQWf4A
 uYVoRzy0j0ES++Q==
X-Developer-Key: i=chuck.lever@oracle.com; a=openpgp;
 fpr=28B2E5B01286DF243CF23EFE336AB3336F667F97

From: Chuck Lever <chuck.lever@oracle.com>

The hard-coded MSDOS_SUPER_MAGIC check in nfsd3_proc_pathconf()
only recognizes FAT filesystems as case-insensitive. Modern
filesystems like F2FS, exFAT, and CIFS support case-insensitive
directories, but NFSv3 clients cannot discover this capability.

Query the export's actual case behavior through ->fileattr_get
instead. This allows NFSv3 clients to correctly handle case
sensitivity for any filesystem that implements the fileattr
interface. Filesystems without ->fileattr_get continue to report
the default POSIX behavior (case-sensitive, case-preserving).

This change depends on commit ("fat: Implement fileattr_get for
case sensitivity"), which ensures FAT filesystems report their
case behavior correctly via the fileattr interface.

Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3proc.c | 18 ++++++++++--------
 fs/nfsd/vfs.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/vfs.h      |  3 +++
 3 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 42adc5461db0..7b094c5908f1 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -717,17 +717,19 @@ nfsd3_proc_pathconf(struct svc_rqst *rqstp)
 
 	if (resp->status == nfs_ok) {
 		struct super_block *sb = argp->fh.fh_dentry->d_sb;
+		bool case_insensitive, case_preserving;
 
-		/* Note that we don't care for remote fs's here */
-		switch (sb->s_magic) {
-		case EXT2_SUPER_MAGIC:
+		if (sb->s_magic == EXT2_SUPER_MAGIC) {
 			resp->p_link_max = EXT2_LINK_MAX;
 			resp->p_name_max = EXT2_NAME_LEN;
-			break;
-		case MSDOS_SUPER_MAGIC:
-			resp->p_case_insensitive = 1;
-			resp->p_case_preserving  = 0;
-			break;
+		}
+
+		resp->status = nfsd_get_case_info(argp->fh.fh_dentry,
+						  &case_insensitive,
+						  &case_preserving);
+		if (resp->status == nfs_ok) {
+			resp->p_case_insensitive = case_insensitive;
+			resp->p_case_preserving = case_preserving;
 		}
 	}
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index eafdf7b7890f..9214f1f1f83d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -32,6 +32,7 @@
 #include <linux/writeback.h>
 #include <linux/security.h>
 #include <linux/sunrpc/xdr.h>
+#include <linux/fileattr.h>
 
 #include "xdr3.h"
 
@@ -2891,3 +2892,45 @@ nfsd_permission(struct svc_cred *cred, struct svc_export *exp,
 
 	return err? nfserrno(err) : 0;
 }
+
+/**
+ * nfsd_get_case_info - get case sensitivity info for a dentry
+ * @dentry: dentry to query
+ * @case_insensitive: output, true if the filesystem is case-insensitive
+ * @case_preserving: output, true if the filesystem preserves case
+ *
+ * Filesystems without ->fileattr_get report POSIX defaults
+ * (case-sensitive, case-preserving). Outputs are unmodified on
+ * failure.
+ *
+ * Return: nfs_ok on success, or an nfserr on failure.
+ */
+__be32
+nfsd_get_case_info(struct dentry *dentry, bool *case_insensitive,
+		   bool *case_preserving)
+{
+	struct file_kattr fa = {};
+	int err;
+
+	err = vfs_fileattr_get(dentry, &fa);
+	switch (err) {
+	case 0:
+		/* Success. */
+		break;
+	case -EINVAL:
+	case -ENOTTY:
+	case -ENOIOCTLCMD:
+		/* Query not supported: Report POSIX defaults. */
+		break;
+	default:
+		/*
+		 * Query failed: Propagate that error since
+		 * support for case-folding is unknown.
+		 */
+		return nfserrno(err);
+	}
+
+	*case_insensitive = fa.fsx_xflags & FS_XFLAG_CASEFOLD;
+	*case_preserving = !(fa.fsx_xflags & FS_XFLAG_CASENONPRESERVING);
+	return nfs_ok;
+}
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 702a844f2106..abf33389ee81 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -156,6 +156,9 @@ __be32		nfsd_readdir(struct svc_rqst *, struct svc_fh *,
 			     loff_t *, struct readdir_cd *, nfsd_filldir_t);
 __be32		nfsd_statfs(struct svc_rqst *, struct svc_fh *,
 				struct kstatfs *, int access);
+__be32		nfsd_get_case_info(struct dentry *dentry,
+				   bool *case_insensitive,
+				   bool *case_preserving);
 
 __be32		nfsd_permission(struct svc_cred *cred, struct svc_export *exp,
 				struct dentry *dentry, int acc);

-- 
2.53.0

