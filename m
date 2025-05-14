Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15446B8
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243837; cv=none; b=C2Q57u1RQotvN6BGmpXTwCLjvHBl31bB+B/yYAWD8pMv2XZG8QxHHGjtiWefCEzcQWreZDXKudqO9jMjX+txuf85IA61G1hrb/avcrCTb/DJ6jNA4kJDcYs0rO+nvHB4YF322m483UBXfggsCK/1VZAWiT+MLRh1C1gbUHEHOqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243837; c=relaxed/simple;
	bh=8XRmprQTZ4MJ9VfFm8u6juPVuM8Yj3ZiNdpnUPXs8HI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kXUvOaQZHqi5l7XJPV4/O8NDc2MFQbo4EyYG+QiuaYFNf7zEuJ4g5ZwaWy8hxPnqXg2GYoyb51F6QF0easa1U3tvw2seROEODUI9q01pzq5rj98bX2Z+C0f/DILz7kSB86R+ADneK9cFfI29jNZsE1+hz7c1mEydWtN3c8c08dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsqtZqqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsqtZqqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C467C4CEE9;
	Wed, 14 May 2025 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747243837;
	bh=8XRmprQTZ4MJ9VfFm8u6juPVuM8Yj3ZiNdpnUPXs8HI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=bsqtZqqPOHYSANYxWjYu49QqhXvbmcT7Sfb8nZ17dtlm4RsUqh3q/DtmTPbQ44X/m
	 KTZa9J44QfbrimDP+0Anj44lOiFr2Izm98b2KE5Xzos5KGzvSXlf1Bn3ZtxVA+1ebu
	 2q7PoMp7F4VS2Ta92t4SsurORZAlxmR1LGlm+gyR2QHaQqDN8OL9kWFRHDWC6yiPCE
	 yik2pHP65y8E+o+xjFK1btcRXbqz2dDfsqtoooZyKsCXj68syrc3jldSr/nLU4cXF/
	 +8TG7X90imlxibq4E9xFAjl8LJw/BgF9SuyzkhFYVFLe9bKsBbqsDzZSa9pbfnoNwY
	 04pw01v4DR1QQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20250514044450.1023153-1-hch@lst.de>
References: <20250514044450.1023153-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: remove the EXPERIMENTAL warning for pNFS
Message-Id: <174724383601.752716.6578207452474738301.b4-ty@kernel.org>
Date: Wed, 14 May 2025 19:30:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 14 May 2025 06:44:20 +0200, Christoph Hellwig wrote:
> The pNFS layout support has been around for 10 years without major
> issues, drop the EXPERIMENTAL warning.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove the EXPERIMENTAL warning for pNFS
      commit: 1c7161ef0164716fdf4618b50747bd3002625e38

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

