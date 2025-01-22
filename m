Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34514A619
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 06:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737525766; cv=none; b=rPBCIh+W8oVjiRxDc9JRYXKegzP4Jq3nzrsYzEvyyuznhqPQ0g6+vPY5EPM+DrrKHuI1eLwSaPAD31ZX/pMOEOzkmHfd3wD0+JLg/BOFsYD269wExNRUlghcvhYbzlPaaFana3vBA6fIEAgYbgfWnBLW6olISjKQmVYxr5yo0JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737525766; c=relaxed/simple;
	bh=Q5bWK79BzPSfRQgVpSdLUXVLQ489D1tQAAHcL0jfNa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBm/XJv0tGnNxJ/y+PsGLLXxXfTGu9WolaY3tW7h9rufqpCcoO8OH1Jys/FjCdQ1W/LK0mh85TRCmnKa/cnADTcl9Tz0fM5Mb3jMgUaZZ0W/XB/bjdCXVN06rIbcWhqp7RyCDk80ftFXEc5vmeS5adu56bSoIJxRUTX/KyZviMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 249D368D05; Wed, 22 Jan 2025 07:02:31 +0100 (CET)
Date: Wed, 22 Jan 2025 07:02:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250122060230.GA30481@lst.de>
References: <20250122020025.GL1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122020025.GL1611770@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 21, 2025 at 06:00:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xfs_scrub_all program wants to write a state file into the package
> state dir to keep track of how recently it performed a media scan.
> Don't allow the systemd timer to run if that path isn't writable.

Why would the path not be writable?  Do we need a different place for
it that is guaranteed to be writable even for setups they try to keep
much of the system read-only?

