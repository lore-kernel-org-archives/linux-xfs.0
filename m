Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D837F8C3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146588; cv=none; b=cvrTgYHQEPfY0I10CQMoT7J7ro5W1HnbioedqJm864mQC80oQ6eHa5rxSpnLhdl+3VBWTI5lN5HJr91JF3I339Ro+MNOkBOWoNAr7StZMstxhC/CI3b08e760uoavKqJTsF+7jry2VW4V2ZmHI8bArPyT/On8cfy+h2Mvz+/Ufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146588; c=relaxed/simple;
	bh=Kjczueb1WGVSnPcsyZUWByAa7yim7MvyrY9VlGMam0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/+FKbRwmoQhBhG61hwlN0NZYGO+3Mnz1Ji98GK91BW4RE045lrS5NtKH14ld77jqaol+aVRVhtppwPslGNh2uQ4NtbJlFSrMwD0jLPMg8ywAiB0SHcnWg0r+vjhhf5QFDOGfybCkQG2TymVCUzctIxUPb2H/Iv3RhQMp5P192A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 84090227AAE; Fri, 23 Jan 2026 06:36:19 +0100 (CET)
Date: Fri, 23 Jan 2026 06:36:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <20260123053619.GB24680@lst.de>
References: <20260122052709.412336-1-hch@lst.de> <20260122052709.412336-4-hch@lst.de> <20260122181012.GD5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122181012.GD5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 10:10:12AM -0800, Darrick J. Wong wrote:
> Anyone want to venture forth with a fixes tag?
> 
> (Though I wonder if a less invasive fix for LTS kernels would be to make
> unmount wait for xg_ref to hit zero, though I guess that runs the risk
> of stuck mounts if someone leaks a xfs_group reference)

I tried.  It probably is the patch that initially added the per-ag
rbtrees:

74f75a0cb7033918eb0fa4a50df25091ac75c16e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Sep 24 19:59:04 2010 +1000

    xfs: convert buffer cache hash to rbtree

but as I can't reproduce the issue locally, and getting syzbot to
verify it required horribly hacker to avoid lockdep I can't actually
confirm it.

