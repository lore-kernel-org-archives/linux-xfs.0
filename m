Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83103B2D10
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796692; cv=none; b=ELAUWMGZaMhs1Oucg/45K671CHvX5z9TI1thRtdvoDezVdOgnakqSs0iRftM4b9+sJK6k/inRSd/oOOUmEhAJPS0sC4b+gM2WjhCIb6v4N1+32A3/lz4j5yt6ueXC7z1qbBgmyN55slSMqDIfBwv8lMObpHXmZq3mwPWr/fcxXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796692; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niMqVSu3ImZvf2hVMHdrJqq9bv+qDg0x3HMsIsducUYskAmbp+2xO1U2vX9LEO9Im5b/lhc3SFU+ib+vKywGsBP2l90KkXUSfSnOgoMwyzKtKcfrWbLKMMV7zuWwME3yquuI3I3QVhbZURRzn9xDxQjXTzXlhK2qfJXatYOdauw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6AC2B68C4E; Tue, 30 Jun 2026 07:18:09 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:18:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs_scrub: fix spacemap external log device scan
 dev key
Message-ID: <20260630051809.GA20888@lst.de>
References: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs> <178278129564.858187.17386795461050444922.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129564.858187.17386795461050444922.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
