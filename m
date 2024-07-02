Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCD41487CE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902535; cv=none; b=G7A303vXh4DV2Y2qH8XQfKFXG+QTn5Ai1bObdPnEsVi6gQ/iHO16IgF/NnXuTSdBt9QgC8OZlwvK/iYD6Imyar431RZeBo1xiX62A80CXad0VnZiVRKu5XYyrzqEV+DxR2GMoVwXPIyW2bm/NgJTglJoSG9eFplppe9B+b3eEnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902535; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCXz/2HoMgk8dt/yNxSFgT7aUq0ZRN112AMeL5xv2HpnaUWAR0dBTCnoCNNW5LDZSeXi/rcBcYhX9AHYRL3Wm3Yyo4TCGtzHtrak80Ili+zTgx/mEFqU1agUkog/15wRjYUIAu/1pC0lOGZwHh2V3GAwD+L028REDBOvHuPOZ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8BB3968B05; Tue,  2 Jul 2024 08:42:11 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:42:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/12] xfs_repair: junk parent pointer attributes when
 filesystem doesn't support them
Message-ID: <20240702064211.GC25104@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122212.2010218.8882336678990830158.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122212.2010218.8882336678990830158.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
