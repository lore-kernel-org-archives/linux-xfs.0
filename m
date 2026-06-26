Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C39149C6F
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 04:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449900; cv=none; b=YaMy+RunoYCs5vrf9a8CJxks86ijPi7QO9jao73QSXo13ZQ4TNMvD8waXNjGxVvVzBWuF+0SQqjMZCenQi6hnywRzjyuMCPjsVXQPpNOLfoRGeIWApmmwisHPtKN6B70DP0o64lKuSjcyRIk7UJ0KNe38zJR9MgltRmH0in7cD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449900; c=relaxed/simple;
	bh=AlZr5UE0y9yqqNIl6k+OHmwm3oZ0DkWD3IfiOqL9psY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuNdCUvKx1ZsxHCLYRCGw4aIzf2/lYPYFDqU5ee8wAvjRPbvxgwTcKCQdltPsQeludLC0ZIDijAtYQ0+gf6gio056kK2zTRqWTPyr2NJhaW5bMVwdrd1CITc3zQo1SunzXd0TYIKYg3uLpGMA3167OP9y9wOo/E26QeuR+IcGUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2360C68B05; Fri, 26 Jun 2026 06:58:17 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:58:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/8] xfs_scrub: stop user file scan if caller already
 aborte
Message-ID: <20260626045816.GA8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801323.1981574.6328414059926266139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801323.1981574.6328414059926266139.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 03:54:28PM -0700, Darrick J. Wong wrote:
> +	while (!si.aborted && (ret = scan_user_bulkstat(ctx, &si, &ino)) == 1) {
>  		/* empty */
>  	}

Style nit, but wouldn't this read better as:

	while (!si.aborted) {
		ret = scan_user_bulkstat(ctx, &si, &ino)
		if (ret != 1)
			break;
 	}

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

