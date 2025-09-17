Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7756F2905
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131290; cv=none; b=S5TabLCqRYufKpXWCGCUokolz0AkVYp7+YfwGQPG54iPhghfvm7q1M0Sz9G9owZKCnNjVJGTEB2xe0S3/dYsBfuDsWB6pEMBYQ9dvm6GiUyodDE8/jpzzE78hNDxXuALp6QLrhNDRXL0HOsLMxb1kbHGrTnoC9wBUL70coeJQVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131290; c=relaxed/simple;
	bh=tCy+qnsALpFS5CNlUE8BQ1QosFOSit9+QetUGcaXyzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZ+ukZwrUOZnErHduo30bUlU+nocf+EHfvU0clF9V+WGLi2LMPcgo12qTkSRo7L96XMcr4IoBm3VenjVHo3D7p/RT+KdcQIA6PtGmJkMDSKDhk/enJ02bB/imioOO3BKKBP4tNTidvmQ/RO7Bqqy9+IJWTU1N+8ZI/D7t6FH4Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B0D5368AA6; Wed, 17 Sep 2025 19:47:56 +0200 (CEST)
Date: Wed, 17 Sep 2025 19:47:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: Improve zone statistics message
Message-ID: <20250917174756.GA18733@lst.de>
References: <20250917124802.281686-1-dlemoal@kernel.org> <20250917124802.281686-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917124802.281686-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please don't captitalize the start of the commit messages.

Except for that it looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
