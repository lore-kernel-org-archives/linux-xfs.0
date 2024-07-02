Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5132A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898096; cv=none; b=dFQGKu+EFdrTGJOFKHS1h9ft5xZIvLP7ZyOZclLrTB7mYit7LVPZmHh7dPM0TQAiGJImCyRgIZVnRXodGkU2+RIhScZhdTp11TmRO8gauufFlDDVUE589pJZ59jQK/12VWI70HJZZazOtBxdz9ny8zgYyJYwLcx/gww+GUDKAJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898096; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K72csfuIXpoU9fCYzo9sxH4HV5r4BFaeCK5j8xhB+VZ0Pf/JGao18C6s2yimsXlQsHYzunzK26RgHcYuV7+XmwO1mE1OcaNz3qIEE9+Ld02xx+IcEUfuvsYgWnB+q28ssVnaSAqNYqLgxTUqK4Lz6FxJp4+a3zJjxGCVN7vWF68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 77B8D68B05; Tue,  2 Jul 2024 07:28:12 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:28:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/8] xfs_scrub: report FITRIM errors properly
Message-ID: <20240702052812.GE22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118206.2007602.14308985688503230669.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118206.2007602.14308985688503230669.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

