Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C415200BA1
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746611565; cv=none; b=nYq17ViB9Gtc4EDV1X896mccB316TTvZ5kdrIn01q9Yry+vruO5wM/iJK1u/GWAwjtVgVr/5scnDyKqM44cYhiz1V5iLphQQfGpQmGBg/mCCrhyCC9kn+ui7rhDDSneNWmAuCVdXsvHk7U5Dqvu2DHS2JLww9IlcHLECWvxchC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746611565; c=relaxed/simple;
	bh=Yv84+Um77sTetICPVm9IV90gJCov+xIKSeSMe0hLg6E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dr/MkcvdZnFuauxWGHjisU8vruYtgofIu0AWfJcshyND1gJeMsMehDC5YH3IgWPyZW7mmPIJcnTTf6Q+cuSdcio/MzYjjMb8z1sKD4DNSx6KoBU1JX0HSFW4KAyaKRM7adEoh8giMS1kWA6fRLcYCrpgV8ZLjlGS+5/rhwSYNQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQGeo0gQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQGeo0gQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE0C4CEF0
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 09:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746611565;
	bh=Yv84+Um77sTetICPVm9IV90gJCov+xIKSeSMe0hLg6E=;
	h=From:To:Subject:Date:From;
	b=WQGeo0gQVsWHjjvpFylHlToGlYpZM19l8n74E7eqtFN4WUsZAzYG77oU21n5ijtj0
	 SWD13g++BUvonq9VIl9zY1AzEjX4ym2Nuc64jHc8Q5XHiDccNNSffbH8Mv/6EH4t5v
	 0guX5yd74G/bmEHSIel7O4eMaPzraklPKxYyL+NrPlJnp91OFx6TZn683BQaHMxW+2
	 DWXLN7Ff4ULSZo98FvLVMW75z8vXiAdcSq7V51gLt2toREJa4mkwTkbHBICCrjiGZO
	 mVWNAA8fqtN2RuhlDyL1QdH7PdTZEQVn3piuE41/sJqmY9S8rFfVoju7N2SpGFR2ZE
	 N7n3i7sJLBY4w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] Fix a couple comments
Date: Wed,  7 May 2025 11:52:29 +0200
Message-ID: <20250507095239.477105-1-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Carlos Maiolino (2):
  Fix comment on xfs_ail_delete
  XFS: Fix comment on xfs_trans_ail_update_bulk()

 fs/xfs/xfs_trans_ail.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

-- 
2.49.0

