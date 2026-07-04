Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAEA28CF77
	for <linux-xfs@vger.kernel.org>; Sat,  4 Jul 2026 04:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783140030; cv=none; b=BRDvJJ6Fu+vJoNR7Hu5KgDCPNuUN92jJLyryU50X/UXn1shUazSY7AYk0FbXrVGo4BymvV/dTqveNZWKHwrd+GMW+97M70lr8xrmRLaXEaXGMVVjWwKukRKZJe9aDRVDlQt4ZO/1whjByNk9s0aHntqKf8IYLS5eWahvMaaSJQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783140030; c=relaxed/simple;
	bh=FVr2mNXPa87d9TlRLnGwl81l0RRi+ZN7yu0RP9t6+/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejfui8AdDlLVx3ZqdSUtAtnDY4kiMj+uSRcqNj1WWKvmVHtl5voAR7xDiBjbhatur7lzx9Hip8fuLd4tPjGdJdvcQXM1Z7tEVMARxknx6nhXcx2Q4JxpB+3EgB4QGHwo/Jj9IJWDGEMBIC+Aw6n3eLNCnTZLDJ46TiG3X5ojMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hemlcyk+; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hemlcyk+"
Date: Fri, 3 Jul 2026 21:40:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783140014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=54JqU1lfDypUXpxov6xYKoj6jcefWT6qyRoG1oo4EY4=;
	b=hemlcyk+pfxCxcSIGHoC34YYgC+z5q1NS01I7bJo/GrJoKFnHPe2Nb5klIKF5NvrQDImLN
	Bs1tgtUHtgb6V+4UL7b53JORBeq6rfqdPZLLA0tbRqtc7lM0KsGiozVB5SdQ2L949UTvok
	5kU+9A/Ms0hz9QZJcWxhxmqmZX0ZJr8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	gfs2 <gfs2@lists.linux.dev>, linux-xfs@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: iomap_writepages WARN_ON_ONCE(PF_MEMALLOC)
Message-ID: <akiNFfUYDrpKgme_@linux.dev>
References: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 01, 2026 at 10:51:06PM +0200, Andreas Gruenbacher wrote:
> Hi Christoph,
> 
> I'm running into a problem with the following check in
> iomap_writepages() on gfs2 in RHEL-8:
> 
>         /*
>          * Writeback from reclaim context should never happen except in the case
>          * of a VM regression so warn about it and refuse to write the data.
>          */
>         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
>                         PF_MEMALLOC))
>                 return -EIO;
> 
> In my case, reclaim is triggered by the following command:
> 
>   echo anything > /sys/fs/cgroup/memory/.../memory.force_empty
> 
> And we end up on this code path:
> 
> mem_cgroup_force_empty_write -> mem_cgroup_force_empty ->
> try_to_free_mem_cgroup_pages -> do_try_to_free_pages ->
> shrink_zones -> shrink_node -> shrink_node_memcgs -> shrink_slab ->
> do_shrink_slab -> super_cache_scan -> prune_icache_sb -> dispose_list ->
> evict -> gfs2_evict_inode -> evict_linked_inode -> gfs2_log_flush ->
> gfs2_ordered_write -> filemap_fdatawrite -> __filemap_fdatawrite ->
> __filemap_fdatawrite_range -> do_writepages -> gfs2_writepages ->
> iomap_writepages

I don't see anything specific to memcg here as the same code path as above can
be taken in the global reclaim. The main question is why gfs2 is evicting a
dirty inode from reclaim. If you check prune_icache_sb which uses
inode_lru_isolate() to select inodes to evict and inode_lru_isolate() has
(inode_state_read(inode) & ~I_REFERENCED) check to filter dirty inodes.

It seems to me that gfs2 and VFS are not agreeing if an inode is dirty or not
and a simple search in gfs2 shows that it is doing (inode->i_flags & I_DIRTY)
instead of (inode_state_read(inode) & I_DIRTY)). Since core vfs code is using
inode_state_read() wrapper to check inode state, I am assuming that is the right
way to do it.

