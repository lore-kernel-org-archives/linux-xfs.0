Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504D72F32;
	Thu,  3 Jul 2025 07:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527630; cv=none; b=ByCaFJdD4XxKC4NyuHFA1MfZ1CE1hlpOldIh051yzywtxaiTxcsxtd0uoM/bysCeZuU4hwcv4JWj2FrI8fNk5Q+WJVSkKtzxQJpKZfzhlyXYuYPy4NKuIkDdlR0apU4ZPi4bebTDdDn3pdRg1yiKie67+RvgNKH2LSBc6tnfUlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527630; c=relaxed/simple;
	bh=2QE0N0n88oNy1PUUugyj+ObrKbmAuInRNuz9gBf0i7U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ewqt3x8PDJJ1YLgIx5vZ/hGbix2kmS71Qdvpj3nvwEJNJWQh3qvkAcDu7y0v5Vmbmbz8CNR1hW1Kp6cqYXvPPUDUsMALWEyBl/qK5jrGsw29coDZX4EC/2xw5xQn0hEtiQ/uPn04JPy87fUBeCKJyrn9Q29S5n2nORZhlI9MEbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exygd6mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exygd6mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA45C4CEEB;
	Thu,  3 Jul 2025 07:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751527630;
	bh=2QE0N0n88oNy1PUUugyj+ObrKbmAuInRNuz9gBf0i7U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=exygd6mbwvSjoPANsN1Ha9P5w5tzJJhdECfKrynfaBHzqY7xGmTaVh6BV0SmQyx6w
	 +LE7Uq4vhUplBO5jGWDcs4aKLr0mwAGxccVAIgmrYSEg2WlCA3II5JGKotFL0gKf6I
	 8RZWC14UDf0YdOwZn012Jud4CE/9yS9LkudrCAffg/XHJHaEwE+waQZZS+hXuePtfo
	 RW62z3mlKjktOR+Osaql7BeoIOwfRUIrU25Mzp0w29HEdGNcYKmxaf5VF/P3jbq0yl
	 W+cqJEWzFm6aH9EcIARKkXIes8gBqRHgK17SAvSZysAtJVoQvKzLT5IwNUOxK+9pUu
	 aL6rs9/IJ0skQ==
From: Carlos Maiolino <cem@kernel.org>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Youling Tang <tangyouling@kylinos.cn>, 
 Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20250630011148.6357-1-youling.tang@linux.dev>
References: <20250630011148.6357-1-youling.tang@linux.dev>
Subject: Re: [PATCH v2] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported
 flags mask
Message-Id: <175152762861.887599.12834824712927485671.b4-ty@kernel.org>
Date: Thu, 03 Jul 2025 09:27:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 30 Jun 2025 09:11:48 +0800, Youling Tang wrote:
> Add FALLOC_FL_ALLOCATE_RANGE to the set of supported fallocate flags in
> XFS_FALLOC_FL_SUPPORTED. This change improves code clarity and maintains
> by explicitly showing this flag in the supported flags mask.
> 
> Note that since FALLOC_FL_ALLOCATE_RANGE is defined as 0x00, this addition
> has no functional modifications.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask
      commit: 9e9b46672b1daac814b384286c21fb8332a87392

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

