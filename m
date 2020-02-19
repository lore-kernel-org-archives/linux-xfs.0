Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748EEC34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B316206ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNVXTiEA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgBSOwo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:52:44 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34388 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726582AbgBSOwo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 09:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582123961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OLNFjZi8gNaJ8KrSeqrg/d9IenQ9dGhy6oHtkolX8dc=;
        b=bNVXTiEA5a0ectvqZRUPn6mf67/EL8fGbiguYRFw0A+njTbyA4XQLgMF5Zlk5DrjzY1+n/
        yxOfB8+SUoYdSYcSm8Ykp9zDuhLs7W1aI+1NEUFvYkVxz0T9EGbfu9iZUvLiHHK9LU4Rtq
        MbP5D7ERVdL97q2Jct96p1ton/EZTCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-ZR884ssBPeGCXzzxRyxy5w-1; Wed, 19 Feb 2020 09:52:37 -0500
X-MC-Unique: ZR884ssBPeGCXzzxRyxy5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F483100DFC9;
        Wed, 19 Feb 2020 14:52:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E15115DA82;
        Wed, 19 Feb 2020 14:52:35 +0000 (UTC)
Date:   Wed, 19 Feb 2020 09:52:34 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the di_version field from struct icdinode
Message-ID: <20200219145234.GE24157@bfoster>
References: <20200116104640.489259-1-hch@lst.de>
 <20200218210615.GA3142@infradead.org>
 <20200219001852.GA9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219001852.GA9506@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 04:18:52PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 18, 2020 at 01:06:15PM -0800, Christoph Hellwig wrote:
> > Any comments?
> 
> "Maintainer drowning, please throw lifejackets... :("
> 
> (I took a long weekend and came back to 1,050 new emails, half of which
> came in via fsdevel...)
> 
> IIRC I started reading this last month, and tried to picture what will
> happen when we introduce a v4 inode format -- will we have to revert all
> of the tests that went from "is di_version == 3" to "if hascrc" in this
> patch?  Or will we simply be adding more code, e.g.
> 
> 	if (hascrc(...)) {
> 		/* do v3 stuff */
> 	}
> 
> 	if (di_version == 4) {
> 		/* do v4 stuff */
> 	}
> 
> I think the answer is that the code for a v4 inode format would probably
> end up doing that and it's probably ok...
> 

FWIW, I don't really view this patch as a straightforward
simplification. IMO, this slightly sacrifices readability for slightly
less code and a smaller xfs_icdinode. That might be acceptable... I
don't feel terribly strongly against it, but to me the explicit version
checks are more clear in cases where the _hascrc() check is not used for
something that is obviously CRC related (which is a pattern I'm
generally not a fan of).

Brian

