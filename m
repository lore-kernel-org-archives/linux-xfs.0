Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EEAD26A;
	Tue, 18 Jun 2024 00:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671601; cv=none; b=p8UV+ryEIiMlXTZvnThQTIdVFQipvO6ZRr5L2aC31+lLKXuUhajDkYUl1bLePjzHTBhKY6Gi5PclNYsEeNS4GUHWSAkHraFrPtAFqO69R395neO/1hqKLbKIqIiu7Oi/P2r1LDFiLiE5FsoCRg1+9fMjah4irMQZVv04kkBve7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671601; c=relaxed/simple;
	bh=VZIKT9Sh1wYygAzuAXzmINhXjWd+LX5b3abfdDh6XlQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ggaxEkURmmJ5sYzLXTGGDzlIKRQMBq0MYVN69J1W7d2o1fWfOrQ85UpY38pslWKTOz4ZHV6VqdaRPlT/GjY7aZ28LTkdtBJVZQdtyV7qh7vSWpm1aAExFytctrJAcm0IpHEBlrGAc6B0cm9RzHGHYJOBUEx/wwuns2E3lIaA7lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TA+Bv9p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TA+Bv9p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8576BC2BD10;
	Tue, 18 Jun 2024 00:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671600;
	bh=VZIKT9Sh1wYygAzuAXzmINhXjWd+LX5b3abfdDh6XlQ=;
	h=Date:Subject:From:To:Cc:From;
	b=TA+Bv9p+VaGBIuiTCE8qNP4/uuaUJchyvCE1BG5yhmsQ7M6CvRRExBQ76x4WawzRw
	 VQiXxrWSiANqEZbxBajmGR6mKQh6S/duqXr15U1tqZDGa9WZ2zrFSOpXJV1jM+BI2c
	 mZ9xYdRnxf9uFMB+conmPRdaEEu+KeZLid5IGahtGiRq7qy1IZzp48KLQfsH3zHcKU
	 f+oRTTTbMkShrVaNZk2UZRitH3GsdVE+e7yhD/cw+8hsRpailrMlziL9qnlnmPpW2V
	 aM+4YMB0Q9sX2mh7/yuaR/L/9E39y6hA7rCAv4yo7oWldT4HgudCt8EEETI9Q0YVe1
	 AenzFDdoo4QSg==
Date: Mon, 17 Jun 2024 17:46:39 -0700
Subject: [PATCHSET 6/6] fstests: minor fixes for 6.10-rc1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, guan@eryu.me,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171867147038.794588.4969508881704066442.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are some fixes for the stuff that just got merged for 6.10-rc1.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.10-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.10-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-6.10-fixes
---
Commits in this patchset:
 * xfs/348: partially revert dbcc549317 ("xfs/348: golden output is not correct")
 * generic: test creating and removing symlink xattrs
---
 tests/generic/1836     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1836.out |    2 ++
 tests/xfs/348.out      |    2 +-
 3 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/1836
 create mode 100644 tests/generic/1836.out

