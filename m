Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A9E5823C
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367350; cv=none; b=ffV/jZc/zOFC7Fw/1xq4SdWQ6fS/gko0ottgAoSs7cU/rDinxO1Ex1139uw++/w2l710E2VojKdC7PhO9W0ssJjKY5+qIOghasThA9BrgU/BBVLFjVa51S2fYNNlaMQWhpvjGSjEqcz/HF3PzzahzTmvJ9GNQhdn2qEZNKkBBag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367350; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEdPBGi3WFrjUPB8xcGQqlPsXJ+nn2qEVn0xHcLhkzrvvFV4X6BMUI27+LgbeT1iorNrvUp+CIA4waE6UsFxVzEySfXhjOdX2+eehVwhep56fRXdE+vJKLzxQ8CxqhYh2Nam26kQNbWTnZlo3iGaTOXVK20KAOCRJHB7tOQmP68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cl2tcovi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cl2tcovi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cl2tcoviimgaSdrFx4aZG2leSd
	+l0BNWrin6mrve4Fs6jO8g0KFTbZoEMYxPglKm9MnLaZLL/jO99Vnh6XFyNqh/+Zatt56MuLvTwST
	47RsUwrv04hRZ/zNdoOC3geoGimqo8Zhb/Q3y8wnBenIkgQXOAWjH9qFPgQo4mO54wnrx39h3GkOZ
	tn5nxUJmJwXFzapyeB0colEFu7IMm3mV0ag+ALdvwYl2xdu9cOwF4so5y8DC8SR88dApYj8fFewga
	adfPe2HKgSHtozmZCw6C+8+WEJtHdsXbpwIQCzrzrSXITxaVSd2TRFoESBJ11VqsbO9GiY5pM0plI
	99xKrnug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWg9-0000000C40p-17YN;
	Wed, 13 Mar 2024 22:02:29 +0000
Date: Wed, 13 Mar 2024 15:02:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs_{db,repair}: use helpers for rtsummary
 block/wordcount computations
Message-ID: <ZfIidfvSH3KAPbTD@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430715.2061422.7561733503744206333.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430715.2061422.7561733503744206333.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
