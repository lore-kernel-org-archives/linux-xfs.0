Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D58288BD
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 06:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718692691; cv=none; b=Oq8/ywuh88wcEyDtK6jmBQaB46g9JbNb7z+xQ5O8VSW/9NDhsXG3VGbkCX+YW9/cZDdxdWG0/HtQ2iF5dePgrhUJ01qlYdeOwmt3KEJp2Wp/yK4CeF27mQgg9uUbn5h0Iv61UTI5ZpF2k+3IOYbNUYev0eIkaoqj4j7HcCP3kcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718692691; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S25JQIRkF60GM1bMRHyUqeYawqhOpOgQZuh+FlLKJMy+K0AVih0828qTeC8+5hdvrpG3nQ0xmi1lpOymHiCZUHCyujfzcea7uhPugeLrgGqk0CHldmFOBVixdYfrNWp5d+P1XSXQ91gZQLN5/6evRZiAj903mz3asPkZqGJBxBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A17B767373; Tue, 18 Jun 2024 08:38:04 +0200 (CEST)
Date: Tue, 18 Jun 2024 08:38:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1.1 5/5] xfs: verify buffer, inode, and dquot items
 every tx commit
Message-ID: <20240618063804.GA28552@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs> <20240618001817.GA103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618001817.GA103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
