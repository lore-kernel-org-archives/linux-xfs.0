Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A013A6F16
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297762; cv=none; b=ry3VCbCFhsHe10HPwAPmsBh17Eubi9gfW/E3IFLMjF5nkjtpUpwlbw6iiM8COz6h5bgWnAxlFeY38NNIGAoFBms2zsf46v7Yg+sNLv7zr6QRdHBKIqvNK/d1bUtpeLM2sIr1EIolVAFSQB+6az/pkHKFsTxuMa0rMA6pzGIsYTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297762; c=relaxed/simple;
	bh=pzKaYsG2ohsLxrQuILA44UI3AlWdISsy6HMki1Uk5hI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uQWucMplqhHBFqnwj2oY8Eg+Lc3N3TRIWkbqhiojWlnN2mFsvpE9BsywuDReDP67PJzTc5DwTKhH47Dw2StC9WXVzsGSrRSDEEWp0h134qhTKAsMChwjd7hYR4ZIuzSiaBB1VVPZycQ1yMoN7WRjiXjcMAvw/0ZiFjgmHsxtBio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNPh7Wlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNPh7Wlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8081F000E9;
	Fri, 21 Aug 2026 07:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297755;
	bh=8ZO28O7cR2KX+vBRHYiDuSaDDl2G02UPG5CTdTzLSL4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UNPh7WljDsyyzmVlmwfcNHqEIa9TOKn0FZmA41skIcTnRLpgmdDEtiovbmLKlDoxv
	 Pv/3Mqva3frWsyVMITwRMOtrnc/hqOsTV2pRSXuoN3BAFawxggDBNrqrekV+b0AiNP
	 LClqiAAnhzn+WGYTfc53OokDw08K4BhTm1S1qWRjkQoC/jIwBER6dZ8rZ9aE17lejm
	 sFHDRroZsGSjCgxurjnH07HOSrMIvNYZR1TSVVMuTR3F0nfHu1Muul0V7U6EJ0WYNa
	 fsHgsK3WcjgTMZTVYy7vpGGHRrsEKxBU1AGs6Sp+KpRjiv3az7YHJeXBXfGRK4Fw3Q
	 DhCiJr/URmN2g==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
 Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260811164912.124416-1-hch@lst.de>
References: <20260811164912.124416-1-hch@lst.de>
Subject: Re: zoned xfs updates v2
Message-Id: <178729775316.580975.7136587435464618149.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 11 Aug 2026 10:48:36 -0600, Christoph Hellwig wrote:
> this series as a bunch of zones fixes, and a trivial code movement to
> move the ioend code into it's own file.
> 
> Andrey just sent a basically identical version of the third patch, but
> I'm including here as this is the series I tested.  Feel free to take his
> version and take my indendent reimplementation as a reviewed-by.
> 
> [...]

Applied to for-next, thanks!

[1/5] xfs: handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones
      commit: ae285611891f8d1a691771d14ecb5c9de3319abf
[2/5] xfs: fix racy open zone caching
      commit: 2d829cc76777a5335269768d7caa750e102f74d2
[3/5] xfs: fix zoned write iomap flags assignments
      commit: 4bc67fc800edcaae8a657e4d2fba12e64e856b9f
[4/5] xfs: factor out a xfs_iomap_set_anon_write helper
      commit: 0510346e8e308d2e2cb057ea7b408758b5d6f6cd
[5/5] xfs: split ioend handling into a separate source file
      commit: 6b855256eb9e652caf8b14eb1f69b6eb00a9d9d1

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

