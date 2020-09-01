Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5F0C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00AC206A5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:04:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ry6/whkt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgIAQEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:04:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731540AbgIAPmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:42:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Fe5dZ148888;
        Tue, 1 Sep 2020 15:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=el9epDx6nHElCUOIGl9X/o9lGP2GRcVlwkGHM5rTHiA=;
 b=ry6/whktdEmBM47fb+iYNrXssMa4wh+CtO6ELir1fpAcaJ5WGO4hiaTZvnomHLwM9vUR
 jatq+sc4IvcM8nh00mBjxDYtWbRdSLsP0Ww2xT0SxDLvVaC8WOiilUMvSG0Dj1XXE+m0
 vh5r5qgIgF3lWCDQo0Kv8Z0k3UC0tM/SA29oVnJokA0njaNYtx4Ij9DzxE3V9Fwg1Gim
 ig4ULw1Rc8vO6Twt3N8D0PX1v430qtFC0Y65blAQNDt+Eq8nn4ytbPTt6Qq4nqmT5Jty
 yAR6cTOhv56q92uAJGdm9WhVFnyTeOQDkKFBPDVz0LH5Ad1y39DH+L8aUGCkolTHzVfU xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eym5498-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 15:42:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Ff7G3117571;
        Tue, 1 Sep 2020 15:42:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3380ss0712-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 15:42:03 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 081Fg1Ok006414;
        Tue, 1 Sep 2020 15:42:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 08:42:01 -0700
Date:   Tue, 1 Sep 2020 08:42:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfsprogs: Introduce xfs_dfork_nextents() helper
Message-ID: <20200901154200.GE6096@magnolia>
References: <20200831130102.507-1-chandanrlinux@gmail.com>
 <20200831130102.507-3-chandanrlinux@gmail.com>
 <20200831205426.GX6096@magnolia>
 <5176869.BzSNGQQ5Lq@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5176869.BzSNGQQ5Lq@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 07:47:41PM +0530, Chandan Babu R wrote:
> On Tuesday 1 September 2020 2:24:26 AM IST Darrick J. Wong wrote:
> > On Mon, Aug 31, 2020 at 06:31:00PM +0530, Chandan Babu R wrote:
> > > This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper
> > > function xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents()
> > > returns the same value as XFS_DFORK_NEXTENTS(). A future commit which
> > > extends inode's extent counter fields will add more logic to this
> > > helper.
> > > 
> > > This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
> > > with calls to xfs_dfork_nextents().
> > > 
> > > No functional changes have been made.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  db/bmap.c               |  6 +++---
> > >  db/btdump.c             |  4 ++--
> > >  db/check.c              |  2 +-
> > >  db/frag.c               |  8 ++++---
> > >  db/inode.c              | 14 ++++++------
> > >  db/metadump.c           |  4 ++--
> > >  libxfs/xfs_format.h     |  4 ----
> > >  libxfs/xfs_inode_buf.c  | 26 ++++++++++++++++------
> > >  libxfs/xfs_inode_buf.h  |  2 ++
> > >  libxfs/xfs_inode_fork.c |  3 ++-
> > >  repair/attr_repair.c    |  2 +-
> > >  repair/dinode.c         | 48 +++++++++++++++++++++++------------------
> > >  repair/prefetch.c       |  2 +-
> > >  13 files changed, 74 insertions(+), 51 deletions(-)
> > > 
> > > diff --git a/db/bmap.c b/db/bmap.c
> > > index fdc70e95..9800a909 100644
> > > --- a/db/bmap.c
> > > +++ b/db/bmap.c
> > > @@ -68,7 +68,7 @@ bmap(
> > >  	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
> > >  		fmt == XFS_DINODE_FMT_BTREE);
> > >  	if (fmt == XFS_DINODE_FMT_EXTENTS) {
> > > -		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> > > +		nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > >  		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> > >  		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
> > >  			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
> > > @@ -158,9 +158,9 @@ bmap_f(
> > >  		push_cur();
> > >  		set_cur_inode(iocur_top->ino);
> > >  		dip = iocur_top->data;
> > > -		if (be32_to_cpu(dip->di_nextents))
> > > +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK))
> > 
> > Suggestion: Shift these kinds of changes to a separate patch to minimize
> > the amount of non-libxfs changes in a patch that will (eventually) be
> > ported from the kernel.  Ideally, the only changes to db/ and repair/
> > and mkfs/ would be the ones that are necessary to avoid breaking the
> > build.
> > 
> > Once you've separated the other conversions (like this one here) into a
> > separate patch, we can review that as a separate refactoring change to
> > userspace.
> 
> So the changes should be split into two patches -- One patch containing
> conversion changes to code inside libxfs and the other one for non-libxfs
> code. Please correct me if my understanding is incorrect.

