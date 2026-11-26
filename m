Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700973;
	b=RJ15lLPZnitoSDlNEgtz3iulXnua/GMYqXyd/+4kj9jFq92WiO524neSdQ2zCK3yxgrv
	 rxdf8QZiwRZddshgO+E9KXD3NTmcGr9M/njCVhEBCDB6+eTAdYTi8de1oBCQVPf8QBa9u
	 u9eP/aUDt9aJlmnt2bTSXyJ3ol+HMZGR7oIp1FCtE3yt1Mmm5H6y8gCVy0p1GwGAhfh7O
	 Wys2RbSp0sNhhqCIAYUR5OirsWTxl/ID3KU0aA9O6YbqCsR+GRaoRBWZAuRCZO3QDALBe
	 4osoW9Yq670pe2U2CUddHJhCwX1HTmgDBgHca22Zr6WrWI6C5fF1YWXnhJQpn7EM3Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700973;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=xQShEC1fLww4uNcdCFsVaAGvyRXHcxig8E9bz7w3rCI=;
	b=GXBuZth2R9p2jM+xA8gzvXXzR0JtDg3kM0i4pitQFZ3ScmNu9OfraXZTbAXfSODRAoi3
	 zR1munTuqsYRvcgl7SGtzQPlzI7TwCcJfB181bQGo7TjXxtoglqtxSAgO3aCk/QolkDTc
	 EqyFg40TKb4OrdNmhVwGFFbik0liCxNJqXuyWO9/M9kThe8y1d8UeAXmC7x2pss2JgEdX
	 N49N2hXyCk9myL8RD0hWMMce/XOddRATsYMUFHw0NOdRsdsZ0pXozO+//WFe1SUwhjXAk
	 8If1z84tfy3+6yFzi8GHmu8np5OuNaOvjyY4oR3uUqDQU+lWrv/V4XIW1B0P1vXcWlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Cwpm1/mw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B56C606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 13:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cwpm1/mw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CD41F000D4;
	Thu, 26 Nov 2026 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700973;
	bh=xQShEC1fLww4uNcdCFsVaAGvyRXHcxig8E9bz7w3rCI=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=Cwpm1/mwlB1lrLgAYPVl8ZMPT7txhPlR2uY/4X+3tWkferjUT99qmL1pSptVurXuu
	 R4SmI74SPnYH8QRXoYAnD5iL9eAx29SCCWuKA/OBAoevl7cqco+b1nnRpLT09zGR6q
	 m3TA/6JdzYfb1ZwJjsjpvpYRxO/OHgqxJbIato2Tjyc4ZINJSLX8kjUZHChvEsskCc
	 Lu5kJ85cMSRjnFBGMFObUZrwnaqI/DBehGa460fC0DWL4lFbF6n9kGOSqrZous0NK4
	 Txl9B9r/iJRSGMnSzMybhLQItyYs8823VBPzi7ERR/oZZir40ltpVvuBUvD3YEltfI
	 QvIdX5HNUiDaw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20261124213906.2130272-1-sandeen@redhat.com>
References: <20261124213906.2130272-1-sandeen@redhat.com>
Subject: Re: [PATCH] xfs: pass proper leaf argument from
 xfs_rtrefcountbt_broot_realloc()
Message-Id: <179570097202.157938.14335866978257668392.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:32 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 24 Nov 2026 15:39:06 -0600, Eric Sandeen wrote:
> xfs_rtrefcountbt_maxrecs() takes a third boolean "leaf" argument, but
> the caller in xfs_rtrefcountbt_broot_realloc() passes level directly,
> rather than "level == 0" as is done correctly in
> xfs_rtrefcountbt_get_minrecs and xfs_rtrefcountbt_get_maxrecs.
> 
> Fix that.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: pass proper leaf argument from xfs_rtrefcountbt_broot_realloc()
      commit: ba7d05f4078051e9b68a08c213eefae0edbc8a0a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

