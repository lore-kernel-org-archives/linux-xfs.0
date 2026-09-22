Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011EC43E067
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 08:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066018; cv=none; b=T0VzaXpY6As4tPX5QatNg1Yernlogd9KWBLxcTNcYHcaAwmIj1WFJ4eCH+9rqPvQz87APvm5MznKW74BRHpZVgVEjKetjjjDLFV8j3tJKzmtkbZ+Nl9vwwNqkSchr0mwU9Y7cKTWSirH6RN7t1e/Odu62PX1IdSHzMP9e5M2M7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066018; c=relaxed/simple;
	bh=zFEi4lXytmrVbgQRpPsKAIkx1xEMbo5uCPAVt3YHyCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVDFymQLdQmbDIZVHyauSnlQ/M50qPtDXbsqBQRXt5fW8ZzdV8a17VA68ZwwEGkKzXgIbLyTghnN3cUFZmZlVeBHNCxBecXJqlgq3qo+giELnXonY8FiezFcK9dkpZHRpymXRZwr8J1ZOPvfgbzS7fWwxAFfZFcY+ksYkCgxOQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VTOTiEQI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LBVmmMGc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VTOTiEQI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBVmmMGc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790066006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w4z5ytHAoQC8UWkOcT2zO26c7SVy/93HRcvFS003K4I=;
	b=VTOTiEQIl91Y6dYxZdf1v2iib8zKxLzjB3IZHRTN/8u1rNeymVxep4Oj/oZHQUvhv9KpdX
	fFyZNAN7kdl4sxYrsUTNYy5Gby/73eCAmDrlBFgnE9H+RKfp29ZG7PSaKasouWYsezS2DM
	dIAK6YXVaJ40hrMDorzora4Cee1HY04=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-kkk78qMGP8ylHVQYO3olqg-1; Tue, 22 Sep 2026 04:33:25 -0400
X-MC-Unique: kkk78qMGP8ylHVQYO3olqg-1
X-Mimecast-MFC-AGG-ID: kkk78qMGP8ylHVQYO3olqg_1790066004
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e73659ac5so54771005e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 01:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790066004; x=1790670804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w4z5ytHAoQC8UWkOcT2zO26c7SVy/93HRcvFS003K4I=;
        b=LBVmmMGcFfV0EoAKs/RX1Baan56NHDQKph14iTQUxxvRsg2nGJROGvtASI1VEycKE8
         riII0t0d6SEN1+0YVmwINKSCOh7VBb+CTWYJ/9B5uy6f9Hwizmzxfd9L/iQOAME7PLdb
         NeeI6ubpqqwl9Zp5rFoiOctlCuEGG/9KrKNaGRHNiuUKuTDGea1BRHAGtLeJolPblSA5
         M+HpioZPSOuq69r7UnVBquw9sDCun3Pb5MT07XDcndkRIjR1efmq4cgnzzhty0l6ugqg
         7jBM2TKu6j/S0qKM70FrB4rRnXyc2JkjGq5NEiVRsFcitzMZrshRZYqACHGVqb/c0ruh
         p0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066004; x=1790670804;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w4z5ytHAoQC8UWkOcT2zO26c7SVy/93HRcvFS003K4I=;
        b=UA8rOQw+pWzk9SgYsemxIIWjy0CwnL87XR02hfoqXvJ8B/i4XzF4qf2FX+knH12Qmd
         0f3TeBQde5q88gciIZAELgtAyi4yeM8bFVTE3byJy4Xk6CnBLpPKeEDpvuUW13MT4908
         DkWlCbYs4chPLoB217UPPRg51pykJmQVzgWWciKjphiZmG9vqjx97wNA8LDU2fHA+Yd3
         POq65qs7A2bX7Yxor85IMh2N3tULq8POysTXcxGdjm/4tfNSLykx/uDFt732NP6Dkugp
         zlLwiWJ6D28FHxWW1zMzIx6GFY5BFoDcBNPYxH3N0e9ySd/XS7+W19yWXGFxRPpkjtK8
         H2Nw==
X-Forwarded-Encrypted: i=1; AKwUvBwsWttlj5l9rBH20nHgbqwKB2aKQPoDr9r58fL07a6aDkdcYeIP1m9lh2ZuF2EsOoR/VgjsgpYfT/o=@vger.kernel.org
X-Gm-Message-State: AFuF++n2BINkn/5wCa7AVsbFC4u50Bh61QxF+g07YI35mG72SeKaTixe
	YHdovOeps7najgRSLfSLoBwJuFUH/4PJyKqfr5an1jozMtnEen62SV4qsyy66ZCPpjcuqsi6uQR
	reqRoq79nzYdfvjZd0Sr8HFYn/HU0pqNlF7yvdZZ+O3Wy845QyivWn6E9vB/W
