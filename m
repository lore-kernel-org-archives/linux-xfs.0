Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2563BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902832; cv=none; b=XqpeD/FGHwOG/cdz5BqzaEPlUAJkM/XqeVM9VHidbTH/oXdLl+4g155WoBpwoGBYMBiMq5dXKWoUTo/Hjwt/sq49qhVDB1u1Mzz4Bkzt6BBcHhZzppYyiDR2OnEUw1qha7dlsPHeCB0fh3JqmyevqfQ14JlR+cfVajjcaWSqvNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902832; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7eXmK1kTpwoJoZRLfTggbs8lssDmEjxC80f5yO0Prd1FiP4N+s9I07Y7mMEdogX2B4+ty4IsNNFOSjLbAx8FCZpapx7EymtJ3SCb1Wkf+okZpz2/6wcWSVsZ+9aqWG6yRdIWXhQa0xZZTaa3gCiw614Uogt+kU2f/OgWRz951Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2DC068B05; Tue,  2 Jul 2024 08:47:08 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:47:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 09/12] xfs_repair: check parent pointers
Message-ID: <20240702064708.GD25370@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122305.2010218.16086560804318113038.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122305.2010218.16086560804318113038.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
