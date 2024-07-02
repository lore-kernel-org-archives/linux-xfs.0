Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F82849621
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902237; cv=none; b=TOzS8zyUXtssw8K68p1KYlWXMu+hyPhNCJNJUt6K6LWHjnIeDpX7U9vqKP0Tg0Y4LLoNBAwBueGlQ4ghSHTEjEVTNCXlzSzqFKiqfqu3LwnBo53r3U040RGc2jtmzkZWdX9Ivp3gGd8K+V+pA8dyI5RvHyZdhMf+dxrO1zK+cXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902237; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBRbC39WsWfVsfHBqGcfnoeggkmmXW9mL3znuCLPTGAXbprjojn9DpJ6DC5cVETpFK4WLf3QPyq3GgHzp4zD+bihAL+mUCff8O5rp/qePbqyGH6WHUok2K9REGIFi+EaovDtvGXqTfWxZYJNd58Z5+QTzq93N2vdMDYK7r5jA5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 39F3368B05; Tue,  2 Jul 2024 08:37:13 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:37:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 21/24] xfs_db: compute hashes of parent pointers
Message-ID: <20240702063713.GE24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121387.2009260.17240012773714059969.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121387.2009260.17240012773714059969.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
