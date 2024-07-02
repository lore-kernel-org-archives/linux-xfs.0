Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E61112E1F2
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902523; cv=none; b=haKTqNGC3VNs/LyuqZ+MIQQJrD6nW3gPE/FkMcKTA1ceWNbxsrKNEYQLRQXX8wf4abJqS4+Ova8OM2eBRj64/5D0CKvb8qseZo3suIztELADP6g8FH6Bsx9bwE92uw8OcggB/h6x744kRw2CZ1MkkfFXX6ORbuiCJtCG9qVZASA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902523; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pt3HJp39drtDT//mXw9tKS859k+u8frRCM78Pz10Tk/BWktGUBo9jXAfT6UVO9FRntmDPTP5C3DgeqUlhN5XmsQWXiF3NFJXRun4dvwxHeB0vCi7ZPz+J5rw2v0odJEOiOOrtrRm+cwzF22DGvXS6qqFjyT6Xq3ICw53jICh9eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 51C6668B05; Tue,  2 Jul 2024 08:41:59 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:41:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 02/12] xfs_db: actually report errors from
 libxfs_attr_set
Message-ID: <20240702064159.GB25104@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122196.2010218.8191843801782872283.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122196.2010218.8191843801782872283.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
