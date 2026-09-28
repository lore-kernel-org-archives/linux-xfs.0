Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C94305698;
	Mon, 28 Sep 2026 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790578706; cv=none; b=jg6pMEwdp+EvU/0oVcxl8AUS2Q3Hpk03AGc/1ji0EtGolsIaR8LO3Joea+rmz3nDQLpdLM9+uaWooN70oNYOlEQqcTGap1mwTDBE/3i1kYVZm7M8cVAa0lB8cDUiA/hhc3hqzdhzKfq413b2q4bEzZV8M5IhITShU/Fa3xSJmOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790578706; c=relaxed/simple;
	bh=93Q/KpuxC7RyG3T9xFYzSEgMe4zvXD/hNPoxuUC/d40=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePYOdZ2CtQnZzRQLfoV6VRWjb9N4JBR3qC7me2adTQLaEiMa8eeI2XAgM4Tv5MLgTTd2Dx+kJ+MdKZ0pq84T/JS8TVMi86Nbo9wD4nZC9qTcx+Z4FM4gx9d9OqbrQGeYbQnuWyy3FONFygtgS68zEwwLo8+1Mjz0Mv3tKkFvPMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 518F968BFE; Mon, 28 Sep 2026 08:58:17 +0200 (CEST)
Date: Mon, 28 Sep 2026 08:58:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <20260928065816.GA21053@lst.de>
References: <20260925051519.3002168-1-hch@lst.de> <arkF56Qtd-kQS9jH@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arkF56Qtd-kQS9jH@zlang-mailbox>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, Sashiko complained that this might break when using external
log devices.  I'll give that a try and will most like respin for that.

