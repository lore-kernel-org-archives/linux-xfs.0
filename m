Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C6F12EBE1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903542; cv=none; b=iTNgBdfOgUDi6z8Br1uQ5qkPUo5+ru9BCc6ZuIk7MdSYHYbkXyVTi12l31HLjwMLDwjpms4H/DaOSumAfky4CsLILL+4Tp4eR0Hw/5ubWbiNbUyb3dWQW7Tt3iWoTya2d518kXZE86Jefuy2BOHF3ZKcIQAPtA2Zc6u9NTS3nvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903542; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niCKZKl5IFzGN4J35Wvb9vPe3tpnw5RDxcRKQAfjw0s41myzfFPK5Uu2MR7tdOD5cT8ZNTWtYKcLxNnWRKtWvVQ9hFeekuyBtGv5qvjFfBGseKFCP2EG64SOxAJm67oAplV3nCvIs6kZvBGqCrQFE+6pb1oocfVNKjAD5qz5Pno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3781E68B05; Tue,  2 Jul 2024 08:58:58 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:58:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/10] xfs_scrub: use scrub barriers to reduce kernel
 calls
Message-ID: <20240702065857.GI26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123273.2012546.4398258276146368055.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123273.2012546.4398258276146368055.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
