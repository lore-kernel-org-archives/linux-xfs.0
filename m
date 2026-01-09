Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B64C3148D9
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971028; cv=none; b=oNDbyhMn+g7+8j/658QvZK6Gjth1RN2hvmQip0dCfQuLMs4Rb58FLCbhl0hNcuAxmJtWk7stfAOGmSbiYvsx63htqokVkg06EIJ/7fVpqQxZiIX9qvFgJoTsgmfdFcCl7ZKbRFLeCSHZaS+jXpevW/roIlw5VOrcEnEv52RmmdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971028; c=relaxed/simple;
	bh=DThXqpqjTPzM+BiNAfAickooeE5Kud+oTDOSD26gHq0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YrkeQ3oP0BKsCwjCLwz06xJKuEUFg+Cio8TZS4fSiU/7Ek7A7Wc2aYcpOeGi1onE9j0E3n3AQCxJkzC4/UOjsgwz2w7pALdWe8AaGQWoLZIVJb+g+MVKlhYXB4i4hboolY9yoUyeLEnU03+OLeb4fbBC5QgBNQ+beA3S8EnOwK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxBtuXRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxBtuXRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5AFC19422;
	Fri,  9 Jan 2026 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971028;
	bh=DThXqpqjTPzM+BiNAfAickooeE5Kud+oTDOSD26gHq0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=kxBtuXRW/OsvgJ+3oJpgdBCybZSmMpWOtSVFfw0+h5FBbr8GM0QUDUr7+qpBtV5mf
	 s0zrKkXigOI6NQT2RkXVqaQCRh4CSmqdv4RsrFTbivZ6/pnt06my9LIS2Gkqu2h1zC
	 TGorpIzfGsi1h+SOxW9uknuv3YfKUE50viZ1yqc05ZHYnzcoT/ZSuge177EM84/64h
	 em1vpN/S6Zu6AcyyBRyNLqjwsRnjD4lUqboEuY6Fw0Mvo3r0eP/Rds7zIPOuAT8EvA
	 ggi/CrhlNsfaIVJ3jdvA3bM3DTDryNmDZBlkRhweMs2RHtzcFtHq1fcr33dis2wzos
	 u6f4BzlgBSE7Q==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
 "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
 Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20251219054202.1773441-1-hch@lst.de>
References: <20251219054202.1773441-1-hch@lst.de>
Subject: Re: [PATCH v2] rename xfs.h
Message-Id: <176797102661.430235.17111864790326075242.b4-ty@kernel.org>
Date: Fri, 09 Jan 2026 16:03:46 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 19 Dec 2025 06:41:43 +0100, Christoph Hellwig wrote:
> currently one of the biggest difference between the kernel and xfsprogs
> for the shared libxfs files is that the all kernel source files first
> include xfs.h, while in xfsprogs they first include libxfs_priv.h.  The
> reason for that is that there is a public xfs.h header in xfsprogs that
> causes a namespace collision.
> 
> This patch renames xfs.h in the kernel tree to xfs_plaform.h, a name that
> is still available in xfsprogs.  Any other name fitting that criteria
> should work just as well, I'm open to better suggestion if there are
> any.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: rename xfs_linux.h to xfs_platform.h
      commit: 24bb56d025e315230af06389e46a8b15dfb71c00
[2/4] xfs: include global headers first in xfs_platform.h
      commit: c21d7553f83571411bfdd9d49d0682cdf79d396d
[3/4] xfs: move the remaining content from xfs.h to xfs_platform.h
      commit: e382d25fea024874f5e6687f85016e6bfc4dd75e
[4/4] xfs: directly include xfs_platform.h
      commit: d6e7819ce63f9fc5de59e2f508e1692a4a2969ee

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

