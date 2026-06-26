Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5124A076;
	Fri, 26 Jun 2026 04:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449562; cv=none; b=C+UOAgD7343g9GKg2GVrn/fNMEDqzg6+ogbPI2oIMqnLrmF4P746MXjBPBh6Ko5WJDc8yWs2AKfdKw5YrfKXd+ic3Y0omdgtTDr2w+lkYOwsr+nt72CijkNu9DEytauWMXjjRUClCdAELeJ8P9ySSCr917DDlYxU8S8CepbNoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449562; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTLihfw1ODwQvS+akp7ReT75A/x8TUk9N5S2uf6Ph3ata4dm095TPMpBQqUKgqQCIjsCO6OPAUVJahFMPNND3eHrVYcBomr3zFxKmmseoKSgWCwDfkPMm2DIgN7NXoe4gHdsEBlGHp3IfnB6flr5lWfJQN6XM2wY2DqW8/0F/2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B1E6168B05; Fri, 26 Jun 2026 06:52:38 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:52:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, fstests@vger.kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <20260626045238.GF8613@lst.de>
References: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs> <178240619668.1665857.17134786745403757824.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178240619668.1665857.17134786745403757824.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

