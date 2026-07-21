Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28641480973;
	Tue, 21 Jul 2026 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630714; cv=none; b=MiM9xnq+IGSHHdRFjJq37bm2/vN4AIG84Op2aedAWl430upTwdFDZPoJM4EtUk8czZlvxvPUUDmmHSWPDbIru4zbvFbZDnbfSab2UenI7aXp5KSZSur8di5YAj7B97zV3hiM3D8sDQX+nbNONzUUzizNxwxV1KX6jJ0R4zO+QZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630714; c=relaxed/simple;
	bh=TCzI1K0kG3ZszcQlzQPF9rx7YSbK7w6q8owxkwh+pzE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p7sA6tC4alOFnyrPw0DVo64OokoeKvMtKGWruLgsypAcMx4px2XGvgu5Y6qrlMqCuBUL7E1StyY8J1UtMD5ZX3mIFqZAxLHQqbd6PKT19OStoNNSiSP+UjiqNgOHFWh6PaxxXOGPy/uxRc0zQWTtsECc9i0cTYb8RJEfwRrEgi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma2maXlg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma2maXlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83AE1F01562;
	Tue, 21 Jul 2026 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630698;
	bh=MVzQnfqLE/nstQnHQJfaI7cv9yLHMUmBRVo3BThwY6E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ma2maXlgPSeQSq2isZ++vNbZnC0MQv1HzR8gYOY4Y2XgPTPbcXChLFIW2ayYHYTD1
	 zPjxhggVBTnWKnFRA99D0cn7lD5BnSL+HzchAAVZyssOXgm4q2lveyaEmoVX9h816r
	 xbwqAiEHUF0fsbbxbfzmUCGnZ2BDI59vbAlo+CzxTgoXqu7fGGg+sQ+KCeQ5tRqUUm
	 C48RPDA8BoIeXu5s7tdHRBX+RQ5yjEgTXXAoHY+0+DndaiHt8YFF3Sj+qP+4y+x5qU
	 UnceyfoBe9/wgiz50tdqj3IVLa/sDHQfQdsy/CpTNaybJ+Giw2AAEsfiFFSoFL4DjJ
	 ZVGicdMKi8+aw==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
References: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 3
Message-Id: <178463069758.324722.3523337122830710867.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 20 Jul 2026 20:23:35 -0700, Darrick J. Wong wrote:
> Here's a third batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> v2: apply rvb tags, split out unlinked inode list repair fixes
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: check cowextsize in xrep_inode_cowextsize
      commit: a75913d5543709c8f4a76435a7a629335f166b1e
[2/5] xfs: fix transaction block reservation in xrep_rtbitmap
      commit: 442b827ea7d3646c5a395d5282f00f67229f2061
[3/5] xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
      commit: b6d9247dd5f092169e731afb8375cc14f921991c
[4/5] xfs: zero i_nlink before repair puts inode on unlinked list
      commit: 266088be85e78d0d9ab3429d0bd0364858001a9c
[5/5] xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems
      commit: 7b2a43bb08b789905716504d50700a0bedba0b35

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

