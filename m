Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1473B38B7C1;
	Sat, 21 Mar 2026 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094326; cv=none; b=dUo8bWgxajoN7XvKbcglyC/zXsc9UnWYoHrC4h75JIPA4pAywdfToIhEqqsDwMsaDgRQXy9y4AgJQJlewJLYAYh45YVbPWIJypSys1vKUyTLaAdpIRm2KBalgmWgfX2ge37pyYnA1o3780gT+cCWB8dYdzrfhCcwZV4rLjUpIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094326; c=relaxed/simple;
	bh=x4z02wA25lLHv2o1UWHyUVhrQUsN8nM9OblPyuHujFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2RIlslNmvVuzJNdPy+LpajoeAmQvpbyPe/nVsSu0HZVCiNzBSUK6Bx8R8zuquSjxs6bvLwUeJH47f9rGlR2cwQenh2D3oqzqPLTX36sNaGkDEsx0276yn7Nz8zz7yAAZ7xwJzepvSAH5VK1feKm54r8DJ2S7OeewXX9QlIY09E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzFIx4r2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzFIx4r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C86CC2BCC4;
	Sat, 21 Mar 2026 11:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094325;
	bh=x4z02wA25lLHv2o1UWHyUVhrQUsN8nM9OblPyuHujFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzFIx4r2sjixeB9srXr7ftlibqczh/tProKdPgKqBr1KkFc2a7bVWd0gyWjiB24QU
	 WEsEm93Eg3HoGZCXhtlggHPYYYej/18At64CI6yq3qDIQh1N2eP1lf+oWnhYh6d+A2
	 7E04nhpautuqVuCHsQTQoHuZnuLiDT9hS9XNdcQWJanQ9PcV8sByZ5BR+/iXeMQAe7
	 6nTwkelinUVqKI7du3cnOofCiq6Mt1DcvS7iJ0xcyL6FklMVwBlAnTLt3Wq6eYs0Mf
	 0kOOZ+86PjbjVjMJt1ciQprUbS/ZYc84on5RipYiyNTgwOtC9GZHl3/veQ7u2vHb83
	 7BtfR0IrvNxsQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 3/9] fstests: add _clone_mount_option() helper
Date: Sat, 21 Mar 2026 19:58:24 +0800
Message-ID: <8121d81f7f91db23a67c3298c274e674352a62f6.1774090817.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774090817.git.asj@kernel.org>
References: <cover.1774090817.git.asj@kernel.org>
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
index a8e6af5d1a1b..7ff9815d88e3 100644
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
+	ext4|xfs|btrfs)
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