X-Gm-Gg: AYBFou2I9M9oiOg/3+avuWLhgfRQCx/tGNfvsdrLWOhjpN2+ooZKTiNvRma5bfpxM9g
	krlVBb8uPsailtvYv1YH6fbHTFRHmLy6tblvBWZ4nWNcbG2d6isE/x/em50ttS5rYG1+Jd9sgs8
	FI3eprST9bA1dL+2zUsxV/e48k53nAFLzPF+/vTKkdPSmeJzJZnNdeS8f7ea1ulO9LvhmRYVFK1
	fmkvdxO6h7m4DhVE9OhpMN36aRFOwl21AQIDxNPKQ9L16701AbRryTXT/6mAXiDTZpu9i8YFeJj
	HK2uLxtGH3HyPlN3Yg/thb35pLuckgaaJJ+MbOmKfXAj8p2iUt9VAnxEn3NRweEDWkOzC3YUc4h
	y5gWMGZaLO+pTjgwa9VxpElFBC60m6EvOiA==
X-Received: by 2002:a05:600c:a42:b0:49e:6683:d23c with SMTP id 5b1f17b1804b1-49fc5594deemr183435125e9.0.1790066004130;
        Tue, 22 Sep 2026 01:33:24 -0700 (PDT)
X-Received: by 2002:a05:600c:a42:b0:49e:6683:d23c with SMTP id 5b1f17b1804b1-49fc5594deemr183434735e9.0.1790066003664;
        Tue, 22 Sep 2026 01:33:23 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdab8ae6dsm74097995e9.0.2026.09.22.01.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:33:23 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:33:22 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, 
	hch@lst.de, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 14/21] xfs: don't remove written extents past EOF on
 fsverity inodes
Message-ID: <arI9MpRVBZ0UEofK@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-15-aalbersh@kernel.org>
 <20260922043750.GN2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922043750.GN2705364@frogsfrogsfrogs>

On 2026-09-21 21:37:50, Darrick J. Wong wrote:
> On Fri, Sep 18, 2026 at 01:15:26PM +0200, Andrey Albershteyn wrote:
> > xfs_free_eofblocks() removes all extents past EOF unless the
> > XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set. This is
> > undesired for fsverity as it stores metadata beyond EOF. However, while
> > merkle tree is being built, delayed preallocation and unwritten extents
> > are used. After metadata construction is done, fsverity inodes becomes
> > read-only and won't be changed anymore, none of these unwritten extents
> > or preallocations in post EOF region will be used.
> > 
> > Let xfs_free_eofblocks() be called on fsverity inode as usual to remove
> > anything which is not written extent. However, inodes which are
> > undergoing merkle tree construction need to be skipped in case reclaim
> > takes place.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 268d159339d0..7fd951992557 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -31,6 +31,7 @@
> >  #include "xfs_rtbitmap.h"
> >  #include "xfs_rtgroup.h"
> >  #include "xfs_zone_alloc.h"
> > +#include <linux/fsverity.h>
> >  
> >  /* Kernel only BMAP related definitions and functions */
> >  
> > @@ -553,6 +554,13 @@ xfs_can_free_eofblocks(
> >  	if (last_fsb <= end_fsb)
> >  		return false;
> >  
> > +	/*
> > +	 * Don't clean fsverity inodes which have merkle tree being built, the
> > +	 * merkle tree is written beyond EOF
> > +	 */
> > +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> > +		return false;
> > +
> >  	/*
> >  	 * Check if there is an post-EOF extent to free.  If there are any
> >  	 * delalloc blocks attached to the inode (data fork delalloc
> > @@ -579,6 +587,9 @@ xfs_free_eofblocks(
> >  	struct xfs_trans	*tp;
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	int			error;
> > +	int			bmapi_flags = XFS_BMAPI_NODISCARD;
> > +	bool			has_verity =
> > +			ip->i_diflags2 & XFS_DIFLAG2_VERITY;
> >  
> >  	/* Attach the dquots to the inode up front. */
> >  	error = xfs_qm_dqattach(ip);
> > @@ -593,15 +604,20 @@ xfs_free_eofblocks(
> >  	 *
> >  	 * Note that this means we also leave speculative preallocations in
> >  	 * place for preallocated files.
> > +	 *
> > +	 * Clean up delalloc reservations for fsverity too as those won't be
> > +	 * used
> >  	 */
> > -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
> > +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
> > +			has_verity) {
> >  		if (ip->i_delayed_blks) {
> >  			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
> >  				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
> >  				LLONG_MAX, NULL);
> >  		}
> >  		xfs_inode_clear_eofblocks_tag(ip);
> > -		return 0;
> > +		if (!has_verity)
> > +			return 0;
> >  	}
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > @@ -613,6 +629,9 @@ xfs_free_eofblocks(
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	if (has_verity)
> > +		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
> 
> This ought to have a comment explaining where post-eof unwritten extents
> might come from:
> 
> 	/*
> 	 * If fs-verity fails to write the full metadata, it can leave
> 	 * unwritten preallocations after EOF.  Clear all that out.
> 	 */
> 	if (has_verity)
> 		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
> 
> 
> With that documented,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Sure, I will add the comment
Thanks!

-- 
- Andrey

