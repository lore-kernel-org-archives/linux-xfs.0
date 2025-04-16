Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CA0230BFF
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 08:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793124; cv=none; b=t5/qWTtxe0vH3BS3k0BUjgqUEZ7cxwSm45JdeGQdMUKa3V4MywJqwZlDIscJcPksKLKKXylcTy2LgvzcyKYTY93vqq9eE0wOtKZeQFjHDJeWmMO+ccH/OVhC4VIX+ahxtTBVtTYLZg/xEeHIM4mHrLkqL2Xt4DhlMKV+dcE32AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793124; c=relaxed/simple;
	bh=N8gOXn/ZCaRhQo/OMQ07PxM8NnqwVfmnQ3P2zp9Gkdk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ci7YwSf+mWZDClplVlKvFhdn09R3AioBZqWMJXn50yg5FqLrGbufc4LglirC/XlDEEyDyibkdjhf/R+svlypNVQ+7FNpNOcFCBa8izhyVOajyOprYLYXn6bX/TlmxPbTmeTWGeCaWMqs/A5sYYfZLaBe8by9E7wgdSG00PEfuWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MY6yNglB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MY6yNglB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06BBC4CEE2;
	Wed, 16 Apr 2025 08:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793123;
	bh=N8gOXn/ZCaRhQo/OMQ07PxM8NnqwVfmnQ3P2zp9Gkdk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=MY6yNglB0bCvVulhBN45yM1HG3vRAnQJUsqYwrB8qCX8WiQF/6ZtIml8StxxWe+Zf
	 s0eOsmPRTVpyRgSXck8kbD+6acDhBG4BXJaAm/ia4wWn7bMyp1tNXFIYq7CiyE1oIL
	 4v+rXTLu/zCMHYq1aGp3KmGTVFhU3h040xUVRxhsi31W30nyqKzxqNAfGXsr6t0Q6i
	 zO39tJWqpKKxDFAHF1r+aZoYJY8TgNurF4z50/K1Fn6LSADE8gVWmD0R2t+15J/i4z
	 YVYSijTddPspxoHQ0hL6Dt8iRy2nm203Uvgw6smmsVwHfxfX3I5YwrczRs9niWWfSy
	 yCfVcHmVPzKhg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20250408003030.GD6283@frogsfrogsfrogs>
References: <20250408003030.GD6283@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: compute buffer address correctly in
 xmbuf_map_backing_mem
Message-Id: <174479312249.188145.17343348646712479969.b4-ty@kernel.org>
Date: Wed, 16 Apr 2025 10:45:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 07 Apr 2025 17:30:30 -0700, Darrick J. Wong wrote:
> Prior to commit e614a00117bc2d, xmbuf_map_backing_mem relied on
> folio_file_page to return the base page for the xmbuf's loff_t in the
> xfile, and set b_addr to the page_address of that base page.
> 
> Now that folio_file_page has been removed from xmbuf_map_backing_mem, we
> always set b_addr to the folio_address of the folio.  This is correct
> for the situation where the folio size matches the buffer size, but it's
> totally wrong if tmpfs uses large folios.  We need to use
> offset_in_folio here.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: compute buffer address correctly in xmbuf_map_backing_mem
      commit: a37b3b9c3cc595521c7f9d9b2b0b2ad367bf9c98

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

