Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AC488208;
	Wed,  7 Oct 2026 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378280; cv=none; b=pZZ8WpPkMiDmIWWlCBI/our7bWlTAjnvsGfHM+olLOA/ej/QAdI5mRKyBqtpix36uTGlpBBFiSPzw4Eah/cGhjIGe2reAGPGpv7e1w3IsWehSk1tpfnsgU+MeJkKpcA+5RL2FsK7vs1kysSuine4ufo4GYgqaMxUODoNXj45RFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378280; c=relaxed/simple;
	bh=mivPCUH5JWuKjtkJUEPvxe0lueWKWBnTJwucU93o4mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1CrFW3lqJQrXobKDJWIYeG37QLxo9df+1gRurbRGRsX6oE1CcpGaO3I5jsypGlY4a5zsi+b//VWFhwtPJFUYRLw+dKSH07tIL14PnD77jZ4YJoRpn4SpsI2foOHYq/OX4WzZBiDPFlZWNowd7XpHESTi/vi7bHRfKHVm9lPvT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eNo3zAL0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eNo3zAL0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q5JV1FrDq5XKpYdaQ4VmVOeN0M/evfDov3VTX6Q6dfg=; b=eNo3zAL0iTgcEAWcWXes+bCdJo
	rUyNqhw7xDwJn1OUs+hp7orQiVaQlOU4nGXoxZMUSZMXd8VJ16EZ/f94qN2NvVXOrl513JQTPWTBd
	S0d9/aww/O6bEmQJf3ND5CV7wWtMrVPpONqoujLkOPLWsmrli0C9zNKafyJdlag7akgL1inqe6Ocf
	7Mwk2hPhYPXqtdfeR/Rj5HrJawIKhvnVLNVSyaVb5NfDFjJUINfL6zOLq+EnHYqoXlbmef+FwXtYJ
	4qYkSAACmABjSQD7RFZDif/MgcSKlOC289u1vCkFpTkDLZMGiNV27BtQJNXTZvJ6yYLEg3zlHY2sL
	SyvT++Ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERJu-00000002V7q-1mF3;
	Wed, 07 Oct 2026 13:04:30 +0000
Date: Wed, 7 Oct 2026 06:04:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: propagate errors while checking null siblings
Message-ID: <asZDXluC2F5Zya7e@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965138.614350.7315633319922629881.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965138.614350.7315633319922629881.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:56:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
> doesn't handle it the way that it handles most runtime errors.  Instead,
> it drops the error and keeps going, even though that's not how that's
> supposed to work.  Fix that by calling xchk_da_process_error to set
> corruption flags and then jump out of the flow of execution.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

