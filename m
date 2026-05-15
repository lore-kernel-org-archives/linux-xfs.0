Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746BD44CAEC;
	Fri, 15 May 2026 11:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778844791; cv=none; b=cz0XXxwe45J+QENGGATCBi5yTNJaVXtlcn/4+VT/5PmbyeIx335pNOU4V0F8eY+qU79haFR0jcsSGuzGBnCe3FoJxNMcD7bgGIN19AeAqKa+axPzjr0zwmP+bpYTIoZGeS7DzCSIybb2EKkaQVEU8oZPMy0SabHovF5dDz1gfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778844791; c=relaxed/simple;
	bh=7k+prS6wu9ZKHKdcwKOZ5QTy4CuG/Ar32QLD2FznPlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=no6Jn9+HBW0VmYqoRIfCC57oWLIIkGbVVu70YFhtko9sfa5ZfaGLc2sFrIAmTphCUkE2oDKo/m1VmJvzCafHA3DxcEdcN4iB7bT73B9MdSAwl5o7fr/V1yv0tL9owISmXIWHShHKFTigQtsfkUU+G5NEXiWzDfLQFNljGB5PnFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E85C68B05; Fri, 15 May 2026 13:33:05 +0200 (CEST)
Date: Fri, 15 May 2026 13:33:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steve French <smfrench@gmail.com>
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
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: improve the swap_activate interface
Message-ID: <20260515113304.GA24980@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 13, 2026 at 03:34:03PM -0500, Steve French wrote:
> I just tried this on 7.1-rc3 with the swap patches (full kernel build,
> on Ubuntu 25,10) and boot failed with out of memory which I had never
> seen before.  Any idea how to workaround this with the swap patch
> series, or is there a fix for this in the swap series already?

Is that a failure with the patches or also with the baseline?

