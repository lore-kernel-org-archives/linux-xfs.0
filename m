Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434CDCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 23:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BB2A21A4C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 23:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CUg84uSM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfJXXNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 19:13:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfJXXNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 19:13:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ON8swE025643;
        Thu, 24 Oct 2019 23:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ewQar+arDr9zB/YUcp2XWykJTKyGO0o2ETqgydYNous=;
 b=CUg84uSMEhEh0KgW8g1L9qT9Wh+m0tYug0LlTHrj/QaIdMb9ZEk36H5RmL+qdE2wKGLb
 CNHysL2VUXRQmjiuyh5NN45jRuTF/r7TFijWL1hNIaj6k5hjgCfC69+P0Gn4liHmJ6OY
 BiXOcI+in/p3yXUPl8zJRIIxe8DRdn8+6Jd187V+WR4LMy4MT7oOObze4+WUbQUQIZzk
 7HNLWYbtziYIYL83ieN3BwSot60NXweKC0u8PSyDOY891NlTH0I1L+PwpW8JYXI1LCw8
 vrREtTM+gn+VsQTYNTrXdWg/eEfLPFLbMkliNhx4zGFIa52n0ie63XNey5rtPsyLUp+g xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4r6jqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 23:13:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ON7ewx073772;
        Thu, 24 Oct 2019 23:13:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vunbk05hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 23:13:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9OND0Qu016355;
        Thu, 24 Oct 2019 23:13:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 16:13:00 -0700
Date:   Thu, 24 Oct 2019 16:12:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 09/17] xfs: add xfs_remount_rw() helper
Message-ID: <20191024231258.GZ913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190348247.27074.12897905716268545882.stgit@fedora-28>
 <20191024153123.GS913374@magnolia>
 <90501efd6808a0816dbdf03b508130136bc8a94e.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90501efd6808a0816dbdf03b508130136bc8a94e.camel@themaw.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240218
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240218
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:53:08AM +0800, Ian Kent wrote:
> On Thu, 2019-10-24 at 08:31 -0700, Darrick J. Wong wrote:
> > On Thu, Oct 24, 2019 at 03:51:22PM +0800, Ian Kent wrote:
> > > Factor the remount read write code into a helper to simplify the
> > > subsequent change from the super block method .remount_fs to the
> > > mount-api fs_context_operations method .reconfigure.
> > > 
> > > This helper is only used by the mount code, so locate it along with
> > > that code.
> > > 
> > > While we are at it change STATIC -> static for
> > > xfs_restore_resvblks().
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_super.c |  119 +++++++++++++++++++++++++++++-----------
> > > ------------
> > >  1 file changed, 67 insertions(+), 52 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 297e6c98742e..c07e41489e75 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -47,6 +47,8 @@ static struct kset *xfs_kset;		/* top-
> > > level xfs sysfs dir */
> > >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs
> > > attrs */
> > >  #endif
> > >  
> > > +static void xfs_restore_resvblks(struct xfs_mount *mp);
> > 
> > What's the reason for putting xfs_remount_rw above
> > xfs_restore_resvblks?
> > I assume that's related to where you want to land later code chunks?
> 
> In the cover letter:
> 
> Note: the patches "xfs: add xfs_remount_rw() helper" and
>  "xfs: add xfs_remount_ro() helper" that have Reviewed-by attributions
>  each needed a forward declartion added due grouping all the mount
>  related code together. Reviewers may want to check the attribution
>  is still acceptable.
> 
> The fill super method needs quite a few more forward declarations
> too.
> 
> I responded to Christoph's suggestion of grouping the mount code
> together saying this would be needed, and that I thought the
> improvement of grouping the code together was worth the forward
> declarations, and asked if anyone had a different POV on it and
> got no replies, ;)
> 
> The other thing is that the options definitions notionally belong
> near the top of the mount/super block handling code so moving it
> all down seemed like the wrong thing to do ...
> 
> So what do you think of the extra noise of forward declarations
> in this case?

Eh, fine with me.  I was just curious, having speed-read over the
previous iterations. :)

--D

