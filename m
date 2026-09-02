Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C0824DFF9;
	Wed,  2 Sep 2026 05:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327100; cv=none; b=WD/N20MKnYNLhEc4ewOovqB0NwtAaIlLK5QmSekDV8N9E/8HcewRCl+voXRg1GRkPtqdbBGFqPHmfs+0rQnn5wnOfQ0hMtugXzV5cQgKWDKl87qyVDN/Sy6CWDdxH1iDz8byS9QuZfGsmaHrMJA55JjHqS9vZhutpdows9xVOyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327100; c=relaxed/simple;
	bh=ZOLx+MFES3tvxwuO/uu9YJrUgonPbl1nVTFmO4BQzs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrW7PeZbzPMmnldNw0SMipswxN7M3rp/ZcVMTb+pd3XnahkUyeHMIVYMa+cTonSLsSH1EBADXUlU1lJPhzdMdMi2OXt6K9x+URihdr0sBvdBzmTOjxestrl6ieEu7RIZbDaLcWppF7vjya5YLrfias4eI4OmhnMYMab+SkTyxks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BC8F68C4E; Wed,  2 Sep 2026 07:31:29 +0200 (CEST)
Date: Wed, 2 Sep 2026 07:31:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open
 helpers for filesystems
Message-ID: <20260902053128.GA23581@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org> <20260901221314.GC6038@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901221314.GC6038@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 03:13:14PM -0700, Darrick J. Wong wrote:
> Hmm.  I /think/ this might be causing regressions in xfs/006,
> generic/311, and xfs/264 on XFS realtime filesystems.  Each test fails
> with a mount failure due to a busy device:

Yes, I bisected thee failures to "xfs: port to fs_bdev_file_open_by_path()"
as reported on Saturday.  Besides the failures I also still have the
same architectural objections to this whole series as before.

