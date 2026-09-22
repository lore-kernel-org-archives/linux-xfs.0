Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15BD53B5F3;
	Tue, 22 Sep 2026 11:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076605; cv=none; b=jy5pCMWbceOeqdJ78gm5yzYzzJfXseJEYphFhiAiS9vdgf6atJj6JXCWgD9rr9laBtvvA5pnZhpR30yapT8+vb+DBNkGTW7EKItqCGAgTnwbQjogGh86QMbQ4vHhBXClA5hoYoOOJbjN+1r8sVnJfs8XlAtoGPWaw7fKoK5SoxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076605; c=relaxed/simple;
	bh=Fcfcg/SnohK01pfQgT7UZiMMCzRAK7qzFCiSmSN4/Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUM5/SyPryWxAjMexQwuxglG01UN9Bw7ZTkZxBX0RTwHKb5wrH3PRHdfDb87XhKsBw2cmPpV7vIynxluQB3b7XBF7AbzyvIE4UeqrqYDRigEH07ngDwFT8bFV10GvUALDrtgkpPmdKgdaHuUANpi15iaialYJDUqrtBqHBkagck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0dEvj5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0dEvj5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F43B1F000FF;
	Tue, 22 Sep 2026 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076597;
	bh=nV8p6Om8qinv6yCBXUuo5B2uIDMSV459k6GB4PG3ZlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W0dEvj5zWbynOI1xN6zKaAWjWZtxGOprab+zcQIcvZTXmYxhx+2RqMPc1aU4QZttH
	 2Lp/6eIl2zv0Rkkad56JU0uFNc+uHztMw/x5ZfZxowYZWEw4kRJSvw8P/qPQoyxL5C
	 UTA5+iAh3uJMkWBtQtoGBf8I8SGI3pdjY4ByxIkJLukL9e6r5RWIkKiyEB2CiVe1LW
	 XrR+xVhQVeezmzuRaN9DcXdomNZZUVVzWLOP+fWiZamXflNSka1h1QzcCOqxZnGtQU
	 +oJijmz3DdwhmB4njIISMv+3QdNdnGRdwwZHpH6aDbkzTZl4JcBfIu8Bc7Hx0RgtkP
	 F/uhJyHeh1mfQ==
Date: Tue, 22 Sep 2026 13:29:52 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, ebiggers@kernel.org, hch@lst.de, 
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 14/21] xfs: don't remove written extents past EOF on
 fsverity inodes
Message-ID: <arJl4xbG3vUrX9DK@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-15-aalbersh@kernel.org>
 <20260922043750.GN2705364@frogsfrogsfrogs>
 <arI9MpRVBZ0UEofK@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arI9MpRVBZ0UEofK@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On 2026-09-22 10:33:22, Andrey Albershteyn wrote:
> On 2026-09-21 21:37:50, Darrick J. Wong wrote:
> > On Fri, Sep 18, 2026 at 01:15:26PM +0200, Andrey Albershteyn wrote:
> > > xfs_free_eofblocks() removes all extents past EOF unless the
> > > XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set. This is
> > > undesired for fsverity as it stores metadata beyond EOF. However, while
> > > merkle tree is being built, delayed preallocation and unwritten extents
> > > are used. After metadata construction is done, fsverity inodes becomes
> > > read-only and won't be changed anymore, none of these unwritten extents
> > > or preallocations in post EOF region will be used.
> > > 
> > > Let xfs_free_eofblocks() be called on fsverity inode as usual to remove
> > > anything which is not written extent. However, inodes which are
> > > undergoing merkle tree construction need to be skipped in case reclaim
> > > takes place.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 25 ++++++++++++++++++++++---
> > >  1 file changed, 22 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index 268d159339d0..7fd951992557 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -31,6 +31,7 @@
> > >  #include "xfs_rtbitmap.h"
> > >  #include "xfs_rtgroup.h"
> > >  #include "xfs_zone_alloc.h"
> > > +#include <linux/fsverity.h>
> > >  
> > >  /* Kernel only BMAP related definitions and functions */
> > >  
> > > @@ -553,6 +554,13 @@ xfs_can_free_eofblocks(
> > >  	if (last_fsb <= end_fsb)
> > >  		return false;
> > >  
> > > +	/*
> > > +	 * Don't clean fsverity inodes which have merkle tree being built, the
> > > +	 * merkle tree is written beyond EOF
> > > +	 */
> > > +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> > > +		return false;
> > > +
> > >  	/*
> > >  	 * Check if there is an post-EOF extent to free.  If there are any
> > >  	 * delalloc blocks attached to the inode (data fork delalloc
> > > @@ -579,6 +587,9 @@ xfs_free_eofblocks(
> > >  	struct xfs_trans	*tp;
> > >  	struct xfs_mount	*mp = ip->i_mount;
> > >  	int			error;
> > > +	int			bmapi_flags = XFS_BMAPI_NODISCARD;
> > > +	bool			has_verity =
> > > +			ip->i_diflags2 & XFS_DIFLAG2_VERITY;
> > >  
> > >  	/* Attach the dquots to the inode up front. */
> > >  	error = xfs_qm_dqattach(ip);
> > > @@ -593,15 +604,20 @@ xfs_free_eofblocks(
> > >  	 *
> > >  	 * Note that this means we also leave speculative preallocations in
> > >  	 * place for preallocated files.
> > > +	 *
> > > +	 * Clean up delalloc reservations for fsverity too as those won't be
> > > +	 * used
> > >  	 */
> > > -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
> > > +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
> > > +			has_verity) {
> > >  		if (ip->i_delayed_blks) {
> > >  			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
> > >  				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
> > >  				LLONG_MAX, NULL);
> > >  		}
> > >  		xfs_inode_clear_eofblocks_tag(ip);
> > > -		return 0;
> > > +		if (!has_verity)
> > > +			return 0;
> > >  	}
> > >  
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > > @@ -613,6 +629,9 @@ xfs_free_eofblocks(
> > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > >  	xfs_trans_ijoin(tp, ip, 0);
> > >  
> > > +	if (has_verity)
> > > +		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
> > 
> > This ought to have a comment explaining where post-eof unwritten extents
> > might come from:
> > 
> > 	/*
> > 	 * If fs-verity fails to write the full metadata, it can leave
> > 	 * unwritten preallocations after EOF.  Clear all that out.
> > 	 */
> > 	if (has_verity)
> > 		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
> > 
> > 
> > With that documented,
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Sure, I will add the comment
> Thanks!

I will re-pharese the comment to:

	/*
	 * While fs-verity writes metadata after EOF, it can leave unwritten
	 * preallocations.  Clear all that out.
	 */

The preallocation are left even in good case, in the merkle tree
holes and after fsverity descriptor.

-- 
- Andrey
