Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F97D54276
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244218; cv=none; b=Kjz8lPD+2bzAcFYxk8vwMWUgPYp4PpuLAI9X0udgAPgFkybh/7HEjS85XiQERXXEEpIJjh1QrcHD3biMbQNThWUmOeG20b3MUY3yxRA2DQEX/6GIjuZGxuOk1qJQfn54x+FJ8B93s7hfwT/a9kwFHq/4nJstqfUtpjyiMfN1qeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244218; c=relaxed/simple;
	bh=s1oN8TRdO/HxDKxd4q0VwJWDIqs3LXD8sBlIRhPXa0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7/48fb3fw67OnLUiL+IcrW9Wza6xvPWYBaSB2qcX6dtMJYNeCcgqkJbWMntKnv2tEqOHfSzOUfvuIJmAvxwfgEisKwtjn2Zar0a2j2IwLEfo+5CcPhH26mF+0Qbx6mL7J7kg8a8asbN3+5+vkmTKu1/Ir04jlM9xQgj+cZK2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E6CE68D08; Mon, 24 Jun 2024 17:50:12 +0200 (CEST)
Date: Mon, 24 Jun 2024 17:50:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: remove the i_mode check in xfs_release
Message-ID: <20240624155011.GA14874@lst.de>
References: <20240623053532.857496-1-hch@lst.de> <20240623053532.857496-3-hch@lst.de> <20240624153459.GF3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624153459.GF3058325@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 08:34:59AM -0700, Darrick J. Wong wrote:
> > -	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
> 
> How would we encounter !i_mode regular files being released?

We can't.  If that code ever made any sense than in ancient pre-history
in IRIX.

> If an open file's link count is incorrectly low, it can't get freed
> until after all the open file descriptors have been released, right?
> Or is there some other vector for this?

No.

> I'm wondering if this ought to be:
> 
> 	if (XFS_IS_CORRUPT(mp, !VFS_I(ip)->i_mode)) {
> 		xfs_inode_mark_sick(ip);
> 		return -EFSCORRUPTED;
> 	}

I wouldn't even bother with that.

