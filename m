Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F89F5A0FE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898636; cv=none; b=D7rHsMvk+SOekolGQJSCGQW0TV+iCOozweTsIDK9oHNrZkDR9JsE6G5MyHYWjcyP9bbuqRcqvAItXkmtIjz649cETT1vt+47SKesUTSqSbNMh3QRgPSzYJBeOawWYT+GyXurroZLeb7O0swuhGedMSSBLIb0T9/H8lmsK8YXi2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898636; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TIi9Mur9X6zwwdUE+wQSXgyPnflDM2JkncG2BKJL9UrSpsWUXGLeDWWLxUjqtcbbONhM8pCisppR02knMqP6PELhaKr2Ti8N5raGjdXy0ODsI6VraOQUnhxAh/s3aH8bzcoGvwTSOWiuGOHdpLAXgCRy1Y2EC1VDKjwqYlrOc1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D2C468B05; Tue,  2 Jul 2024 07:37:12 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:37:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs_scrub: allow auxiliary pathnames for sandboxing
Message-ID: <20240702053712.GA23155@lst.de>
References: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs> <171988119021.2008208.14026851256345116344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119021.2008208.14026851256345116344.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

