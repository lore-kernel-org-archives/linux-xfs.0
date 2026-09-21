Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2752044E66F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979600; cv=none; b=dO7i2nJHxtgn25ZVWWygVctOViU4PosAUaMnxzb1zVHGwImPBsr3lB2VezSR7sgP+yDt0sd12VUurWPg/HXm7EIXq4VhRmaDBE6QxluI71+U6I+4g6/FsklXM4DD/IBRqVSQvfHG4uH0XSvcPqg3Pt9/C+glqQCCTLbchz/niXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979600; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NUGiZc9hb4VfXVutouGjU76Pi/Dyd3erMw6CPnnnIlRWoUnKomvK4bRRs2JBv1OzlbgjHYy2cGOA7IsBWN8JyikkrbVcUE4RbASxDpNoVp/jYfQn8EcZPQdQxQHzJ3wgdE5FMn+v9Br1xw31vsjWEEE5CuLmZGoxDJbo0eK8m4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C68968B05; Mon, 21 Sep 2026 10:33:15 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:33:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/3] xfs: add xfs_error_report the ability to
 display an error code
Message-ID: <20260921083314.GA20936@lst.de>
References: <20260917103633.14703-1-cem@kernel.org> <20260917103633.14703-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917103633.14703-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
