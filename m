Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8633ED5B2;
	Tue,  6 Oct 2026 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276990; cv=none; b=n1dJLb/mUoNYfmXxPoVry1eI/rq9AVIsH1pxbiWesMi+eYVnVkOVsT35VSK7o6sSpYzCoENeXzHsjW8JsTn3oVChAl+xdPVthyBtoO0CViy2NS+V5+PKN6UQqGKIL6IfAcDXcHsVdYeFfae0JfR/isQLwED+Xo/M0420AjCktqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276990; c=relaxed/simple;
	bh=5n/J6CmmI0c9HTisOz6R+Nbsxf/9l4DUCmWiLZc0fI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4zVVAUYsYpQt5FZ9oeSfprO2NwCTFPYVfyqcUs9AlVyTDn7bsjdoutDqSgyDcOv5pWtL60u0MMNyyYqbF+GUh/BVgycPCWYY8U7kMYN6D0ePOUzLvzSee6Z2mTdVSm1B5g3jsPgm8jotlRyjc6PgPpI9h9gY+YksYY4Sbak2IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ku9gfmgX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ku9gfmgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1BC1F00898;
	Tue,  6 Oct 2026 08:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276988;
	bh=4OcYaGBMyjAjdPcmFvhN7quzF1FNmh3RAdwyqZwKqq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ku9gfmgXxV5wFVuy6XVE8I9Te/8vEjg4gN6EEIVwdMNyUYM9PCrDhmAND0F/w/om+
	 0DKAiLBgUgxESSdABiUossJlgQY3vSIDaRYk5mAniprtU4dy0ASGzZtmnazxUTARy/
	 jJUWNUUsYrqeNunP3CfLtkJGY5b+qob8nH95AYNQA5vMoonETrM7RQqirn44kcuo9G
	 +aS4vysprmqub3W3qNZO9L+4IT9O0yLf2EL6VSKKp0nbe1HfwPxUYi2Y9W5Sn4zHTf
	 vNTE5VP/PGFw94KhHBdvqvV8FUJguejfDY5pC3O4CkCWbo3sM8MkhhwQj7O6M3MUUz
	 YUNhomFMKDlTg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 07/21] fstests: add SEMANAGE_PROG
Date: Tue,  6 Oct 2026 16:55:33 +0800
Message-ID: <8900633faf8103fe992514d07d69efc9d38e8241.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define `SEMANAGE_PROG` for an upcoming test case that uses `semanage(8)`.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/config b/common/config
index 76b43b8c6ad9..e8fecc168e5a 100644
--- a/common/config
+++ b/common/config
@@ -243,6 +243,7 @@ export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
 export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
+export SEMANAGE_PROG="$(type -P semanage)"
 
 # udev wait functions.
 #
-- 
2.43.0

