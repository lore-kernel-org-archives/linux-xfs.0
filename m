Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E1E47668C
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 08:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966519; cv=none; b=DfpISHfQYFEPBLk6xkA6eGRYTFZrj9ZuFJZDTawVbhyOtd638YnoFQljykpaJuyPTtCcmCmGXXY1KvNmpSUR52qb/+JXRNTAOI2v7QJe6KRh8rk+yWf+Lj7XuXGkda7cL/+5FjijfN5OnCeZgpPcZXFJCR9vW5VmfaMfkws/7C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966519; c=relaxed/simple;
	bh=OVTMecY4u85d3B7wsAXm3TPD6qeZqPYulgDWYnsh2X8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R+SXmYtAx/nEvdwvTwNiSqZDUcIwlijS6tuokf1BdpgY7UufgPzsoc37uAqcTyds8VY+6P3MUVqkdF2p5mTAK1UlvnRjw+K8RCrMykpGH14EOffZvWLXo0A02i6yv7h1LBvP+2t334oAnYvzykhSgpiSP8WZICRYuK+krZDTNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9i99yBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9i99yBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCE51F00893;
	Wed, 14 Oct 2026 08:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966518;
	bh=oADJ5lWxIOFUthRExK7qbjwVdydyxv1SrjyafQjAkqI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Z9i99yBg5yZ12sU5NcaiEV441A9JHYsIiaxX+P+TY4HmTTO7GpAG97fqoeXppS9Jd
	 /QPijeqibeVDmGCLg89o8KbZrtqxCKA7hFuh4XDbvNYGYNKv5C06K2nSdilUTYVht5
	 X2DpR6VT13Rw+dRFQ1oYkcR39MiN2Ni24EmfUHbk06ks6JAf2PklIDhxZtCBYRH4/J
	 N3fm6n1DD4zhTvOnQjObm6Y0fEC07ih2Pe7yooIFGT37hhzXq6Q9Cfk/hipxLp2iAu
	 vJ+7uxfyzMF9hAxjLbcvBEb07KdfuLE5bdG2H638SKwqhMO8bSGrpthlKcE7HEW4ZE
	 FBO+JAbWpuinQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Cc: pankaj.raghav@linux.dev, John Garry <john.g.garry@oracle.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com
In-Reply-To: <20261008111147.3906817-1-p.raghav@samsung.com>
References: <20261008111147.3906817-1-p.raghav@samsung.com>
Subject: Re: [PATCH v3] xfs: don't limit software atomic writes by the
 group alignment
Message-Id: <179196651654.20513.6379916199777037805.b4-ty@kernel.org>
Date: Wed, 14 Oct 2026 10:28:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 08 Oct 2026 13:11:47 +0200, Pankaj Raghav wrote:
> xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
> greatest power-of-two factor of the group size when the device advertises
> atomic writes, so that allocations can be made naturally aligned for
> REQ_ATOMIC. But that value is the software limit: it is only used when
> reflink is enabled, and out of place writes through the COW fork have no
> alignment requirement.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't limit software atomic writes by the group alignment
      commit: ec8f62cc109a3f596b3c65dc0f1011c209239051

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

