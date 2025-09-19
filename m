Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE83203A0
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298558; cv=none; b=INAf3VmaMTzH1NYQksJgjgONTJ/phSSV63fzoUZHMq1g8NcQIX8LkWQgOIESTIP3obCpeiMNmDcQcOx8IZ5hFUbuEEL559oNatiNXpJ5fXzKAFeQ0J9gQznkqcEy/FJnGlSETi8qFiRhho/C4fhvnw51ggst16ENjHwo4BDWhh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298558; c=relaxed/simple;
	bh=fRvVS+fU85W5OJzg3+CdUkRccYnOh+ZCNN4TNBlWi5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LutGLzoZpE8WbCW78Du2PqVi/rasbrG48dfuuZ2dngBF22D+gXKPZC01iAQWJj8K16z3QClPVOq6OOnbVHVWWdYBoO6Z9FBCSUd/tI6m0/6LJ+fmdYA6ISilKjQHemTSqXqwrgJHf4faiDM/qevMqpyhBwTj3MjQ7ZYUDq582tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXpUQxb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXpUQxb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D8CC4CEF0;
	Fri, 19 Sep 2025 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298558;
	bh=fRvVS+fU85W5OJzg3+CdUkRccYnOh+ZCNN4TNBlWi5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=oXpUQxb7wwCxitk1RtNNEsynVquzesejjJwxLURbwX0VoP1M00c1Rv9V/SpuGNSr8
	 tzFAhsvchHzyGWuSRO1JE+HELE0N+zeldu5Mlt0XDiiQmuFV/59Fv6IzfEtpzcVXQG
	 cizDFSY4chQNBsJ5dxd+BTfBIvT6M+56P7KQevqoAYiLaDXQbVn4/vY/YCpn824YbA
	 f0os++Kdmm62qS2D9Ma5IbPAjGpXdVBq3dpXizAV069ZD2pFqk+2Y4MDYqQ0N0ve78
	 Z2AHjwI5YD0xeV/5hVvp5wHc/VdlLZILEp4fOaJFDK/nLUfl5DX9I55+jIbvDykTEP
	 fyc9kf54DMyXw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20250919131435.802981-1-hch@lst.de>
References: <20250919131435.802981-1-hch@lst.de>
Subject: Re: [PATCH] xfs: constify xfs_errortag_random_default
Message-Id: <175829855700.1207654.11207663997429773026.b4-ty@kernel.org>
Date: Fri, 19 Sep 2025 18:15:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 19 Sep 2025 06:14:11 -0700, Christoph Hellwig wrote:
> This table is never modified, so mark it const.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: constify xfs_errortag_random_default
      commit: 3c54e6027f14c4f54be5508af748f6cc2fd72f89

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

