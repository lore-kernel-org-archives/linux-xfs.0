Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DA05473E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902186; cv=none; b=J5ACX6hGkmXMWI4JpUQDOHeM0rYPIBF0jp60PbSf1so+pp8+LSKTiOLspC0XQNTgR2+8dCKACCbbe9nQCFuo5xUz18iyoETD733/uj57tC+I5TAesV7lfvkprW6QXE991stq2Lkgu4dfYomI0AeYdkBJVjMoa9yiAbyGlC5J/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902186; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vj4jSg+5ru3WYIiPqPC4JFt1jyW4PzqLTnbP09mr68Q/ZrGpw4elNd83RgKsRf7jt/krGuH4+p+FsJtbOKks9Mwdm0EtMrysQTCbxzI9PG9OX4b+9vUKJ1TNZYeCcGUyuu/DO+fhg/sSSvPjetU4tJueCq8FmiRU1w2TTMX+PIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F29568B05; Tue,  2 Jul 2024 08:36:22 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:36:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 19/24] xfs_db: make attr_set and attr_remove handle
 parent pointers
Message-ID: <20240702063621.GC24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121357.2009260.1818577364230485511.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121357.2009260.1818577364230485511.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
