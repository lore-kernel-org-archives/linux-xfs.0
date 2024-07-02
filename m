Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644722A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897821; cv=none; b=It5HJduE+Zl7o0wGXub4NNZMKfgshWxtQogKQ1j8WnLUYJ39DgIjZN1/WA+E6bKL0BjCfBdFi4ahuhBZ6wCSJibXL97UIjlsbpaDokJXvmxXCW47a9pfBXgGLFxWyEsw23+1PX5SUg8dpf2MgqPfDySd8kZ/HFaRqiUZv+IyUJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897821; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYDT3F2whUbJr0azKfMc2oZq12SKXo8YsxTVY7dmUQLKeRe+YOkk7tf5DRHGNqRVxHQuNTjjAqfjb7Pdp999UqsYczbRZKsZkgPcE5QCvgjs/5iCiepyEsAN+EWXuUkog6jpooO0d8ifjfPQcmiPgqaMq6OfKF/J/wLUECFM8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B7FF668B05; Tue,  2 Jul 2024 07:23:37 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:23:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/13] xfs_scrub: store bad flags with the name entry
Message-ID: <20240702052337.GJ22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117716.2007123.15452278521191859205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117716.2007123.15452278521191859205.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
