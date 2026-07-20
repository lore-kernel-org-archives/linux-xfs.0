Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655DA3D0C18;
	Mon, 20 Jul 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537876; cv=none; b=UN5HqJXAKjaor2YM9HSvM7Q5aMgdWptzxxMhZ7Wznsb3u721NTtC6G07/tO1w9kU1Psc7ydMGZ4t0GHxeXcu5rKL+gI7MKs0XgAXEcD2EVmueIYx6+se5BFUn5fLOHwcOdPnQUBc4KKomQRWdspbbjaV67cPZDRTFofMz7+7icQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537876; c=relaxed/simple;
	bh=J3Pi/WAs63J/C4fLkp4Kbt9nitDaFpgaMh/KBOtp4WU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Jk2g2oGFKPI39FESIkNSbp1KVjvsj5+DXRLB2CKuwmwoFxEeWoBcPXAZ5gQnTT4XuHa+mNB+3qMYP2amGVLP1LGxnU0+Mzmpszsv+32EBlrnur5VB6EzkTbO8Xmq2ZUfN6FV3qIxkec8dAX7v6hkoVZRW8ScuP6/07FQ1NUZAiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0isusl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0isusl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248C31F000E9;
	Mon, 20 Jul 2026 08:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784537875;
	bh=XXClVuwV0sVcKwPu6DDEPupcFH0LWQfMW2L+BKPytXU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=c0isusl1KoCs3UaAUaTfSCTU2pxON4uJsjzaNzyj3EbFc4UfMb95OxDe7hBtN5btM
	 FAYFPqV/1E7pmUs2AaKo+fV6F8jMWL5dVguE+oEl6TqCyTdfiGpXHleeixh65VPFV1
	 Ak3nhj1t0fp7/k4gsoak4p17bxwzbtR4yELYoZZyyeldGBWImgjzx3t6PcAnjHg84i
	 MoTRStW4kkSEuusSqvAhl8KF74jqByFJQfju8WlP6UYb30VPuHL80IDwQSsbO025bf
	 JvN0wAEVHN4MR2WVp+sC2s7vBK4alBwlGCgUjr8Ul4nE7fbY03r8I2gogIQLeHOAqI
	 O+yIE4FRjpU6g==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 2
Message-Id: <178453787385.7428.13090168411944119051.b4-ty@b4>
Date: Mon, 20 Jul 2026 10:57:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 13 Jul 2026 23:04:02 -0700, Darrick J. Wong wrote:
> Here's a second batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: set xfarray killable sort correctly
      commit: 540ddc626245f12f56326ee0c1601f71ebb41d64
[2/6] xfs: fix off-by-one error when calling xchk_xref_has_rt_owner
      commit: 5d72a68f2007ba2a968d6bf47dba3f4620bd182e
[3/6] xfs: handle non-inode owners for rtrmap record checking
      commit: 353a5900bc85234e7df05caac37698042dc26348
[4/6] xfs: fully check the parent handle when it points to the rootdir
      commit: ba150ce63453ccd74bae1404c1dfedbd01ecfd55
[5/6] xfs: clamp timestamp nanoseconds correctly
      commit: 15e38a9366b31d3d61081ead115f1dff59379e24
[6/6] xfs: don't zap bmbt forks if they are MAXLEVELS tall
      commit: 59c462b0f5cfa107794228051724b34ae9334168

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

