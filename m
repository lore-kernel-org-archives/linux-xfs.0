Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9951B043A
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752593797; cv=none; b=cpN/Ha/zdXPXJbCBfetwL8nhpRgcNExqEl8Z/6l6lV7Pbqql/KkKmoSW0aCFKYOseIv85nfrTGCJL1nsAodvirMfXOHWp4a/n10TGZj9lOyPz2qPF+8na1deZwla6AxwwM/DDwUHpdowA4h6JESTl9uPuoVWNQLZPKyBaatyjWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752593797; c=relaxed/simple;
	bh=+EDwBlV7k6cJDrYTDxIATUZkUiiWIWtESTXsK5jxEc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fH5wJkGcaGcmgu8p7UKBoqVdZRwDcgBW+gXtrpdMZIeiZlZlqbws5AnL1mPpERXEJ36+G62eG+Unn0TUnyq0l1hPObI3iJRLnP1aiJRHJg8JkLU4O1mTk2XmMmtjMP4Q0Hm2cLNmTH6W8egi4X5VgZ6xnO9YWBCdRKhCXDDuIuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 657B4227AB7; Tue, 15 Jul 2025 17:36:31 +0200 (CEST)
Date: Tue, 15 Jul 2025 17:36:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: return the allocated transaction from
 xrep_trans_alloc_hook_dummy
Message-ID: <20250715153630.GB29642@lst.de>
References: <20250715122544.1943403-1-hch@lst.de> <20250715122544.1943403-8-hch@lst.de> <20250715151811.GZ2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715151811.GZ2672049@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 15, 2025 at 08:18:11AM -0700, Darrick J. Wong wrote:
> >  	*cookiep = current->journal_info;
> >  	current->journal_info = NULL;
> 
> You could get rid of all this journal_info manipulation because xfs no
> longer uses that to track the current transaction.

I'll take a look.  Probably separately from this series to avoid
scope creep.
