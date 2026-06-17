Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DA03CEB92;
	Wed, 17 Jun 2026 11:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695277; cv=none; b=nQkSSTh9BzzMK8nXI6z6O01QptdmxD9Ermq41mqSJPNZ3mf/P1tRf7SkleZQBA7QcbJlY2ZW1ROdwSFsSoE/pl+oEBSp/oF8PqAQL8f63TrWwSn1nHWgw32l9oGrFR1S/S8PDbjV7kAgDOZwwRvh8AJEM+VUkF7qm2zCGzf5h8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695277; c=relaxed/simple;
	bh=1BmLtKnIz046V+Q8VyXWydUr1TIRZA6RC0grby2YkZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol06rfxaKn77DYVNcIR3dn2Zt1KSwbMv7+GWPACQGRaI+MKRrK4eiluEzzAHyjvUEmD/XqrDRLmzbNWPCryUj6OQJXharAPphv7H2nxxLk+b2SVcP5PLhEGhP4fidIbaNPy7j23uVRoeBvjFEDzR0KlARrVNIrW71bbM/3pIkIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tx183UWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tx183UWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED151F00A3A;
	Wed, 17 Jun 2026 11:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695274;
	bh=11X4zN8yljptgUmegGLc9eRycZkJzLRPMfam5P0waQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx183UWBDcb6cM7UpbniLBQugwLMTY8ljaxB/fkfAkjoAfUDwpfzNUdZiG2oJHz3A
	 7CvH7B1E1yZ7n3b2HqeHsM5uAvy/EuDWzT4mI+WPZXTfr0eEhUlwYCud8l7CcYd0kA
	 AOL5JcczTKswRzsAkBqKBWYxHV/ff0dfNl2lTeBfxADirnqMMYJ/97qGlNsdwk+Brx
	 IuhLlT3LK/5uP8GVJx2ipdjY23aUuExlOvkSEi8cTjRiljOnSEzesAmKO6dUfBm7E0
	 01etGfC++kie4nh25uNo74GciHRYza5UJ4YRMwfVK+dW8Rf6Dawgi/b9a08RvwvrcK
	 7wmxfnSptsZSg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 10/11] fstests: add _change_metadata_uuid helper
Date: Wed, 17 Jun 2026 19:20:37 +0800
Message-ID: <7a29c19695da36f50b0f65a617e7f328d7bb9611.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781694879.git.asj@kernel.org>
References: <cover.1781694879.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

_change_metadata_uuid changes the UUID of the golden filesystem before it
is cloned.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/common/rc b/common/rc
index d95eec94f7b7..5cd4e025293b 100644
--- a/common/rc
+++ b/common/rc
@@ -1533,6 +1533,29 @@ _scratch_resvblks()
 	esac
 }
 
+# Change the metadata UUID of the given device to a newly generated one.
+# Args:
+#   $1: Block device path to modify.
+_change_metadata_uuid()
+{
+	local temp_mnt=$TEST_DIR/${seq}_mnt
+	local dev=$1
+
+	case $FSTYP in
+	xfs)
+		_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+		$XFS_ADMIN_PROG -U generate $dev >> $seqres.full
+		;;
+	btrfs)
+		_require_command "$BTRFS_TUNE_PROG" "btrfstune"
+		$BTRFS_TUNE_PROG -m $dev
+		;;
+	*)
+		_notrun "Require filesystem with metadata_uuid feature"
+		;;
+	esac
+}
+
 # Create a small loop image, run an optional tuning function ($2) on it,
 # clone it, and attach both to loop devices, returned in ($1).
 # Args:
-- 
2.43.0

