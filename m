Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F034CE67B
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 18:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223603; cv=none; b=THsOS84jgGnkjIvi2Oa6KPj1GwhEsRhFlllrL4m7b5byI8YsIBeLuA2zqvpFlOIY3R4r0ljbIcRJyIGO5iVwvBrC9FrjqPFczv5htsm1YJWId1r9g3x1/WoMl8YatRqsma3l8P83THpfE3xyaeA2anPISYFOaneiKKP7k/uV4d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223603; c=relaxed/simple;
	bh=SVvcOEQImRPtW3QGHKh9vBFOCVtxFRhBRWPUdGJWUTw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p2AnlHa33/MuZJMWNVoog5M74fD4hZ6iC3INb+IgR09oL1zFHe+hAV8/kswdj3oFtYBPjY8n+EPYawcwpS4KlTgEb/QiEa1U4IlHAou4E7mVXzNnoMj5C1j3iiRgzeALmmpmiG4i1BSLDFQa2J1yCmMCiMZxRf0gt/4WVfCh7mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euUhsDAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euUhsDAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A65B1F00893;
	Mon,  5 Oct 2026 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223601;
	bh=lLngGVRPZAUsZJkxPQ5Tsku5aiRh4b4mhny/WFvY9MY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=euUhsDALpJ0QVjxhMe5wSvGqVOJMogJSC0B6XijrDD0VOrIyRDtSessxKwWK9hNzV
	 AYJ/RNKB8jKwPTc6Y6sH2ejvGsItA4m8nVQd15/RBtEu6StuxYrbBD14/udkH5IJqP
	 Abw/praoMwF+fjQ12JUZqXk6Rg0zDTiBxPAutf7etg7mxjaru4k8f3VyQAPgLEZJh0
	 aA1Hm9yG5D9WcUoByqkRXoqidTL+EFbVKldfdBqPEPfkHv08wHt12Fx6Rv0Kij4bVM
	 9bXeIxWICTl2aJWJT5n2AglmCR30dWPnOhJkyA5VRIwJ+2oUOK5qJUAPNcTYlWE1xh
	 PcEiy8e1RgBIQ==
From: Carlos Maiolino <cem@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org, 
 sandeen@sandeen.net
In-Reply-To: <20260924151638.38535-1-cem@kernel.org>
References: <20260924151638.38535-1-cem@kernel.org>
Subject: Re: [PATCH v4 0/3] Enable xfs error reporting to print out error
 codes
Message-Id: <179122360012.102066.14164626257915601915.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 24 Sep 2026 17:16:27 +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This is the new version of the error code printing series.
> 
> The only modification here is on patch 2 which replaces the macros by
> an inline function suggested by hch.
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: add xfs_error_report the ability to display an error code
      commit: b3837dc0c73143f86549c3808e0323a47fe739ad
[2/3] xfs: introduce xfs_trans_cancel_error()
      commit: f4922f6fb12b18ff1efe7cf5a46c187a07b7f9ea
[3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
      commit: 90c4dd2fa8fc3485551023e855c093bd9b675256

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

