Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022E43A6B61
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 11:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775560514; cv=none; b=uZ4R0XHdDQurLth9HJbT7dXNTB/9Q5i80wSr91tr+iTVJ2IUnUQT7YEhwIfuq3UKfP2d9WU/LZv5pEigt5zgT/HS9Jp1KgouzvoqXqVWTDPP912Gx8TYjkXSD5+bwMYf40hAiNFczS7MeRjyTdPjA57Y5cGxxCkMH3tPvhq2VZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775560514; c=relaxed/simple;
	bh=y+HAUiltt9/0Bt3+vQYCOdPVFSbtu20/E8PzjkryOx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QFJ2a9zozOdvEYzAEg0GfT7pxMrCKD3sBK1TZJiTH4F2ELwrDwbCbBgeRgWOg84aDE96wQPVCWOmHPuFehks3RLi0O51Xv/SrNC9UF9Oka48s34JxDY7NA2EDsm8VaOz/qHIzbRcXImS9YNpQMZYgYpHBFjn1qpQCkiR7DaTVh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uY8b5hfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uY8b5hfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6948C116C6;
	Tue,  7 Apr 2026 11:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775560513;
	bh=y+HAUiltt9/0Bt3+vQYCOdPVFSbtu20/E8PzjkryOx8=;
	h=From:To:Cc:Subject:Date:From;
	b=uY8b5hfLDoqgMg7Sb3/ojxjtTsvNgb0XitsTV6W+JE+hkJCeas7sIRIM2WicD7dkc
	 OQqPEwLUP3fI3ULV4wLzjROyJmnmWplQ6gY/3jHFti5f5hiFs9yZhjWKx4Ntly4npG
	 zd5BzFaZDlmsWrjaE52Vf2j1iTlKo7OxqRYO7Hbek2v4axn5cvbQ8DFTI4tM5dY8o4
	 jrfj2J7Z3AkLSBpy8JRtohKyHOXfbMrrMVstd8P1w2+A2ErcO0tYoINkA4hfh2UPQS
	 e3n4/nc9U0azLMAdZsCUwM7h+CSG6aU0naFf2F0uJsLYl8pRz/9QkiYnvS4H6hh23R
	 IXY9KcvNpOarg==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v4 0/2] Improve user experience with xfs_fsr
Date: Tue,  7 Apr 2026 13:14:58 +0200
Message-ID: <20260407111507.79977-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This is the V4 of this series,
this fixes an issue based on an user report via IRC in January.

The only change in this series in in patch 2 which adds back the
fprintf() call I accidentally removed while rebasing it.


Carlos Maiolino (2):
  fsr: package function should check for negative errors
  fsr: always print error messages from xfrog_defragrange()

 fsr/xfs_fsr.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

-- 
2.53.0
