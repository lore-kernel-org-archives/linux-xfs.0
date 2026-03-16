Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B613932E12E
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 09:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773651860; cv=none; b=pNpH41bWXro5mdZrgQLQh8XA9VuP7IyqPC/cBqdC54iQSxNnb+9HizK2NNPXduC46FWOaF+nNoIogS3JGVRuCpIsr9yXXh2yI8t6SN5oejEgP6LvO9qZ963oAWubvqogoym+FH4EQpW2I6/coxkJNFQI5Ge3VnsEkjNsjbpuIRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773651860; c=relaxed/simple;
	bh=OkYftY4tVOaFN6j1RFdnPT6jcBYpIq6p8PHhIH7uPAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdwB63whWNkFuoBQvNx1yPjoaskjwRACUdUiEFRxdiHEYmxPshLGhmzn1aIZ54MDFqAMJ/UdYusmV08fRvDAw2KTAvADNyReF0sqq5V1tNk8vXC5RpUqs21Oke616IjtGznknHEl6U2eRzeOcaKGkFf7cZsaODOptHnz5zBYb24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6382268B05; Mon, 16 Mar 2026 10:04:17 +0100 (CET)
Date: Mon, 16 Mar 2026 10:04:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH 3/3] xfs_io: report rg_writepointer in report rg_info()
Message-ID: <20260316090417.GE1952@lst.de>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com> <20260313002456.3823811-3-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313002456.3823811-3-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good and thanks a lot!

Reviewed-by: Christoph Hellwig <hch@lst.de>

