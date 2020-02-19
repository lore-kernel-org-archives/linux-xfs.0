Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D387C34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 05:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B0F0208C4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 05:44:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qk2+2hj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgBSFoL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 00:44:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgBSFoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 00:44:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J5h2tU006692;
        Wed, 19 Feb 2020 05:44:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5Ku7IPDQYLRuWC2R52PvwGjNvnUUBrsos9cEeQv7KqE=;
 b=Qk2+2hj4FOiX811r5pwoaIgbRvv8DtmKp8veg+hoG36Av01Cas2DsX/AjAwK2dM6Uo+M
 KFakeV3GqGKZSsqGXeBkAR8eGR4wzZ7ZMHLKvjMCPX1pSfHGLDVqZ1xsXxuWd4osv650
 yPDfoXtO1y6RDp2/xOzlJYBhK3JZwXR+nMOpWybaSIN0L6WKHKTxXV9qO679KViUzH7/
 IU5cnZfZ4wSRqvMGo6GpmSiaEDLYT0GanA8Vnjl0RUkFki2FlHleoTMOVzEdUCJ7M1eK
 pybn1PPpsIOHFLPYGznbLDh01jg5DDXW0dIjJndQhrpnTZbPrnsf72Ss3urQlHbuPk7r 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8udd0p62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 05:44:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J5fhrc188281;
        Wed, 19 Feb 2020 05:44:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y8ud2baw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 05:44:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01J5i7vf014914;
        Wed, 19 Feb 2020 05:44:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 21:42:48 -0800
Date:   Tue, 18 Feb 2020 21:42:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] misc: make all tools check that metadata updates
 have been committed
Message-ID: <20200219054247.GM9506@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086366953.2079905.14262588326790505460.stgit@magnolia>
 <a3541c48-5187-29c9-daa6-40beda27bcec@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3541c48-5187-29c9-daa6-40beda27bcec@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=2 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 06, 2020 at 12:38:17PM -0700, Allison Collins wrote:
> 
> 
> On 2/4/20 5:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new function that will ensure that everything we changed has
> > landed on stable media, and report the results.  Teach the individual
> > programs to report when things go wrong.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Ok, looks functionally sane to me:

Thanks for reviewing the three series!

--D

> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> 
> > ---
> >   db/init.c           |   14 ++++++++++++++
> >   include/xfs_mount.h |    3 +++
> >   libxfs/init.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
> >   libxfs/libxfs_io.h  |    2 ++
> >   libxfs/rdwr.c       |   27 +++++++++++++++++++++++++--
> >   mkfs/xfs_mkfs.c     |   15 +++++++++++++++
> >   repair/xfs_repair.c |   35 +++++++++++++++++++++++++++++++++++
> >   7 files changed, 137 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/db/init.c b/db/init.c
> > index 0ac37368..e92de232 100644
> > --- a/db/init.c
> > +++ b/db/init.c
> > @@ -184,6 +184,7 @@ main(
> >   	char	*input;
> >   	char	**v;
> >   	int	start_iocur_sp;
> > +	int	d, l, r;
> >   	init(argc, argv);
> >   	start_iocur_sp = iocur_sp;
> > @@ -216,6 +217,19 @@ main(
> >   	 */
> >   	while (iocur_sp > start_iocur_sp)
> >   		pop_cur();
> > +
> > +	libxfs_flush_devices(mp, &d, &l, &r);
> > +	if (d)
> > +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> > +				progname, d);
> > +	if (l)
> > +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> > +				progname, l);
> > +	if (r)
> > +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> > +				progname, r);
> > +
> > +
> >   	libxfs_umount(mp);
> >   	if (x.ddev)
> >   		libxfs_device_close(x.ddev);
> > diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> > index 29b3cc1b..c80aaf69 100644
> > --- a/include/xfs_mount.h
> > +++ b/include/xfs_mount.h
> > @@ -187,4 +187,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
> >   extern void	libxfs_umount (xfs_mount_t *);
> >   extern void	libxfs_rtmount_destroy (xfs_mount_t *);
> > +void libxfs_flush_devices(struct xfs_mount *mp, int *datadev, int *logdev,
> > +		int *rtdev);
> > +
> >   #endif	/* __XFS_MOUNT_H__ */
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index a0d4b7f4..d1d3f4df 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
> >   	}
> >   	btp->bt_mount = mp;
> >   	btp->dev = dev;
> > +	btp->lost_writes = false;
> > +
> >   	return btp;
> >   }
> > @@ -791,6 +793,47 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
> >   	mp->m_rsumip = mp->m_rbmip = NULL;
> >   }
> > +static inline int
> > +libxfs_flush_buftarg(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	if (btp->lost_writes)
> > +		return -ENOTRECOVERABLE;
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
> >   /*
> >    * Release any resource obtained during a mount.
> >    */
> > diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> > index 579df52b..fc0fd060 100644
> > --- a/libxfs/libxfs_io.h
> > +++ b/libxfs/libxfs_io.h
> > @@ -23,10 +23,12 @@ struct xfs_perag;
> >   struct xfs_buftarg {
> >   	struct xfs_mount	*bt_mount;
> >   	dev_t			dev;
> > +	bool			lost_writes;
> >   };
> >   extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
> >   				    dev_t logdev, dev_t rtdev);
> > +int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
> >   #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 8b47d438..92e497f9 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -17,6 +17,7 @@
> >   #include "xfs_inode_fork.h"
> >   #include "xfs_inode.h"
> >   #include "xfs_trans.h"
> > +#include "libfrog/platform.h"
> >   #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
> > @@ -1227,9 +1228,11 @@ libxfs_brelse(
> >   	if (!bp)
> >   		return;
> > -	if (bp->b_flags & LIBXFS_B_DIRTY)
> > +	if (bp->b_flags & LIBXFS_B_DIRTY) {
> >   		fprintf(stderr,
> >   			"releasing dirty buffer to free list!\n");
> > +		bp->b_target->lost_writes = true;
> > +	}
> >   	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
> >   	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> > @@ -1248,9 +1251,11 @@ libxfs_bulkrelse(
> >   		return 0 ;
> >   	list_for_each_entry(bp, list, b_node.cn_mru) {
> > -		if (bp->b_flags & LIBXFS_B_DIRTY)
> > +		if (bp->b_flags & LIBXFS_B_DIRTY) {
> >   			fprintf(stderr,
> >   				"releasing dirty buffer (bulk) to free list!\n");
> > +			bp->b_target->lost_writes = true;
> > +		}
> >   		count++;
> >   	}
> > @@ -1479,6 +1484,24 @@ libxfs_irele(
> >   	kmem_cache_free(xfs_inode_zone, ip);
> >   }
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
> >   /*
> >    * Write out a buffer list synchronously.
> >    *
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 1f5d2105..6b182264 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3644,6 +3644,7 @@ main(
> >   	char			*protofile = NULL;
> >   	char			*protostring = NULL;
> >   	int			worst_freelist = 0;
> > +	int			d, l, r;
> >   	struct libxfs_xinit	xi = {
> >   		.isdirect = LIBXFS_DIRECT,
> > @@ -3940,6 +3941,20 @@ main(
> >   	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
> >   	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> > +	/* Make sure our new fs made it to stable storage. */
> > +	libxfs_flush_devices(mp, &d, &l, &r);
> > +	if (d)
> > +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> > +				progname, d);
> > +	if (l)
> > +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> > +				progname, l);
> > +	if (r)
> > +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> > +				progname, r);
> > +	if (d || l || r)
> > +		return 1;
> > +
> >   	libxfs_umount(mp);
> >   	if (xi.rtdev)
> >   		libxfs_device_close(xi.rtdev);
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index eb1ce546..c0a77cad 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -690,6 +690,36 @@ check_fs_vs_host_sectsize(
> >   	}
> >   }
> > +/* Flush the devices and complain if anything bad happened. */
> > +static bool
> > +check_write_failed(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int			d, l, r;
> > +
> > +	libxfs_flush_devices(mp, &d, &l, &r);
> > +
> > +	if (d == -ENOTRECOVERABLE)
> > +		do_warn(_("Lost writes to data device, please re-run.\n"));
> > +	else if (d)
> > +		do_warn(_("Error %d flushing data device, please re-run.\n"),
> > +				-d);
> > +
> > +	if (l == -ENOTRECOVERABLE)
> > +		do_warn(_("Lost writes to log device, please re-run.\n"));
> > +	else if (l)
> > +		do_warn(_("Error %d flushing log device, please re-run.\n"),
> > +				-l);
> > +
> > +	if (r == -ENOTRECOVERABLE)
> > +		do_warn(_("Lost writes to realtime device, please re-run.\n"));
> > +	else if (r)
> > +		do_warn(_("Error %d flushing realtime device, please re-run.\n"),
> > +				-r);
> > +
> > +	return d || l || r;
> > +}
> > +
> >   int
> >   main(int argc, char **argv)
> >   {
> > @@ -703,6 +733,7 @@ main(int argc, char **argv)
> >   	struct xfs_sb	psb;
> >   	int		rval;
> >   	struct xfs_ino_geometry	*igeo;
> > +	bool		writes_failed;
> >   	progname = basename(argv[0]);
> >   	setlocale(LC_ALL, "");
> > @@ -1106,6 +1137,8 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
> >   	format_log_max_lsn(mp);
> >   	libxfs_umount(mp);
> > +	writes_failed = check_write_failed(mp);
> > +
> >   	if (x.rtdev)
> >   		libxfs_device_close(x.rtdev);
> >   	if (x.logdev && x.logdev != x.ddev)
> > @@ -1125,6 +1158,8 @@ _("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
> >   	free(msgbuf);
> > +	if (writes_failed)
> > +		return 1;
> >   	if (fs_is_dirty && report_corrected)
> >   		return (4);
> >   	return (0);
> > 
