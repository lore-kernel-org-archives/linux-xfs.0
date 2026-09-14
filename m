Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8884743F8BE
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387074; cv=none; b=akhc52sJFGgXURttebi582EgCDAZ05SaZtO4NQCGdDhpDTZe2AOSSy6PwvpA2TXLj+XB/7h6203HWTlnQvYgCeRK7LXtHnCv+VvtK7TDfuAFP8XJGX88nLqVbDf0Kgb5ib05ReKuavN8T7GQsQeoFzv41Wn5IJmbFSyRCtunPRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387074; c=relaxed/simple;
	bh=rOWxSJCaTHGrgqmS4yVuFAPF3k36Vae9Hy6cj4L0Aus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oq7fOV63xmPO68BJLvNHcWqnBvDT97+uH/le/GZKP6tU9lN6aMQwd69TkChAwqPPvRE6wB1WPy9LSOxMQ4vtwUgZIlcgyMqqtgz2z86xg6AIvv8JgGOCxuyYMPgDuMvkwTPYBgT8mNBJX5cW8qdwRw3r4s9NMGMWWcnfflxznRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQFROJCp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQFROJCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127981F00893;
	Mon, 14 Sep 2026 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387073;
	bh=U5olZKw/UcXy3WMCip49I/K91J5wHCQw6temQK/tPR8=;
	h=From:To:Cc:Subject:Date;
	b=jQFROJCpo3Dly3YcGKuYDtdXeaH4IPjslZAmIwCmOOjgTX/Ujp+bFFqBfdQ+FXi38
	 mpkd/sLsBdZaO2dmnDU0blzbdvhlFcvUmOoncBA/4TM8mzy8sDvi8tgBeEBUk4Uk+j
	 A2gDGdhYV9xqz+MLIjEghrEDwsH1oS0tKGjPJA4dDNbx9i8fusCGBguxjiPgVmy9Bi
	 lxvTEOmNW1N3CO1pD9nRsY+ioNYhyK/5iNTkuDgnAkIMetHohFiWE1uMr0mj/YFRlr
	 34jOKBNLm4nwBCzbH4qKD/Quo1+WNwwU/UcezDv5oJGnr+gOFJ8Z+WJ4jf06JVKows
	 o5To5SKSYL96w==
From: cem@kernel.org
To: cem@kernel.org
Cc: djwong@kernel.org,
	hchc@last.de,
	sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/3] Enable xfs error reporting to print out error codes
Date: Mon, 14 Sep 2026 13:57:38 +0200
Message-ID: <20260914115746.82122-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hi,

this is the V2 of this series addressing the comments from the previous
version. Details are in each individual patch, but the main change:

I removed the errname() call from patch 1. Turns out it would make
things more complicated as we'd need to not only check if
xfs_error_report() receives an error, but also if errname() returned a
non-NULL value. Having the error name was a nice to have thing, but
printing only the error number make things simpler.

Also hch already cleaned the extern modifiers from the prototypes so I
removed it from here.

Carlos Maiolino (3):
  xfs: add xfs_error_report the ability to display an error code
  xfs: enable xfs_trans_cancel() to report and error code
  xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

 fs/xfs/xfs_error.c         | 16 +++++++++++-----
 fs/xfs/xfs_error.h         |  9 +++++----
 fs/xfs/xfs_exchmaps_item.c |  9 ++++++---
 fs/xfs/xfs_inode_item.c    |  3 ++-
 fs/xfs/xfs_iomap.c         |  2 +-
 fs/xfs/xfs_log_recover.c   |  3 ++-
 fs/xfs/xfs_trans.c         |  8 +++++---
 fs/xfs/xfs_trans.h         |  6 +++++-
 8 files changed, 37 insertions(+), 19 deletions(-)

-- 
2.55.0

