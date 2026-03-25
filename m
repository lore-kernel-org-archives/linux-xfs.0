Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A54175A7B;
	Wed, 25 Mar 2026 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425428; cv=none; b=Y1uxgSGB4WAFV79oY+P9nMJdAMCX3MqjCChSty7yAaBMiXdHpY/IyijtyWncaq0KMgHg8ANVXtxDA1eirarnPwU3B7jfu9lEiG/xfPrSvPqNlJn7u+iFpV/LWS3ulNrR3kUu6ZzE73rFWeXds5qd2JsIEdaPk+g2uqgnKI3G0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425428; c=relaxed/simple;
	bh=0q8BLJk/ygKuLzqid/uDpe6daMEqtyc+fcO/geTlCUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRTsZo/iQ4e2c1F23aZDRNF095bdA4wpb9U7NOP6YAOL99/r1b9OkjjWAcc38C111Q3a+jluwnHG6OUTRjPnMLjLLVDOLSSlK2Xx6702qfByXg3c3iL6+dWSnUKrUNaGRJUSW8f/1yEXXsNR3D7DH62QDoQl2vPR5mY0j2bGEBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9146B68C7B; Wed, 25 Mar 2026 08:57:00 +0100 (CET)
Date: Wed, 25 Mar 2026 08:57:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 03/25] fsverity: generate and store zero-block hash
Message-ID: <20260325075700.GC952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-4-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Shouldn't we still try to get this out of the fsverity_info first?

