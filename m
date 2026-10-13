Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92234D17B3;
	Tue, 13 Oct 2026 12:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893334; cv=none; b=oYq2naISDC/vEjuzImeXI8pEf4BtjSbQR1eCk3EUg3aNi5tvkEmjKMdHijEgaaILd9+Jythjo7rBu4Im6GU/PQX6x3+ccYqOwS1Co+jRoOL5Wh1uwjCgAR2MHe4Y7xXwzq+WLk3VeQTpANsena0wXHSUb9/Atu63G66/y03t6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893334; c=relaxed/simple;
	bh=7L3mWqLTUJVP+8Zs4VfMkC4ChfOZAWJgZcxFldPtEPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tz0tXI9IxBbLgcZrnaBKrpUVK6qTfLe9C6jAMwltDBSQVJhj41wJTuivTbqLeWW8PPxb1pRgZRNDKOaOhFsd/a7WsH1Zpw+N3/txbVfZL+S9sbXxqDyYSYBhz2kVAf8kN5EPFZDWUPtzXr88N6nIb4R8eEQsaVKZkBK3JFKk+lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 15728227A88; Tue, 13 Oct 2026 14:08:47 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:08:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: make pNFS LAYOUTCOMMIT stable the way fdatasync
 does
Message-ID: <20261013120846.GA4040@lst.de>
References: <20261013-xfs-pnfs-commit-datasync-v1-1-2a12ef89ecd9@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-xfs-pnfs-commit-datasync-v1-1-2a12ef89ecd9@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 13, 2026 at 05:54:44PM +0900, Daejun Park via B4 Relay wrote:
> If preferred, I can factor the end of xfs_file_fsync() into a helper
> that both use, instead of exporting xfs_fsync_flush_log().

That feels like a bit of overkill, given that the shared code is
just two function calls.

> +int
>  xfs_fsync_flush_log(
>  	struct xfs_inode	*ip,
>  	bool			datasync,

... but maybe this helper should move to xfs_log.c and renamed to
something like xfs_log_force_inode?

Otherwise this looks good, thanks a lot!
