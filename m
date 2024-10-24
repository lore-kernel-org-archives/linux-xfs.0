Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008A71E1335
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775958; cv=none; b=Ii+v3Wcw3QukoPNHuGOqrGOfD51pxdfkWvbX3AykmOCc6NObmELAPViA4hzJvAsKe0CLH7bxy+C5iAg9CfWhqgR9ZywmWBGhEYr6FIeH97OyAB6qMSma4+r0bF9BN5eV2sq8arq9upFdvefHPyYfWfTcdpqMoNFhYAtjDplJGuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775958; c=relaxed/simple;
	bh=KUg4/IPSz2uXjF7v2KVOvJnVnpbT9lXESWQNgAzZOoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNtH6+LEh0MiRy6yAox7duE3oY4sNKOmYHkLiqsgFNlYAew5se+k4ECHqlvh0I6u4kNCTRMtmncNX84eWoV6sKlFPfpb7YmFw2y3X3M7J/Ue4s9DPBZlLcKFfKrGo8QB8rwUupVS9oW2omdCBv7n+iPNnulLvPy5BWTPp1tde3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAqpdgnq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAqpdgnq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729775955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y+eArl/ouMtYqxGsIAmRgnol83pzCCJcNzLyiWIlwa8=;
	b=NAqpdgnqOHVUo7D5HSkGZV6xRIQV1YwzH6XgPwq250IwpAxRBh+EzKFwYZVeYlJkRsGxxi
	hhNnOe8VrsjRrGoPWqMljA5CyBzt+y4QXhFG+WH27HXcj6+MrltSb7XNzCy6GRt9QlAcRv
	sOmgEccGbeD3oWTkLk+OOnKK6y5gMQY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-12-asGBEXTbOyycdjKULKktFQ-1; Thu,
 24 Oct 2024 09:19:13 -0400
X-MC-Unique: asGBEXTbOyycdjKULKktFQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9F2C1955F43;
	Thu, 24 Oct 2024 13:19:12 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.135])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30A6019560A2;
	Thu, 24 Oct 2024 13:19:12 +0000 (UTC)
Date: Thu, 24 Oct 2024 09:20:39 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <ZxpJp48vi4NpFVqJ@bfoster>
References: <20241024025142.4082218-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024025142.4082218-1-david@fromorbit.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Oct 24, 2024 at 01:51:02PM +1100, Dave Chinner wrote:
> We have had a large number of recent reports about cloud filesystems
> with "corrupt" inode records recently. They are all the same, and
> feature a filesystem that has been grown from a small size to a
> larger size (to 30G or 50G). In all cases, they have a very small
> runt AG at the end of the filesystem.  In the case of the 30GB
> filesystems, this is 1031 blocks long.
> 
> These filesystems start issuing corruption warnings when trying to
> allocate an in a sparse cluster at block 1024 of the runt AG. At
> this point, there shouldn't be a sparse inode cluster because there
> isn't space to fit an entire inode chunk (8 blocks) at block 1024.
> i.e. it is only 7 blocks from the end of the AG.
> 
> Hence the first bug is that we allowed allocation of a sparse inode
> cluster in this location when it should not have occurred. The first
> patch in the series addresses this.
> 
> However, there is actually nothing corrupt in the on-disk sparse
> inode record or inode cluster at agbno 1024. It is a 32 inode
> cluster, which means it is 4 blocks in length, so sits entirely
> within the AG and every inode in the record is addressable and
> accessible. The only thing we can't do is make the sparse inode
> record whole - the inode allocation code cannot allocate another 4
> blocks that span beyond the end of the AG. Hence this inode record
> and cluster remain sparse until all the inodes in it are freed and
> the cluster removed from disk.
> 
> The second bug is that we don't consider inodes beyond inode cluster
> alignment at the end of an AG as being valid. When sparse inode
> alignment is in use, we set the in-memory inode cluster alignment to
> match the inode chunk alignment, and so the maximum valid inode
> number is inode chunk aligned, not inode cluster aligned. Hence when
> we have an inode cluster at the end of the AG - so the max inode
> number is cluster aligned - we reject that entire cluster as being
> invalid. 
> 
> As stated above, there is nothing corrupt about the sparse inode
> cluster at the end of the AG, it just doesn't match an arbitrary
> alignment validation restriction for inodes at the end of the AG.
> Given we have production filesystems out there with sparse inode
> clusters allocated with cluster alignment at the end of the AG, we
> need to consider these inodes as valid and not error out with a
> corruption report.  The second patch addresses this.
> 
> The third issue I found is that we never validate the
> sb->sb_spino_align valid when we mount the filesystem. It could have
> any value and we just blindly use it when calculating inode
> allocation geometry. The third patch adds sb->sb_spino_align range
> validation to the superblock verifier.
> 
> There is one question that needs to be resolved in this patchset: if
> we take patch 2 to allow sparse inodes at the end of the AG, why
> would we need the change in patch 1? Indeed, at this point I have to
> ask why we even need the min/max agbno guidelines to the inode chunk
> allocation as we end up allowing any aligned location in the AG to
> be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> unnecessary and now we can remove a bunch of code (min/max_agbno
> constraints) from the allocator paths...
> 
> I'd prefer that we take the latter path: ignore the first patch.
> This results in more flexible behaviour, allows existing filesystems
> with this issue to work without needing xfs_repair to fix them, and
> we get to remove complexity from the code.
> 
> Thoughts?
> 

This all sounds reasonable on its own if the corruption is essentially
artifical and there is a path for code simplification, etc. That said, I
think there's a potential counter argument for skipping patch 1 though.
A couple things come to mind:

1. When this corrupted inode chunk allocation does occur, is it possible
to actually allocate an inode out of it, or does the error checking
logic prevent that? My sense was the latter, but I could be wrong. This
generally indicates whether user data is impacted or not if repair
resolves by tossing the chunk.

2. Would we recommend a user upgrade to a new kernel with a corruption
present that causes inode allocation failure?

My .02: under no circumstances would I run a distro/package upgrade on a
filesystem in that state before running repair, nor would I recommend
that to anyone else. The caveat to this is that even after a repair,
there's no guarantee an upgrade wouldn't go and realloc the same bad
chunk and end up right back in the same state, and thus fail just the
same.

For that reason, I'm not sure we can achieve a reliable workaround via a
kernel change on its own. I'm wondering if this requires something on
the repair side that either recommends growing the fs by a few blocks,
or perhaps if it finds this "unaligned runt" situation, actively does
something to prevent it.

For example, I assume allocating the last handful of blocks out of the
runt AG would prevent the problem. Of course that technically creates
another corruption by leaking blocks, but as long repair knows to keep
it in place so long as the fs geometry is susceptible, perhaps that
would work..? Hmm.. if those blocks are free then maybe a better option
would be to just truncate the last few blocks off the runt AG (i.e.
effectively reduce the fs size by the size of the sparse chunk
allocation), then the fs could be made consistent and functional. Hm?

Brian

