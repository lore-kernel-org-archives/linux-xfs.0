Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792EE220696;
	Tue, 11 Mar 2025 12:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741695255; cv=none; b=CZzlmVO4hLD9XT84LN2V5rAqmCLKYw6y4VehzWtRYrMyoXo5w0xb8shPQvS7b5SFZRBJNbyi76PYs0mxImjLHY4UksfLJf34hPUGHBw0vEECkv0RZ06B4Rs5afumgGd+M1vnDn2V5Ie2Z5kqoQxTfJkQAtu70gF6CTSCduRj9xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741695255; c=relaxed/simple;
	bh=a++24uUTLK2PNwQPMpIurTxfLZzgbMtDFEnAaQ0CYHE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XVQnkRRzby0xpJNgnoUfVd3CFK/br05kcCSpWVD3V2Sn/4D04SjwYtiTiSPaItS8OnTsUMlsZoxDGPbrcsxTwvLFO436/tAwIXBAVLDWY8jwHx8GF/uf+sx56y3HkTLQeSab5D03B+r2AYfV8ATMRewFy7kjpO3Nv0EgXnjWfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8dKUupL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8dKUupL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4555C4CEE9;
	Tue, 11 Mar 2025 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741695255;
	bh=a++24uUTLK2PNwQPMpIurTxfLZzgbMtDFEnAaQ0CYHE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=H8dKUupLYF06v0dv5Z2ZDGf/zQeIAAM3xcOH5Y60vjIJiiDRO7l26C+0FmPsAMTxU
	 FkW+SOZrdh0GEIhVUIpFMyhpz8qfCmX6wFVrtKNqfLosgY/6k653HZZ0gcWNXRBPln
	 1LRHXIQDj94eaQxuBAvqMhLHhnIcj3/Jex5shgyjOefXA1VhgETjvI4jxHDwIXCa/Y
	 kpQ/qcvqp2oTiFtt1g9w3X0kXyO9r2N2TnE5ueCWN7pukpPEkgzW6+icXBQeNqwEFt
	 WC9/2kt+aC81viBAS6BfMrcteU40odGiypJajlgxizmZ378cTtPK91mZDf5cXU9Bs4
	 WRxnuLD0veCIw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250310133848.9856-1-hans.holmberg@wdc.com>
References: <20250310133848.9856-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: trigger zone GC when out of available rt blocks
Message-Id: <174169525343.243032.18168782700221523251.b4-ty@kernel.org>
Date: Tue, 11 Mar 2025 13:14:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 10 Mar 2025 13:39:59 +0000, Hans Holmberg wrote:
> We periodically check the available rt blocks when filling up zones
> and start GC if needed, but we may run completely out in between
> filling zones, so start GC(unless already running) if we can't reserve
> writable space.
> 
> This should only happen as a corner case in setups with very few
> backing zones.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: trigger zone GC when out of available rt blocks
      commit: b7bc85480b03765a7993262f2c333628c36fbc45

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

