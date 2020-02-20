Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF9BC11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07BF224670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="III5PoUa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBTQqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:46:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgBTQqs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:46:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KGgtG1039769;
        Thu, 20 Feb 2020 16:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oLaZZ4RKgcDCoVM1Ze5nggvHhrl9KOD78y1NvFBSKpo=;
 b=III5PoUa0ELJbTY6QoVVuVCnn2JTitu+BX+q6CJx4/ebKVlC5XALAAohohheGSOtXQbH
 pj0fCFBfv3c8JG4k4ZI+Ax8Gvetex3aWdkoNYvNBWaGB3QRXR22Xx2OTVRwS5qf4qBR7
 CGWHFXbx8E9TyxL273DbFNHjFfVF1kwIfMhsTu8TF+r5JLdqw2bkkBuBLZGmgib0eqSb
 /v1R33GYrCZYlsOEsftTyfKFAM5xviWbIRyviVlX9vBlIpLgaBSljQRZ9TKd2rPHULmN
 heMd5ivqfDS02jUKI4AO7DR2xEAwsvj7wehAKlVMUz2TWjb2N6CVNc5URh7NLFBtfHhu 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8uddb1pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 16:46:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KGgHIL050279;
        Thu, 20 Feb 2020 16:46:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8udd5865-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 16:46:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01KGkewo003325;
        Thu, 20 Feb 2020 16:46:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 08:46:39 -0800
Date:   Thu, 20 Feb 2020 08:46:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] libxfs: enable tools to check that metadata updates
 have been committed
Message-ID: <20200220164638.GW9506@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216292664.601264.186457838279269618.stgit@magnolia>
 <20200220140612.GB48977@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220140612.GB48977@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 09:06:12AM -0500, Brian Foster wrote:
