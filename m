Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB451C84D0
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 22:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740436111; cv=none; b=XaGZLbwedetMGsbyw+LYoSynwk4/rrJZODP+wPVlrW7zHrEPSsZsuqDoIWe44jAf1hwNoZVn6tFDhHv8qt7DtU5p1fyZ2AI+E2ObKQLsZZc7vyJZ91AE7xLm1CI3Yc7VKx7DNSWCJWtWfFl47qNEipzeW1TvOguZdWfO+Bvd790=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740436111; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPiIR1GXav9iHTYyKzVPblFOFGffAIS70KDYunaLnMfb+sLkg+oGkxl945PcENP+0e+SF8/JNhDA7nXQB0TaWQu8X0UjLjYVHCYbgLXfT7nU33q/Vj0hsMiE0HI6oxrnTT3axAWt23q9afBWHe+uFwgEN9dogfVeG8hH2HzFghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2E3268C4E; Mon, 24 Feb 2025 23:28:23 +0100 (CET)
Date: Mon, 24 Feb 2025 23:28:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs_scrub: fix buffer overflow in string_escape
Message-ID: <20250224222823.GA15469@lst.de>
References: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs> <174042401290.1205942.5986684789242095979.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174042401290.1205942.5986684789242095979.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

