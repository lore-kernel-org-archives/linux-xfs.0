Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F68BC63697
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 17:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D335246AD
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 17:55:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cUzIft2u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgKSRzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 12:55:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgKSRzn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Nov 2020 12:55:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHsGWb158991;
        Thu, 19 Nov 2020 17:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RQMGu397UJiD6IQkZ9SXl4sQ4tzFvvkD9H3x5KZi/Eo=;
 b=cUzIft2uRpAg1lJcUUwgCM4vvyVPR+YqUoGCAbAnQ4Bz6MkMKC/IxsoEe2i4szXd8dcu
 vwPBB9Pk+j5NYvDvHxD7dDwmqoixqlaWjYUXqDGWB9G0wH12fzYdAF+T2/sHfVl2b8Rk
 x40262Qzx0h6TaWSXZJ8X+ss/x03bikoh+YuCM2rWocbIytBVrTTqDC4D7dEEEGDr7vl
 BwLS8Xuz9uGL4GdIcl1vLihSiVQcoRTqsHBCrzAYeAwO+8hnLdu+yZW1CZuQk4yZi5WM
 f2U+dA69xCeqq5huyw5nwKGeYjbPl17cddPxw04JEhzm4HvpK7YFKO61RrZ7CUD3B3sL /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76m6u81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 17:55:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHtb4i184581;
        Thu, 19 Nov 2020 17:55:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0u2sph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 17:55:37 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AJHtRVk018790;
        Thu, 19 Nov 2020 17:55:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 09:55:27 -0800
Date:   Thu, 19 Nov 2020 09:55:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] xfs: don't allow NOWAIT DIO across extent boundaries
Message-ID: <20201119175526.GF9695@magnolia>
References: <20201119042315.535693-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119042315.535693-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 19, 2020 at 03:23:15PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Jens has reported a situation where partial direct IOs can be issued
> and completed yet still return -EAGAIN. We don't want this to report
> a short IO as we want XFS to complete user DIO entirely or not at
> all.
> 
> This partial IO situation can occur on a write IO that is split
> across an allocated extent and a hole, and the second mapping is
> returning EAGAIN because allocation would be required.
> 
> The trivial reproducer:
> 
> $ sudo xfs_io -fdt -c "pwrite 0 4k" -c "pwrite -V 1 -b 8k -N 0 8k" /mnt/scr/foo
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0001 sec (27.509 MiB/sec and 7042.2535 ops/sec)
> pwrite: Resource temporarily unavailable
> $
> 
> The pwritev2(0, 8kB, RWF_NOWAIT) call returns EAGAIN having done
> the first 4kB write:
> 
>  xfs_file_direct_write: dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 0x2000
>  iomap_apply:          dev 259:1 ino 0x83 pos 0 length 8192 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
>  xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
>  xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
>  xfs_iomap_found:      dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 8192 fork data startoff 0x0 startblock 24 blockcount 0x1
>  iomap_apply_dstmap:   dev 259:1 ino 0x83 bdev 259:1 addr 102400 offset 0 length 4096 type MAPPED flags DIRTY
> 
> Here the first iomap loop has mapped the first 4kB of the file and
> issued the IO, and we enter the second iomap_apply loop:
> 
>  iomap_apply: dev 259:1 ino 0x83 pos 4096 length 4096 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
>  xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
>  xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
> 
> And we exit with -EAGAIN out because we hit the allocate case trying
> to make the second 4kB block.
> 
> Then IO completes on the first 4kB and the original IO context
> completes and unlocks the inode, returning -EAGAIN to userspace:
> 
>  xfs_end_io_direct_write: dev 259:1 ino 0x83 isize 0x1000 disize 0x1000 offset 0x0 count 4096
>  xfs_iunlock:          dev 259:1 ino 0x83 flags IOLOCK_SHARED caller xfs_file_dio_aio_write
> 
> There are other vectors to the same problem when we re-enter the
> mapping code if we have to make multiple mappinfs under NOWAIT
> conditions. e.g. failing trylocks, COW extents being found,
> allocation being required, and so on.
> 
> Avoid all these potential problems by only allowing IOMAP_NOWAIT IO
> to go ahead if the mapping we retrieve for the IO spans an entire
> allocated extent. This avoids the possibility of subsequent mappings
> to complete the IO from triggering NOWAIT semantics by any means as
> NOWAIT IO will now only enter the mapping code once per NOWAIT IO.
> 
> Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Hmm so I guess the whole point of this is speculative writing?

As in, thread X either wants us to write impatiently, or to fail the
whole IO so that it can hand the slow-mode write to some other thread or
something?  The manpage says something about short reads, but it doesn't
say much about writes, but silently writing some but not all seems
broken. :)

If so then I guess this is fine, and to the (limited) extent that I grok
the whole usecase,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3abb8b9d6f4c..7b9ff824e82d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -706,6 +706,23 @@ xfs_ilock_for_iomap(
>  	return 0;
>  }
>  
> +/*
> + * Check that the imap we are going to return to the caller spans the entire
> + * range that the caller requested for the IO.
> + */
> +static bool
> +imap_spans_range(
> +	struct xfs_bmbt_irec	*imap,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_fileoff_t		end_fsb)
> +{
> +	if (imap->br_startoff > offset_fsb)
> +		return false;
> +	if (imap->br_startoff + imap->br_blockcount < end_fsb)
> +		return false;
> +	return true;
> +}
> +
>  static int
>  xfs_direct_write_iomap_begin(
>  	struct inode		*inode,
> @@ -766,6 +783,18 @@ xfs_direct_write_iomap_begin(
>  	if (imap_needs_alloc(inode, flags, &imap, nimaps))
>  		goto allocate_blocks;
>  
> +	/*
> +	 * NOWAIT IO needs to span the entire requested IO with a single map so
> +	 * that we avoid partial IO failures due to the rest of the IO range not
> +	 * covered by this map triggering an EAGAIN condition when it is
> +	 * subsequently mapped and aborting the IO.
> +	 */
> +	if ((flags & IOMAP_NOWAIT) &&
> +	    !imap_spans_range(&imap, offset_fsb, end_fsb)) {
> +		error = -EAGAIN;
> +		goto out_unlock;
> +	}
> +
>  	xfs_iunlock(ip, lockmode);
>  	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
>  	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
> -- 
> 2.28.0
> 
