Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FF81DF269
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187054; cv=none; b=d8U0XLvNgGkjemQxKEvEpgQ0f/vu+5NpCiBF9rj+B7n72fyKDUwSXQ/bqnKnuak09nE4m1z/tXCvoTtjeMQf9AFPpypK6rnZ8tEZb1LZX8Ez5UNGslh5Q565w5Kq6j0fxgGv7tEuGeek4vXbo5j5hvExnk5R/MP/x++dHoddWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187054; c=relaxed/simple;
	bh=AtqFUOcYbV4UG66kjfdLq9BZV1Vv45ico8l4q1HluRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUWa6QQWtcr+1AHBL9M3abd7DuiL9XZPHIOx5sh+zq4PPQnfvKPB2670TpFgFhAta88dJjRVZ4OMI+doU0xk+uTv0ursuU8bPV3iZ3fx/NKxHExWIuv6DN/cYIYg6LSc8zQc2R6w1n7EJJ9enPaXBqhRqOXCHVO+TZ8zOinxCv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F177B67373; Mon,  6 Jan 2025 19:10:48 +0100 (CET)
Date: Mon, 6 Jan 2025 19:10:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remove XFS_ILOG_NONCORE
Message-ID: <20250106181048.GB31325@lst.de>
References: <20250106095044.847334-1-hch@lst.de> <20250106095044.847334-3-hch@lst.de> <20250106170953.GZ6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106170953.GZ6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 09:09:53AM -0800, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index 15dec19b6c32..41e974d17ce2 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> 
> Technically this is part of the userspace ABI:
> 
> $ grep NONCORE /usr/include/
> /usr/include/xfs/xfs_log_format.h:362:#define   XFS_ILOG_NONCORE        (XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
> 
> But it makes no sense for userspace to try to use that symbol and
> Debian codesearch says there are no users, so:

In the past we've done plenty of refactoring of the format headers.
Locking us out of that would be rather painful.

