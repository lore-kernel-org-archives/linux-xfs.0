Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A4161313
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712335258; cv=none; b=ZXrRCYrSCTOwu0b23fsE0AGyWbjTSG7QunCHO99GSPSg96vKd+mth6kCPiG5SOmbb0Aac0zAg2TRtDZm+PxBLp8xpwtffxzbh6iLbTo7lPvaQvSSVjtEAZPCLs4/TbgHR4yyIM2yHm9D806RdVSOPc9/d4V7kxLk6ALW6FcZaBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712335258; c=relaxed/simple;
	bh=qXq7kqUs8IUF8fgSyKJoCPEzw6Ha+WpRgrRbfDuwiJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkuYMPCWL54TJJYq4zlrYiob3lkio+BcwHnKMEYP91INvZLep/NFp9l0gvbwzNlgF3GZoExkY4aItHpmHXEWuzZAReJYarCTgUTDZNxV2HYptXir3wYulghnUWA6zbqxCNzGLw0cZCzVi286jlCnVh9coLkcvVcJcM+NiVBWr34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFB4468D07; Fri,  5 Apr 2024 18:40:51 +0200 (CEST)
Date: Fri, 5 Apr 2024 18:40:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move more logic into xfs_extent_busy_clear_one
Message-ID: <20240405164051.GA14726@lst.de>
References: <20240405060710.227096-1-hch@lst.de> <20240405060710.227096-2-hch@lst.de> <20240405154429.GZ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405154429.GZ6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 05, 2024 at 08:44:29AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 05, 2024 at 08:07:08AM +0200, Christoph Hellwig wrote:
> > Move the handling of discarded entries into xfs_extent_busy_clear_one
> > to reuse the length check and tidy up the logic in the caller.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> AFAICT, the return value of xfs_extent_busy_clear_one is whether
> or not it actually changed the pagb_tree, right?  And if that return
> value is true, then we want to wake up anyone who might be waiting on
> busy extents to clear the pagb_tree, which is what the @wakeup logic
> does, right?

Yes and yes.
