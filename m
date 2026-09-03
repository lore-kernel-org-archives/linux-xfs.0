Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D053A54763;
	Thu,  3 Sep 2026 06:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415572; cv=none; b=lcZFdxGq3Jys3gR4cV37cVvWsjq5g8PGHv/PGONdx5Ytt3J5MBQL5MT5T6yqJ0Ag4JedqWKa3U4UtejuFg5fR9OAOAHe7leCi7bxBEjLCLNKUDeqVr6q122WK5LOnR19k65dzsC2RaV0FUvnMHt/V0XK1qNr7GAfU5vFO2qjwaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415572; c=relaxed/simple;
	bh=uKqBuLVnIwLzg78VDMd0UqiOotrHaJmpOaxoW0yZWpw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=if2XH+VCNl6CgDNQzh0dh9QAToddmgKDkAvLF3pDTyujkuPOjnV8zyOy/D6+MB6KUw4lvwxguIY8boetehU5YXFcSHRKzlzRze6RvfbGOs5zk4pMeRKpyboOZZGqEbhb8UE3T7quACHzsggAMh+ax5vCM9/duo6M2wW5xAYEAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNkEsTRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNkEsTRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317AB1F00A3A;
	Thu,  3 Sep 2026 06:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415571;
	bh=4EpF+2j0c9CnenLScxaemdSfSyd+z9TzLjRp+3WIrVI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MNkEsTREYlfGifRY+rCCLo4kXc0mgLi2g6zmDDdSiQCUR3J0VBL8zzeMgJcHG1BmS
	 /hR39UVZL60/fJuQQqtFFtaAX3bpqs4dKGjAcxy4LhKniDy4qmutaMBhl3tJgyFYkL
	 t4of+gD73TRE2oiRPIx9rKQDSlayNRhY+liR6q8PFcgzIa9Otdglxlt8EFDWmEmwN9
	 yDsPejy2rOXKhFrLPvJp876z21bmGCMOUcvpL+MJ2sA2Qv0mVr/tkNhTjpQxpmWqjg
	 pgtIpWVDZ51lEx0wT3cYVVnjHm+FZr5PafjuVgkS5avtLsF0xxNWrRSgGSNnB+slgS
	 WLxlv5B20YhjQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hch@lst.de, Anuj Gupta <anuj20.g@samsung.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, 
 Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20260901054348.808571-1-anuj20.g@samsung.com>
References: <CGME20260901054416epcas5p13e8b9a5e5e8ebe10715f735c82ded916@epcas5p1.samsung.com>
 <20260901054348.808571-1-anuj20.g@samsung.com>
Subject: Re: [PATCH v2] xfs: release alleged child inode on metapath unlink
 error
Message-Id: <178841556989.1198521.17542664209670800283.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:09 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 01 Sep 2026 11:13:48 +0530, Anuj Gupta wrote:
> If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
> succeeds, release the inode reference before returning.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: release alleged child inode on metapath unlink error
      commit: f7cc83204d79537c6bddd6c28d77dd0625eb6aea

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

