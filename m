Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89538F649;
	Wed, 10 Jun 2026 07:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781076285; cv=none; b=eziLmpJM8YwY2Vov/UlBIFisSs541DjtOSS4VAjSi6omBySxk05JHrjavIpJZAmbwKt5Tn3pJwRFcjqu1smOTdyrGvcoOg3YgnttmBd4at9lhcbuTL6MT8qmRw1Ciqr3HcRDDgIoeh8ryRYv+/gz1L1XnGI62N6+Zas3k7fpkxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781076285; c=relaxed/simple;
	bh=9bty3HZuoVMZ5u5b/x+NaOuDsNbcsnhZK+zS6GDNjAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgE2f5PH4Rr3ua17rwkaAUZXW/PZDfzIBPw8TQ/4E6b85brnR3gztwLd5Qcn8q3Sfg9EcfM77Cx5rlrZv4ZcmfrrhyDsMH+vE/rkLDFSDzcWDlauKqW9ntCGIMmf88VN2Fctsjpl/8SKEHccAu+K/UHpd5U94LRFzt8DFLzTi1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SH1/wVyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SH1/wVyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3890E1F00893;
	Wed, 10 Jun 2026 07:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781076283;
	bh=R2ez+RC6RwaA/slWb5T1nPdaQdgueSdJoX8AxwtxUTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SH1/wVynbSTuxYweWh+aGagEgsCeR5BNe5ZkaahAk2tw9nsu9u5fxMv3gcdm0PGjB
	 x7rH/aydsk4DgkNQWsy2O/pJEz7Ww8nbqalCS2QosG/f1E6/yPz4MD/vgZXbWU4G6p
	 oG+HfvO/+1FgvAHN8Jci1nno8GrlB2gNJaI74Yglmt4EEC83POLyQ/ZyJUaZXJ/0PP
	 0V28x1Wxg16Twyi2Jw+SuX11EKzrg7yL3oikXqgEAInPcJCvl8J+6Jsb64rkKEsxg6
	 dR0Qsv6CZp8r2BBOID+Nz4XLtag+s6027je9on3+tevxbG64paYPf7pFGjatdTbKFk
	 lFilQ5toNujrw==
From: Christian Brauner <brauner@kernel.org>
To: djwong@kernel.org,
	Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: pass the correct len to fserror_report_io in __iomap_write_begin
Date: Wed, 10 Jun 2026 09:24:36 +0200
Message-ID: <20260610-fanpost-abfuhr-perspektive-7fc7719434d5@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610050642.1906695-1-hch@lst.de>
References: <20260610050642.1906695-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=956; i=brauner@kernel.org; h=from:subject:message-id; bh=9bty3HZuoVMZ5u5b/x+NaOuDsNbcsnhZK+zS6GDNjAQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRpCpq+yF5Um/xh9d6YeIadjydO2bNhCl91zPWzbgZP3 WdKumtf6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIuhsjw8H1fRFcF4JO59mw n/h2utvIUVhxzzPpb5cFPi8UFYplPsDw3+3HLe/V94N6ArUnc7jx5YVePqZbue+Q3ZSNH3l7kx9 /4QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 10 Jun 2026 07:06:42 +0200, Christoph Hellwig wrote:
> len is size of the (larger) write request, plen is the range for which
> the read failed here.

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[1/1] iomap: pass the correct len to fserror_report_io in __iomap_write_begin
      https://git.kernel.org/vfs/vfs/c/de654d66ff30
