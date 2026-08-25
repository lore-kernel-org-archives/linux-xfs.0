Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE8F3C2BA2;
	Tue, 25 Aug 2026 06:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787640521; cv=none; b=VR9iAW+CYjE8K69FB8xVjKRyqGDG5kzfzGV7OyrOPkg1NY9sxv9Tr7H+d95RC6yD0yM86gp5HvcgS2KgyzUxD0voFjbObCPegqykEyOyQpQpJVcDwlbTC5dfqwNy1yz/vYyVdIce9D5U6392xsdj+NarQl5sOPX8N2rPbp7wGkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787640521; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlMatP2wuFG2W0GfcaUxwGfHDzy/EQ1dpcIt85UUIZgiZ3wEc5Aw08x2LuMiPfL7KusIkT4lHqmRIQNy3StBmrEl63eifVUiZGq9bmVH7KDOvyShNmYIU80Cs6RiNXPuoj+6C8yLRr+Q/B2HV/Q2YDjKAlg6KWF7Vj/EolRlXI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC5BF68BFE; Tue, 25 Aug 2026 08:48:35 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:48:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: destroy seen inode bitmap when we fail to add
 a dirpath
Message-ID: <20260825064835.GA24772@lst.de>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs> <178760941186.944364.1427795667692371177.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760941186.944364.1427795667692371177.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

