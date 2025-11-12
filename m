Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25326262FC7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762960783; cv=none; b=azyix9GDG9abja6rGzyDouObqyqyTNMO9UWNlStu9yLPD7UogL+DB/eP1fmZfb38rrnFRolnrhZHhQ+drWUloh/rCNKseQfpwqJW+h2KMFNtxSZHuc+NHceYIhBG6n//L/crfq/nGS5T7rXNNaTbFuXum7TxgcSYssNb6QpMSGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762960783; c=relaxed/simple;
	bh=B/Xj6dHGhYO9LjnltSlIqUQq1rG4YlaLryiI88Ii/xo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R8jZTU5Nmnbvw1O2ZY9Lybv2LquCNPshZ0icOIKgaoGMGxsfFK59IuIhLBVSfpzJc6EJPVmE6kCPHLkfWxpsSf2ZMo9kE8urC/4tEiNr47V1yFIEaJw36ur3Bvi5Flvnj3Bds4aQFFOjGQxCPkodNh3x05F+HfeQnIhkK815lSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=DqxKn5wd; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="DqxKn5wd"
Received: from localhost.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTP id E0F18407850F;
	Wed, 12 Nov 2025 15:19:32 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru E0F18407850F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1762960772;
	bh=ORFRzvdWmDckEoewbnYOaGp2bDKgYzl3YIosHJ7mo9Q=;
	h=From:To:Cc:Subject:Date:From;
	b=DqxKn5wdW5CcLd/5fat4e3BQUCsN8OCJG1ILyrweR60w89F248VmZX20sKTz6YQ0K
	 LU1h1xiBiv+IcATEGHI8zwLXTAaNUZ/FdQtYYxkzBQJRkZmTFanepeGp7q1hZyATcN
	 MDqgaHrZj8UgUpHEYGu2ady+n2pGorDeldCn9r9U=
From: Alexander Monakov <amonakov@ispras.ru>
To: "Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs_db rdump: papercut fixes
Date: Wed, 12 Nov 2025 18:19:30 +0300
Message-ID: <20251112151932.12141-1-amonakov@ispras.ru>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I've been using the new 'rdump' command of xfs_db for manual recovery of
a substantially damaged filesystem. I'd like to propose two patches that
would have made that work a bit easier.

I'd also like to suggest to remove the one-argument form of rdump that
dumps from root. I'm honestly unsure what it's for, considering that
'rdump / dest' is also supposed to work.

Alexander Monakov (2):
  xfs_db rdump: remove sole_path logic
  xfs_db: use push_cur_and_set_type more

 db/namei.c        |  2 +-
 db/rdump.c        | 21 +++------------------
 man/man8/xfs_db.8 |  8 +-------
 3 files changed, 5 insertions(+), 26 deletions(-)

-- 
2.51.0

