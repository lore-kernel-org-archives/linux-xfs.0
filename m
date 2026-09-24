Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168D3B42CB;
	Thu, 24 Sep 2026 02:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790215910; cv=none; b=apSmF3aUCzgtULF27wZUVxjcXQEiMRdYeGiISo7iS3Ewz6BbV46Kn38OGThHyaPVDGxdaKUlOJbSv+Dav8mC3Jx+p9WF/V4E21pM05rj5b5Fsze+UOEfLg7guE0OOqUanp64trqzYB31xnE9NUAnVHHZ/K567GsnWkoUctPaaxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790215910; c=relaxed/simple;
	bh=dg68lrqlwHcYmHaqICpOpLZynvg/nPi2GSo0AscZ4q4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=tWs4UlmAIYzAPKRlR2FITbfxwHaOWmubni1iW/5YXIThUlv//i+RGPVKbEGDNaoat2/3Ei8Cym+JtRzHB7cy7GT/4eNQFOWQ0cFr02OpCMerx25sHWUhUwxMi3n/v6xxx73Qiw2JIc8dNARhWEI93zwO8+wwQ4FDqblduKrU4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=UI9wjv83; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="UI9wjv83"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790215895; bh=dg68lrqlwHcYmHaqICpOpLZynvg/nPi2GSo0AscZ4q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UI9wjv83u/DRHnXBnKDejEeqXJT11gZcraDOSl/Tgd4Tnp+bznPf2NsAcdCuruDfC
	 5hSFW0fMTtRUlHYRzk99Vz4292nUsbDjJx1kTxICL940oiaP10wNUVQD2YLCZbuBfP
	 sgiNc/SpWPcGQykAOWhP9W/QiZjbNBtab2e03tGY=
Received: from localhost.localdomain ([14.22.11.180])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 2E13707B; Thu, 24 Sep 2026 10:11:33 +0800
X-QQ-mid: xmsmtpt1790215893tqqmm8vgl
Message-ID: <tencent_C716F404D30EB56D3E69D2B29D4D9AD78307@qq.com>
X-QQ-XMAILINFO: OW+Aa38L0qVBr0h5j+U9QsWGyu/R97F7I8vRzAFrhFW/LVdoPpdYVdmNHT8mAc
	 0yHYjTeoPD3oCRom0PCFpwLcGD/egMXYeVjMxr685MF10UhqdNQD9StZyaSd4hPruSKlWLGYxBsV
	 c4WIk11NK84beGuPs8RNyJzfcjbwgan5yNpSI22RqmU+uG5/QzzxnjisVETI4/lBkxmIxqWXnl6q
	 u8B/yqKkxjTg53F2KvORBcPcX3PutQRvEUodHlkRU5L+xuteDN2yTKsNkeQAV06YTSvalGji2jjO
	 jcU50Pg8zlK+bE/aGMWV7fawG4/iVTh6uzKvSpnt5C0bIWJyZNO6987hZkbJBcpOW0RfNe2Wqbgz
	 8Mus6+YgRzKLx/SoPLMTzi3in/0BzWjxn/qGoBISGOJHX5uGtVxXwPzccyzBf0QF9hePekKtCMnM
	 3Rl00zdHYbNuR3df3rKuwOenzaLpNVpOuhjd7wigjoZduIEMYEJMk6ANB54MrqmGVFs+RRaiaYpt
	 zmPMMm2DxkvmiPs+zkJpdIjrvebAXbgz+XUQNNzUZhcE7cXxKpR0iNfduAnfH+8cCe8EBnXyoBgh
	 Zh66gmoKdEpLLVT5yVKlGVqWBss1LQdOiVzgaHFjBSbrPRMye+5zUm3eITfGDmEhRlA7h8A2IL/7
	 U+HT4KxDAl+miIbS59IL9rTS9X8WWkt5GRd+AOoENQDi/BEhPBifq8dcCdNYhWHHeifcV+jqoiRK
	 7qUkDZITX4f2Rjtb02Bxhb9dj3DYEDR4O4+G75htDXTxFpA6562klPZ0kX+ny61q1rK9hm+A66MO
	 A/gExeB7jk5Rg3MhbsJA9vRe14qv4+kHH3W8L2dtmT+52PRF58kekKfZ8LNFWoJVhlymyfIOcmJ1
	 daq2fu25xSWfddmtyRkmoW9B+ILS7WlqjFmzp74XnywbVOzkXRXMBVy2K9c7bZreGgiJV/pQjD1F
	 Y8VFaFDhyuvXG4TNcvMPXsu4W4La9nG2tXvJKvWzA6Zp4RIodfVp8gBzZB+CCSSdU1XBLP5itkwe
	 OF0uPPrNdIPfDpWHcb4uupfCKpEUSiUhREnQZaPrnmMCvpzNoFbsJUJWehIKr1ElH9dJmBGRo3My
	 Z0TVVUvVGWEGTNBrBA1PNCJVw1Hw==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: MingTao Huang <1037827920@qq.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	MingTao Huang <mintaohuang@tencent.com>,
	MingTao Huang <1037827920@qq.com>
Subject: Re: [PATCH] xfs: fix skipped flushing items not counted in xfsaild_push()
Date: Thu, 24 Sep 2026 10:11:26 +0800
X-OQ-MSGID: <20260924021126.2548907-1-1037827920@qq.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <arL9Xrmf5Q7wd3T4@dread>
References: <arL9Xrmf5Q7wd3T4@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Dave,

Thank you for the detailed explanation.

> As the author of this code, I can say for certain that the
> intent of 'count' is to count the number of items we made
> pushing decisions about, not count the number of items we
> have iterated.

I wasn't aware that count tracks push decisions rather than
items visited. Thank you for clarifying this.

> Tell me how the delwri list got so long that it gets stuck
> inside xfs_buf_delwri_submit_nowait(). Whatever caused that
> is the bug that we need to understand and fix

I think your point is well taken. I will continue investigating
the root cause of this soft lockup and follow up when I have
more evidence.

Thanks,
MingTao

