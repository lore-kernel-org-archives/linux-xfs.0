Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5A53A8D0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902772; cv=none; b=u/h9SSXuyTHC/nn+kbv2rjfLj37uWGa25GwPtWli2dPCqo+JLZXj77K9xgTFoh5h4sBhZLCAnGTaeXSZ4dse3zYKxD1jht2B79W9/UgXxIa+5r30pGp2PIu85mA7smnn7u/ZJ4q2LcS66OpcHprnyJCleBPPktLsmw640KW7XAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902772; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3l7f03sCkQ2ihEvy2Gr04V2tVjR6lPT2GlqzWRh/T+SVJhv4NJ+VEMln4DpqjDe7qce9Vptp7jR9DrNgIv81B/by+Re3TuxduiaHwVay5LtjJ8zokq/LH1eVD41NId66/l6HaP/POWZFMTQmggph8v//x+psAEHWForMhKKw74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0A9EA68B05; Tue,  2 Jul 2024 08:46:08 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:46:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 08/12] xfs_repair: deduplicate strings stored in string
 blob
Message-ID: <20240702064607.GC25370@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122289.2010218.15312017622674815172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122289.2010218.15312017622674815172.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
