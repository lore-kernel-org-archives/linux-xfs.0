Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827F7523D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902031; cv=none; b=VECAp+r36Fci2cT0BDKc4FuX2RwZyzDNksdL5aCRJ3DI4X0W6zXed4PcpfVAPSvLDYS6ctS48c28jllO5VgLNdagLw8Hkv/vQdgHAKVs88jZyjVJrZB6Bvx+qGIQAdQPTGK6GiXd00sjzqYCNqzsi8Y1G4aA6WtAW/fGHTrYHXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902031; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDzd3VPwB0+v35dKbAMHUC4DCRXk95hWIc+3RSLBftKQ89JfDr4v/DUxIQke4hMu/NNwfv8ez61NscANTm1iSYdv1aEu8ojyUmOUlPy0/SblCx5gw86xXJtHpScX/GxB2WmBBh0j1xlokg82A2pFXQNWzS+6V6bqs6y0mwJPssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA83168B05; Tue,  2 Jul 2024 08:33:46 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:33:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 16/24] xfs_db: obfuscate dirent and parent pointer
 names consistently
Message-ID: <20240702063346.GA24351@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121310.2009260.13863957257257204611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121310.2009260.13863957257257204611.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
