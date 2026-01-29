Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E816A26CE39
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 11:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686373; cv=none; b=iw5imjLsVc6TyRRQEo7mSDJo80wOWl8Oaxr2Z21n3HsI7kR3P6YaaQeE6qwm07ywcPlI8cpLwxDkvij/uagip6Fxres62TRrxTDqBKAwxPCVA4q4uKQc4hSsR0H7Mgom61Ey05xEZUlwAtHVo4GFxGG2VgP4Dj8LfOmqfZXRJGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686373; c=relaxed/simple;
	bh=UmJ0YBoTYHbA4hProzlhiUbCp+WnWKpX9qzIOYffJm0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=X9+6b3Zp4Q3INDgF27jbSeXpY8DmXjqB3f/nSNRoEdbQS9TzKfMJ0T/DWSFk+DPjTuwoo/HCBZ5sYJhGKo1iQpItRASbH8PyvYa6a/9XM4BY841obvcJzkdsfdwM6/jDw/KAOUw1EUWgoKX6A8x8Y70ZKW7kVr9fFVyJ9gqUdy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgIA03gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgIA03gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E67C4CEF7;
	Thu, 29 Jan 2026 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686372;
	bh=UmJ0YBoTYHbA4hProzlhiUbCp+WnWKpX9qzIOYffJm0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=LgIA03gf+jEKULybP6tPsAD6DMzyDkvF5nNg77dUXSIceLJd1rSGxUIPS1KP5rh7+
	 IKFaYXRAYM5Ur44ia17tbV7EUp/3JbMtQyJW3GmBSUIINPH26ixvziQpCfpcbA7qx4
	 V+8jS6U00jWEQdTGwrIDxI8TFRoy2ceAB9dLRfGyao3SDYji+HCK1y6M1VndqlvAL0
	 ocuXlGBv9UEAxfSsBkEhDzPRq5XMN0z2iwWNbZhfG33fy2+rTERvwaGd6nxIsaAnOX
	 UNx2rPW+Qoq7XdaSZWVU8b7GQv6YodHb5XUD9NwJZhDQIsDKSR0c4WTYdWBTlW/t8I
	 991nEoL4piE5g==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>, 
 Keith Busch <kbusch@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260127151026.299341-2-hch@lst.de>
References: <20260127151026.299341-1-hch@lst.de>
 <20260127151026.299341-2-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe
 in the GC scatch buffer
Message-Id: <176968637097.19428.16298518427955892476.b4-ty@kernel.org>
Date: Thu, 29 Jan 2026 12:32:50 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 27 Jan 2026 16:10:20 +0100, Christoph Hellwig wrote:
> When scratch_head wraps back to 0 and scratch_tail is also 0 because no
> I/O has completed yet, the ring buffer could be mistaken for empty.
> 
> Fix this by introducing a separate scratch_available member in
> struct xfs_zone_gc_data.  This actually ends up simplifying the code as
> well.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: use a seprate member to track space availabe in the GC scatch buffer
      commit: c17a1c03493bee4e7882ac79a52b8150cb464e56
[2/2] xfs: remove xfs_zone_gc_space_available
      commit: 7da4ebea8332e6b2fb15edc71e5443c15826af49

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

