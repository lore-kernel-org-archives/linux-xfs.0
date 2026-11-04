Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826263;
	b=FsXaX6C2GjbrK47RpwHiX2WZehLVf3AXVs5Vsiw9PWv8TLyQbAYqjybD0SkY2WDF+rV2
	 /6fWT8mQe3dQq0LxFH9t+6rYdIsi/VhjbuhcCgi6t2oIHUs8m8LzOH4bdN6EUneE0THOY
	 jibUGrszLdvyIvB9ewwCVReAbtPW7JSJSn4ZG2nrF2nw5qGQWINmT2Um1x8dtJ3kCeE3q
	 oSHumKgmvt4VZ1XngSDsLCMgs2H7AHh/q3V1p6MA9EPdXqri77VaPp4DPsRs6pyQchcUI
	 LGgLDXiwQ8Ttfnfbxl7mSvd3MNJ67Pz+4iV46XJj28QE8PaTrfZ0MwiTTSbHpjnNOjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826263;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dwtFWN/4cYJVMt8Xf3Mo9Ioh5U7rpzYxYFROJxRMYWM=;
	b=bNm5ATlra8i4XkLtPo3Pxiknqq4y6Tj5kpfAfzmrIIGRyxTqHIZgG+qms275OK6CqeZx
	 S8VV/GiGBgAfDrnKL0X9/roXGnU8rFJxTzx0EKtAR9/1Sk7hgV0jpNaoy0Us9A/+ksj9L
	 2Mh6siwzOLf/VOETV15EGmbnmg5MFhxHCA8rk3HGhKDeQzmn42c3gRlUiAPDV1YzqlZaP
	 HTkxuVYY7+DmXyGElPNEhLGx25aVNjQ5seObhHoIeZbhUj52jLM57t9caZKZM8h0XLRC8
	 TgPDXFDqghQF2NCdGliVWK0A6E81RQHHO08G79udTIFQGmWRpxdieXlR7cmViFHJyGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OzDkMIbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2EE606D4C7
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OzDkMIbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576D71F00A15;
	Wed,  4 Nov 2026 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826263;
	bh=dwtFWN/4cYJVMt8Xf3Mo9Ioh5U7rpzYxYFROJxRMYWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OzDkMIbvGTnoEMnghYENinasEEJkRAIqM2EgSCb/J47yElbmKIEaMW9Cx71A1dWO1
	 fHpDCEe3qHXwkC/ETayM95REVSJmn8V7cmMMK0hEWLCck+L8Ler1yNQJKSOnXYQ443
	 +vNB48G7RkqzsoWk4r3N+msbJNIpOvQktRvlDyx+1iNUf6/W1jRpRwhmw9/x6t/B3o
	 sPq3fgDqTW104QrJY9wo5ANPoOt5uh+tA0y9fWJk3mo8u2gMKXoRFimg+aB3koIoPR
	 WlAsGcZmxCv5v/1r3Ml8pDwCJrZf9+dJvneDTLNVQHsScFFvminfrwAOM8tPb4BKUO
	 Z4zmlSyZxqptg==
Date: Thu, 5 Nov 2026 08:04:15 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <auudz7Iwm2MrNA-b@dread>
References: <20261102193533.93690-1-lauri.gates@gmail.com>
 <aulwLCnibXfaMzR_@infradead.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aulwLCnibXfaMzR_@infradead.org>

On Mon, Nov 02, 2026 at 09:25:00PM -0800, Christoph Hellwig wrote:
> Hi Lauri,
> 
> On Mon, Nov 02, 2026 at 09:32:45PM +0200, Lauri Gates wrote:
> > Hi,
> > 
> > FIEMAP on files with XFS_DIFLAG2_REFLINK set does not scale across
> > threads. For every written extent, xfs_read_iomap_begin() calls
> > xfs_reflink_trim_around_shared() (IOMAP_REPORT), which goes to
> > xfs_reflink_find_shared() and reads the AGF of the extent's AG with
> > xfs_alloc_read_agf(pag, NULL, 0, &agbp). Concurrent callers queue on
> > that buffer's b_sema. A parallel du-style scan of a reflinked tree
> > stops scaling at roughly the AG count, and threads working in the same
> > AG run slower than one thread alone.
> 
> FIEMAP is purely a debug interface for file system developers.  So
> running it in parallel for lots of files is highly unexpected and
> suggests a misuse of the interface.
> 
> > My question, in more detail at the end: does reporting the shared flag
> > for FIEMAP need the AGF buffer locked?

The problem is that we don't have a 'this inode has shared extents'
flag in the file_getattr() flag set, hence there is no easy way to
query if the inode may or may not have shared extents in it. That
would be trivial to add, and would avoid the need to FIEMAP every
single file in the fs to check for shared extents...

> It needs to protect against agf_refcount_level changing, so yes.
> In theory it would be fine with a shared lock on the AGF buffer if
> we had a shared/exclusive lock on the buffers (which is something
> I've wondered about a few times before), or some other high-level
> synchronization against adding more reflinks.
> 
> > I ran into this adding a shared-block mode to dust, a du clone, which
> > FIEMAPs every file and counts FIEMAP_EXTENT_SHARED extents once.
> > Inodes without the reflink flag return early and are unaffected.
> 
> Ok, so this is the use case.  The more efficient way to do this
> would be to subtract the multiple mapped extents based on the
> refcount btree, i.e.
> 
> 	for each AG (and RTG with rtreflink):
> 		for each entry in the (rt)refcountbt:
> 			subtract rc_blockcount * (rc_refcount - 1);
> 
> We'd need a new ioctl for that, but it should be pretty easy.
> The major downside is that this only works for whole-device du,
> but then also any other version would have a really hard time figuring
> out what to do with reflinks the span the reported/not reported
> boundary.

Efficient ad hoc physical extent status querying is what the
GETFSMAP ioctl is supposed to provide, right?

The owner of an physical extent is part of the input key filters, so
it extending the implementation to filter extents by owner field
would allow arbitrary per-file extent map lookups. e.g.
functionality like "report only shared extents for a given inode
number range" is well within the functional scope of this interface.

That allows dust to fstat a file to get the total block count and
inode number, call file_getattr() to see if the file has shared
extents, and then use fsmap to efficiently query the exact shared
extent list for that inode and so calculate the shared block count
for that inode number....

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
