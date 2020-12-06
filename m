Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760D7C19425
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4284223120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLFXJc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:09:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:09:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N45A5185213;
        Sun, 6 Dec 2020 23:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=s4UpUcCt0LUuCpMK1xE78x4ZJaUd39uODPHs3WzwcDg=;
 b=zcxSxV7huCfuQQQfzJUMjbxFXF3UHCWa7U8br4ef5f8g60QwGs4j9sbZdTAHYytB8Q4n
 DEUdJPaRBKVbLUTwH9vgGxv0W8CiCijAwpL10co5GaDZnng5OTwoqMT7zHR6osCj9JJF
 rxfQO5YHgCYAHwyoKctPTfymdIKC6QcLjTnkUdmlR9kQ5hYkdJtCKgz3JqRrvTJfd5sg
 1RnUk1guWCCMrDZTgTsf1cATGS6TZEk5iGNP1WbltLmbaGom6d0DmVb86gwRscqviUFi
 yUZfS215IUJ9aXlCkc3l6X/4ckbt7GSicO9FZNXmTW5QhDUnM6EydfYOBjlI1XkCI5zm xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mqjvgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:08:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N4frH165518;
        Sun, 6 Dec 2020 23:08:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358kskgaef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:08:46 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6N8hme010870;
        Sun, 6 Dec 2020 23:08:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:08:43 -0800
Date:   Sun, 6 Dec 2020 15:08:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
Message-ID: <20201206230842.GI629293@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704435080.734470.11175993745850698818.stgit@magnolia>
 <20201204140036.GK1404170@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204140036.GK1404170@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 09:00:36AM -0500, Brian Foster wrote:
> On Thu, Dec 03, 2020 at 05:12:30PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The bmap, rmap, and refcount log intent items were added to support the
> > rmap and reflink features.  Because these features come with changes to
> > the ondisk format, the log items aren't tied to a log incompat flag.
> > 
> > However, the log recovery routines don't actually check for those
> > feature flags.  The kernel has no business replayng an intent item for a
> > feature that isn't enabled, so check that as part of recovered log item
> > validation.  (Note that kernels pre-dating rmap and reflink will fail
> > the mount on the unknown log item type code.)
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_bmap_item.c     |    4 ++++
> >  fs/xfs/xfs_refcount_item.c |    3 +++
> >  fs/xfs/xfs_rmap_item.c     |    3 +++
> >  3 files changed, 10 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 78346d47564b..4ea9132716c6 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -425,6 +425,10 @@ xfs_bui_validate(
> >  {
> >  	struct xfs_map_extent		*bmap;
> >  
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> > +	    !xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return false;
> > +
> 
> Took me a minute to realize we use the map/unmap for extent swap if rmap
> is enabled. That does make me wonder a bit.. had we made this kind of
> recovery feature validation change before that came around (such that we
> probably would have only checked _hasreflink() here), would we have
> created an unnecessary backwards incompatibility?

Yes.

I confess to cheating a little here -- technically the bmap intents were
introduced with reflink in 4.9, whereas rmap was introduced in 4.8.  The
proper solution is probably to introduce a new log incompat bit for bmap
intents when reflink isn't enabled, but TBH there were enough other rmap
bugs in 4.8 (not to mention the EXPERIMENTAL warning) that nobody should
be running that old of a kernel on a production system.

(Also we don't enable rmap by default yet whereas reflink has been
enabled by default since 4.18, so the number of people affected probably
isn't very high...)

Secondary question: should we patch 4.9 and 4.14 to disable rmap and
reflink support, since they both still have EXPERIMENTAL warnings?

--D

> Brian
> 
> >  	/* Only one mapping operation per BUI... */
> >  	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> >  		return false;
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index 8ad6c81f6d8f..2b28f5643c0b 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -423,6 +423,9 @@ xfs_cui_validate_phys(
> >  	struct xfs_mount		*mp,
> >  	struct xfs_phys_extent		*refc)
> >  {
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return false;
> > +
> >  	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
> >  		return false;
> >  
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index f296ec349936..2628bc0080fe 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -466,6 +466,9 @@ xfs_rui_validate_map(
> >  	struct xfs_mount		*mp,
> >  	struct xfs_map_extent		*rmap)
> >  {
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		return false;
> > +
> >  	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
> >  		return false;
> >  
> > 
> 
