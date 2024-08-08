Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2614A18C32F
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723126205; cv=none; b=W6sdrARMguNmulVPXYJYDwGQmyQ6hfIw9GpsrAtf0lEFT1dH1mDigwazGy4TyvUTqW1MIJOzKbmCyz75MyAI1b2eOg/U80bap0CNogUdt0BvE+hN0Z3GkUnbuWqQt7jEAvFRY0EjoQQ01P29McrSzufpWEMgeqdX7ENGkOxVhR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723126205; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmK91S9W10njZOerfSykJr0ZsFpATWtQT0bildpUBxdCRfkqbPEjF6xuFYLQx9amLFWgrgyP8IU+JTTL5++TCHNg8dJeLTchcYT79+92dmfJ91zUR0DOvw7CVE/+grW9RYhRsv5/it8epz6RlxeMGXbUyOe5y+pRi5e4XGvI4Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 02B7668B05; Thu,  8 Aug 2024 16:10:00 +0200 (CEST)
Date: Thu, 8 Aug 2024 16:10:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] design: fix the changelog to reflect the new
 changes
Message-ID: <20240808141000.GE22326@lst.de>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs> <172305794161.969463.5451370159032939139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172305794161.969463.5451370159032939139.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

