Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDE22EA15C;
	Fri, 23 Jan 2026 14:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177613; cv=none; b=uPg4gTUNp6rTIuvJSR6ujcg4OB0UigLvuhxe2XjbOclowsXSqTOgdM/mtcRp4g1K04dS8vS1vby8crZH8lqA37rxOSgJ56cK3YjA7QzsdNUQhZbFMZY9NFpBpbj92ACJ1VHh5rZl9ZqTxFI8Zrlq2pF9zvFUWWI/TmLv4aRZitA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177613; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=as8cfmseFjzH+G5uKmMK/vBoevFfWWZJQboA2ADVPjiIewPxzmCDvB1LPqSTYIT+Kf+5VtRa1JESfNxIph8NaKGMyDfl3N9JE6XwrhXytjc+SDjzfRedZVzqLW9x3cCWcphBlqlJL5uqnA+sT/lI85Yhzr9wpCvmkEAW3LLerDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B28EE227AAE; Fri, 23 Jan 2026 15:13:29 +0100 (CET)
Date: Fri, 23 Jan 2026 15:13:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/5] xfs: get rid of the xchk_xfile_*_descr calls
Message-ID: <20260123141329.GA25834@lst.de>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153716.1677852.3636395936252128481.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176915153716.1677852.3636395936252128481.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
