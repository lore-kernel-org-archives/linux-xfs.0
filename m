Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E275E30BF6D;
	Wed, 13 May 2026 07:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778658377; cv=none; b=QZ+jjG8QDgtktUrbyp3pz4qljZYrZ9mO4uhhARJFCFsUKi57qv+KNY5JgjC7AeUmsIJF0XIgz3UgcYSP+p70S2OIh3WwawJl5onEmz+1XH5/z2aI6dD+NFjclKw1IfIhOcvQjy1Nj1zfQSvQTyl/YZzE//fwDFV/zrRlHpF8JXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778658377; c=relaxed/simple;
	bh=UZSXOXRAL8kPEhm1dPm7Xpr01V9VYoK5WvLmNfNR94o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXa9uff5AEINLdLW1PxOhVQEgGcQBe1NxHAypEA3u7BTDf1gA33dUx++FxSbfJkLEjkFYjlw5cpT8yczkaHAtEWIGMkKz4seeFF+cb8Jc/u4jeRY5OE7MBhz5zoSDOn1eZtnkQbC5y7qzsk6Q6hu72TREsrzwLh0ujv05JiTZHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E742668C4E; Wed, 13 May 2026 09:46:08 +0200 (CEST)
Date: Wed, 13 May 2026 09:46:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
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
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
Message-ID: <20260513074608.GA3693@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-10-hch@lst.de> <20260512170846.GJ9555@frogsfrogsfrogs> <20260513055806.GC1236@lst.de> <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 13, 2026 at 04:44:53PM +0900, Damien Le Moal wrote:
> Hmmm... With zonefs, swap files can be created on top of conventional zone
> files. So enforcing "no swap on zoned device" here would break that.

We can check that none of the extents fall onto sequential zones instead
of just devices.

I still wonder why you bother with swap to zonefs at all, though.

