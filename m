Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05332523D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902145; cv=none; b=P1UOlvF0BeDxAwAo764V2kq+s2lnryClRL7Adk6M2hDqSiNPDmVazJYGd8D/odRTZPEFf/DYiCex9oozHejXplK6oZ+4VeNZ5NZdyPId3KX74OxCcUz/yzZq0y3V4ncPFjy/GdKBU9oIgLW0No1H30RClGZlm6XHyvRAg1rjQTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902145; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3W344jR+PBxk+HxYmMMudPNpxS0vmmtq39hdSL/UTUDdpKQxo5n0OprILbpCiH6ymGCp6gBaeSUC2GKxqtsfCHbG7Zvf8zkxhdOeBVEO/d+rN2vIkNt3lakBgakg894TRtcW7VaOkbD+WcgfBCq9OnRTXioDz/YvdVYbdsYBjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9AAE868B05; Tue,  2 Jul 2024 08:35:40 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:35:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 17/24] libxfs: export attr3_leaf_hdr_from_disk via
 libxfs_api_defs.h
Message-ID: <20240702063540.GA24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121326.2009260.10614225579834518986.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121326.2009260.10614225579834518986.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
