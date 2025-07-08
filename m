Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F032DAFD6;
	Tue,  8 Jul 2025 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751976025; cv=none; b=Vw7Muq/+dvcsW9kX95Ax++MdwZaRadxpU0+oCJtNn/yYCP2+uQGO+ReeeGpAqCTMw6s2aosU5DjlAVDYbubVhywuwm8rsh4JnIzLmw3v244ZUKhH1SsQjbdX1MHV6YPU2dmRVV1ebdiChXle6Zd4/+gRLe1Bp+DidtaOYCTy9Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751976025; c=relaxed/simple;
	bh=JhQaAXFww5cgFc3ThL7I+C4YjjUeRx7F4hDjE8VLpT0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=crNkxVGONLXBujNWDXGM+XUagjgaOUx+1KLMc1iFXEdV57E1NBN2JaxliWbh97juEUn4QPuXzEU9lNQUUUfRFl68HIGN6h1qdwpPGT/lYlOlTC+4zXWAVW94XnQ4wYH6l69uFmfvOGZh1gw8fneqmnkIEiAh9ZCq61WiMW/j2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUL7Tiod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUL7Tiod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F2EC4CEF6;
	Tue,  8 Jul 2025 12:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751976024;
	bh=JhQaAXFww5cgFc3ThL7I+C4YjjUeRx7F4hDjE8VLpT0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=LUL7TiodYJkz2bXI8+H5HNzS2OoQ2oIm30ti3T+msmif1Je6salTFWDI7h1fSP65c
	 JYLyrJrhDthauuBgleSVvD5pjQ+ATLcbM/MRywb8WhXOp8WnXmQvz/l+iF7HP8eKLu
	 WcgBU1qVvLG6IwEjGQ2POj4HZMzTZUF7puh+B6zMOauktLbQ+n/b7owBAp7brahprk
	 hDWvfPOoW/k2glFvtKPvD3JvB1VJweAQGXoh3MAEym2jIGAJ42sCkGaMaWhMIW5AHE
	 nTuE0T7J+4W8E9Y2akz2NEexvGGwPUMO2HtSP/MW3l9KG2lkIqp9g7VgtIPB8ikYdo
	 HEeDXY+d4mFbQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, 
 Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
In-Reply-To: <20250702093935.123798-1-pchelkin@ispras.ru>
References: <20250702093935.123798-1-pchelkin@ispras.ru>
Subject: Re: [PATCH v2 0/6] xfs: cleanup key comparing routines
Message-Id: <175197602309.1155040.9466707632114261976.b4-ty@kernel.org>
Date: Tue, 08 Jul 2025 14:00:23 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 02 Jul 2025 12:39:27 +0300, Fedor Pchelkin wrote:
> Key comparing routines are currently opencoded with extra casts and
> subtractions which is error prone and can be replaced with a neat
> cmp_int() helper which is now in a generic header file.
> 
> Started from:
> https://lore.kernel.org/linux-xfs/20250426134232.128864-1-pchelkin@ispras.ru/T/#u
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: rename diff_two_keys routines
      commit: c4c6aee6ba87fdfbaeed1966f81298e3f3913f3c
[2/6] xfs: rename key_diff routines
      commit: fb7eff8c9f1b7ac46b8e376f9da19d8996cd0262
[3/6] xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
      commit: ff48e83c9dcd8c4f6b92b7d695ebe599c0a0e57d
[4/6] xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
      commit: 786b3b2e16600a642ddf15bcaf94694cfc6b3250
[5/6] xfs: use a proper variable name and type for storing a comparison result
      commit: a0b2b28e1cc1c3c95bd889eec455bf8e68def61d
[6/6] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()
      commit: 10e4f0aebdadc94930e82ac13ef1e01abb0bda03

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

