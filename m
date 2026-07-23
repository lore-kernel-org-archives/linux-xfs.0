Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907AA35CB8C;
	Thu, 23 Jul 2026 05:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783261; cv=none; b=cliz0vRQ7GKpIWTr6/w066tZHyJiseEMu4UkVLwHde4V2OPy40ZgqeFBOW2qy6tvGwbK3qlUnMwd9GujyWIjCG3gOVffdNsd1zTkWVdfzxPT/mbCJtI6tA0nFRBshNWwN/HfMjg4XK6Uu/UV0/Gd0OjZGh44M6aZlNC7QKN5Al0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783261; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fH+xfQxvCgBd9km+xaJlb3I8qQXtVJeFilY7tFnP9cxUoRX9vtiSoYksbVW7dszBNRBBRdD6Ka6/Fx9iwld7qydFT6AiBlMgxvTqWB1w860WyEEx2qHJBGNW+A2kekYiE/wAbx12MO5oUVp7jJhNA4D8iOZfcTlfhwwoGhI9lCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2199D68AFE; Thu, 23 Jul 2026 07:07:38 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:07:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: check xfarray iteration errors when
 committing unlinked inode lists
Message-ID: <20260723050737.GD7121@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419616.830862.9734210711949892226.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419616.830862.9734210711949892226.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

