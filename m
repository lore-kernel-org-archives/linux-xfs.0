Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09BD33B970
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783949514; cv=none; b=LKScn0LuH+8JFrBLKY11RyXYkQLBuJs3nlPNI30w6spneFbzWQdYj2cpowhU/wYaerK4c4Oamj/X4qBF4NPiZtomIn8ZtVL0bZ1ZNIZAFZ6PaK6XsnMxjv1f3chltkElgd4PX3gYpGYnV93QRsS+jz6FkbcXyWoX7n+E0YrXrV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783949514; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuK+15xYyyF3KZRaOhdpGFOw7vFaQiKB9OvwVSUCJqZMnNQSNtfAvXtZkAmdYUGoMcd4wEve7emJ/+i7qOiWzMkaFkqhgk6ruYVpPLJ8otUqZR0/v+asVX3yfuJqBSv+GseSTwajTag7B2YNlGSpABxI2RIUBwAJOEc2uT10FR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3040468C4E; Mon, 13 Jul 2026 15:31:49 +0200 (CEST)
Date: Mon, 13 Jul 2026 15:31:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 1/4] xfs: add xfs_metadir_create_file helper
Message-ID: <20260713133148.GA25950@lst.de>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com> <20260713124250.3978-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713124250.3978-2-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

