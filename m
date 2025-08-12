Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788541FBE87
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984009; cv=none; b=VvA6BK49+SVAwZRoxC5FYk5+kz6l29qfKsEMKeMz1AVaDQpxobglqzThrz8x1ojPYs4XO9YFsa5TcvoLCgFH/ftNvLvvMgMPEi6lJg3yFovNZhjb76+VUotzXbHM4CkyfxjNGAmqasbKKVLE6NL3k7sFQDNvtD42Kyr0Nq5HAz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984009; c=relaxed/simple;
	bh=L4tws+aMYe5ZoxGopsjIazjBbanIp4toRIyrxbtE+Rg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Rese9RSmLYkZhIyScJMY+XpqacVluc0cq9JNsnjWnyFXj0xFsoTst5chRdtP12eWiRY3GQCsre2URPj8KUv59oSsKQHq8OHaS0bK5GKMgHtdSblkFY1aBqcu+gVsBrclJY5CsnUMf3I38SHqqpUg2da3Lx4ezsWnfz1ixEFs9kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUgmsGJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUgmsGJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770BCC4CEF1;
	Tue, 12 Aug 2025 07:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754984009;
	bh=L4tws+aMYe5ZoxGopsjIazjBbanIp4toRIyrxbtE+Rg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=RUgmsGJC1zw+DARvcgdlDgpQbevCS2brPH+r1AvGwHMuzrI/C5n8vUqqfoO4qAJ6m
	 HsrWHSLT3EJ0SOJ52uhWTL2yKsL3Sv9MfpI3INI+g5qYjaSmPqjBzvqBhKZ7Ydu7Gv
	 QRzRrEVk/Sx1ktDnF6eqU/VeIu0mgSKhssAjni+nJY2XwY0nQ6UbSs5praUGQ3eAF3
	 rwlPYsQ6XMAzWN2vXSRHi3ZenLkeSnApidWyZ15//Vdw2CU2jlfWtCEet2VoZbZiNL
	 /38DQs1rStci6lXQ5Hqj9Z80NFurqwEaF/TrbGYHtsC8EkJiLU0PYKBXUtl14XU0MX
	 0kg9kH6ZcfSAg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250723053544.3069555-1-hch@lst.de>
References: <20250723053544.3069555-1-hch@lst.de>
Subject: Re: [PATCH] xfs: split xfs_zone_record_blocks
Message-Id: <175498400817.824422.2096415196645532496.b4-ty@kernel.org>
Date: Tue, 12 Aug 2025 09:33:28 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 23 Jul 2025 07:35:44 +0200, Christoph Hellwig wrote:
> xfs_zone_record_blocks not only records successfully written blocks that
> now back file data, but is also used for blocks speculatively written by
> garbage collection that were never linked to an inode and instantly
> become invalid.
> 
> Split the latter functionality out to be easier to understand.  This also
> make it clear that we don't need to attach the rmap inode to a
> transaction for the skipped blocks case as we never dirty any peristent
> data structure.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: split xfs_zone_record_blocks
      commit: f76823e3b284aae30797fded988a807eab2da246

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

