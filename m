Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CFB35F5E0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780381976; cv=none; b=EjkcPlCW6I5Z/IGds7QkJHVYS71uXic9y4nqFHBJjzHMEu+l/GCjfCPJd/3HYSyMZeq9O4IgnHoYQsqintLweW7IpQV7DssdWntlZ+yC7xqXUX8nU+iwuyJnEilhgWSgkFqXBLG+NaKTe0I5Ju85gTqui0vzyn1ttoLejXwnUck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780381976; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOanKe2Fb6AltiL39LZ/XwN7MbJ+YqteYNWVkOyJQNdBKWvb0yE20DCnIQ2aCeg+yTardHKhO3/M0G4M+74S+dzZTEKu/zsW3a9IEwaBvSNNBzwWK1KwY+3k9+92o/f5EQZTUiG+YN2d3OP8NBG95RWABTxGcMnE7vbC+MtmVfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DD2468BEB; Tue,  2 Jun 2026 08:32:53 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:32:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/7] xfs_healer: fix Makefile errors
Message-ID: <20260602063252.GE2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627135.588879.17876889855063986521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627135.588879.17876889855063986521.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

