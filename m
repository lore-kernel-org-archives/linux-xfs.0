Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C47E38910D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763385; cv=none; b=jG8QCyXrNqrGqACOUlfwzLE0NFeop2fhsF/HEQrWlw635gQK84Z+XIVSNvuCkDcZ0TG/+aCQTD8bmTVrdJ2IGKz/Xfp16LadMIH/cosESg6Y0VQtUmp8bcGT+3R2OTLLZK6FJGmNm7ZOnZwriVW3eIQsB9xl4aeO9MPFzt/lXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763385; c=relaxed/simple;
	bh=egZLjoetmB9nGAE5zeKq/Z+dUXk4UHzrkDAc7GzMH34=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tDlXMyeB56MFULRcw+ie2ZCIqhC8TmGBpjezoDdwbUUOqTSXJAx70w07Nca2c5heC7GzpVUzIPRg7pc1WaFI4BjW/1gnnXziZaGrKQSXwXNxIWs/sNJ/GF4VTi8RqiXel4uBz1NMTfMQKUw3Xp0hmWt+/bAnri39TETgiPnB3UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fh4xc8RM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fh4xc8RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A161F00AC4;
	Mon,  3 Aug 2026 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763379;
	bh=J7rCiIQtM+XfCPE3MmcnOUJt2YpElPLAr/AAhZ5G6cA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Fh4xc8RMvzuBAUkKma2wcYP89YVAGv4DLp6xy6fmp90kInln/gakS/0/38fzgHPQi
	 5/YDPIosgy6Nu5GpqHh94aoMmpnw4F2umFBYcj5zyT2dm6d8WkBDjJvqAvKz3WQixK
	 884tcvQocNcArFLoi0ziq3wpuB5EApb1QhgkPYjlb/2GVtGCO8ynuq7IQLTmvmCYQu
	 Ux6qd4VTD6uJAmvu0oUjZW3R5rTXo0oEAPGvv1TycdhFPrb9UJw3sjsc/MOtQcP+Hl
	 MemPK27wIXyRQJaqZawMbPftTdXMu+DJSd+jykE1k+P84K7RAuZ/d+3fZvn2EW9Go3
	 Gd7i8IHBCJyCg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20260729130256.2282092-1-hch@lst.de>
References: <20260729130256.2282092-1-hch@lst.de>
Subject: Re: zoned GC fix v2
Message-Id: <178576337809.315832.14285856868357891346.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:58 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 29 Jul 2026 15:02:47 +0200, Christoph Hellwig wrote:
> this series fixes a potential deadlock in the zoned GC code, and
> also adds a comment in the same area while looking at it.
> 
> Changes since v1:
>  - improve a commit log
>  - improve a code commit
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: add a separate bio_set for spliting GC writes
      commit: 63de19199342e2598373cbb99186fa93e9116603
[2/2] xfs: add a comment to describe xfs_gc_bio.victim_rtg
      commit: ec6978e6bf68fb6f51edd4f700f9a554dc0da894

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

