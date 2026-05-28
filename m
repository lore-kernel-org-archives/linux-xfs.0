Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E7FDF76;
	Thu, 28 May 2026 04:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941176; cv=none; b=Zq/EN3UGmUUKUA8ibHArhDaPxw07mXgtdbJfe8SyMkWunf9ltsEPvuJIjUCyaZ2V7YnaWEs0rHThKbvLRbIT3pqlu1ow0fGC9Cz2JUrN2fCI1QF2N873ZFI8giTzHl9ui2SMGA9vQepGo1Z/ZkW2Yd0+SBv2OTy5+eAThhYodtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941176; c=relaxed/simple;
	bh=w/IG18gkZGLcDhQOyCgSms3iUlSYKTXVOxqwBiNOolk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xlwfh82xS0vKgSKIG/cXATxU4er9sfApJ/3NHenH4Gf1NMcGbEBocFKSz/oYYeNxyDYwzlrT24XhKSqWfCvDPCE1RjKb5G8jUCPfs9FBQPHaY32joXV7mURJKyMgEoB01aEEHzsYUpEGzPBWZZqwsUtcv4dWaqMSvnXI29d8jq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKSGv1Dq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKSGv1Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF271F000E9;
	Thu, 28 May 2026 04:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941175;
	bh=PAvTWkROU+u+H9crk+JD4pEa+DKYrUN/J2Uia9F6hVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKSGv1DqAx5vGEyfWkTpShtLnnMd3c1/YnTVRVLcfFBR7uTFBpnffhcQV6TGueuSW
	 F6rV+JDf0wCqd5xNhuQcHhA1lK5jTysPKwB97Z7IS3/sK5dKjgHwyAX8USKXY+ZUCN
	 qbiJ9hP+GLuNAy6qEm+nidudllY/NmYYY8lZVabLN2bQ4CPXT399CgaeHs2TYRWAA2
	 Z4THj/lFwApmZFy/PRG8E2fNszVsXcqKTpeq/OvLRGdvGHsGc3MHRfmXoIZUYlN/bX
	 pxKK3HHf6ZArr3r/c5gVe4tDRhFmDCIQQv52YBo0R/1Sm+QjJ6Hp/zHj0/VWW+VAvo
	 OcDgFZHFS/bbw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 02/11] fstests: add _clone_mount_option() helper
Date: Thu, 28 May 2026 12:05:33 +0800
Message-ID: <4346c80089c61c8f0d62ea696f9d73f2a9669297.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
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
 common/rc | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/common/rc b/common/rc
index d7e3e0bdfb1e..937f478963b4 100644
--- a/common/rc
+++ b/common/rc
@@ -414,6 +414,23 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+# Return filesystem-specific mount options required for mounting clone/snapshot
+# devices.
+_clone_mount_option()
+{
+	local mount_opts=""
+
+	case "$FSTYP" in
+	xfs)
+		# Allow mounting a duplicate filesystem on the same host
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

