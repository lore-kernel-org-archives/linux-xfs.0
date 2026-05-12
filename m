Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B6B379C5E;
	Tue, 12 May 2026 07:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570432; cv=none; b=W0wNDpy7IWhlgxGAl4BUKSY5jP4NfI48FBVAdHdkk4sczHPWtiVdaM0ChFdyBG557c1+ZRa4Hy3v+5Zv8ypSjVEvGyu6IN5M+WHIiRPBjEiHfQRKYjcdmjeZu9oWiwjoXutb3IvUuAkD2wUC3c6/j+wX9bnJOdlAgHDFFH7vkmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570432; c=relaxed/simple;
	bh=WO5TyXSQt3jZoSF/CLHx8igk7yg6Gis1Q53sIKXHzJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chrVct6NfREA0uQhR96K1D1wXwv6zcux6n7XQfglxQdmPnHv+L8tvutOMjgeukIF1QHO73BP+U9tZT+S1ihOPADkTcZcqLXXh/xPP+H5ybClbbrLIwNAMTus9VdzAngf4K/J5a97I0NgSqWbES9Mr88xXD1tWuhvM0dTBv4+ONk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB1E668B05; Tue, 12 May 2026 09:20:22 +0200 (CEST)
Date: Tue, 12 May 2026 09:20:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
Message-ID: <20260512072022.GA32622@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-2-hch@lst.de> <03dddf72-8755-4ebf-ba79-456377f0f25d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03dddf72-8755-4ebf-ba79-456377f0f25d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 12, 2026 at 04:08:35PM +0900, Damien Le Moal wrote:
> On 5/12/26 14:35, Christoph Hellwig wrote:
> > Always use si->max which is updated setup_swap_extents instead of copying
> > into and out of maxpages.
> 
> Checking mm/swapfile.c, I see s->max being set only in swapon(). Is this a typo
> or am I misunderstanding this sentence ?

It is updated by the file system methods or the generic implementation
called by setup_swap_extents currently.  So the above is a bit imprecise.

The next patch then removes this confusing update.

