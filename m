Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471F04D2ECF
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143763; cv=none; b=nOIvJEwwe23ixTwEkFIuEK7SAfk87/+C3ey8wUnXIUb2PoiIOksKgnyR2ZnwpvYI78pD+n3ydnOhrFdF8ollNkZgmT9JcdIRTK5zqkKHyshJLLuonNaR4nqC+ZZni486v1Ff1xjr3lCSQQ6jPt73G7gOOqYp0kAGq+3ABLFkl+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143763; c=relaxed/simple;
	bh=4ysNs78GLIgHIZd6NSomhhdiuevrsBVsuM6/XoE3ig0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MaiPlOSvxxBcCgiJoyTRKEDHS+kTyNXrAdqHYibFw9h/Hd3wnGTPgMWTvzY5m3iqrnyGIFY4IU9zIYpzozPD+Pagfy0v47/72FEnhBguxoksSWtxRi3sg1ZQXS7RSHKnLDGhcAyCkVjN9PoCB9NYwhnrwoL0M2SZsEgglksH3sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWOaaV10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWOaaV10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EECC2BC86;
	Tue, 10 Mar 2026 11:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773143761;
	bh=4ysNs78GLIgHIZd6NSomhhdiuevrsBVsuM6/XoE3ig0=;
	h=From:To:Cc:Subject:Date:From;
	b=IWOaaV10I1hNWxXBbPW6UxjxJRBe0YWMwi5+yv+vp+EMzzVRE5GpcSJa/ra8SG00y
	 yD25eK7NPGqjr7QW9M3dQp0f5q+HMj57w5ZdQv/fkPfC+MzI//EQ6JKZH+OXzbNT6F
	 n4ytVScS7+0vRmDJ6jQH7yMNlgZF+LPzd+Yz7IZltJs4DF/xFVKdo78jMoswdqd6Nz
	 +hnrQwc8Xmlx4hdOSNzafE/hAtEQIbrSRxOOp+puY6uOpYpZATq+D7LJ81OqPhjmQp
	 CGR0fjkIVpYas19wX8BcmM5IbliiI0BroZ1JA1GHa1Yv2U+zg71Fu/AVklmMRAGgOL
	 LBKGhsxsHmCtw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH 0/4] Zoned device cleanups
Date: Tue, 10 Mar 2026 12:55:03 +0100
Message-ID: <20260310115555.114197-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

These patches initially were part from an attempt to implement atomic
writes for zoned devices.

Due to unforeseen circumstances, we can't implement it, at least for now
without restructuring a big part of the code.

Christoph though suggested those cleanups were good enough to be sent
even without proceeding with the implementation.

Carlos Maiolino (4):
  xfs: factor out isize updates from xfs_dio_write_end_io
  xfs: move zoned dio ioend to its own function
  xfs: factor out xfs_zone_inc_written
  xfs: opencode xfs_zone_record_blocks

 fs/xfs/xfs_file.c       | 94 +++++++++++++++++++++++++++++------------
 fs/xfs/xfs_zone_alloc.c | 32 ++++++--------
 2 files changed, 81 insertions(+), 45 deletions(-)

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
2.53.0

