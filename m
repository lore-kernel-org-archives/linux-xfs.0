Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053379F5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067756; cv=none; b=nluZZbD492kU/sgA7VJd6lzmiXdsdn+xWzvJUWhSuRzMWgdjqvHxsWL+1CJfmYS4OEQpF9il59J969e9srOykoubqRdtRmUxgvebcHauXzTYjeS8UyxXcUQShnegenwXxuR8efPapXgzMu0Cfd+1lAiqx7gXj9aepckADCXUX+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067756; c=relaxed/simple;
	bh=AoZd4NU6ko/2QtWSmKsmf9EJaw6RR9g1Kxtk3IYosek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZfED61I1KnLUZhztzbOO/fXrbE8lHP3g44DeDN3uxtTebYz4EPZKkRHR+zGW9j9DMNdVTK8U5zjdPGYmHp70vNgscMuoe6nwswSBPgGT4ufnjjoLsYc0zMOYZCRgCmvvv1VK4NP2W0YuJiE8+YJhlz7fnQIh2k3g6/S96Qa/+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20CC768D05; Fri, 13 Dec 2024 06:29:12 +0100 (CET)
Date: Fri, 13 Dec 2024 06:29:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/43] xfs: disable sb_frextents for zoned file systems
Message-ID: <20241213052911.GO5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-20-hch@lst.de> <20241212222609.GH6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212222609.GH6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 02:26:09PM -0800, Darrick J. Wong wrote:
> What should be the value of sb_frextents, then?  Zero?  Please specify
> that in the definition of xfs_dsb and update the verifiers to reject
> nonzero values.

Right now it's undefined.  But forcing it to zero makes sense.

