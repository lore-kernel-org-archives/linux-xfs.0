Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992340;
	b=kd60rPRStmbGyz5uoh7kkKo+7vj3ji5kWU6Ng5tW6m3P6IsvV8g9GwgEUSpFLXaOAxgL
	 51nvgpwR+/KtH4F9KKKrr+UUVw2RnMyka/t+ai5Tb6FnEmzBUYsi9u0JH3OUs7irecRfc
	 pBGafTnQTn+DybvlpY7em2O3QI31Nlf+L1K5SBfLX/GpN42ISrgPk0j0JDDNtQSVa26jK
	 nDdShBDeox8ao88nXCV2OCl/llU44EkzxuB9Z77VqW0GKH7i7t/norRMZ3bA0KyzHTqay
	 iWB/8bfaRRPvWCHMerX3cpsp6f3wj+qPTqoXhYm4e+bIHzPu7P/lR5VHFPBG8Fs8CFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992340;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=6SU7Ri3CWXnoDNX+3IBxcJRBsBSxmdHWqrHuMtV5VgI=;
	b=eMGYqoDYIm8w7DGt01N5w9VY/+gXDAzMGBqR18LPXNFRa2+6gsSR2BX0d7V5gxXKuE2N
	 2j1qa+ySwgEChEp6zTziQGKUQldgD5MxRWaVP40Qy+ScQgvwhRGQQa0hbT0lDpAtQETvI
	 SVeFyXWUzmI17YyO1VGjnHXAODy302nyt7SvaE9WihIDuyuu5GBjbZbcrOb/Dcj2We2QN
	 M/0/7NX83TGOruuEuMXw/Rj5KKRQVTLWDezd5aA0mQAM87He0Lju41rJ1HRTjoxPhl9if
	 8BgkoyRQyuZJSjsNvUR+1SIopR2nrf9QjuuwBMC7Zume4w63B4LGTgPk09Xzhv8UBlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xk2BKZ3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A000606A8AB;
	Wed, 18 Nov 2026 08:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xk2BKZ3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583D01F000C4;
	Wed, 18 Nov 2026 08:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992340;
	bh=6SU7Ri3CWXnoDNX+3IBxcJRBsBSxmdHWqrHuMtV5VgI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Xk2BKZ3VJ/wWActT2df0EDQ0CvMGwc9HGOUR62ALBG7+hJeDgRMWePBQttcBwPOIy
	 5SwsKNSP21HMzpN+1JOTdBnDuHLrS9DkWLG3qcvOZhU7ddcz5wQuQ3ft7kEQRgOUgc
	 6htEOjLWiO0325eDEMYDOWOYP9X/N914d/uZRo0eOWf0+cQY8hB+cdb93brccT2X++
	 5nLMHCJuStI9X1oKLodXrBvc3WfY8fNCe/9V8q0s6IIPKayLBGnjxytDKndqHk0XOF
	 1BgoqE1aI1YvZIRrr9adZ0+7tzPhjg8Nt8TyJkCWJihe1AMZRF/KNyhPCGwk2nKSsc
	 WAU9Y4BpcxVYQ==
From: Carlos Maiolino <cem@kernel.org>
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261116020510.17329-1-wuyiqing@cmss.chinamobile.com>
References: <20261116020510.17329-1-wuyiqing@cmss.chinamobile.com>
Subject: Re: [PATCH] xfs: remove unused variable in xrep_tempfile_copyin()
Message-Id: <179499233906.5574.7966848291904639925.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:59 +0100
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

On Mon, 16 Nov 2026 10:05:10 +0800, Yiqing Wu wrote:
> The pos variable in xrep_tempfile_copyin() is initialized from the
> starting file offset and incremented on every iteration of the copy
> loop, but it is never used.  GCC flags this as a dead assignment when
> building with W=1:
> 
>   fs/xfs/scrub/tempfile.c:493:33: warning: variable pos set but not used [-Wunused-but-set-variable=]
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove unused variable in xrep_tempfile_copyin()
      commit: 5c7da17f904da61c6912ae719e8f3c3eb353ee88

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

