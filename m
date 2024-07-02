Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023AB364A0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898403; cv=none; b=hJDTiScIfLOe1gaNMeGwo7+zMANBp6m4Rj0QTfwY2eULHH9XLa/senA59RCz0d44GpktyXj2qkJhjDjBoI54WB4iB8l8XbgA9qTfsjU8dXKT7nr5vTFRdxoSE1uPkC5BISQ+9SJ99vGxD0R8ynIibcYklxqPsZlAE8KItp8cyls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898403; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4NIPzqD7QCa8c/kyf5h4PMs+dHQZSt5KS5pyeAZiHZbzg8wGnHnXABppwtML68BOgQl1F7YjZppZSsursIfv3V+5BXfqEb9sWg5QPfIqvw98Lkph+Ay6ZNqTuxkNwxVIAe4Vl6kgm7ANhaAwKJJAbES3hxYnmCu5jUJAqV0iTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 187BD68B05; Tue,  2 Jul 2024 07:33:19 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:33:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/7] libfrog: print cdf of free space buckets
Message-ID: <20240702053318.GJ22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118625.2007921.7225855318666248252.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118625.2007921.7225855318666248252.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

