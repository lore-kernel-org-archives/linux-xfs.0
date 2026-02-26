Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8CC279DC3;
	Thu, 26 Feb 2026 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116926; cv=none; b=Tz9aQQM+XmFwpVqW1aVJtmqbFGbKN44mCCPci1QTYPGievtzpm2O9B1eh/3PaDWIXhUybTsC8MT7yfiFuSgcGFs+j2SifOIfM0GlAxW5d9i5HcglRAS8/L6/WhWJ+MIiOvnJU5nWZbMHOokuz1g8F/c4pToheLC08Znb4cTn0zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116926; c=relaxed/simple;
	bh=2SIdks2QnEfo/xw64rjyLP0FMw8//eERAlvfISayXqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRlhH1fEeht5kp0RJ/dHR4uuejVkLOgKxfruyj7a3PnqjHMiZil37UpMt2nDPeXvGr3h9uFKUZRWQjI/S12+YNIPeb1c4IZyQH72msX0cITrgSyfI7y1jgb3UjZoCmoilWYRRMhcuU75bHXTLRYzpFv0lLnQXiKfNxc052TWneg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTwAZ88V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTwAZ88V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8448C2BC9E;
	Thu, 26 Feb 2026 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772116925;
	bh=2SIdks2QnEfo/xw64rjyLP0FMw8//eERAlvfISayXqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTwAZ88VLff6KZA+y2MF4q3LcH5R2rNP4lGAlR7fBMQkJujfDNEa08EwqkdUrF9+7
	 0P1q4QZGfQEEHPFK/Cm7K9VrJQibjFF25U9MDI40pmhjr8+UfuwJg2Npr0uGQLJYiR
	 b87SjN5cJG3mAQfsJ63h27QfXjblHr3o3cTteLZ1MtRHBScsfqJIjKNObWZxl/pmlR
	 7K5la6S4bAC1jxl7XgvU303yKVx0cF8K7LrN7HJ3dcBlmRhi5V1Ut/rhgrKf7u//6j
	 J/rrGnwLYauK7DshHY1X0y2yXQ3dzTkDQuXXO9A0cfWrScXl0vqT1CfHKMd3K85B9I
	 7EZZ7x+6yunpw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] fstests: add _clone_mount_option() helper
Date: Thu, 26 Feb 2026 22:41:44 +0800
Message-ID: <5a362fc3297410cce387cf718e25a53e6bee1c1c.1772095513.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772095513.git.asj@kernel.org>
References: <cover.1772095513.git.asj@kernel.org>
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
 common/rc | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/rc b/common/rc
index 2253438ef0f6..438de54a467b 100644
--- a/common/rc
+++ b/common/rc
@@ -397,6 +397,14 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+_clone_mount_option()
+{
+	local mount_opts=""
+	[[ "$FSTYP" == "xfs" ]] && mount_opts="-o nouuid"
+
+	echo $mount_opts
+}
+
 _supports_filetype()
 {
 	local dir=$1
-- 
2.43.0

