Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FB4963A4
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817650; cv=none; b=XEL74ubJMgew2ckcPX/b9wIZgry7MEzgekYXVDhtb+u2oOLpVibg6IEVPV3ilcw7fBGNncj9/rhXmKYew9BBLXq57JHnRtK1uF5l5OsrJLcPOjoZxo11R6KzhI+5+YlxmzqrAU857nqcb6JlqmSIY8b1mTOi1sENtw4YLmibkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817650; c=relaxed/simple;
	bh=l9puN6Ns0fIV3T10t4BK1Loo2r6rRgn/WsaABKj0eK0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S9irmNV1j/Jxk3uU6iDzt1VPU6TCngrQNAeOLO2ER5Y6jWDvF5t5YgVjAsk6Nv0cWDZGX27Aq2JRmZcWXvS7nf/t8k8wpRubw4Bn+f6yVqXQf02J+0M1Zv2S+1ap4O4XEuCB9yrMn5ARasN+42hQ8gK4tEV8mW9dJ30MKRcFZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uz2NriE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uz2NriE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80211F0089C;
	Mon, 12 Oct 2026 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817648;
	bh=KMkdBfz0ACy3fUAs0eJwfEVVSrz1vCnWjTtwBIjc07E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Uz2NriE0h3Mfe79gc3/FNuw4kjh2duGcP8KD00yhCekdyw8qhb+2kKK3kjyU26hpG
	 CUSiZW/Qpi8sl8n5/qT91jVgfExLg42WQ79tdaYoArA6xKxTHeOj2h+oQLJugVmNz9
	 cOSMutja2goxNkqxcwIOuLdxEnYNM02eCQrI3CF8R1B4qx1jQbaDmKcKONqe6JpKmT
	 Kkmm/PdFLms68Xu9Lz1UmW6QAg9F1GLmv2DXN+X8xjlmOVLWaj+/lHBptYpSFa0L1S
	 RfB5otwOKglj1gC6x2ovP6seOMW2PFGI9QhmguQL0rUQ8GCWibSn9JOxlw1duGKe5l
	 HWLVKoJ+JEQ6A==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Norbert Szetei <norbert@doyensec.com>, linux-xfs@vger.kernel.org, 
 Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20261007170227.GH2705364@frogsfrogsfrogs>
References: <20261007170227.GH2705364@frogsfrogsfrogs>
Subject: Re: [PATCH v2] xfs: fix exchange-range-to-eof file size exchange
Message-Id: <179181764758.486116.2698634126339376411.b4-ty@kernel.org>
Date: Mon, 12 Oct 2026 17:07:27 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 07 Oct 2026 10:02:27 -0700, Darrick J. Wong wrote:
> Norbert Szetei posted a patch containing an incomplete description of a
> bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
> exchange-range into modifying a file so that it has shared blocks
> starting beyond EOF, which is never allowed because files never have
> written data beyond EOF, and you can only share written data blocks.
> This is key to all the incorrect behavior that follows.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix exchange-range-to-eof file size exchange
      commit: 0be6da616ab5031ea6419dc4fe0bf0e378fb6757

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

