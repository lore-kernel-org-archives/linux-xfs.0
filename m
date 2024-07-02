Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0FFBA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902749; cv=none; b=pgyvts+F3iWD6avCc5gtFvjFrcsavcH5G9Cwl8+JcRySSgKdUqrt1B/D4Yk/zp/9jsxEBFzbID+8xQSdoKiuFSPD0ZCIqV5vNI3Y9crmsLlnxy+V/14higOPKbn1COS7mEZnwrvEEZwYiA4gyF2maEa++EyX88wE/VyH47wLems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902749; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuXFndhKRa/Ns8v2NdIWDgHGuN/rfgkYoRK1gq9PUNA0Q8ZI5pQLVhUiuj+kDMcTyOG5RrglhUGWMVwecVWyXYrQ2DggbN4JlnW2v+JHtWtUMAKgwDeC3xTenJnlLmHPNP7cJuwPU5pt7EO9uxp90fPwxvL70NbSNco68scxtFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C749668B05; Tue,  2 Jul 2024 08:45:45 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:45:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 07/12] xfs_repair: move the global dirent name store to
 a separate object
Message-ID: <20240702064545.GB25370@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122273.2010218.9308056457503800032.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122273.2010218.9308056457503800032.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
