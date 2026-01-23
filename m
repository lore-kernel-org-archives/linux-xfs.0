Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DB8318B80;
	Fri, 23 Jan 2026 07:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151620; cv=none; b=QXI1dP2DCW84tUrY9096YWwujgCzITPH7OZ+3udrgi38z7plku+umDkddRRwQiKp/lK/vM+BnjhiZFclnXXy8IpMuZbhtckgKwzMvtJXwmt6xqUr3ylU3saUUHxPXrXKA/eE/fKV65RC0g+sMkp/QweynWj2gmv6WMG0Xot/jFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151620; c=relaxed/simple;
	bh=xWJlC56ytp7VaBP2X6LppyLGFBh0JYwPRgjL1tBKTiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgio8ycgca8MS4pRk1acQPK99cfQ87L6Or1xeaGodvGngeIildkwmJMvPoaXcrhvyDngd5X4XNsrK3n9LUL66IR2m4Z91yoOdexQD1LQvUP9gPFXERgWIflfLyDaLfq55IKJUHEy9a9qltdxFCfZTL/URssvf+9u9lo7DO8+xqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRxDrkNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRxDrkNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169F2C4CEF1;
	Fri, 23 Jan 2026 07:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151620;
	bh=xWJlC56ytp7VaBP2X6LppyLGFBh0JYwPRgjL1tBKTiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRxDrkNv+iEOawQ+KOrhTYBVnCoBZ5Ccs4ihA9O0xmegSB+Ji2dSZ8oxELTtjurUh
	 ifimLGe8WppqhN5k8M4ZutPBAC7kU/HDMWkKNNuf85M+SjF57S2cFq3qVq6R6Ysgfx
	 zPjMKv/8pKqae8jRpuEh39UljJKsU0FjiyJY20zsFWhWNOPTq1MxB2osUY4FHU9z5H
	 dkQYDvy/rZGMF/7dV9rktRcimnrOJXkvhoP4oV5rPbS5xwVfAf5nLUboxdeU1stkHE
	 uEQlbICmKoqR2OS6CRwe7SDHVkRnVr6WGOFrVYE3EZwTs0NVz37jaAzCvnNzvNzcGk
	 q9u92XrhTGmuw==
Date: Thu, 22 Jan 2026 23:00:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check the return value of xchk_xfile_*_descr
 calls
Message-ID: <20260123070019.GO5945@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
 <176897723563.207608.1472219452580720216.stgit@frogsfrogsfrogs>
 <20260121070323.GA11640@lst.de>
 <20260121182208.GH5945@frogsfrogsfrogs>
 <20260122055748.GA23964@lst.de>
 <20260122185701.GO5966@frogsfrogsfrogs>
 <20260123053323.GA24680@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123053323.GA24680@lst.de>

On Fri, Jan 23, 2026 at 06:33:23AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 10:57:01AM -0800, Darrick J. Wong wrote:
> > > > Alternately we just drop all the helpers and kasprintf crap in favor of
> > > > feeding the raw string ("iunlinked next pointers") all the way through
> > > > to shmem_kernel_file_setup.
> > > 
> > > But wouldn't we get duplicate names for different inodes?
> > 
> > Yes, but that's only used for readlink of /proc/$pid/fd/* so (AFAICT) it
> > makes tracing more confusing but doesn't affect functionality.
> > xfs_healthmon just passes in "xfs_healthmon" and I can run healers on
> > multiple filesystems just fine.
> > 
> > anon inodes are ... uh ... magic.
> 
> Ok, that certainly would simply things a lot, and I'd be ok with it.
> 
> My ideas didn't really work out.  The last idea I had was to be able
> to specify a prefix in a new method in struct xchk_meta_ops, but
> this starts to feel like severe overengineering.

<nod> I just replaced them with static strings and everything seemed to
work fine.  Will send a replacement patchset shortly.

--D
