Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78461C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4615D23787
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgLGQu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:50:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38262 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgLGQu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 11:50:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GnqLr028506;
        Mon, 7 Dec 2020 16:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EDA5lGKBEVXFoTeg7gU21D4dD6xkBeDs7DcpfBsdnd4=;
 b=Pwg6b++GGm7vVDIYV7mJ08bUVhiEzCXEKr/TVVhcTYDlcLCfjx6uc1DgQUfGctCEUBCQ
 edUs+1gjql3w994WcTl9HveWAWV+Q8ZMUQYOBFJlaJXgVoCErbUWXClT+GiGp5u531sC
 C8hbEyYd3dsimzgoDH/zvTkwM5MMxY5m2Xqrq6g0AtVuhBwqV0KFdhiYB5zBy/g8c4bu
 zGst26WGhajMA7W7jm7jaqVZzLk2N9urFb0dhGTwDVYWqHMbEmjtC/0E/2ddhFYID7MB
 PJBcL8DMr1AXbFR7v44xDYXsPtcfPBam4MM82bhkHGAeR50lTbv658ZgpU10hAWHND9B ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqpak4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 16:50:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7Gne7v087903;
        Mon, 7 Dec 2020 16:50:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4wgecm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 16:50:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7Go53t000370;
        Mon, 7 Dec 2020 16:50:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 08:50:05 -0800
Date:   Mon, 7 Dec 2020 08:50:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
Message-ID: <20201207165004.GM629293@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704435080.734470.11175993745850698818.stgit@magnolia>
 <20201204140036.GK1404170@bfoster>
 <20201206230842.GI629293@magnolia>
 <20201207140212.GB1585352@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207140212.GB1585352@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070108
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 09:02:12AM -0500, Brian Foster wrote:
> On Sun, Dec 06, 2020 at 03:08:42PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 04, 2020 at 09:00:36AM -0500, Brian Foster wrote:
> > > On Thu, Dec 03, 2020 at 05:12:30PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > The bmap, rmap, and refcount log intent items were added to support the
> > > > rmap and reflink features.  Because these features come with changes to
> > > > the ondisk format, the log items aren't tied to a log incompat flag.
> > > > 
> > > > However, the log recovery routines don't actually check for those
> > > > feature flags.  The kernel has no business replayng an intent item for a
> > > > feature that isn't enabled, so check that as part of recovered log item
> > > > validation.  (Note that kernels pre-dating rmap and reflink will fail
> > > > the mount on the unknown log item type code.)
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/xfs_bmap_item.c     |    4 ++++
> > > >  fs/xfs/xfs_refcount_item.c |    3 +++
> > > >  fs/xfs/xfs_rmap_item.c     |    3 +++
> > > >  3 files changed, 10 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > > > index 78346d47564b..4ea9132716c6 100644
> > > > --- a/fs/xfs/xfs_bmap_item.c
> > > > +++ b/fs/xfs/xfs_bmap_item.c
> > > > @@ -425,6 +425,10 @@ xfs_bui_validate(
> > > >  {
> > > >  	struct xfs_map_extent		*bmap;
> > > >  
> > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> > > > +	    !xfs_sb_version_hasreflink(&mp->m_sb))
> > > > +		return false;
> > > > +
> > > 
> > > Took me a minute to realize we use the map/unmap for extent swap if rmap
> > > is enabled. That does make me wonder a bit.. had we made this kind of
> > > recovery feature validation change before that came around (such that we
> > > probably would have only checked _hasreflink() here), would we have
> > > created an unnecessary backwards incompatibility?
> > 
> > Yes.
> > 
> > I confess to cheating a little here -- technically the bmap intents were
> > introduced with reflink in 4.9, whereas rmap was introduced in 4.8.  The
> > proper solution is probably to introduce a new log incompat bit for bmap
> > intents when reflink isn't enabled, but TBH there were enough other rmap
> > bugs in 4.8 (not to mention the EXPERIMENTAL warning) that nobody should
> > be running that old of a kernel on a production system.
> > 
> > (Also we don't enable rmap by default yet whereas reflink has been
> > enabled by default since 4.18, so the number of people affected probably
> > isn't very high...)
> > 
> 
> Hmm, so this all has me a a bit concerned over the value proposition for
> these particular feature checks. The current reflink/rmap feature
> situation may work out Ok in practice, but it sounds like that is partly
> due to timing and a little bit of luck around when the implementations
> and interdependencies landed. This code will ultimately introduce a
> verification pattern that will likely be followed for new features,
> associated log item types, etc. and it's not totally clear to me that
> we'd always get it right (as opposed to something more granular like
> incompat bits for intent formats). Is this addressing a real problem
> we've seen in the wild or more of a fuzzing thing?

Neither, it was just me doing some code review over thanksgiving.

It also occurred to me to (re)consider this in terms of "What are we
protecting against?"  Adding feature checks to the CUI/RUI recovery
functions makes sense since we can't replay something into a feature
that isn't enabled.  For BUI items however, the bmap has existed forever
so we're really not guarding much.  If someone out there has (for
example) a V4 filesystem with a dirty BUI to replay, why not replay it?

So I guess I could just drop the feature check from the BUI recovery
function.

--D

> > Secondary question: should we patch 4.9 and 4.14 to disable rmap and
> > reflink support, since they both still have EXPERIMENTAL warnings?
> > 
> 
> That sounds like an odd thing to do to a stable kernel, but that's just
> my .02.
> 
> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  	/* Only one mapping operation per BUI... */
> > > >  	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> > > >  		return false;
> > > > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > > > index 8ad6c81f6d8f..2b28f5643c0b 100644
> > > > --- a/fs/xfs/xfs_refcount_item.c
> > > > +++ b/fs/xfs/xfs_refcount_item.c
> > > > @@ -423,6 +423,9 @@ xfs_cui_validate_phys(
> > > >  	struct xfs_mount		*mp,
> > > >  	struct xfs_phys_extent		*refc)
> > > >  {
> > > > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > > > +		return false;
> > > > +
> > > >  	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
> > > >  		return false;
> > > >  
> > > > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > > > index f296ec349936..2628bc0080fe 100644
> > > > --- a/fs/xfs/xfs_rmap_item.c
> > > > +++ b/fs/xfs/xfs_rmap_item.c
> > > > @@ -466,6 +466,9 @@ xfs_rui_validate_map(
> > > >  	struct xfs_mount		*mp,
> > > >  	struct xfs_map_extent		*rmap)
> > > >  {
> > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > +		return false;
> > > > +
> > > >  	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
> > > >  		return false;
> > > >  
> > > > 
> > > 
> > 
> 
