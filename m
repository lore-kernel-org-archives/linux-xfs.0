Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780172B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898763; cv=none; b=uuRh7uYjL/JIGrL0b8vR3KcT8PJYmpMiZ/ZXVSFFE3v89geIDfJTbFXdDnrMTXRvZD3bORGJoNg2SId8isBFr8l7cHu+5Im8uI/DZkvyr9wncydy1cxzZ2/4g0bT0F9SRam8Xr2EzKp7EA3zmDjmNwEikK0osxlrMxFDmRuiqsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898763; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZAOhJA/I+RPejBNAH7hjltHqCySIHqtZlwxOEjqO9FD6GLWkAI/qYMsP5198WbaJzYePCWnuHbopiy4bBWV3oBOX6vZacJFiedkFuwyYEoWiGaO3nsN+UYOXjSXVCcPT0ujMm1gsnhKa40q0/Rvgvq60HF4LcwJ78PntCtupRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C79F968B05; Tue,  2 Jul 2024 07:39:19 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:39:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/6] xfs_scrub_all: enable periodic file data scrubs
 automatically
Message-ID: <20240702053919.GG23155@lst.de>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs> <171988119470.2008463.14610381676308637018.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119470.2008463.14610381676308637018.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

