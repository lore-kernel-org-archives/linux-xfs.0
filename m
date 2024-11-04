Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B4616EB76
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 04:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694412; cv=none; b=fSbEA7JNORz0NqLAq2JlosqtV6nM7/xgpPVIB/X4Mn8mhVMQ70AqNfgJ60MS/beLBvhjB5zNum74qRWq8hHsRsZPW3l+tt0rHvwSzOkQheVPH7XhU87IWTWEEmVJYvEaWFAwhpKRuYzrlmnpWee8LjPXXTrtBHHjafCCr0grEQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694412; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVTiEiz5dJZd6ORG25htxftbJSrcv4S+aQO5wUTeV/0292gNcQi3ZrxecuVGxCsDP54euEpQXjzXlWRRc8DNOoCpF0fxwZR0FgpG8WI/dOD0JP5o/X9H1EdVYxaCPn+TTJHrC0WEizAuOkutEf1b5BdJF7OJEuZjzHnKJQIbUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2BFFC68AFE; Mon,  4 Nov 2024 05:26:48 +0100 (CET)
Date: Mon, 4 Nov 2024 05:26:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: separate space btree structures in
 xfs_ondisk.h
Message-ID: <20241104042647.GB17773@lst.de>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs> <173049942785.1909552.1399958870612921080.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173049942785.1909552.1399958870612921080.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

