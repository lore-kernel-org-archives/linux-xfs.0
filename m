Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED21BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902851; cv=none; b=TXSkQo6vdPTHCITCI5jSTCBp70qX2ldy81pQaXCujxAHjo3x2jNKbOc3xqHo1BH4/GhOVDsF7P6PQcgnTilOXIq2SlWLyYtAp42P7k2l38/5BiPUJe6WaOQiCTy7j4W8OBn2lJpHTwSMJx6QLnlEPoAbHg5fIyHCVbZf/kNIIP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902851; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1LFOrKqmgUInRCUsmlXF1JxcYWoO8EYukk6tBTzu2OMr3ntcRrjOR2zDnLb0Z8tCxyHG6cO5k6W2y9V4UIjr5bIoyg1bBynEvxwukYZmZpsK4UO88c/eHTYz3cpnPBIRi7z3cp+dJ0iId5jFbTvsYyU+yCOrFVsUAfT0kKaZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD14A68B05; Tue,  2 Jul 2024 08:47:27 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:47:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 10/12] xfs_repair: dump garbage parent pointer
 attributes
Message-ID: <20240702064727.GE25370@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122321.2010218.4681521171948051075.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122321.2010218.4681521171948051075.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
