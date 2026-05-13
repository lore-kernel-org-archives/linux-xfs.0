Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FE63A8747;
	Wed, 13 May 2026 05:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778651788; cv=none; b=m+X0qJuCZ6aZ+CiT35d/Fdi3yF7iEgGp7+C5aj3WTuk7wBC3Z1bnL4Z/eV7vwlEuvheSqT0tsSeOYrBs6tdFBlmoSWq5wj7XiRiA8MKcx+pTklxcREVtWRtskGHbtLo5ItJx1MetNpqbyzBtpe4NkzG2Vd9++sKxBENGVTwMzE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778651788; c=relaxed/simple;
	bh=s+h37/IOBmcvhCEzcH/fk+Et7jvVkVJRpnwV7+Hslrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFmvYHU5Su486fGMdo7feAfsIUnimECjTJwwMFxHFvnXdHo60fBH8MbI6u9XmAXId4R0P7RS9rE0LChYUVezfrw9leBjdLJc3b/W4QLoAZIUNzlV8LBAts3F1pNLezJlylX50+cHNuxXthBlBQ1y5GRY1zhvCVUSIFjgHw58mVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 693FC68BEB; Wed, 13 May 2026 07:56:22 +0200 (CEST)
Date: Wed, 13 May 2026 07:56:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
Message-ID: <20260513055622.GA1236@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-6-hch@lst.de> <20260512164308.GF9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512164308.GF9555@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 12, 2026 at 09:43:08AM -0700, Darrick J. Wong wrote:
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 651c1b59ff9f..1b7fc03612f4 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2783,25 +2783,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
> >  {
> >  	struct address_space *mapping = swap_file->f_mapping;
> >  	struct inode *inode = mapping->host;
> > -	int ret;
> > +	int ret, error = 0;
> 
> /me wonders why not reuse ret instead of declaring a new variable?

Because when I wrote this, the setup methods could still return a
positive number of extents value that must not be clobbered.  Since
then I added patches before this that removed that, so we can use
the same ret variable.