I usually try to split the responsibilities in this manner:

"libxfs: prepare for FROB API change" -- make whatever change I need
to so that the next patch doesn't become insanely difficult.  This patch
is optional.

"xfs: change FROB API to frob" -- this is a strict backport of changes
from the kernel git tree to xfsprogs.  The only changes outside of
libxfs/ are fixes whatever tool breakage happens.

"xfs_db: support new FROB" -- add whatever new code you need to add to
xfs_db to support the new frob

"xfs_repair: support new FROB" -- same thing with repair

<repeat with the other tools>

"mkfs: support new FROB" -- same thing with mkfs

"xfs: officially enable FROB feature" -- make it so that libxfs will
actually recognize whatever new feature you're adding, if you're adding
one.

--D

> > 
> > The reason for this ofc is that when the maintainers run libxfs-apply to
> > pull in the kernel patches, they're totally going to miss things like
> > this conversion unless you make them an explicit separate change.
> > 
> > FWIW the conversions themselves mostly look ok...
> > 
> > >  			dfork = 1;
> > > -		if (be16_to_cpu(dip->di_anextents))
> > > +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
> > >  			afork = 1;
> > >  		pop_cur();
> > >  	}
> > > diff --git a/db/btdump.c b/db/btdump.c
> > > index 920f595b..9ced71d4 100644
> > > --- a/db/btdump.c
> > > +++ b/db/btdump.c
> > > @@ -166,13 +166,13 @@ dump_inode(
> > >  
> > >  	dip = iocur_top->data;
> > >  	if (attrfork) {
> > > -		if (!dip->di_anextents ||
> > > +		if (!xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK) ||
> > >  		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
> > >  			dbprintf(_("attr fork not in btree format\n"));
> > >  			return 0;
> > >  		}
> > >  	} else {
> > > -		if (!dip->di_nextents ||
> > > +		if (!xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK) ||
> > >  		    dip->di_format != XFS_DINODE_FMT_BTREE) {
> > >  			dbprintf(_("data fork not in btree format\n"));
> > >  			return 0;
> > > diff --git a/db/check.c b/db/check.c
> > > index 12c03b6d..2d1823a4 100644
> > > --- a/db/check.c
> > > +++ b/db/check.c
> > > @@ -2686,7 +2686,7 @@ process_exinode(
> > >  	xfs_bmbt_rec_t		*rp;
> > >  
> > >  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> > > -	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> > > +	*nex = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > >  	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
> > >  						sizeof(xfs_bmbt_rec_t)) {
> > >  		if (!sflag || id->ilist)
> > > diff --git a/db/frag.c b/db/frag.c
> > > index 1cfc6c2c..20fb1306 100644
> > > --- a/db/frag.c
> > > +++ b/db/frag.c
> > > @@ -262,9 +262,11 @@ process_exinode(
> > >  	int			whichfork)
> > >  {
> > >  	xfs_bmbt_rec_t		*rp;
> > > +	xfs_extnum_t		nextents;
> > >  
> > >  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> > > -	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
> > > +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > > +	process_bmbt_reclist(rp, nextents, extmapp);
> > >  }
> > >  
> > >  static void
> > > @@ -273,9 +275,9 @@ process_fork(
> > >  	int		whichfork)
> > >  {
> > >  	extmap_t	*extmap;
> > > -	int		nex;
> > > +	xfs_extnum_t	nex;
> > >  
> > > -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> > > +	nex = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > >  	if (!nex)
> > >  		return;
> > >  	extmap = extmap_alloc(nex);
> > > diff --git a/db/inode.c b/db/inode.c
> > > index 0cff9d63..3853092c 100644
> > > --- a/db/inode.c
> > > +++ b/db/inode.c
> > > @@ -271,7 +271,7 @@ inode_a_bmx_count(
> > >  		return 0;
> > >  	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
> > >  	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
> > > -		be16_to_cpu(dip->di_anextents) : 0;
> > > +		xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK) : 0;
> > >  }
> > >  
> > >  static int
> > > @@ -325,6 +325,7 @@ inode_a_size(
> > >  {
> > >  	xfs_attr_shortform_t	*asf;
> > >  	xfs_dinode_t		*dip;
> > > +	xfs_extnum_t		nextents;
> > >  
> > >  	ASSERT(startoff == 0);
> > >  	ASSERT(idx == 0);
> > > @@ -334,8 +335,8 @@ inode_a_size(
> > >  		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
> > >  		return bitize(be16_to_cpu(asf->hdr.totsize));
> > >  	case XFS_DINODE_FMT_EXTENTS:
> > > -		return (int)be16_to_cpu(dip->di_anextents) *
> > > -							bitsz(xfs_bmbt_rec_t);
> > > +		nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> > > +		return (int)(nextents * bitsz(xfs_bmbt_rec_t));
> > >  	case XFS_DINODE_FMT_BTREE:
> > >  		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
> > >  	default:
> > > @@ -496,7 +497,7 @@ inode_u_bmx_count(
> > >  	dip = obj;
> > >  	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
> > >  	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
> > > -		be32_to_cpu(dip->di_nextents) : 0;
> > > +		xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK) : 0;
> > >  }
> > >  
> > >  static int
> > > @@ -582,6 +583,7 @@ inode_u_size(
> > >  	int		idx)
> > >  {
> > >  	xfs_dinode_t	*dip;
> > > +	xfs_extnum_t	nextents;
> > >  
> > >  	ASSERT(startoff == 0);
> > >  	ASSERT(idx == 0);
> > > @@ -592,8 +594,8 @@ inode_u_size(
> > >  	case XFS_DINODE_FMT_LOCAL:
> > >  		return bitize((int)be64_to_cpu(dip->di_size));
> > >  	case XFS_DINODE_FMT_EXTENTS:
> > > -		return (int)be32_to_cpu(dip->di_nextents) *
> > > -						bitsz(xfs_bmbt_rec_t);
> > > +		nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> > > +		return (int)(nextents * bitsz(xfs_bmbt_rec_t));
> > >  	case XFS_DINODE_FMT_BTREE:
> > >  		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
> > >  	case XFS_DINODE_FMT_UUID:
> > > diff --git a/db/metadump.c b/db/metadump.c
> > > index e5cb3aa5..6a6757a2 100644
> > > --- a/db/metadump.c
> > > +++ b/db/metadump.c
> > > @@ -2282,7 +2282,7 @@ process_exinode(
> > >  
> > >  	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
> > >  
> > > -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> > > +	nex = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > >  	used = nex * sizeof(xfs_bmbt_rec_t);
> > >  	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > >  		if (show_warnings)
> > > @@ -2335,7 +2335,7 @@ static int
> > >  process_dev_inode(
> > >  	xfs_dinode_t		*dip)
> > >  {
> > > -	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> > > +	if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK)) {
> > >  		if (show_warnings)
> > >  			print_warning("inode %llu has unexpected extents",
> > >  				      (unsigned long long)cur_ino);
> > > diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> > > index a738cd8b..188deada 100644
> > > --- a/libxfs/xfs_format.h
> > > +++ b/libxfs/xfs_format.h
> > > @@ -993,10 +993,6 @@ enum xfs_dinode_fmt {
> > >  	((w) == XFS_DATA_FORK ? \
> > >  		(dip)->di_format : \
> > >  		(dip)->di_aformat)
> > > -#define XFS_DFORK_NEXTENTS(dip,w) \
> > > -	((w) == XFS_DATA_FORK ? \
> > > -		be32_to_cpu((dip)->di_nextents) : \
> > > -		be16_to_cpu((dip)->di_anextents))
> > >  
> > >  /*
> > >   * For block and character special files the 32bit dev_t is stored at the
> > > diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> > > index ae71a19e..d5584372 100644
> > > --- a/libxfs/xfs_inode_buf.c
> > > +++ b/libxfs/xfs_inode_buf.c
> > > @@ -362,9 +362,10 @@ xfs_dinode_verify_fork(
> > >  	struct xfs_mount	*mp,
> > >  	int			whichfork)
> > >  {
> > > -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> > >  	xfs_extnum_t		max_extents;
> > > +	uint32_t		di_nextents;
> > >  
> > > +	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> > >  
> > >  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> > >  	case XFS_DINODE_FMT_LOCAL:
> > > @@ -396,6 +397,15 @@ xfs_dinode_verify_fork(
> > >  	return NULL;
> > >  }
> > >  
> > > +xfs_extnum_t
> > > +xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
> > > +{
> > > +	if (whichfork == XFS_DATA_FORK)
> > > +		return be32_to_cpu(dip->di_nextents);
> > > +	else
> > > +		return be16_to_cpu(dip->di_anextents);
> > > +}
> > > +
> > >  static xfs_failaddr_t
> > >  xfs_dinode_verify_forkoff(
> > >  	struct xfs_dinode	*dip,
> > > @@ -432,6 +442,8 @@ xfs_dinode_verify(
> > >  	uint16_t		flags;
> > >  	uint64_t		flags2;
> > >  	uint64_t		di_size;
> > > +	xfs_extnum_t            nextents;
> > > +	int64_t			nblocks;
> > >  
> > >  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
> > >  		return __this_address;
> > > @@ -462,10 +474,12 @@ xfs_dinode_verify(
> > >  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
> > >  		return __this_address;
> > >  
> > > -	/* Fork checks carried over from xfs_iformat_fork */
> > > -	if (mode &&
> > > -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> > > -			be64_to_cpu(dip->di_nblocks))
> > > +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> > > +	nextents += xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> > > +	nblocks = be64_to_cpu(dip->di_nblocks);
> > > +
> > > +        /* Fork checks carried over from xfs_iformat_fork */
> > > +	if (mode && nextents > nblocks)
> > >  		return __this_address;
> > >  
> > >  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> > > @@ -522,7 +536,7 @@ xfs_dinode_verify(
> > >  		default:
> > >  			return __this_address;
> > >  		}
> > > -		if (dip->di_anextents)
> > > +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
> > >  			return __this_address;
> > >  	}
> > >  
> > > diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
> > > index 9b373dcf..f97b3428 100644
> > > --- a/libxfs/xfs_inode_buf.h
> > > +++ b/libxfs/xfs_inode_buf.h
> > > @@ -71,5 +71,7 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
> > >  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
> > >  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
> > >  		uint64_t flags2);
> > > +xfs_extnum_t xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip,
> > > +			int whichfork);
> > >  
> > >  #endif	/* __XFS_INODE_BUF_H__ */
> > > diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> > > index 80ba6c12..8c32f993 100644
> > > --- a/libxfs/xfs_inode_fork.c
> > > +++ b/libxfs/xfs_inode_fork.c
> > > @@ -205,9 +205,10 @@ xfs_iformat_extents(
> > >  	int			whichfork)
> > >  {
> > >  	struct xfs_mount	*mp = ip->i_mount;
> > > +	struct xfs_sb		*sbp = &mp->m_sb;
> > >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> > >  	int			state = xfs_bmap_fork_to_state(whichfork);
> > > -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> > > +	xfs_extnum_t		nex = xfs_dfork_nextents(sbp, dip, whichfork);
> > >  	int			size = nex * sizeof(xfs_bmbt_rec_t);
> > >  	struct xfs_iext_cursor	icur;
> > >  	struct xfs_bmbt_rec	*dp;
> > > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > > index 6cec0f70..b6ca564b 100644
> > > --- a/repair/attr_repair.c
> > > +++ b/repair/attr_repair.c
> > > @@ -1083,7 +1083,7 @@ process_longform_attr(
> > >  	bno = blkmap_get(blkmap, 0);
> > >  	if (bno == NULLFSBLOCK) {
> > >  		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
> > > -				be16_to_cpu(dip->di_anextents) == 0)
> > > +			xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK) == 0)
> > 
> > 		    ^
> > This should /not/ be indented so that it lines up with the if body.
> 
> Sorry about that. I will fix it up.
> 
> -- 
> chandan
> 
> 
> 
