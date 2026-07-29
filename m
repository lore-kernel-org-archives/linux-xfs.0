Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A762E45628A
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351025; cv=none; b=B867fcKxInGtwwxk9Xg5lrivuIMLFLyrg7t435nDfPmnFjTQ83iheKbgqJVi3ijpUJkBU1xWN97UDeAlPpJgpkpKA27jJcVzwhHUZHGAh7Ud454yAvLLp6RqbzIOvQ6WBescLB7+IVYXWkfE0v6qcJ6YvkIv7i1p/6RrJHNPlDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351025; c=relaxed/simple;
	bh=cMZzq72m4tF3C7T7QqevR4B4SKsnfBzAOZvd4QY3f8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnnZ5FhaD1QbhY4kCRTmG0ti5H72bciHiHpJ/o8VZK02n/fi+WeMInXPoSlvgJq/kzKThdZCQVzGQkE1u0O/mCnIS/UqLi+telO2qQJmS1HcROgQ9Ord41kZAdUine1kqTitmMOJKmawCWAHIgHemKXTYylDCqA25rD+fkAfCq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O7N2VfEy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O7N2VfEy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785351022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xwIkbzgD5JWK7eOuvDeKBAaok/SPkMC8V5l6Sx2cjPk=;
	b=O7N2VfEyhO8A64BBI9a4EOfFlV0gLofFQ/I5FUChE0VifoThrL6ENxQhShzT9B8ArOCErI
	RAFhVDGdOWMOqDh790HPFnlSAe9w4i/wVN6J29o7yTu1W3N74yo66gX9UbxWXFLSvCyRAW
	eDFa4laHa98EmpB+JwwS5B1J845cRYU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-Ros4idO1MWWUhbBoaJ7Z5A-1; Wed,
 29 Jul 2026 14:50:19 -0400
X-MC-Unique: Ros4idO1MWWUhbBoaJ7Z5A-1
X-Mimecast-MFC-AGG-ID: Ros4idO1MWWUhbBoaJ7Z5A_1785351017
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E24021956080;
	Wed, 29 Jul 2026 18:50:16 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.46])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88B361800480;
	Wed, 29 Jul 2026 18:50:15 +0000 (UTC)
Date: Wed, 29 Jul 2026 14:50:13 -0400
From: Brian Foster <bfoster@redhat.com>
To: Matt Fleming <matt@readmodwrite.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [BUG] xfs: sparse inode allocation can trip i != 1 after AGFL
 growth
Message-ID: <ampLZcB3CAzLPKV5@bfoster>
References: <20260717130429.1838767-1-matt@readmodwrite.com>
 <alpsniDzp5kWl0xA@bfoster>
 <al33dUXS_8Yr5vEu@matt-Precision-5490>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al33dUXS_8Yr5vEu@matt-Precision-5490>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Jul 20, 2026 at 11:37:25AM +0100, Matt Fleming wrote:
> On Fri, Jul 17, 2026 at 01:55:42PM -0400, Brian Foster wrote:
> > On Fri, Jul 17, 2026 at 02:04:29PM +0100, Matt Fleming wrote:
> > > 
> > > The failure sequence seems to be:
> > > 
> > > 1. AG0 has no free inodes, so inode allocation needs a new chunk.
> > > 2. Full chunk allocation cannot fit.
> > > 3. Sparse chunk allocation can fit and passes the old AGFL minimum check.
> > > 4. Removing the sparse extent from free space grows both bnobt and cntbt.
> > 
> > I assume this means we happen to alloc a sparse chunk out of the middle
> > of a free extent, causing an additional record and thus splits in both
> > trees.
>  
> Yep, exactly.
> 
> > It also looks like we set args.minleft = igeo->inobt_maxlevels in the
> > chunk alloc path, presumably with the intent to leave enough blocks
> > around for inode record insertion. I assume the above available value is
> > prior to the sparse chunk alloc. It would be interesting to see what the
> > same values/calculations are after the chunk alloc at the time of the
> > inobt block alloc that fails.
>  
> Before sparse inode allocation:
> 
>    pagf_freeblks:    2514
>    pagf_flcount:     8
>    levels:           bno/cnt/rmap = 1/1/2
>    reservation:      2505
>    minleft:          2
>    min_freelist:     8
>    AGFL credit:      min(8, 8) = 8
> 
>    available:
>      2514 + 8 - 2505 - 8 - 2 = 7
> 
>    request:
>      minlen=4 align=4 slop=0
>      alloc_len = 4 + (4 - 1) + 0 = 7
> 
> So the sparse inode allocation only just passes the allocator check.
> 
> After sparse inode allocation, at the failing inobt split allocation:
> 
>    pagf_freeblks:    2510
>    pagf_flcount:     4
>    levels:           bno/cnt/rmap = 2/2/2
>    reservation:      2505
>    minleft:          0
>    min_freelist:     12
>    AGFL credit:      min(4, 12) = 4
> 
>    available:
>      2510 + 4 - 2505 - 12 - 0 = -3
> 
>    request:
>      minlen=1
> 
> So after removing the 4-block sparse extent, bnobt/cntbt have grown,
> AGFL has dropped, min_freelist has increased from 8 to 12, and the
> later single-block inobt allocation has no available space.
> 

