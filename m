Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC84B04B1;
	Wed, 16 Sep 2026 12:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560423; cv=none; b=JWrtMeq0Lf7RAz70+P+ul9Zen8EU4zlDrY656SmJROfkLADxYH2+mMLqbjvrhm/TpLkmNXTDTya7/3DV2KXrWtA3F8QvywtcVic8biCLCTsIP62BkQ7+silvUet1YPdiChA2SOKX57807TDU29oCTyJPN0E0DCVys/dZxhnNGgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560423; c=relaxed/simple;
	bh=lwle7nNhHXThQ6j6tjhq/HCQUySFcf6JoA5CBw19P+I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GDJYzyY1dNEu3+zqwoRlaCF/IVaxDY6h5GI0ZOkX5QrhL1u60lf/nmZay0uU4JgEbIEdRr4CEQwBrg0Bn4LjHmrhdlJePJxXRCTwn7QRw1XPRyTde5Yrr6qHH2sec2aJHqLds29Nh0ShOo4i+t9HE3vQjRJVpnK1eXZvvvlwGP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDmTjOwz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDmTjOwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD221F0089D;
	Wed, 16 Sep 2026 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560410;
	bh=B2EcF+GeyBALCfJnw1uehGbcGGfKtSbsTDDrT027Gd4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DDmTjOwz/B319NFX/l+MtWn9XWrkXntxZszGbIcMhhrX2xuXaxmdPN12Ky6sWqDw3
	 rLZBmNCUBYyzddioIWiWkEIu9Y+VmGCUav6owTqC7W3JQhpJh/SmhubVFvX+F7rwAu
	 BJl0dAKZUVulTdQhTGu5ndjvBO1f2HOLW57H9/xvXetG4FV/94ve+lvzNVdHnYJWxx
	 U0G2DeUSLhNHl1t9p7515yppodfvkQ6iJeycztiX0xoR8rM4CAo+4w1kwKscymOqtR
	 eUI7Q7/jLiAzWxN92hEIJRYbCi6TxPcDjhpQm1aAv6yX9Q3Sbu5bLVl6fY2332aMu3
	 LrUkUbSvCmhVA==
From: Carlos Maiolino <cem@kernel.org>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260914093152.1698-1-aditya.ansh182@gmail.com>
References: <20260914093152.1698-1-aditya.ansh182@gmail.com>
Subject: Re: [PATCH v6 0/1] xfs: prevent close() hangs on frozen
 filesystems
Message-Id: <178956040899.10466.11807387586827569205.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 14 Sep 2026 09:31:50 +0000, Aditya Prakash Srivastava wrote:
> This is version 6 of the patch series addressing the close() system
> call hanging indefinitely on frozen XFS filesystems (Bugzilla #205833).
> 
> In v5, I introduced a transaction allocation flag
> (XFS_TRANS_WRITECOUNT_TRYLOCK) to handle the trylock inside
> __xfs_trans_alloc() and propagated it down to xfs_free_eofblocks().
> Christoph suggested this design and reviewed the implementation.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: prevent close() from hanging on frozen filesystems
      commit: 6fdfe8606f99d86bdd109c94ef0821b8529fe44b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

