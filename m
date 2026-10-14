Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C604FECCF;
	Wed, 14 Oct 2026 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983448; cv=none; b=TfTUOLCOYHpnRYmqTeK+pHZIr7zcpbDJT75iKVS+xltsT3UoEbwjUrkXK+swImrUMPzQoTQ32ROSHAPG6vt/+O4e0Tybqf57PaS+f2MUkJQMIhjbCXOPeVWqnQalsvf/J4yDWyxB3Vt8Unfs+oX18MhDp1AH8PU391zEptrmwTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983448; c=relaxed/simple;
	bh=ce1V/vC7Ibx+vcCqURH2LWlp4CEboQAEjh7LzG0R2yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQs/XBP8nCVYHrcwfv9YBv6eg1q6pOmQKkQv3X1O1MqYv6vJL4ByAcFiQYInQ0+fzIeqcrWibfFWimZOBG1sxrys0Zq3AaJa5FYbbsKBRYikHQgj2gcIbzH3lxFoPg49N+mUkgXQx3/ZLj/pZHvbQ/oiosQPqymv0iHq53MyPJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C602168B05; Wed, 14 Oct 2026 15:01:24 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:01:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: (2) [PATCH] xfs: make pNFS LAYOUTCOMMIT stable the way
 fdatasync does
Message-ID: <20261014130124.GA15407@lst.de>
References: <20261013120846.GA4040@lst.de> <20261013-xfs-pnfs-commit-datasync-v1-1-2a12ef89ecd9@samsung.com> <CGME20261013120853epcas2p4eaaf03a8d782645c9d336cc4a5300f3c@epcms2p5> <20261014014056epcms2p5df940cfbe097b8cccce16080e482e422@epcms2p5>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014014056epcms2p5df940cfbe097b8cccce16080e482e422@epcms2p5>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 14, 2026 at 10:40:56AM +0900, Daejun Park wrote:
> On Tue, Oct 13, 2026 at 02:08:46PM +0200, Christoph Hellwig wrote:
> > That feels like a bit of overkill, given that the shared code is
> > just two function calls.
> 
> OK, no helper then.
> 
> > ... but maybe this helper should move to xfs_log.c and renamed to
> > something like xfs_log_force_inode?
> 
> Makes sense now that it is used outside xfs_file.c. There already is an
> xfs_log_force_inode() in xfs_inode.c, which is the !datasync case of
> this one, so in v2 I'll move xfs_fsync_flush_log() next to it and make
> xfs_log_force_inode() a wrapper around it.

Oh, I should have thought of xfs_log_force_inode as I added it.
I think adding the datasync argument to it is probably the best idea.
