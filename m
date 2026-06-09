Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289BD3D3CEF
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989971; cv=none; b=XiXrasbGCMyNv7gtYHT6vEPX024U3f60BxO71VVzvn9bxq56QH3H8pCHm2aFvWJpDzhlRFD1h6b0bSDPcm8y2aYGUmHJgmI1Oq444IwLkux7v+mbjo0tx6wEcvmslL810XUubEQK3VwBEs/19YfjAi2/8vwAiIOKdBuqCypBxZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989971; c=relaxed/simple;
	bh=J/50xDOWZX8tD8FFM++yzqib/vhdFT1El/L8X/M9VQ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=i1bTXp5QeQHJJelqRumo3l1KSah+ae38lbJZdPjpWMH7jP59m0CCeQ+ZzKhezTGihTf5dBWekHN8nUzQsDhO+Pl441NKFc1+iG5+qzcB8NG7HK2L5yfUbX5oyph4e90knwAokzmR21V4MhNDaeda3M12gwaH15A1eOdi10j2JB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1aRp8Ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1aRp8Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2891F00899;
	Tue,  9 Jun 2026 07:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780989969;
	bh=MlKSxip4JWZrzb26/uhEXmxGyVjp0QJJdKSPDU+nWjI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=T1aRp8AiA6Fl/1TJ3Rfk6Srhelt2l7nQ2XgTM6odn0HUeTAW8wMJ7FLPWd3T94Fe5
	 P0BOdFmsdaIsK4XyCYr+3l36K5C4hAw60l8TiDA72Zb9tKcjDHFNzF0Lr0KsnBCZFY
	 JedOspdH9YkCF3RDE15/maUgK6HzCFEialqUyzCdIsydrfp35Ul4RSC4ibU2sukWOj
	 qBTNggjlOoVc+NWx+2mAlpTWSpvJuhXMiinDbp2LyDhYXBTRS16P7THMPTB3yudHFE
	 45AeLGC2Oar7xeWBqo+obuea5fpY54+ESOSbTFWhnNPVj3UX7DvBL9mrFnqbm8LqVw
	 J6H9sgYsXBUUA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260529054404.2720366-1-hch@lst.de>
References: <20260529054404.2720366-1-hch@lst.de>
Subject: Re: [PATCH] xfs: remove the call to xfs_buf_reverify in
 xfs_trans_read_buf_map
Message-Id: <178098996887.72840.16214173977072847656.b4-ty@b4>
Date: Tue, 09 Jun 2026 09:26:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Fri, 29 May 2026 07:43:58 +0200, Christoph Hellwig wrote:
> xfs_trans_read_buf_map asserts bp->b_ops is non-NULL just before
> calling xfs_buf_reverify which is a no-op if bp->b_ops is set, making the
> call dead code ever since it as added in commit 1aff5696f3e0 ("xfs: always
> assign buffer verifiers when one is provided").
> 
> Remove the useless call, mark xfs_buf_reverify static and clean up the
> branch dealing with a buffer attached to the transaction in a bit by
> deduplicating and keeping together the asserts and removing the bip
> variable only used once outside of asserts and tracing.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove the call to xfs_buf_reverify in xfs_trans_read_buf_map
      commit: f8e9350fff08217591eaab01551a7a253fbb1fc0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

