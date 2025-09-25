Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D887C2D7DD1;
	Thu, 25 Sep 2025 09:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758792629; cv=none; b=eD5rbgalDk1YvCOLxHUm0fUdz9kaGCrm890qkHBUVlgI5db6BBT3cH5rxNwkM54rffP8Rz9dAvrrusGc4W6dkIg1i6KIFkseHVKmgB3+Ba3y8RGa0gIC7sh2CtB3QvAmBgUt1kqfq9ilFZ7uTpx2oxGkpx+VOmaHIvXDv0YFBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758792629; c=relaxed/simple;
	bh=njZcZyoZSiE+Hn3EZ5XKFPr+ZwSzdkZ8LZWiPmLMBY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NdnRvIqVMy3SIYOEN4icLzc7H+Nh5ZCf6gdzmLsPdtqW1OPe/M0fnX2cAc3VgPbBPWPZdPOvFM/PHzM8zQRBIrFMlnbRw2oDBH0x8km3Dje1Pi8Zw5YnbtjuTY7Imv7Q0GzeVpeBqZDmNNggi6dtXFhdBBEaH7qI/PZjX7e/Sc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJfCwd9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJfCwd9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18600C4CEF0;
	Thu, 25 Sep 2025 09:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758792629;
	bh=njZcZyoZSiE+Hn3EZ5XKFPr+ZwSzdkZ8LZWiPmLMBY8=;
	h=From:To:Cc:Subject:Date:From;
	b=dJfCwd9jaaRg96T3eLENn+FguuUcySmWA7UpJlvZboj6Rf/4ALkKZOLAdjBYfKQ7c
	 PKzp6fvYfr6L1A37yjKTnxN8+wwmREuT1GBu2MyDiOTJVKK3oOpGpWu9cRrSQVJaFL
	 wdu85DHUGgbToivarwwUZEI/OSgY52c+rLmDF6i8jf8SM/ZKToZosYS1dhHh0Bz7BE
	 y7y5OgXpM6NaundZgqfWLA9l6zP14hXzhZCeAKt1ZdLGPSlOSxWfxYJ2AyYLystnlt
	 EncJ39fmiO00Za5s3MqIb28TOq2zF0iu5HCuNWii1Qs6Kff+wnkTqLEbImvQNc7XTP
	 jo0b33PngnAvA==
From: cem@kernel.org
To: zlang@redhat.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 0/3] Update to account for attr2 and ikeep removal
Date: Thu, 25 Sep 2025 11:29:23 +0200
Message-ID: <20250925093005.198090-1-cem@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Linux 6.17 removes attr2 and ikeep mount options, which have been
deprecated for a long time.

There are 3 specific tests that fails now due to the abscence of such
mount options:

Both xfs/513 and xfs/613 tests several mount options, so this series
only update both tests.

xfs/539 on the other hand has been written specifically for such
options, so it is pointless to keep this for 6.17 and above.


Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos Maiolino (3):
  xfs/513: remove attr2 and ikeep tests
  xfs/613: remove attr2 tests
  xfs/539: Remove test for good

 tests/xfs/513     | 11 --------
 tests/xfs/513.out |  7 -----
 tests/xfs/539     | 72 -----------------------------------------------
 tests/xfs/539.out |  2 --
 tests/xfs/613     |  6 ----
 tests/xfs/613.out |  4 ---
 6 files changed, 102 deletions(-)
 delete mode 100755 tests/xfs/539
 delete mode 100644 tests/xfs/539.out

-- 
2.51.0