> On Wed, Feb 19, 2020 at 05:42:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new function that will ensure that everything we changed has
> > landed on stable media, and report the results.  Subsequent commits will
> > teach the individual programs to report when things go wrong.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/xfs_mount.h |    3 +++
> >  libxfs/init.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/libxfs_io.h  |    2 ++
> >  libxfs/rdwr.c       |   27 +++++++++++++++++++++++++--
> >  4 files changed, 73 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> > index 29b3cc1b..c80aaf69 100644
> > --- a/include/xfs_mount.h
> > +++ b/include/xfs_mount.h
> > @@ -187,4 +187,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
> >  extern void	libxfs_umount (xfs_mount_t *);
> >  extern void	libxfs_rtmount_destroy (xfs_mount_t *);
> >  
> > +void libxfs_flush_devices(struct xfs_mount *mp, int *datadev, int *logdev,
> > +		int *rtdev);
> > +
> >  #endif	/* __XFS_MOUNT_H__ */
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index a0d4b7f4..d1d3f4df 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
> >  	}
> >  	btp->bt_mount = mp;
> >  	btp->dev = dev;
> > +	btp->lost_writes = false;
> > +
> >  	return btp;
> >  }
> >  
> > @@ -791,6 +793,47 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
> >  	mp->m_rsumip = mp->m_rbmip = NULL;
> >  }
> >  
> > +static inline int
> > +libxfs_flush_buftarg(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	if (btp->lost_writes)
> > +		return -ENOTRECOVERABLE;
> 
> I'm curious why we'd want to skip the flush just because some writes
> happened to fail..? I suppose the fs might be borked, but it seems a
> little strange to at least not try the flush, particularly since we
> might still flush any of the other two possible devices.

My thinking here was that if the write verifiers (or the pwrite() calls
themselves) failed then there's no point in telling the disk to flush
its write cache since we already know it's not in sync with the buffer
cache.

> > +
> > +	return libxfs_blkdev_issue_flush(btp);
> > +}
> > +
> > +/*
> > + * Purge the buffer cache to write all dirty buffers to disk and free all
> > + * incore buffers.  Buffers that cannot be written will cause the lost_writes
> > + * flag to be set in the buftarg.  If there were no lost writes, flush the
> > + * device to make sure the writes made it to stable storage.
> > + *
> > + * For each device, the return code will be set to -ENOTRECOVERABLE if we
> > + * couldn't write something to disk; or the results of the block device flush
> > + * operation.
> 
> Why not -EIO?

Originally I thought it might be useful to be able to distinguish
between "dirty buffers never even made it out of the buffer cache" vs.
"dirty buffers were sent to the disk but the disk sent back media
errors", though in the end the userspace tools don't make any
distinction.

That said, looking at this again, maybe I should track write verifier
failure separately so that we can return EFSCORRUPTED for that?

--D

> 
> Brian
> 
> > + */
> > +void
> > +libxfs_flush_devices(
> > +	struct xfs_mount	*mp,
> > +	int			*datadev,
> > +	int			*logdev,
> > +	int			*rtdev)
> > +{
> > +	*datadev = *logdev = *rtdev = 0;
> > +
> > +	libxfs_bcache_purge();
> > +
> > +	if (mp->m_ddev_targp)
> > +		*datadev = libxfs_flush_buftarg(mp->m_ddev_targp);
> > +
> > +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> > +		*logdev = libxfs_flush_buftarg(mp->m_logdev_targp);
> > +
> > +	if (mp->m_rtdev_targp)
> > +		*rtdev = libxfs_flush_buftarg(mp->m_rtdev_targp);
> > +}
> > +
> >  /*
> >   * Release any resource obtained during a mount.
> >   */
> > diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> > index 579df52b..fc0fd060 100644
> > --- a/libxfs/libxfs_io.h
> > +++ b/libxfs/libxfs_io.h
> > @@ -23,10 +23,12 @@ struct xfs_perag;
> >  struct xfs_buftarg {
> >  	struct xfs_mount	*bt_mount;
> >  	dev_t			dev;
> > +	bool			lost_writes;
> >  };
> >  
> >  extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
> >  				    dev_t logdev, dev_t rtdev);
> > +int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
> >  
> >  #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
> >  
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 8b47d438..92e497f9 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -17,6 +17,7 @@
> >  #include "xfs_inode_fork.h"
> >  #include "xfs_inode.h"
> >  #include "xfs_trans.h"
> > +#include "libfrog/platform.h"
> >  
> >  #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
> >  
> > @@ -1227,9 +1228,11 @@ libxfs_brelse(
> >  
> >  	if (!bp)
> >  		return;
> > -	if (bp->b_flags & LIBXFS_B_DIRTY)
> > +	if (bp->b_flags & LIBXFS_B_DIRTY) {
> >  		fprintf(stderr,
> >  			"releasing dirty buffer to free list!\n");
> > +		bp->b_target->lost_writes = true;
> > +	}
> >  
> >  	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
> >  	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> > @@ -1248,9 +1251,11 @@ libxfs_bulkrelse(
> >  		return 0 ;
> >  
> >  	list_for_each_entry(bp, list, b_node.cn_mru) {
> > -		if (bp->b_flags & LIBXFS_B_DIRTY)
> > +		if (bp->b_flags & LIBXFS_B_DIRTY) {
> >  			fprintf(stderr,
> >  				"releasing dirty buffer (bulk) to free list!\n");
> > +			bp->b_target->lost_writes = true;
> > +		}
> >  		count++;
> >  	}
> >  
> > @@ -1479,6 +1484,24 @@ libxfs_irele(
> >  	kmem_cache_free(xfs_inode_zone, ip);
> >  }
> >  
> > +/*
> > + * Flush everything dirty in the kernel and disk write caches to stable media.
> > + * Returns 0 for success or a negative error code.
> > + */
> > +int
> > +libxfs_blkdev_issue_flush(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	int			fd, ret;
> > +
> > +	if (btp->dev == 0)
> > +		return 0;
> > +
> > +	fd = libxfs_device_to_fd(btp->dev);
> > +	ret = platform_flush_device(fd, btp->dev);
> > +	return ret ? -errno : 0;
> > +}
> > +
> >  /*
> >   * Write out a buffer list synchronously.
> >   *
> > 
> 
