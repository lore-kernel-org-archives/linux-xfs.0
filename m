Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460E1DFDB8
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766861; cv=none; b=c9DwenzAzkMQglAQM0oPkHqSvC18mlJUN9PmyjG9cVi+Fku1eQHuqvYNHAM8g3SbgBaIO57GOqxoD1kGxvphsKOpqDanZYyNVZ++fp5LwceuMIrV4hv94MoJvOiTm7DT5s5k4pzvffzcH2ESTP+Q8VQG3swnS7jnhBShBwOqbpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766861; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWqE8GMhVdx+CmwXeJB6azxuSQ/7k36wxzC2JKxgVxz2lxs2AFtsLTax7C3112y4Rwl3gWXEKTz4/rpHE+3qU/Mlhkwbf1O78Qi625BRDjHz0RmoT8T9UpzNrQW+Uxj8DiRQLKszxDK8G88rQN5XxW8ZcBuY0266P3Z0vkYCZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A245227A87; Wed,  7 Jan 2026 07:20:57 +0100 (CET)
Date: Wed, 7 Jan 2026 07:20:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 2/6] mkfs: remove unnecessary return value
 affectation
Message-ID: <20260107062056.GB15430@lst.de>
References: <20251220025326.209196-1-dlemoal@kernel.org> <20251220025326.209196-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

