Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61187C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 456FB20738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHRXfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:35:44 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49356 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHRXfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 19:35:44 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5EBB83A6693;
        Wed, 19 Aug 2020 09:35:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8B8h-0007GH-23; Wed, 19 Aug 2020 09:35:35 +1000
Date:   Wed, 19 Aug 2020 09:35:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200818233535.GD21744@dread.disaster.area>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159770505894.3956827.5973810026298120596.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=00O8cm8hraYYhIWErA4A:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 03:57:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> time epoch).  This enables us to handle dates up to 2486, which solves
> the y2038 problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
.....
> +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
>  void
>  xfs_inode_from_disk_timestamp(
> +	struct xfs_dinode		*dip,
>  	struct timespec64		*tv,
>  	const union xfs_timestamp	*ts)
>  {
> +	if (dip->di_version >= 3 &&
> +	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {
> +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> +		uint64_t		s;
> +		uint32_t		n;
> +
> +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> +		tv->tv_nsec = n;
> +		return;
> +	}
> +
>  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
>  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
>  }

Can't say I'm sold on this union. It seems cleaner to me to just
make the timestamp an opaque 64 bit field on disk and convert it to
the in-memory representation directly in the to/from disk
operations. e.g.:

void
xfs_inode_from_disk_timestamp(
	struct xfs_dinode		*dip,
	struct timespec64		*tv,
	__be64				ts)
{

	uint64_t		t = be64_to_cpu(ts);
	uint64_t		s;
	uint32_t		n;

	if (xfs_dinode_is_bigtime(dip)) {
		s = div_u64_rem(t, NSEC_PER_SEC, &n) - XFS_INO_BIGTIME_EPOCH;
	} else {
		s = (int)(t >> 32);
		n = (int)(t & 0xffffffff);
	}
	tv->tv_sec = s;
	tv->tv_nsec = n;
}



> @@ -220,9 +234,9 @@ xfs_inode_from_disk(
>  	 * a time before epoch is converted to a time long after epoch
>  	 * on 64 bit systems.
>  	 */
> -	xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
> -	xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
> -	xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
> +	xfs_inode_from_disk_timestamp(from, &inode->i_atime, &from->di_atime);
> +	xfs_inode_from_disk_timestamp(from, &inode->i_mtime, &from->di_mtime);
> +	xfs_inode_from_disk_timestamp(from, &inode->i_ctime, &from->di_ctime);
>  
>  	to->di_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> @@ -235,9 +249,17 @@ xfs_inode_from_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> -		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> +		xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> +				&from->di_crtime);
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> +		/*
> +		 * Set the bigtime flag incore so that we automatically convert
> +		 * this inode's ondisk timestamps to bigtime format the next
> +		 * time we write the inode core to disk.
> +		 */
> +		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
> +			to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
>  	}

We do not want on-disk flags to be changed outside transactions like
this. Indeed, this has implications for O_DSYNC operation, in that
we do not trigger inode sync operations if the inode is only
timestamp dirty. If we've changed this flag, then the inode is more
than "timestamp dirty" and O_DSYNC will need to flush the entire
inode.... :/

IOWs, I think we should only change this flag in a timestamp
transaction where the timestamps are actually being logged and hence
we can set inode dirty state appropriately so that everything will
get logged, changed and written back correctly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