> Ian
> 
> > 
> > --D
> > 
> > > +
> > >  /*
> > >   * Table driven mount option parser.
> > >   */
> > > @@ -455,6 +457,68 @@ xfs_mount_free(
> > >  	kmem_free(mp);
> > >  }
> > >  
> > > +static int
> > > +xfs_remount_rw(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	struct xfs_sb		*sbp = &mp->m_sb;
> > > +	int			error;
> > > +
> > > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > > +		xfs_warn(mp,
> > > +			"ro->rw transition prohibited on norecovery
> > > mount");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > > +	    xfs_sb_has_ro_compat_feature(sbp,
> > > XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > > +		xfs_warn(mp,
> > > +	"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > > filesystem",
> > > +			(sbp->sb_features_ro_compat &
> > > +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > > +
> > > +	/*
> > > +	 * If this is the first remount to writeable state we might
> > > have some
> > > +	 * superblock changes to update.
> > > +	 */
> > > +	if (mp->m_update_sb) {
> > > +		error = xfs_sync_sb(mp, false);
> > > +		if (error) {
> > > +			xfs_warn(mp, "failed to write sb changes");
> > > +			return error;
> > > +		}
> > > +		mp->m_update_sb = false;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Fill out the reserve pool if it is empty. Use the stashed
> > > value if
> > > +	 * it is non-zero, otherwise go with the default.
> > > +	 */
> > > +	xfs_restore_resvblks(mp);
> > > +	xfs_log_work_queue(mp);
> > > +
> > > +	/* Recover any CoW blocks that never got remapped. */
> > > +	error = xfs_reflink_recover_cow(mp);
> > > +	if (error) {
> > > +		xfs_err(mp,
> > > +			"Error %d recovering leftover CoW
> > > allocations.", error);
> > > +			xfs_force_shutdown(mp,
> > > SHUTDOWN_CORRUPT_INCORE);
> > > +		return error;
> > > +	}
> > > +	xfs_start_block_reaping(mp);
> > > +
> > > +	/* Create the per-AG metadata reservation pool .*/
> > > +	error = xfs_fs_reserve_ag_blocks(mp);
> > > +	if (error && error != -ENOSPC)
> > > +		return error;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  struct proc_xfs_info {
> > >  	uint64_t	flag;
> > >  	char		*str;
> > > @@ -1169,7 +1233,7 @@ xfs_save_resvblks(struct xfs_mount *mp)
> > >  	xfs_reserve_blocks(mp, &resblks, NULL);
> > >  }
> > >  
> > > -STATIC void
> > > +static void
> > >  xfs_restore_resvblks(struct xfs_mount *mp)
> > >  {
> > >  	uint64_t resblks;
> > > @@ -1307,57 +1371,8 @@ xfs_fs_remount(
> > >  
> > >  	/* ro -> rw */
> > >  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY))
> > > {
> > > -		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > > -			xfs_warn(mp,
> > > -		"ro->rw transition prohibited on norecovery mount");
> > > -			return -EINVAL;
> > > -		}
> > > -
> > > -		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > > -		    xfs_sb_has_ro_compat_feature(sbp,
> > > -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
> > > {
> > > -			xfs_warn(mp,
> > > -"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > > filesystem",
> > > -				(sbp->sb_features_ro_compat &
> > > -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
> > > ;
> > > -			return -EINVAL;
> > > -		}
> > > -
> > > -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > > -
> > > -		/*
> > > -		 * If this is the first remount to writeable state we
> > > -		 * might have some superblock changes to update.
> > > -		 */
> > > -		if (mp->m_update_sb) {
> > > -			error = xfs_sync_sb(mp, false);
> > > -			if (error) {
> > > -				xfs_warn(mp, "failed to write sb
> > > changes");
> > > -				return error;
> > > -			}
> > > -			mp->m_update_sb = false;
> > > -		}
> > > -
> > > -		/*
> > > -		 * Fill out the reserve pool if it is empty. Use the
> > > stashed
> > > -		 * value if it is non-zero, otherwise go with the
> > > default.
> > > -		 */
> > > -		xfs_restore_resvblks(mp);
> > > -		xfs_log_work_queue(mp);
> > > -
> > > -		/* Recover any CoW blocks that never got remapped. */
> > > -		error = xfs_reflink_recover_cow(mp);
> > > -		if (error) {
> > > -			xfs_err(mp,
> > > -	"Error %d recovering leftover CoW allocations.", error);
> > > -			xfs_force_shutdown(mp,
> > > SHUTDOWN_CORRUPT_INCORE);
> > > -			return error;
> > > -		}
> > > -		xfs_start_block_reaping(mp);
> > > -
> > > -		/* Create the per-AG metadata reservation pool .*/
> > > -		error = xfs_fs_reserve_ag_blocks(mp);
> > > -		if (error && error != -ENOSPC)
> > > +		error = xfs_remount_rw(mp);
> > > +		if (error)
> > >  			return error;
> > >  	}
> > >  
> > > 
> 
