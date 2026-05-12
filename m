Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B686F25B0AA
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778587739; cv=none; b=kdaw45aDGEtOr3V/RaeSiBGMpq9nqgUA+cZe4YbWHmFxb+UkHolArFU67rnuSxJaPONNrDHayEmKhxgFp8rZQrMyo9E4UAbcu37JdiMg4SSZ+hCLdL+gGqIiT3j5W6FddkGaX6uZbkZDqDFt2XkgSKBkUhWzMJcg6tUof72psnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778587739; c=relaxed/simple;
	bh=fl4feT7jxC3rokeH1eksxYMMgI/pDDycoI7bAgCRkSc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dv5zzXvOhUSfphoOWn5P8gD7fWSs97+iKLSDJLDaMCWvrOBBsorIL3RGrYu1NFZGv5woDxLrgxrah+xR4j3abA/nEAqNGFCJiYCpIa4OhY2bSEMxWimwkdKdCsrN+eGiSpz2rzUn3UB+B7us7Dms9BskWoOaaf+DCb6xenZrNW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mbznhGO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbznhGO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B164DC2BCB0;
	Tue, 12 May 2026 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778587739;
	bh=fl4feT7jxC3rokeH1eksxYMMgI/pDDycoI7bAgCRkSc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mbznhGO+WqbiS86bXcFxNdJJZQ2fyS/WuXx4D4qoXRgxUhEbHZ0VQcyX9/EdFN8U1
	 fUJi1tAihmoqujCFJf1Ck9mTlBg9Df0wvkZiU8dVJb3kvn6E6SoOnCDp4i6T88pqy3
	 Ee1czGKMlqS/UZnZeHJeNG4Dth9zjHUvUwAhj4PN3WUrTVFkv9Rn2qrkF2suMhtkr2
	 7ZYhTD++QpwmPpwjyj3c1U5Ww3Jy65OxLqZ86cOalXOXlM1SVNVGNNtR4UcD5dlr5n
	 P2ZTgDaKzsuYOzv6fDeA0EsTObKtMWHjSPgq01XZXOYROeGyWig3A53zjd6RyQ3oBE
	 EIxRl+Kbj5GhQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260507052457.1305016-1-hch@lst.de>
References: <20260507052457.1305016-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix the "limiting open zones" message
Message-Id: <177858773843.168431.8544120014339339853.b4-ty@kernel.org>
Date: Tue, 12 May 2026 14:08:58 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 07 May 2026 07:24:57 +0200, Christoph Hellwig wrote:
> The xfs logging macros include a newline, remove the \n, which adds an
> extra one.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix the "limiting open zones" message
      commit: 5082d8835070fe63f3c61fe574cbb5319bd94575

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

