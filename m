Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6A62AD17
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901647; cv=none; b=kdA2aU/GgXi+nYHb8ApWVt1xrJwOPLFbPQA5QvfNuYrsMfdBgQO4HUwy5haxizVcKj6isdnvDArFc/1b4bscibufWVE9RJK1Vxq8aM9vNnsn9r3kKj/VtIyM4NG3Lh4Qpln6yuZQ5VI38ap+15iciVyos1KWm+O/GeQ2AJPzLrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901647; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAq52+WaJ5YoXTZ7NHvgeRfho9A4tHhSm9MS28D0j3WVVqxqCksQa5QjbAltZVilywnHNTb/KIMSUn1LteiwpLzfpI6DZ7+xTngPzC1EJFdIVDf6IqYJxBR5+dOEaTkIXSGHVsymLzEZYau7dbQVi/aNsvWLXx6QFZ59aBgfWOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CD88868B05; Tue,  2 Jul 2024 08:27:23 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:27:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 10/24] xfs_spaceman: report file paths
Message-ID: <20240702062723.GJ24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121217.2009260.18429552066421688989.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121217.2009260.18429552066421688989.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
