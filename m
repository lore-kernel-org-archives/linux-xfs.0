Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C31376E0
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535870; cv=none; b=GmVzbTot8TbL/dUyhUdiI1h/MxdpZsycenMwL7WMNhcKQZbvBj1i+PLTydcllNrkUuuG8j0zrhfwk/wkDRajqgc9W3pE0IMsVcFoM/rdGqXDcOaJX1W2JppLcsef0adL0CQ/0/B8LNXUr0hJG34pT9zpbkafNym2PI47Hp5ofeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535870; c=relaxed/simple;
	bh=bBXYgTqDy6bQDTewapcIua1FVfWq0iQLUi03m7llyL0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fLjlsoFy0RXPr+jfJ2p7QFCGMrLMA5r9v+UGVpxLmv19ysNhWUTVc+sEF3+eMblz3R/IDP2z83PauS2KhCeAwXoTm8brZHBQlLikJaeI1JtU2jA0v7Haypzgn/nez3BKtpD1DuT12kiTkpZEZoO5IB2T5YMIxy8KMz/GSFekVlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CF+urOcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CF+urOcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8DAC4CECE;
	Mon, 25 Nov 2024 11:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732535869;
	bh=bBXYgTqDy6bQDTewapcIua1FVfWq0iQLUi03m7llyL0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=CF+urOcVzWqG6KkefhUPSEWEXn/VkCLTCXRB3n9ifwHYWTQkO2cz2uLvEOrDmZJVF
	 boCdLGLttzrgV/4h/dLOnMmT+84qU1xUcnGDEHBq8EoEhrBChCGUsHZa3E0i7txKyP
	 Jc28kd2qJIDNhjsVn8le6t++ll6dH22HWFzTY7klpR/mbBwgiJg1w4UiHi+O+4gzJW
	 zhZ9wmWrd/3+SdSYnCrxRzLGGfoRClJm9nSacnwcNlgaj5mOgcCeCH80wDKLATRu2u
	 WvDLjpY5pXYLAJw6uwni2B3dfXKy9DeTTHFKbXtIiGvCRd9pSKaJFTTDPOsrAlZ+nA
	 BaRKXV3k8c/rA==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
In-Reply-To: <20241113091715.54565-1-leo.lilong@huawei.com>
References: <20241113091715.54565-1-leo.lilong@huawei.com>
Subject: Re: [PATCH v2] xfs: remove unknown compat feature check in
 superblock write validation
Message-Id: <173253586557.514512.10040836613465181367.b4-ty@kernel.org>
Date: Mon, 25 Nov 2024 12:57:45 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 13 Nov 2024 17:17:15 +0800, Long Li wrote:
> Compat features are new features that older kernels can safely ignore,
> allowing read-write mounts without issues. The current sb write validation
> implementation returns -EFSCORRUPTED for unknown compat features,
> preventing filesystem write operations and contradicting the feature's
> definition.
> 
> Additionally, if the mounted image is unclean, the log recovery may need
> to write to the superblock. Returning an error for unknown compat features
> during sb write validation can cause mount failures.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove unknown compat feature check in superblock write validation
      commit: 652f03db897ba24f9c4b269e254ccc6cc01ff1b7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

