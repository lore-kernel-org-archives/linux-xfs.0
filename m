Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCED12F585;
	Tue, 13 Oct 2026 00:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850126; cv=none; b=IIWup7pCulLSacWmU6vEAqoUmJAuRt4YyGEdOatApcbUzNrENz1UJplk7TtE9BtX1m+bdJIvbgrz/8tIRFvvDGSI8uh3E/n1DCTmhjwkh4JuIEIm1TgkwD/XxLDbI2fr+C4vdguKXZ7ihE+kVflXcc0kjce4R9x73o9BgrsVVE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850126; c=relaxed/simple;
	bh=82RKDJ2lL5iNF7YfGeJ0vnvn+ywKrV/xCzz6Sl7WHNI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=jKPzqJwMZ9Q/Wzc50VDKeH94R5hetRUmphLtOmnOnEmUj+ScCh6dLpjfsvXTG8+yyerp5r3TFRKNYYaDf9A/JTFgV7kt66h9sYFLwSQQu2xsy10sn/yvtHM4h1PcUj4LVoWdrV3HJmynsFl9fq2/pXtLn6k65ZmdaroH/SluLlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1izpxDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1izpxDZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 35A471F0089B;
	Tue, 13 Oct 2026 00:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850125;
	bh=Mr36MvjSNk5YkPSTzGx8Vr/goS6n4PVzxmzgOxmUH3o=;
	h=Date:Subject:From:To:Cc;
	b=d1izpxDZUiliqf67iH7UtloCy2L6p/lvJGr4qHLtd4mquaqzsOwmgEFyozjmPzJ5o
	 sbtkuOjuH7HZPg3vSdptQizSoER2EE3NmXTCTkHZGt+eP5LBMwxSm7GJcwtzShrfej
	 IJKDO0f1Ol9rs5SxqYsiZ3U9hfLCyqk8NApZidme9IdoA9Jr3DPbDiMgw36mrULloQ
	 hHtIzWxMsnodZKMFXWobyqz5jSwiCgmQNRjaCXiKt2EcKvg16re2RDjoJPGZJBFR6h
	 XV7lLnhA9Roax1LRF6Je53FPVffxStHd/ySTE/E1eSJe9zrN/88JxpbCnvPnhcV98c
	 yKtcLJqKXerfg==
Date: Mon, 12 Oct 2026 17:08:44 -0700
Subject: [PATCHSET 2/2] fstests: new tests for new features
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007737.1732474.11416600010761357309.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are some new tests for new features.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-2
---
Commits in this patchset:
 * xfs: test rt group superblock repair
 * xfs: test unlinked inode list checking and repair with loops
---
 tests/xfs/1905     |   53 +++++++++++++
 tests/xfs/1905.out |    2 
 tests/xfs/1906     |   48 ++++++++++++
 tests/xfs/1906.out |    2 
 tests/xfs/1907     |  213 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1907.out |   17 ++++
 6 files changed, 335 insertions(+)
 create mode 100755 tests/xfs/1905
 create mode 100644 tests/xfs/1905.out
 create mode 100755 tests/xfs/1906
 create mode 100755 tests/xfs/1906.out
 create mode 100755 tests/xfs/1907
 create mode 100644 tests/xfs/1907.out

