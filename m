Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70381DA21
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818270; cv=none; b=s0yY5U1aEQwCTxYA5R3rmqnhHJOPPqTJiiDARi9oQa+wwl92Fp40SzYiQacd8TmlWdiqIKE/vozZaAVXJv1tI6JqqLYD/3n46Mvt3jSsNzmR7Id8hyPY+MnKOYDBrtGUVfQcqQG7z9Ja9/61YDz7Q7JT/eNq/ygMpz26IxnxQQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818270; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHTM/fvqXe4QS1yjjEekxhSnG1TPcNgjVbzv1nZ6ljvxTaRAIwyrYqZjdVuPqjvj1m+Wd/HauPJk/d92/G6rV6tZ62z0OHiSZi6BwNUdgKlcnuN9HBw39rb2xIogSwIg72c2t217OoI5JDPTQ/8PYFou0pGxPxG4TAoGqIilL9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21B4368B05; Wed, 28 Aug 2024 06:11:06 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:11:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/10] xfs: replace shouty XFS_BM{BT,DR} macros
Message-ID: <20240828041105.GD30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131573.2291268.11692699884722779994.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131573.2291268.11692699884722779994.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

