Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527752B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898728; cv=none; b=HV3T+xbLicfPPesRdRJgGX6cZARUJXBP22C22cw0u1Io0hQ23PMq3+eo8BwzShAmNR21qh2CxA/7wKQKi8BJKelB5ZluCW5qO8C+lD+kKpysNnV8BNtTJfqofPdpu6V0renCPOl2BibFZrw8D3NoPykU6U47pA9nJ8bzHBMWWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898728; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtOzLkyG6haGfeggL0yoYr/RBC1xdv4y92J4YeReUJ+Im95A0/5vkLz5o7iPO6y8WDihPHjSUJC8L8PR7ew/9JJIUWNe9qKyUpbimwuWyu1Jm/ha9NyF90Kaz34e87ZkZa1tf6R4I1uU/GPicw8Ztrmodk/Vmu9r+/GYINilwK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8577868B05; Tue,  2 Jul 2024 07:38:43 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:38:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] xfs_scrub_all: remove journalctl background process
Message-ID: <20240702053843.GE23155@lst.de>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs> <171988119439.2008463.11717166273939123673.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119439.2008463.11717166273939123673.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

