Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBDA12C54A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903460; cv=none; b=ccCL3/jNStThp/6xwmQV8nDHKwY0HT+5oGUNy/pwOEjpz2avvnJ3bSognHRO1KXk76+ek++4yB5lS7Q4ADsPOvA1aAZBhlw1fJSO01qav/Iof0Du0tfFW76EbLysvQ6QGdoPi9TAyFOpuwwdDkaWcq6TLc1kg0OpxDAEY/uvmH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903460; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSwQS2rLAtni0nf6pYMHTYwPyYTQhgDsEh9Nkm1f1EeWLgO/c8YZLLU2Jh7dly7vGBG9CioV+8usKbZT/AQtV4/OaeKIhRj8kh3NoB160VEDQ4kR6mPP6tG9ZG3xXFzvIpvYrYrvWhAPmOUDkeMF1+1U6Pxg3iT36lblpq5QcQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB2D868B05; Tue,  2 Jul 2024 08:57:36 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:57:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/10] xfs_scrub: split the repair epilogue code into a
 separate function
Message-ID: <20240702065736.GE26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123211.2012546.6968675746772396260.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123211.2012546.6968675746772396260.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
