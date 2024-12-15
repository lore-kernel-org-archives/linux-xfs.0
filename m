Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9198E17C98
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 05:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734240053; cv=none; b=ApfpT/R1Ycgini4K4lys0q2RV2Dpuxc2Ng+u5pjS5nEvhDDDkQ4CM9xFCreQarjEczHZTCgnrmI2E7CNq1HLcmzkV7LpNqp5KqMGy0wwnOApG3rtU2jQch4hClu25pXz/D+kyAb+g6V0YZK3Azqu2bHlC1XGbamdFwM7Nz/OMdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734240053; c=relaxed/simple;
	bh=xxfFb0ByI/jd+GI5bmPEjMWBsa7yMQsKeuPFRW+3T5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTNFzTNG9zVShWx320trQL9CTztjUFLXc6pN21ws8BT4TaRSME+WJpsxFgShAHVh9ansy6hIikszeAq/YnKfMsAFuQDnAp2nOkwlcLyc383qmcp0XSpcrqxqJUxj62MMJDHd/S5A2ImQlgduQr+toIhXBgBTPRk9Xj6UyrF77Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DF8268C7B; Sun, 15 Dec 2024 06:20:41 +0100 (CET)
Date: Sun, 15 Dec 2024 06:20:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/43] xfs: define the zoned on-disk format
Message-ID: <20241215052040.GB10051@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-16-hch@lst.de> <20241212220220.GA6653@frogsfrogsfrogs> <20241213052210.GK5630@lst.de> <20241213170917.GK6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213170917.GK6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 09:09:17AM -0800, Darrick J. Wong wrote:
> > It will be capacity in bytes / 256MB unless you found a really, really
> > weird beast.
> 
> I bet someone will get tempted to make bigger zones for their 120TB hard
> disk.

Larger zones would make our life a lot easier, but there's not sign of
HDD zone size changing soon.

