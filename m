Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35043D47C9
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164385; cv=none; b=P8OkK5ozXsFV1/UvdMydyrWaKRoLYSy5EuKHCQQxdKabt4eKtiT2fSEIllzZxJ4kO0DOdSgDd/IzBYLaf+3RKSan3AAT39ya6mc4UB0S6Eks3ASynmvyy7rlmTowSNccSgF73dU0ngGs38mccFrfvasRd7xFNpPZ5fjM0X7WJW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164385; c=relaxed/simple;
	bh=C1epaAb/hc/DhiYLcgOhkP7qylrHX6JjAD1ucy7s864=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OFRpHeoJyCC3rBF48S7qeKLzbfcWJzdS0124OuztWGqMHqqQASE5lrvFkO8k/HMHZl+5i0a1LvWMrMVeFI3F8WhOJtrpNA/1ja0L8OpPhsHNEgw7paTkMMkvOWt+OieFyjd2jIrYjI6lv5KyC5etNVfTAgBb9M6eVl2Vtbuyzs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNjiTzV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNjiTzV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958A0C19425;
	Tue, 10 Mar 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773164385;
	bh=C1epaAb/hc/DhiYLcgOhkP7qylrHX6JjAD1ucy7s864=;
	h=From:To:Cc:Subject:Date:From;
	b=MNjiTzV61Ov8iz9L+FhS57NkuQJr9j4gbyMDV7DDEcJ3XeqFA2e4Fi0LZRkkknBeF
	 jiiVbKpQlxgaq43azV4LbMHyo0DuPn2gBUV6EibvNWvFs7Ev8fhKUCHcpMl28D+rpk
	 J/M/YNR2CR68Wtvk35tG51D5wnyDSMz171ffu9UwFIb4qeythr7Z82eXTnvMeEs726
	 a/R4rOdL/1WKHJf2iHj5zYmQYzT72ogmxeiGkP9x0sIb6qUckIwhoBXJ9j6QlATHPH
	 s9kQUxNnp/m56qdSpvwkkkrXbEi1tL7kc1Rat9N3Ayjd/WXHUb4KzmfkwObfYQ9Tcz
	 VnxuUhWdYamUw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH v2 0/4] Zoned device cleanups
Date: Tue, 10 Mar 2026 18:36:45 +0100
Message-ID: <20260310173709.457047-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This is the V2 of this series, which implement changes suggested by
Damien and Christoph on the V1.

Only changes are on patches 1 and 2.

Original cover follows:

These patches initially were part from an attempt to implement atomic
writes for zoned devices.

Due to unforeseen circumstances, we can't implement it, at least for now
without restructuring a big part of the code.

Christoph though suggested those cleanups were good enough to be sent
even without proceeding with the implementation.


Carlos Maiolino (4):
  xfs: factor out isize updates from xfs_dio_write_end_io
  xfs: factor out xfs_dio_write_zoned_end_io
  xfs: factor out xfs_zone_inc_written
  xfs: opencode xfs_zone_record_blocks

 fs/xfs/xfs_file.c       | 95 ++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_zone_alloc.c | 32 ++++++--------
 2 files changed, 82 insertions(+), 45 deletions(-)

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
2.53.0
