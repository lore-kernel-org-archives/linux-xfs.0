Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8C23B2D0A;
	Thu, 10 Sep 2026 09:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031468; cv=none; b=ty3s07wzxJrTh63RqAkoCIAn0n+zXeABnSm8gJyCoopgVOiLN+1DAe46ecIOo+7csKRVQIzdQlWQpcJXlK+KBHEbW74evutwrtcw9VpYG1bxfRVup9LG3uggMwfSkuLO0xt7r4R9NnS7Bw+KDBBVsqxUTXWuo1r8extT2FlWyUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031468; c=relaxed/simple;
	bh=yEihuGsnkd2cF3UCDqKSmNm0LuQORMEXdtn4bI2D2ko=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZGTqxWviX4yBm5TyRW7UhHgam2HvpOsWUQZPGQOZUxFTr7YKhyopo7/M6fcgohdvtcFK8CP0wL3LiGjL5JKM4i+ZFtOD4YNQBEsehruMkEwshCDRsJb96t5LkDEtCYFcj7zGyHXScz6hvEV/TtFJw4BA7rdkghCvzrdT3oR+GxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWTDKg9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWTDKg9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087B81F000FF;
	Thu, 10 Sep 2026 09:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031466;
	bh=Om4/4wR8XiQjZcEzDJnBdGiKR/o/I1znT/NJPyH2Jjk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gWTDKg9X/cm30tobADEboBgNBq9atliYdzxNufW99ttbFVfvZX5HRK4kfenGC+olO
	 lGllgFhtzDnGHpb+flS/rGbNscE8Z4CVwYM4k7bmlIWn618viVEvB8P3TrS/HGlOon
	 YUVCvaQcuZlQpyPX6tajBDBnQIJRuaw1HiMRXYqq1rpsv7+zQSwrVo370LVxb09BFy
	 ETjFlS54I8wcMzcTZTm5Tws2UKm1akeZsIsU6xyJtfBy10UG4aRk3gtPe+xjyqO6xG
	 XSxVki9y6dOJdT+ej/5CtJsLBpvZbxp1WnWPh4N1Lw7sd9US5Ju287TJSTNfINp65Y
	 E9GtUaW0lu34Q==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET 1/2] xfs: LLM-inspired bug fixes, part 11
Message-Id: <178903146473.432315.7198169961397970973.b4-ty@kernel.org>
Date: Thu, 10 Sep 2026 11:11:04 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 08 Sep 2026 23:02:51 -0700, Darrick J. Wong wrote:
> Here's an eleventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
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

[1/6] xfs: snapshot scrub stats when rendering them
      commit: 2c67526f55f3f5de10e22172a51ed18022abc1f3
[2/6] xfs: report healthy filesystem events in scrub stats
      commit: c7de6c2cefd2c3e26dac23a2549254029e4e789d
[3/6] xfs: report runtime failures in scrub
      commit: 45125e769b6ab95e2dc99bbe476f205ac934459d
[4/6] xfs: remove redundant function declaration
      commit: 08655d4168c8b53b5b6e1686cb07e7ec3f37ba56
[5/6] xfs: snapshot old AGFL before rewriting it
      commit: 036c497d345eed05ef6c1a5b0cd1d4b54574a095
[6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
      commit: 763490d70e9b6b26e551b91847814c959468a80c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

