Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AD5275851
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747050190; cv=none; b=o9lJeuEtIO01gp21on0fI7g982X+nZPiqcUrLbH2fT5a4KyIuZ33PJzzaRhWW0PnATDzcH8Y+B+zKcuvPdJrIgChg/Ym2NfT0Q9mj7GeQbtWUn+HfMYfq9J/EO0J/pUJIR+YU8qzb3UptJX37s3iSS2qgYIzC4/dJayHInmgS3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747050190; c=relaxed/simple;
	bh=giURGobf22NB6VoSnRJrFi1O2N3ux83WtYGyIk70e9w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SWpLvNStKPVjMwlP2vGMSmnOTWqUB372+rkiOOZg/JRZoasjZnZW0tkDimGQR9DSZrI7gRZx4Rr6uzHpLnqYIeR3md5GQgqYduiiRdFHJaQafORkJy7zGb4QzjabdN6MKyfiIQtZjuu4JFEdERB+wmg7XA0JazjKjPnsrICQt0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PvRzGM6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PvRzGM6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CFAC4CEE7;
	Mon, 12 May 2025 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747050190;
	bh=giURGobf22NB6VoSnRJrFi1O2N3ux83WtYGyIk70e9w=;
	h=From:To:Cc:Subject:Date:From;
	b=PvRzGM6RtDAbbkJFInq+U2/jJtnNCQRTy/WBptqj5DVMcW4D+sbimXZZVyTe9gf1h
	 St0jrAY3n/48IsBNIb7E5SRTcso+6x0eMmkIcC3kmhv5nL51a+xLLHNDjTL9lh8rMF
	 TIdEtgIt3Wx47S/gwZfKcLMMSLn5yQaelgeLOrBzgAuObipORL/0+bZqBztORmS14V
	 tiZQ+NyX6ofuZvl7ptptI0xt1/jlqfGgKwxM8t+A0JGyyM42ChD4Vy4+y27qZSzAVT
	 0b3KA/bbwGQkE1PmrrfBvgtPNjQpWQrCeuHA2J4VLiwOlFUJtbCkyHK6sebMUF2rP8
	 AeAbbzTjjLQzA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	david@fromorbit.com
Subject: [PATCH V2 0/2] Fix a couple comments
Date: Mon, 12 May 2025 13:42:54 +0200
Message-ID: <20250512114304.658473-1-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Fix a couple comments in the AIL code

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos Maiolino (2):
  xfs: Fix a comment on xfs_ail_delete
  xfs: Fix comment on xfs_trans_ail_update_bulk()

 fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

-- 
2.49.0

