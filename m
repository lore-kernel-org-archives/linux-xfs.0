Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899FAC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 13:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5318C2068F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 13:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uv+EOrB2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgFVNX1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgFVNX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 09:23:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C793C061573
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 06:23:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so7552833pld.13
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 06:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlfNgMWE9G1ypD5jfPZdzXudYCODUPJrjS1GTgkLEoY=;
        b=uv+EOrB2/0QR/F9F5u296kTXjdLfutG0UEnDh+ibS/lkvkcV7DW2JzNYEASz2wz8oP
         cpOk8303G7RQE9nNL2qndvgOeZJ+kzWoUqLK8Txb1g0H5zWfzfgNxUuhwKN4w+bhmk18
         ctO5wPbLYy1eukQrTZVl5HIIL8Ak0VCdugrdWYyFokcOEO0O7JjPWBOd4eiewxqvf4Xa
         30qtI4g+S1J/jrXUCQ4Gi7UR4zMu4aNpdDWda8T2kMQXIsjLyITHYwtdBsG7FN8LjB4V
         UmpwnhqZfUdS09h12AhRUa9VsA/eakTkHQWHtyndm/8za4w/mj8GZY47uGXHx6Or97r1
         x1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlfNgMWE9G1ypD5jfPZdzXudYCODUPJrjS1GTgkLEoY=;
        b=QPdoYTiSX2sOMXohMSBAzCZFcE0U9wlKsrrDKdF+gjqqqwOuxlGOCbBQ7XusbcjMqq
         IEmyZftBOzG5sT297Jplvopoj42Q8ezDWmY5ZNsLj+Tyw1aUNttlFRlslu739U1xnzpi
         0Gvw+3LBjhVmIBY+gMvsDGt9tSf6liTOvRSfGIlJ10lwHHKAo2MbS0tPKkf6rUMNJ3H0
         PJd8yuCUtuOy7HfuEGRT+pAImmjO2FwRQ4Ptw/JxnzSPxJoOhLi4NKSuCBr9cPxo9aAw
         COpszGJXhg5M7lBeJ6qfeacZg3//660RG+WnAIUs1NVUCU3VwQGZDLl81Itn9e+ZcW3D
         KvAA==
X-Gm-Message-State: AOAM531jHZdcl9rsZpw1Jz33agaFWtPR+vlJwyLDIrUCYG47XYAJTL3n
        c/BLUfbFmNKoJzxww+qcmxI=
X-Google-Smtp-Source: ABdhPJyGdH0PRiIVRLkLOoYm+zUretlluejMmr2BEYR3CvvESnmoDCS5YzwMu6TkS8JOBOkvWjx1mQ==
X-Received: by 2002:a17:90a:e387:: with SMTP id b7mr19037515pjz.176.1592832205599;
        Mon, 22 Jun 2020 06:23:25 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id w206sm14408071pfc.28.2020.06.22.06.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 06:23:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: move the di_flags2 field to struct xfs_inode
Date:   Mon, 22 Jun 2020 18:53:23 +0530
Message-ID: <113775697.lumUs5xBWa@garuda>
In-Reply-To: <83835142.PHEsXu1aPz@garuda>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-13-hch@lst.de> <83835142.PHEsXu1aPz@garuda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 22 June 2020 6:21:37 PM IST Chandan Babu R wrote:
> On Saturday 20 June 2020 12:40:59 PM IST Christoph Hellwig wrote:
> > In preparation of removing the historic icinode struct, move the flags2
> > field into the containing xfs_inode structure.
> >
> 
> The changes look good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

The commit "fs/xfs: Update xfs_ioctl_setattr_dax_invalidate()"
(e4f9ba20d3b8c2b86ec71f326882e1a3c4e47953) adds the function
xfs_ioctl_setattr_prepare_dax() which refers to xfs_icdinode->di_flags2. A
rebase should solve this issue.

> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
> >  fs/xfs/libxfs/xfs_inode_buf.h |  2 --
> >  fs/xfs/xfs_bmap_util.c        | 24 ++++++++++++------------
> >  fs/xfs/xfs_file.c             |  4 ++--
> >  fs/xfs/xfs_inode.c            | 22 ++++++++++------------
> >  fs/xfs/xfs_inode.h            |  3 ++-
> >  fs/xfs/xfs_inode_item.c       |  2 +-
> >  fs/xfs/xfs_ioctl.c            | 23 +++++++++++------------
> >  fs/xfs/xfs_iops.c             |  2 +-
> >  fs/xfs/xfs_itable.c           |  2 +-
> >  fs/xfs/xfs_reflink.c          |  8 ++++----
> >  11 files changed, 46 insertions(+), 50 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index bb9c4775ecaa5c..79e470933abfa8 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -255,7 +255,7 @@ xfs_inode_from_disk(
> >  					   be64_to_cpu(from->di_changecount));
> >  		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> >  		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> > -		to->di_flags2 = be64_to_cpu(from->di_flags2);
> > +		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
> >  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
> >  	}
> >  
> > @@ -321,7 +321,7 @@ xfs_inode_to_disk(
> >  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> >  		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
> >  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> > -		to->di_flags2 = cpu_to_be64(from->di_flags2);
> > +		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
> >  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
> >  		to->di_ino = cpu_to_be64(ip->i_ino);
> >  		to->di_lsn = cpu_to_be64(lsn);
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> > index 5c6a6ac521b11d..4bfad6d6d5710a 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.h
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> > @@ -19,8 +19,6 @@ struct xfs_icdinode {
> >  	uint32_t	di_dmevmask;	/* DMIG event mask */
> >  	uint16_t	di_dmstate;	/* DMIG state info */
> >  
> > -	uint64_t	di_flags2;	/* more random flags */
> > -
> >  	struct timespec64 di_crtime;	/* time created */
> >  };
> >  
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 0b944aad75e618..8f85a4131983a6 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1332,9 +1332,9 @@ xfs_swap_extent_rmap(
> >  	 * rmap functions when we go to fix up the rmaps.  The flags
> >  	 * will be switch for reals later.
> >  	 */
> > -	tip_flags2 = tip->i_d.di_flags2;
> > -	if (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
> > -		tip->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> > +	tip_flags2 = tip->i_diflags2;
> > +	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
> > +		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
> >  
> >  	offset_fsb = 0;
> >  	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
> > @@ -1405,12 +1405,12 @@ xfs_swap_extent_rmap(
> >  		offset_fsb += ilen;
> >  	}
> >  
> > -	tip->i_d.di_flags2 = tip_flags2;
> > +	tip->i_diflags2 = tip_flags2;
> >  	return 0;
> >  
> >  out:
> >  	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
> > -	tip->i_d.di_flags2 = tip_flags2;
> > +	tip->i_diflags2 = tip_flags2;
> >  	return error;
> >  }
> >  
> > @@ -1708,13 +1708,13 @@ xfs_swap_extents(
> >  		goto out_trans_cancel;
> >  
> >  	/* Do we have to swap reflink flags? */
> > -	if ((ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK) ^
> > -	    (tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)) {
> > -		f = ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
> > -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> > -		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
> > -		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> > -		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
> > +	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
> > +	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
> > +		f = ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> > +		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> > +		ip->i_diflags2 |= tip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> > +		tip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> > +		tip->i_diflags2 |= f & XFS_DIFLAG2_REFLINK;
> >  	}
> >  
> >  	/* Swap the cow forks. */
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 4f08793f3d6db4..193352df48f6bd 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1052,9 +1052,9 @@ xfs_file_remap_range(
> >  	 */
> >  	cowextsize = 0;
> >  	if (pos_in == 0 && len == i_size_read(inode_in) &&
> > -	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> > +	    (src->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> >  	    pos_out == 0 && len >= i_size_read(inode_out) &&
> > -	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> > +	    !(dest->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
> >  		cowextsize = src->i_cowextsize;
> >  
> >  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 479342ac8851f4..593e8c5c2fd658 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -81,7 +81,7 @@ xfs_get_cowextsz_hint(
> >  	xfs_extlen_t		a, b;
> >  
> >  	a = 0;
> > -	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> > +	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
> >  		a = ip->i_cowextsize;
> >  	b = xfs_get_extsz_hint(ip);
> >  
> > @@ -671,9 +671,7 @@ uint
> >  xfs_ip2xflags(
> >  	struct xfs_inode	*ip)
> >  {
> > -	struct xfs_icdinode	*dic = &ip->i_d;
> > -
> > -	return _xfs_dic2xflags(ip->i_diflags, dic->di_flags2, XFS_IFORK_Q(ip));
> > +	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2, XFS_IFORK_Q(ip));
> >  }
> >  
> >  /*
> > @@ -841,7 +839,7 @@ xfs_ialloc(
> >  
> >  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> >  		inode_set_iversion(inode, 1);
> > -		ip->i_d.di_flags2 = 0;
> > +		ip->i_diflags2 = 0;
> >  		ip->i_cowextsize = 0;
> >  		ip->i_d.di_crtime = tv;
> >  	}
> > @@ -898,13 +896,13 @@ xfs_ialloc(
> >  
> >  			ip->i_diflags |= di_flags;
> >  		}
> > -		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
> > -			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> > -				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> > +		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY)) {
> > +			if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
> > +				ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
> >  				ip->i_cowextsize = pip->i_cowextsize;
> >  			}
> > -			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> > -				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
> > +			if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
> > +				ip->i_diflags2 |= XFS_DIFLAG2_DAX;
> >  		}
> >  		/* FALLTHROUGH */
> >  	case S_IFLNK:
> > @@ -1456,7 +1454,7 @@ xfs_itruncate_clear_reflink_flags(
> >  	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> >  	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> >  	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
> > -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> > +		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> >  	if (cfork->if_bytes == 0)
> >  		xfs_inode_clear_cowblocks_tag(ip);
> >  }
> > @@ -2756,7 +2754,7 @@ xfs_ifree(
> >  
> >  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
> >  	ip->i_diflags = 0;
> > -	ip->i_d.di_flags2 = 0;
> > +	ip->i_diflags2 = 0;
> >  	ip->i_d.di_dmevmask = 0;
> >  	ip->i_forkoff = 0;		/* mark the attr fork not in use */
> >  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 7673c841d89154..709f04fadde65e 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -65,6 +65,7 @@ typedef struct xfs_inode {
> >  	};
> >  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
> >  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
> > +	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> >  
> >  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> >  
> > @@ -193,7 +194,7 @@ xfs_get_initial_prid(struct xfs_inode *dp)
> >  
> >  static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
> >  {
> > -	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
> > +	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 6af8e829dd0172..04e671d2957ca2 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -342,7 +342,7 @@ xfs_inode_to_log_dinode(
> >  		to->di_changecount = inode_peek_iversion(inode);
> >  		to->di_crtime.t_sec = from->di_crtime.tv_sec;
> >  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
> > -		to->di_flags2 = from->di_flags2;
> > +		to->di_flags2 = ip->i_diflags2;
> >  		to->di_cowextsize = ip->i_cowextsize;
> >  		to->di_ino = ip->i_ino;
> >  		to->di_lsn = lsn;
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 326991f4d98096..d05b86e7930e84 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1110,7 +1110,7 @@ xfs_fill_fsxattr(
> >  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
> >  	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
> >  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> > -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> > +	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
> >  		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
> >  	fa->fsx_projid = ip->i_projid;
> >  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
> > @@ -1183,15 +1183,14 @@ xfs_flags2diflags2(
> >  	struct xfs_inode	*ip,
> >  	unsigned int		xflags)
> >  {
> > -	uint64_t		di_flags2 =
> > -		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> > +	uint64_t		i_flags2 = (ip->i_diflags2 & XFS_DIFLAG2_REFLINK);
> >  
> >  	if (xflags & FS_XFLAG_DAX)
> > -		di_flags2 |= XFS_DIFLAG2_DAX;
> > +		i_flags2 |= XFS_DIFLAG2_DAX;
> >  	if (xflags & FS_XFLAG_COWEXTSIZE)
> > -		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> > +		i_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> >  
> > -	return di_flags2;
> > +	return i_flags2;
> >  }
> >  
> >  static int
> > @@ -1201,7 +1200,7 @@ xfs_ioctl_setattr_xflags(
> >  	struct fsxattr		*fa)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	uint64_t		di_flags2;
> > +	uint64_t		i_flags2;
> >  
> >  	/* Can't change realtime flag if any extents are allocated. */
> >  	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
> > @@ -1217,19 +1216,19 @@ xfs_ioctl_setattr_xflags(
> >  
> >  	/* Clear reflink if we are actually able to set the rt flag. */
> >  	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
> > -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> > +		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> >  
> >  	/* Don't allow us to set DAX mode for a reflinked file for now. */
> >  	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
> >  		return -EINVAL;
> >  
> >  	/* diflags2 only valid for v3 inodes. */
> > -	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> > -	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
> > +	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> > +	if (i_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
> >  		return -EINVAL;
> >  
> >  	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
> > -	ip->i_d.di_flags2 = di_flags2;
> > +	ip->i_diflags2 = i_flags2;
> >  
> >  	xfs_diflags_to_iflags(ip, false);
> >  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> > @@ -1575,7 +1574,7 @@ xfs_ioctl_setattr(
> >  	else
> >  		ip->i_extsize = 0;
> >  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> > -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> > +	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
> >  		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
> >  	else
> >  		ip->i_cowextsize = 0;
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index f37154fc9828fd..3642f9935cae3f 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -1265,7 +1265,7 @@ xfs_inode_should_enable_dax(
> >  		return false;
> >  	if (ip->i_mount->m_flags & XFS_MOUNT_DAX_ALWAYS)
> >  		return true;
> > -	if (ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> > +	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
> >  		return true;
> >  	return false;
> >  }
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 7937af9f2ea779..4d1509437c3576 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -111,7 +111,7 @@ xfs_bulkstat_one_int(
> >  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
> >  
> >  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> > -		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> > +		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
> >  			buf->bs_cowextsize_blks = ip->i_cowextsize;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 0e07fa7e43117e..476ba54d84a9a3 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -882,7 +882,7 @@ xfs_reflink_set_inode_flag(
> >  	if (!xfs_is_reflink_inode(src)) {
> >  		trace_xfs_reflink_set_inode_flag(src);
> >  		xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
> > -		src->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> > +		src->i_diflags2 |= XFS_DIFLAG2_REFLINK;
> >  		xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
> >  		xfs_ifork_init_cow(src);
> >  	} else
> > @@ -894,7 +894,7 @@ xfs_reflink_set_inode_flag(
> >  	if (!xfs_is_reflink_inode(dest)) {
> >  		trace_xfs_reflink_set_inode_flag(dest);
> >  		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
> > -		dest->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> > +		dest->i_diflags2 |= XFS_DIFLAG2_REFLINK;
> >  		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
> >  		xfs_ifork_init_cow(dest);
> >  	} else
> > @@ -943,7 +943,7 @@ xfs_reflink_update_dest(
> >  
> >  	if (cowextsize) {
> >  		dest->i_cowextsize = cowextsize;
> > -		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> > +		dest->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
> >  	}
> >  
> >  	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
> > @@ -1463,7 +1463,7 @@ xfs_reflink_clear_inode_flag(
> >  
> >  	/* Clear the inode flag. */
> >  	trace_xfs_reflink_unset_inode_flag(ip);
> > -	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> > +	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> >  	xfs_inode_clear_cowblocks_tag(ip);
> >  	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> >  
> > 
> 
> 
> 


-- 
chandan