> --D
> 
> > 
> > On Thu, Jan 16, 2020 at 11:46:40AM +0100, Christoph Hellwig wrote:
> > > We know the version is 3 if the file system is CRC enabled or otherwise
> > > 2 given that we upgrade any remaining v1 inode.  Remove the extra field
> > > and simplify the code a bit.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
> > >  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
> > >  fs/xfs/libxfs/xfs_format.h     | 15 +++++++--------
> > >  fs/xfs/libxfs/xfs_inode_buf.c  | 18 +++++++-----------
> > >  fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
> > >  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
> > >  fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
> > >  fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
> > >  fs/xfs/xfs_bmap_util.c         | 16 ++++++++--------
> > >  fs/xfs/xfs_inode.c             | 22 ++++------------------
> > >  fs/xfs/xfs_inode_item.c        | 14 ++++++--------
> > >  fs/xfs/xfs_ioctl.c             |  7 +++----
> > >  fs/xfs/xfs_iops.c              |  2 +-
> > >  fs/xfs/xfs_itable.c            |  2 +-
> > >  fs/xfs/xfs_log_recover.c       |  4 ++--
> > >  fs/xfs/xfs_symlink.c           |  2 +-
> > >  16 files changed, 53 insertions(+), 86 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index 08d4b10ae2d5..474317f9e6ae 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -526,7 +526,7 @@ xfs_attr_shortform_bytesfit(
> > >  	int			offset;
> > >  
> > >  	/* rounded down */
> > > -	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
> > > +	offset = (XFS_LITINO(mp) - bytes) >> 3;
> > >  
> > >  	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
> > >  		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> > > @@ -593,8 +593,7 @@ xfs_attr_shortform_bytesfit(
> > >  	minforkoff = roundup(minforkoff, 8) >> 3;
> > >  
> > >  	/* attr fork btree root can have at least this many key/ptr pairs */
> > > -	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
> > > -			XFS_BMDR_SPACE_CALC(MINABTPTRS);
> > > +	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> > >  	maxforkoff = maxforkoff >> 3;	/* rounded down */
> > >  
> > >  	if (offset >= maxforkoff)
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 4c2e046fbfad..a39558596aef 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -193,14 +193,12 @@ xfs_default_attroffset(
> > >  	struct xfs_mount	*mp = ip->i_mount;
> > >  	uint			offset;
> > >  
> > > -	if (mp->m_sb.sb_inodesize == 256) {
> > > -		offset = XFS_LITINO(mp, ip->i_d.di_version) -
> > > -				XFS_BMDR_SPACE_CALC(MINABTPTRS);
> > > -	} else {
> > > +	if (mp->m_sb.sb_inodesize == 256)
> > > +		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> > > +	else
> > >  		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> > > -	}
> > >  
> > > -	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
> > > +	ASSERT(offset < XFS_LITINO(mp));
> > >  	return offset;
> > >  }
> > >  
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 1b7dcbae051c..3247977aa139 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -946,8 +946,11 @@ enum xfs_dinode_fmt {
> > >  /*
> > >   * Inode size for given fs.
> > >   */
> > > -#define XFS_LITINO(mp, version) \
> > > -	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
> > > +#define XFS_DINODE_SIZE(mp) \
> > > +       (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
> > > +        sizeof(struct xfs_dinode) : offsetof(struct xfs_dinode, di_crc))
> > > +#define XFS_LITINO(mp) \
> > > +	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(mp))
> > >  
> > >  /*
> > >   * Inode data & attribute fork sizes, per inode.
> > > @@ -956,13 +959,9 @@ enum xfs_dinode_fmt {
> > >  #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
> > >  
> > >  #define XFS_DFORK_DSIZE(dip,mp) \
> > > -	(XFS_DFORK_Q(dip) ? \
> > > -		XFS_DFORK_BOFF(dip) : \
> > > -		XFS_LITINO(mp, (dip)->di_version))
> > > +	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
> > >  #define XFS_DFORK_ASIZE(dip,mp) \
> > > -	(XFS_DFORK_Q(dip) ? \
> > > -		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
> > > -		0)
> > > +	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
> > >  #define XFS_DFORK_SIZE(dip,mp,w) \
> > >  	((w) == XFS_DATA_FORK ? \
> > >  		XFS_DFORK_DSIZE(dip, mp) : \
> > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > > index 8afacfe4be0a..62299b6c2a97 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > > @@ -205,16 +205,14 @@ xfs_inode_from_disk(
> > >  	struct xfs_icdinode	*to = &ip->i_d;
> > >  	struct inode		*inode = VFS_I(ip);
> > >  
> > > -
> > >  	/*
> > >  	 * Convert v1 inodes immediately to v2 inode format as this is the
> > >  	 * minimum inode version format we support in the rest of the code.
> > > +	 * They will also be unconditionally written back to disk as v2 inodes.
> > >  	 */
> > > -	to->di_version = from->di_version;
> > > -	if (to->di_version == 1) {
> > > +	if (unlikely(from->di_version == 1)) {
> > >  		set_nlink(inode, be16_to_cpu(from->di_onlink));
> > >  		to->di_projid = 0;
> > > -		to->di_version = 2;
> > >  	} else {
> > >  		set_nlink(inode, be32_to_cpu(from->di_nlink));
> > >  		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
> > > @@ -252,7 +250,7 @@ xfs_inode_from_disk(
> > >  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
> > >  	to->di_flags	= be16_to_cpu(from->di_flags);
> > >  
> > > -	if (to->di_version == 3) {
> > > +	if (xfs_sb_version_hascrc(&ip->i_mount->m_sb)) {
> > >  		inode_set_iversion_queried(inode,
> > >  					   be64_to_cpu(from->di_changecount));
> > >  		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> > > @@ -274,7 +272,6 @@ xfs_inode_to_disk(
> > >  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > >  	to->di_onlink = 0;
> > >  
> > > -	to->di_version = from->di_version;
> > >  	to->di_format = from->di_format;
> > >  	to->di_uid = cpu_to_be32(from->di_uid);
> > >  	to->di_gid = cpu_to_be32(from->di_gid);
> > > @@ -303,7 +300,8 @@ xfs_inode_to_disk(
> > >  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
> > >  	to->di_flags = cpu_to_be16(from->di_flags);
> > >  
> > > -	if (from->di_version == 3) {
> > > +	if (xfs_sb_version_hascrc(&ip->i_mount->m_sb)) {
> > > +		to->di_version = 3;
> > >  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> > >  		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
> > >  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> > > @@ -315,6 +313,7 @@ xfs_inode_to_disk(
> > >  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
> > >  		to->di_flushiter = 0;
> > >  	} else {
> > > +		to->di_version = 2;
> > >  		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> > >  	}
> > >  }
> > > @@ -428,7 +427,7 @@ xfs_dinode_verify_forkoff(
> > >  	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
> > >  	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
> > >  	case XFS_DINODE_FMT_BTREE:
> > > -		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
> > > +		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
> > >  			return __this_address;
> > >  		break;
> > >  	default:
> > > @@ -632,7 +631,6 @@ xfs_iread(
> > >  	    xfs_sb_version_hascrc(&mp->m_sb) &&
> > >  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> > >  		VFS_I(ip)->i_generation = prandom_u32();
> > > -		ip->i_d.di_version = 3;
> > >  		return 0;
> > >  	}
> > >  
> > > @@ -674,7 +672,6 @@ xfs_iread(
> > >  		 * Partial initialisation of the in-core inode. Just the bits
> > >  		 * that xfs_ialloc won't overwrite or relies on being correct.
> > >  		 */
> > > -		ip->i_d.di_version = dip->di_version;
> > >  		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
> > >  		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
> > >  
> > > @@ -688,7 +685,6 @@ xfs_iread(
> > >  		VFS_I(ip)->i_mode = 0;
> > >  	}
> > >  
> > > -	ASSERT(ip->i_d.di_version >= 2);
> > >  	ip->i_delayed_blks = 0;
> > >  
> > >  	/*
> > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> > > index fd94b1078722..fda0d1ebc37d 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_buf.h
> > > +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> > > @@ -16,7 +16,6 @@ struct xfs_dinode;
> > >   * format specific structures at the appropriate time.
> > >   */
> > >  struct xfs_icdinode {
> > > -	int8_t		di_version;	/* inode version */
> > >  	int8_t		di_format;	/* format of di_c data */
> > >  	uint16_t	di_flushiter;	/* incremented on flush */
> > >  	uint32_t	di_uid;		/* owner's user id */
> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > > index ad2b9c313fd2..518c6f0ec3a6 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > > @@ -183,7 +183,7 @@ xfs_iformat_local(
> > >  	 */
> > >  	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
> > >  		xfs_warn(ip->i_mount,
> > > -	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
> > > +	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
> > >  			(unsigned long long) ip->i_ino, size,
> > >  			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
> > >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > index 500333d0101e..668ee942be22 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > @@ -46,14 +46,9 @@ struct xfs_ifork {
> > >  			(ip)->i_afp : \
> > >  			(ip)->i_cowfp))
> > >  #define XFS_IFORK_DSIZE(ip) \
> > > -	(XFS_IFORK_Q(ip) ? \
> > > -		XFS_IFORK_BOFF(ip) : \
> > > -		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
> > > +	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
> > >  #define XFS_IFORK_ASIZE(ip) \
> > > -	(XFS_IFORK_Q(ip) ? \
> > > -		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
> > > -			XFS_IFORK_BOFF(ip) : \
> > > -		0)
> > > +	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
> > >  #define XFS_IFORK_SIZE(ip,w) \
> > >  	((w) == XFS_DATA_FORK ? \
> > >  		XFS_IFORK_DSIZE(ip) : \
> > > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > > index 8ef31d71a9c7..2cbda2615d75 100644
> > > --- a/fs/xfs/libxfs/xfs_log_format.h
> > > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > > @@ -424,12 +424,10 @@ struct xfs_log_dinode {
> > >  	/* structure must be padded to 64 bit alignment */
> > >  };
> > >  
> > > -static inline uint xfs_log_dinode_size(int version)
> > > -{
> > > -	if (version == 3)
> > > -		return sizeof(struct xfs_log_dinode);
> > > -	return offsetof(struct xfs_log_dinode, di_next_unlinked);
> > > -}
> > > +#define xfs_log_dinode_size(mp)						\
> > > +	(xfs_sb_version_hascrc(&(mp)->m_sb) ?				\
> > > +		sizeof(struct xfs_log_dinode) :				\
> > > +		offsetof(struct xfs_log_dinode, di_next_unlinked))
> > >  
> > >  /*
> > >   * Buffer Log Format definitions
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index a454f481107e..a61f58d181cd 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1439,12 +1439,12 @@ xfs_swap_extent_forks(
> > >  	 * event of a crash. Set the owner change log flags now and leave the
> > >  	 * bmbt scan as the last step.
> > >  	 */
> > > -	if (ip->i_d.di_version == 3 &&
> > > -	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> > > -		(*target_log_flags) |= XFS_ILOG_DOWNER;
> > > -	if (tip->i_d.di_version == 3 &&
> > > -	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> > > -		(*src_log_flags) |= XFS_ILOG_DOWNER;
> > > +	if (xfs_sb_version_hascrc(&ip->i_mount->m_sb)) {
> > > +		if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> > > +			(*target_log_flags) |= XFS_ILOG_DOWNER;
> > > +		if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> > > +			(*src_log_flags) |= XFS_ILOG_DOWNER;
> > > +	}
> > >  
> > >  	/*
> > >  	 * Swap the data forks of the inodes
> > > @@ -1479,7 +1479,7 @@ xfs_swap_extent_forks(
> > >  		(*src_log_flags) |= XFS_ILOG_DEXT;
> > >  		break;
> > >  	case XFS_DINODE_FMT_BTREE:
> > > -		ASSERT(ip->i_d.di_version < 3 ||
> > > +		ASSERT(!xfs_sb_version_hascrc(&ip->i_mount->m_sb) ||
> > >  		       (*src_log_flags & XFS_ILOG_DOWNER));
> > >  		(*src_log_flags) |= XFS_ILOG_DBROOT;
> > >  		break;
> > > @@ -1491,7 +1491,7 @@ xfs_swap_extent_forks(
> > >  		break;
> > >  	case XFS_DINODE_FMT_BTREE:
> > >  		(*target_log_flags) |= XFS_ILOG_DBROOT;
> > > -		ASSERT(tip->i_d.di_version < 3 ||
> > > +		ASSERT(!xfs_sb_version_hascrc(&ip->i_mount->m_sb) ||
> > >  		       (*target_log_flags & XFS_ILOG_DOWNER));
> > >  		break;
> > >  	}
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 401da197f012..ccd975d0616b 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -801,15 +801,6 @@ xfs_ialloc(
> > >  		return error;
> > >  	ASSERT(ip != NULL);
> > >  	inode = VFS_I(ip);
> > > -
> > > -	/*
> > > -	 * We always convert v1 inodes to v2 now - we only support filesystems
> > > -	 * with >= v2 inode capability, so there is no reason for ever leaving
> > > -	 * an inode in v1 format.
> > > -	 */
> > > -	if (ip->i_d.di_version == 1)
> > > -		ip->i_d.di_version = 2;
> > > -
> > >  	inode->i_mode = mode;
> > >  	set_nlink(inode, nlink);
> > >  	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
> > > @@ -847,14 +838,13 @@ xfs_ialloc(
> > >  	ip->i_d.di_dmstate = 0;
> > >  	ip->i_d.di_flags = 0;
> > >  
> > > -	if (ip->i_d.di_version == 3) {
> > > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > >  		inode_set_iversion(inode, 1);
> > >  		ip->i_d.di_flags2 = 0;
> > >  		ip->i_d.di_cowextsize = 0;
> > >  		ip->i_d.di_crtime = tv;
> > >  	}
> > >  
> > > -
> > >  	flags = XFS_ILOG_CORE;
> > >  	switch (mode & S_IFMT) {
> > >  	case S_IFIFO:
> > > @@ -907,10 +897,8 @@ xfs_ialloc(
> > >  
> > >  			ip->i_d.di_flags |= di_flags;
> > >  		}
> > > -		if (pip &&
> > > -		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
> > > -		    pip->i_d.di_version == 3 &&
> > > -		    ip->i_d.di_version == 3) {
> > > +		if (xfs_sb_version_hascrc(&mp->m_sb) &&
> > > +		    pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
> > >  			uint64_t	di_flags2 = 0;
> > >  
> > >  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> > > @@ -1122,7 +1110,6 @@ xfs_bumplink(
> > >  {
> > >  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> > >  
> > > -	ASSERT(ip->i_d.di_version > 1);
> > >  	inc_nlink(VFS_I(ip));
> > >  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > >  }
> > > @@ -3808,7 +3795,6 @@ xfs_iflush_int(
> > >  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
> > >  	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> > >  	ASSERT(iip != NULL && iip->ili_fields != 0);
> > > -	ASSERT(ip->i_d.di_version > 1);
> > >  
> > >  	/* set *dip = inode's place in the buffer */
> > >  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
> > > @@ -3869,7 +3855,7 @@ xfs_iflush_int(
> > >  	 * backwards compatibility with old kernels that predate logging all
> > >  	 * inode changes.
> > >  	 */
> > > -	if (ip->i_d.di_version < 3)
> > > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > >  		ip->i_d.di_flushiter++;
> > >  
> > >  	/* Check the inline fork data before we write out. */
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index 8bd5d0de6321..08e54023430b 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -125,7 +125,7 @@ xfs_inode_item_size(
> > >  
> > >  	*nvecs += 2;
> > >  	*nbytes += sizeof(struct xfs_inode_log_format) +
> > > -		   xfs_log_dinode_size(ip->i_d.di_version);
> > > +		   xfs_log_dinode_size(ip->i_mount);
> > >  
> > >  	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
> > >  	if (XFS_IFORK_Q(ip))
> > > @@ -305,9 +305,6 @@ xfs_inode_to_log_dinode(
> > >  	struct inode		*inode = VFS_I(ip);
> > >  
> > >  	to->di_magic = XFS_DINODE_MAGIC;
> > > -
> > > -	to->di_version = from->di_version;
> > > -	to->di_format = from->di_format;
> > >  	to->di_uid = from->di_uid;
> > >  	to->di_gid = from->di_gid;
> > >  	to->di_projid_lo = from->di_projid & 0xffff;
> > > @@ -339,7 +336,8 @@ xfs_inode_to_log_dinode(
> > >  	/* log a dummy value to ensure log structure is fully initialised */
> > >  	to->di_next_unlinked = NULLAGINO;
> > >  
> > > -	if (from->di_version == 3) {
> > > +	if (xfs_sb_version_hascrc(&ip->i_mount->m_sb)) {
> > > +		to->di_version = 3;
> > >  		to->di_changecount = inode_peek_iversion(inode);
> > >  		to->di_crtime.t_sec = from->di_crtime.tv_sec;
> > >  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
> > > @@ -351,8 +349,10 @@ xfs_inode_to_log_dinode(
> > >  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
> > >  		to->di_flushiter = 0;
> > >  	} else {
> > > +		to->di_version = 2;
> > >  		to->di_flushiter = from->di_flushiter;
> > >  	}
> > > +	to->di_format = from->di_format;
> > >  }
> > >  
> > >  /*
> > > @@ -370,7 +370,7 @@ xfs_inode_item_format_core(
> > >  
> > >  	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
> > >  	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> > > -	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
> > > +	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
> > >  }
> > >  
> > >  /*
> > > @@ -395,8 +395,6 @@ xfs_inode_item_format(
> > >  	struct xfs_log_iovec	*vecp = NULL;
> > >  	struct xfs_inode_log_format *ilf;
> > >  
> > > -	ASSERT(ip->i_d.di_version > 1);
> > > -
> > >  	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
> > >  	ilf->ilf_type = XFS_LI_INODE;
> > >  	ilf->ilf_ino = ip->i_ino;
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index 331453f2c4be..a40ed3f51650 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -1147,7 +1147,7 @@ xfs_ioctl_setattr_xflags(
> > >  
> > >  	/* diflags2 only valid for v3 inodes. */
> > >  	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> > > -	if (di_flags2 && ip->i_d.di_version < 3)
> > > +	if (di_flags2 && !xfs_sb_version_hascrc(&mp->m_sb))
> > >  		return -EINVAL;
> > >  
> > >  	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
> > > @@ -1358,7 +1358,7 @@ xfs_ioctl_setattr_check_cowextsize(
> > >  		return 0;
> > >  
> > >  	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
> > > -	    ip->i_d.di_version != 3)
> > > +	    !xfs_sb_version_hascrc(&ip->i_mount->m_sb))
> > >  		return -EINVAL;
> > >  
> > >  	if (fa->fsx_cowextsize == 0)
> > > @@ -1486,7 +1486,6 @@ xfs_ioctl_setattr(
> > >  			olddquot = xfs_qm_vop_chown(tp, ip,
> > >  						&ip->i_pdquot, pdqp);
> > >  		}
> > > -		ASSERT(ip->i_d.di_version > 1);
> > >  		ip->i_d.di_projid = fa->fsx_projid;
> > >  	}
> > >  
> > > @@ -1499,7 +1498,7 @@ xfs_ioctl_setattr(
> > >  		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> > >  	else
> > >  		ip->i_d.di_extsize = 0;
> > > -	if (ip->i_d.di_version == 3 &&
> > > +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> > >  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> > >  		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
> > >  				mp->m_sb.sb_blocklog;
> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index 700edeccc6bf..cd5e9288c598 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -551,7 +551,7 @@ xfs_vn_getattr(
> > >  	stat->blocks =
> > >  		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> > >  
> > > -	if (ip->i_d.di_version == 3) {
> > > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > >  		if (request_mask & STATX_BTIME) {
> > >  			stat->result_mask |= STATX_BTIME;
> > >  			stat->btime = ip->i_d.di_crtime;
> > > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > > index 4b31c29b7e6b..07b81474e35e 100644
> > > --- a/fs/xfs/xfs_itable.c
> > > +++ b/fs/xfs/xfs_itable.c
> > > @@ -110,7 +110,7 @@ xfs_bulkstat_one_int(
> > >  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> > >  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
> > >  
> > > -	if (dic->di_version == 3) {
> > > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > >  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> > >  			buf->bs_cowextsize_blks = dic->di_cowextsize;
> > >  	}
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 99ec3fba4548..030149564034 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -2868,8 +2868,8 @@ xfs_recover_inode_owner_change(
> > >  		return -ENOMEM;
> > >  
> > >  	/* instantiate the inode */
> > > +	ASSERT(dip->di_version >= 3);
> > >  	xfs_inode_from_disk(ip, dip);
> > > -	ASSERT(ip->i_d.di_version >= 3);
> > >  
> > >  	error = xfs_iformat_fork(ip, dip);
> > >  	if (error)
> > > @@ -3074,7 +3074,7 @@ xlog_recover_inode_pass2(
> > >  		error = -EFSCORRUPTED;
> > >  		goto out_release;
> > >  	}
> > > -	isize = xfs_log_dinode_size(ldip->di_version);
> > > +	isize = xfs_log_dinode_size(mp);
> > >  	if (unlikely(item->ri_buf[1].i_len > isize)) {
> > >  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
> > >  				     XFS_ERRLEVEL_LOW, mp, ldip,
> > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > > index a25502bc2071..7c63b1c62c9b 100644
> > > --- a/fs/xfs/xfs_symlink.c
> > > +++ b/fs/xfs/xfs_symlink.c
> > > @@ -204,7 +204,7 @@ xfs_symlink(
> > >  	 * The symlink will fit into the inode data fork?
> > >  	 * There can't be any attributes so we get the whole variable part.
> > >  	 */
> > > -	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
> > > +	if (pathlen <= XFS_LITINO(mp))
> > >  		fs_blocks = 0;
> > >  	else
> > >  		fs_blocks = xfs_symlink_blocks(mp, pathlen);
> > > -- 
> > > 2.24.1
> > > 
> > ---end quoted text---
> 