Ok, thanks for the additional data. So the first allocation proceeds
based on meeting the minleft and agfl requirements at the time. That
allocation causes a full split and level increase on both alloc btrees
in the AG, so as you've pointed out we consume the 4 free blocks and 4
blocks from the agfl. We turn around in the same transaction and insert
the inobt records, which attempts an alloc for the inobt that fails
because the AG no longer meets minimal allocation criteria, despite
having minleft set to 2 to ensure that some blocks remain available for
this very purpose after the first allocation.

I think the immediate issue here is that the allocbt min free
requirements change within the same (transaction + agf buf) instance.
IOW, since the btrees run a full split on the first allocation and the
agfl requirements are based on the requirements for the next full split,
we can be reasonably certain another full split will not occur in the
lifecycle of this particular trans/agf combination.

Having an LLM run through a hypothetical situation where we held the
agfl requirements constant across these two allocations suggested that
indeed, this would allow us to allocate the final available block for
record insertion.

That said, I'm not totally convinced this is the best solution. The
purpose of sparse inodes was not necessarily to facilitate allocation of
every last block in the AG, but moreso to improve the ability to
allocate inodes in AGs with high levels of free space fragmentation. I'm
a little concerned that trying to do the former here would just lead us
into other future traps by trying to extract precision out of gating
logic that isn't really designed for it.

With that in mind, the other possible way to handle this is to be more
conservative and just make sure the allocation fails gracefully up
front. There are probably multiple different ways to do that as well.
The LLM hacked up something to bump minfree within the allocator when
minleft is set. That seems to work, but I don't really like it.

Another option that seems a bit more simple/logical to me is to let the
sparse allocation attempt bump minleft by the number of blocks that the
length is reduced by when we fall into the sparse allocation path. The
idea here is just to maintain consistent enospc behavior between sparse
and non-sparse chunk allocation. That's a simple one line change, also
prevents the problem, and (IMO) is more straightforward to document and
reason about.

I want to think about that a little more and need to run more tests, but
unless something better comes along I'll try to post that soonish. BTW,
I had to make some tweaks to the reproducer test to make it work on my
fedora based test vm. Is this something you plan to post for upstream
inclusion?

Brian

--- 8< ---

diff --git a/tests/xfs/842 b/tests/xfs/842
index 9e694a56..5455998f 100755
--- a/tests/xfs/842
+++ b/tests/xfs/842
@@ -293,9 +293,9 @@ inspect_unmounted
 read -r free reserved used <<<"$(ag0_reservation_state)"
 reservation=$((reserved - used))
 outside=$((free - reservation))
-bno_level=$(agf_field 'levels[0]')
-cnt_level=$(agf_field 'levels[1]')
-rmap_level=$(agf_field 'levels[2]')
+bno_level=$(agf_field bnolevel)
+cnt_level=$(agf_field cntlevel)
+rmap_level=$(agf_field rmaplevel)
 flcount=$(agf_field flcount)
 bno_recs=$(alloc_root_field bnoroot numrecs)
 cnt_recs=$(alloc_root_field cntroot numrecs)

