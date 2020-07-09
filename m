Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF827C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A994F20720
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rBcU9AJB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgGIQme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 12:42:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33786 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgGIQme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 12:42:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069Gakt7166941;
        Thu, 9 Jul 2020 16:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AyRlpu92d3EZ++RaIFpIwm9Bmo5IIdvveGiEgNAg1Ds=;
 b=rBcU9AJB+dUq0ZUHgEaO9ltfaMdFtyTuBwiUoSvcRHu/zzunGzBbfr2MeadzpmLHwRBo
 OH3IjjJKyDk3cWP3BTN3EwifU42KqGI84OBgsKmdUGVV2kGpKn4jejtCjzogz3go04vi
 X2h2otuY5zHSmyZbiLztGPiXIXeD2AILv0Ek709fZsLvaYai1y3kxEIZ2pO4L+waMN+F
 4DTBT1EUzzb0xMnCGT+l3AgwTsEjCOq5JbCRy+ViNU9FfqbQenyAGeF96q4YbFm2mTaf
 eRHoH6A/InYjxN2f3sJO6NDMtGzHr8BCelAjBDeKWrkYCMDwwYM2KX0+Q2YzBBoXL3D2 UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 325y0ajy4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 16:42:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069GdLjW069706;
        Thu, 9 Jul 2020 16:42:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 325k3hjby9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 16:42:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 069GgU3s024145;
        Thu, 9 Jul 2020 16:42:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 09:42:30 -0700
Date:   Thu, 9 Jul 2020 09:42:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: Remove kmem_zone_zalloc() usage
Message-ID: <20200709164229.GR7606@magnolia>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
 <20200708125608.155645-3-cmaiolino@redhat.com>
 <20200709025523.GT2005@dread.disaster.area>
 <20200709085500.fkdn26ia4c4ffipt@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709085500.fkdn26ia4c4ffipt@eorzea>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 10:55:00AM +0200, Carlos Maiolino wrote:
> On Thu, Jul 09, 2020 at 12:55:23PM +1000, Dave Chinner wrote:
> > On Wed, Jul 08, 2020 at 02:56:06PM +0200, Carlos Maiolino wrote:
> > > Use kmem_cache_zalloc() directly.
> > > 
> > > With the exception of xlog_ticket_alloc() which will be dealt on the
> > > next patch for readability.
> > > 
> > > Most users of kmem_zone_zalloc() were converted to either
> > > "GFP_KERNEL | __GFP_NOFAIL" or "GFP_NOFS | __GFP_NOFAIL", with the
> > > exception of _xfs_buf_alloc(), which is allowed to fail, so __GFP_NOFAIL
> > > is not used there.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 3 ++-
> > >  fs/xfs/libxfs/xfs_bmap.c           | 5 ++++-
> > >  fs/xfs/libxfs/xfs_bmap_btree.c     | 3 ++-
> > >  fs/xfs/libxfs/xfs_da_btree.c       | 4 +++-
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
> > >  fs/xfs/libxfs/xfs_inode_fork.c     | 6 +++---
> > >  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
> > >  fs/xfs/libxfs/xfs_rmap_btree.c     | 2 +-
> > >  fs/xfs/xfs_bmap_item.c             | 4 ++--
> > >  fs/xfs/xfs_buf.c                   | 2 +-
> > >  fs/xfs/xfs_buf_item.c              | 2 +-
> > >  fs/xfs/xfs_dquot.c                 | 2 +-
> > >  fs/xfs/xfs_extfree_item.c          | 6 ++++--
> > >  fs/xfs/xfs_icreate_item.c          | 2 +-
> > >  fs/xfs/xfs_inode_item.c            | 3 ++-
> > >  fs/xfs/xfs_refcount_item.c         | 5 +++--
> > >  fs/xfs/xfs_rmap_item.c             | 6 ++++--
> > >  fs/xfs/xfs_trans.c                 | 5 +++--
> > >  fs/xfs/xfs_trans_dquot.c           | 3 ++-
> > >  19 files changed, 41 insertions(+), 26 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > index 60c453cb3ee37..9cc1a4af40180 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > @@ -484,7 +484,8 @@ xfs_allocbt_init_common(
> > >  
> > >  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> > >  
> > > -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> > > +	cur = kmem_cache_zalloc(xfs_btree_cur_zone,
> > > +				GFP_NOFS | __GFP_NOFAIL);
> > 
> > This still fits on one line....
> > 
> > Hmmm - many of the other conversions are similar, but not all of
> > them. Any particular reason why these are split over multiple lines
> > and not kept as a single line of code? My preference is that they
> > are a single line if it doesn't overrun 80 columns....
> 
> Hmmm, I have my vim set to warn me on 80 column limit, and it warned me here (or
> maybe I just went in auto mode), I'll double check it, thanks.

That was increased to 100 lines as of 5.7.0.

--D

> > 
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > > index 897749c41f36e..325c0ae2033d8 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > > @@ -77,11 +77,13 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
> > >  /*
> > >   * Allocate a dir-state structure.
> > >   * We don't put them on the stack since they're large.
> > > + *
> > > + * We can remove this wrapper
> > >   */
> > >  xfs_da_state_t *
> > >  xfs_da_state_alloc(void)
> > >  {
> > > -	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
> > > +	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
> > >  }
> > 
> > Rather than add a comment that everyone will promptly forget about,
> > add another patch to the end of the patchset that removes the
> > wrapper.
> 
> That comment was supposed to be removed before sending the patches, but looks
> like the author forgot about it.
> 
> > >  	*bpp = NULL;
> > > -	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
> > > +	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS);
> > >  	if (unlikely(!bp))
> > >  		return -ENOMEM;
> > 
> > That's a change of behaviour. The existing call does not set
> > KM_MAYFAIL so this allocation will never fail, even though the code
> > is set up to handle a failure. This probably should retain
> > __GFP_NOFAIL semantics and the -ENOMEM handling removed in this
> > patch as the failure code path here has most likely never been
> > tested.
> 
> Thanks, I thought we could attempt an allocation here without NOFAIL, but the
> testability of the fail path here really didn't come to my mind.
> 
> Thanks for the comments, I"ll update the patches and submit a V2.
> 
> Cheers
> 
> -- 
> Carlos
> 
