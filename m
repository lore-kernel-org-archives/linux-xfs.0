Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFE978C9E;
	Wed,  7 Aug 2024 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047188; cv=none; b=NPJzUZ6BSix8A0qrRhPBNX79pCh5c161wshqtaIr/ANPxq3GA+Aqn+Z/3M1knWj5xFdTjaLHG1ojsGTygk8gCalyq6P8MLR72vmQ7mncPD/aKJ10vNiq2LX3W6GC6+bUEst7PeZAzQJH4KFo0LdDywZvXUz2c3Q/wEETjqghqx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047188; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2xMfhlJS907TAj6T78+aRq+b13oSAHG7Zgg7aJ93hId88lG96vuLM+VnUbegNTodUC0CIeeuzzHkMPuBA9rpTQoaI64xNe728KpvBlIu0EgaHgRlpbTABdgF9NS2DJPXwacATCl8qs7ZI7pwlSw9RkDyiYu53z5m8N1kIBU400=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5701C68BFE; Wed,  7 Aug 2024 18:13:04 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:13:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: set autofsck filesystem property
Message-ID: <20240807161304.GG9745@lst.de>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs> <172296825658.3193344.3348247369210100441.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825658.3193344.3348247369210100441.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

