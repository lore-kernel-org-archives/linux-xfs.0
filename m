Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3B31DE2A0
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901461; cv=none; b=jx/LOS3zUXW+WWjoYrJ51uCjnpAXZ6fEzQi+rPrIclv2YlvZBxBar+aNJ59pdrsiRDXR91O8yIUuC1/31+iUdX5OCSfTu42AELpm6tx0PNoOjgUQ1xqtm7eUy48sWiHA7z7UML+og0EXoNEDCED7JlfKX01KI3dvxVM9vmw2T5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901461; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FueZGjn7mgagxm8DalnhYP9Dglza8ub6GgBZ9Fgt4n7VlgWbW82GtSDXUzTkaHADsoNsaczKmc97dq/roym0E6RNYEnM+CY1FTC4HBl2iXMcefxE0wAMimjNYaz0wGrro96eC16cJVOsgkdAw3yp5uDHN5ug1AQ0J5UVPMjQDbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAD3B68D0D; Fri,  7 Feb 2025 05:10:55 +0100 (CET)
Date: Fri, 7 Feb 2025 05:10:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] man: document new XFS_BULK_IREQ_METADIR flag to
 bulkstat
Message-ID: <20250207041055.GB5349@lst.de>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs> <173888086105.2738568.7689923306499344386.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086105.2738568.7689923306499344386.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

