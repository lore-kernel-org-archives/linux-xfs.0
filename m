Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6D3AB26E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147876; cv=none; b=hHWskv9+EGzwanOlvA8SIZc98ozRWIuZgne0eFw+vPUL9XET2Hoe6jygkRP4k1oCIGMpR8mSZ4IiEtOTZAL8rhx4IPGCLSJexbTQaEmQ+9Fp7uvxkvzXnK4Vp0CyZeDWbW1ZoqVz1ahEcFMW0Y16olf25Mfk/2TjleGV+n4TQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147876; c=relaxed/simple;
	bh=VC184v5ouMHwyKskt87HXn2FfjhXSpbWSTRkGR61uQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OuW3pDxNZtBolKybQxQ5lkEcJJPP/JX5h7xvBy2vF8qE+auTPXpc5mU0AEJQLfFsy4+VkbS2+iqmmh9hTHp+mLyJwwKB0eqvNkq413TU2sHD0Qyync93frni0o52JVsjwoC0f3IpdH+CINg1iZaJdoAR9jFbD0dBhSAoJ0tMqMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 413D668C4E; Tue, 10 Mar 2026 14:04:33 +0100 (CET)
Date: Tue, 10 Mar 2026 14:04:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH 2/3] xfs: convert busy_extents list to a pointer within
 cil context
Message-ID: <20260310130432.GB4151@lst.de>
References: <20260310123324.339310-1-cem@kernel.org> <20260310123324.339310-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310123324.339310-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 01:33:15PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Decouple the busy extents list from the cil context.
> 
> By having the object independently allocated, we can transfer
> its ownership to the discard code.

This looks fine, but I don't really understand the rationale here.

