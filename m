Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717120;
	b=qa9x4dv6Z5MEHkWGOOw8UxbdvY/F3egOpL9clRS3u8Xp+2455XLUvk3q7G99z1QfeMQ8
	 FKVQnZecAZJgFZ8ltdXleEn7iJbEQNKEKD9HiMsRGVJzUtFT/z8bOU83GxdIuga/bLbu9
	 Y4S4bqlPwSLVgAFnHtdRQvpBqhewImGi6U2HQB3quVctchxRhVJ7EmGwvx07sjJJgXxXl
	 AMFSt8VG2WzU7wwExcO69M1oZ9n9lzMqDK95MN4L9ISeH90WoEQBuSjRbNYjeJgjjfQ5f
	 F9fZGs0FPPpipDaa/wk7yArARIgL14qYl2O8jF4BiMjh+U2OCXungbFBpgFzqtRkaPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717120;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/4OAfWq3Q227So6//15V6EfHPFpWbAipGQfXInWUBlY=;
	b=SYxFHvfo0as1Dg2guowt+Q4/+9DUbGgv0BRueqXpl9rgpf2WCvYwjZXU4BjS3gie14tR
	 K+VcE6DUsSjB2U1tKTfdMnwqH3of0wPIewVh0PG7EyMYyPzI3DzmOaz/cyeVoA2ZUwsGQ
	 8pqsTwb/sexcSHsJmkMgWLFs9F9Gtv0/JfJXAfumGMoghR1QvOKqpoMu+mzDTDbNpUm6k
	 w0pajVDuxq4U3euZBeCoF6fL5TgaeNvXUF0BdZihb94zz8JgyTef11pv+wEqNXWtq8iFj
	 aOoU8897ZB5nWz6AR+57BJ0WLZZHr3Yyt6Hguvgr4ndGNuR9Z1ZHVXUrWlXc8J+9rdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="g/psyuRg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F6B606A328;
	Tue,  3 Nov 2026 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g/psyuRg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2C91F000C1;
	Tue,  3 Nov 2026 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717119;
	bh=/4OAfWq3Q227So6//15V6EfHPFpWbAipGQfXInWUBlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g/psyuRgqZxi5k7bq9CANmOvPeYiP/r+LuM+FMF2ZU54bj5VxvHd9flAVboNv+bsg
	 uD+bwXJbtF/3FDbWGBI2MD2Pdx8cCs688bXmIQVgbSOG2JILnHUU4yBy26u+hOJOvl
	 k78WLjATe3CxLbbNTtKGDYIfvcF5531j3Mb2G3RI6a1DpZIM6pNXH3gvTbcrTkAU3t
	 d0e7LNXvu9eS+pz3J7o3Pjr8uAu84xainAstvJPgEV9HUJL8uEIYkVGBcSCm2JZqWk
	 Oklkfei64xHqxnmwDhodAMVWzelle6FkHpsZT+CV/gFcfzDsvWukHW4UHl3pXmDLt1
	 WKP42jphvBJnQ==
Date: Tue, 3 Nov 2026 15:45:15 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v18 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <aunynmhdqBMCTdBj@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
 <20261102144147.2393369-8-aalbersh@kernel.org>
 <aumsPwTUaMgsccSb@infradead.org>
 <aunvf0_84c4K3s8b@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <aunyEHubncj93edp@infradead.org>
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
In-Reply-To: <aunyEHubncj93edp@infradead.org>

On 2026-11-03 06:39:12, Christoph Hellwig wrote:
> On Tue, Nov 03, 2026 at 03:31:15PM +0100, Andrey Albershteyn wrote:
> > On 2026-11-03 01:41:19, Christoph Hellwig wrote:
> > > On Mon, Nov 02, 2026 at 03:41:37PM +0100, Andrey Albershteyn wrote:
> > > > The __xfs_bunmapi() is used to remove all extents past EOF. Add
> > > > XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
> > > > written ones in place. This will be used in following patch to clean up
> > > > unwritten extents on fsverity inodes.
> > > 
> > > As discussed before, we either need to fix the Sashiko complains (which
> > > could get really annoying), or disallow fsverity on RT files with
> > > rt extent size > 1.  And probably also add a soft assert about this
> > > to __xfs_bunmapi itself to make the limitations clear.
> > > 
> > > Otherwise this looks good.
> > > 
> > 
> > Yes, I added the check in "[PATCH v18 09/15] xfs: add fs-verity
> > support" [1] in xfs_fsverity_begin_enable()
> > 
> > +	/*
> > +	 * fs-verity stores the Merkle tree past EOF in units of the filesystem
> > +	 * block size, so it cannot support realtime files whose allocation unit
> > +	 * (extent size) is larger than the block size.
> > +	 */
> > +	if (xfs_inode_has_bigrtalloc(ip))
> 
> Please also add a similar check/comment in __xfs_bunampi for the
> XFS_BMAPI_UNWRITTEN case as a safeguard and documentation of the
> limitations.
> 

Sure

I see that sashiko also noticed that realtime could be enabled
betwee _begin_enable() and _end_enable() as inode lock is not held
over that period. I will also add check there to forbid that, but
the xfs_dinode_verify() comment seems incorrect.

-- 
- Andrey
