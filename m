Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAACCA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 17:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 898572077C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 17:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SyrZJzfb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfJURcN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 13:32:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56074 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfJURcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 13:32:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LHT4FR031348;
        Mon, 21 Oct 2019 17:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=K3XH0uTTbWt+QMDkmAF9I5Ol2g+NJ+tQplaPaiS2BaA=;
 b=SyrZJzfbqj3CpG6+khZ42vdUEz718QgMNohVmLDdAFX6HBJJ4VgXAWMpBVksMoDfS+w+
 /AOkr8ZgZH1eMiw+miLMjZX6F5eqjpTXtOWtXAqfSrQ/V5teUizJyfOjA6Z/DI4JsOLw
 b1fpTaohnyEqqMjCtvGFMOYChBPKBAEs/6gyKZlRCK3mEIu7lvBcD61w90fbh05gmMA/
 VSLffuUBbD7K0pG9AOLpZdX8RBRK89AWVfHxVYLVwMURAuURCDNufMTjuCwubEGAO++J
 2y4+wJ0bBCBb9gUI/Zq9I+ETslzsLBjC9a9ZgKkEYRZfzIZ/n4kPM7tEQijwVV+BUt+T oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswt9c4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 17:32:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LHSBx6132358;
        Mon, 21 Oct 2019 17:32:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vrcmnkcr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 17:32:09 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LHW8wt023708;
        Mon, 21 Oct 2019 17:32:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 10:32:08 -0700
Date:   Mon, 21 Oct 2019 10:32:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs_scrub: separate media error reporting for
 attribute forks
Message-ID: <20191021173207.GA913374@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944737397.300131.4607692740306012565.stgit@magnolia>
 <bcb6ea07-b970-0e2e-a888-6919bf2513f7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb6ea07-b970-0e2e-a888-6919bf2513f7@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 11:18:09AM -0500, Eric Sandeen wrote:
> On 9/25/19 4:36 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use different functions to warn about media errors that were detected
> > underlying xattr data because logical offsets for attribute fork extents
> > have no meaning to users.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/phase6.c |   45 ++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 38 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index 4554af9a..1edd98af 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -113,7 +113,7 @@ xfs_decode_special_owner(
> >  
> >  /* Report if this extent overlaps a bad region. */
> >  static bool
> > -xfs_report_verify_inode_bmap(
> > +report_data_loss(
> >  	struct scrub_ctx		*ctx,
> >  	const char			*descr,
> >  	int				fd,
> > @@ -142,6 +142,40 @@ _("offset %llu failed read verification."), bmap->bm_offset);
> >  	return true;
> >  }
> >  
> > +/* Report if the extended attribute data overlaps a bad region. */
> 
> I'd like to see a comment above the typedef for this function
> (eventually scrub_bmap_iter_fn), or above the function which uses it
> (scrub_iterate_filemaps) in order to explain what the return
> values mean and the implication for scanning.

Ok, I'll add some comments for what the return values are.  FWIW I'm
trying to push all the iterator ->fn() things to "0 to keep going; or
nonzero to end the loop and return immediately".

> Looking at this w/o a lot of context, 
> 
> "Report if the extended attribute data overlaps a bad region."
> 
> and nothing but "return true" seems ... odd.  I think what it means
> is "print something if found ... and set an error for some problems,
> but always continue scanning?"

Correct -- the return value here determines whether or not the iteration
loop continues iterating.

> > +static bool
> > +report_attr_loss(
> > +	struct scrub_ctx		*ctx,
> > +	const char			*descr,
> > +	int				fd,
> > +	int				whichfork,
> > +	struct fsxattr			*fsx,
> > +	struct xfs_bmap			*bmap,
> > +	void				*arg)
> > +{
> > +	struct media_verify_state	*vs = arg;
> > +	struct bitmap			*bmp = vs->d_bad;
> > +
> > +	/* Complain about attr fork extents that don't look right. */
> > +	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC)) {
> > +		str_info(ctx, descr,
> > +_("found unexpected unwritten/delalloc attr fork extent."));
> > +		return true;
> > +	}
> > +
> > +	if (fsx->fsx_xflags & FS_XFLAG_REALTIME) {
> > +		str_info(ctx, descr,
> > +_("found unexpected realtime attr fork extent."));
> > +		return true;

..so this hunk complains about seeing things in the metadata that
shouldn't be there.  That isn't a runtime error, so we want to continue
iterating.

The "remove moveon aliens" series later on will clean all this up.

Hmm, why /is/ that a str_info()?  I think my reasoning is that the the
attr fork checker in phase 3 should already have complained about this,
so we don't need to str_error() it again.

> > +	}
> 
> so these don't flag any error, and moveon stays true, but
> 
> > +
> > +	if (bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
> > +		str_error(ctx, descr,
> > +_("media error in extended attribute data."));
> 
> this actually counts as an error?  OTOH report_data_loss() seems to return
> false if it finds something like this, so I'm a little confused about the
> difference and the behavior.  Help?

<nod> For now, it's marked as a filesystem corruption, since we've lost
data.  A(nother) subsequent series changes this str_error call to
str_unfixable so that we can call this what it is -- we lost user data
and there's nothing we can do about it.

Either way, the data's gone but we /can/ keep iterating the bad blocks
list so we return true here.

--D

> 
> > +
> > +	return true;
> > +}
> > +
> >  /* Iterate the extent mappings of a file to report errors. */
> >  static bool
> >  xfs_report_verify_fd(
> > @@ -155,16 +189,13 @@ xfs_report_verify_fd(
> >  
> >  	/* data fork */
> >  	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_DATA_FORK, &key,
> > -			xfs_report_verify_inode_bmap, arg);
> > +			report_data_loss, arg);
> >  	if (!moveon)
> >  		return false;
> >  
> >  	/* attr fork */
> > -	moveon = xfs_iterate_filemaps(ctx, descr, fd, XFS_ATTR_FORK, &key,
> > -			xfs_report_verify_inode_bmap, arg);
> > -	if (!moveon)
> > -		return false;
> > -	return true;
> > +	return xfs_iterate_filemaps(ctx, descr, fd, XFS_ATTR_FORK, &key,
> > +			report_attr_loss, arg);
> >  }
> >  
> >  /* Report read verify errors in unlinked (but still open) files. */
> > 
