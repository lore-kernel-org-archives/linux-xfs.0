Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274FA2B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901451; cv=none; b=nkYemwVMzDncbvbDZh3V+diXuq7jrD5h2bqWvfYZtCmN71Kgd7fyxhnW44C/012QNgf+v/p2vF5YYs9kA+lhPQtr3SLdxvY91cXKz9SvSx/PEXt52LQXKJgFr7UQWxyZeBa7NQiyqURvB2HO7BjSUKG5AjT7xpkFPIAbhij0UyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901451; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFaNbjvDsdwpw1I+/Knwp0oMMNNGpdr2FOvb0QenKKmmh+OWpcNJZev04j+2VvTDHs9e4fsGDhwXoYTUl/bHrl0gWegp9XwTGyQl1X6T9IaYiosqz8O8Pezo/v+N6AISRjHSzOjjNkPM18Tx7TtbVY4YiULMPszyt8yeGlpThGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 96AC268B05; Tue,  2 Jul 2024 08:24:05 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:24:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/24] libxfs: create attr log item opcodes and formats
 for parent pointers
Message-ID: <20240702062405.GA24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121078.2009260.1928679002077059727.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121078.2009260.1928679002077059727.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

