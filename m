Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0202C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 02:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A204020787
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 02:52:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sYyv/hut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgC0CwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:52:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgC0CwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 22:52:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2ni3T110918;
        Fri, 27 Mar 2020 02:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DqsZX53MPTndv+CIVDoNt9OMST7fEFPm21i+wNnCZnA=;
 b=sYyv/huthKX71ngcPaKDeJsHM9xNj3yIRaGaIZm6uTNihDJLZ2UkJw3CTff1CKR8GnD1
 to8TLm71JxwASq9/XPFFwpWyqhy/6amHGVOSVVQ+MxUr97gzacsv9pHrkTbFXeYNjhk+
 U9iqY1C6F4019evw/TwGcRR2U+HOqSozTLpSE5qPf72SxExChfs0V5ZwYwm5D/1Ygpw9
 qNlCKbnnfY83vQfv50KaXcAlGldyVfSLfMJ5ZZF9vj0zC1Hlue04M2Gaxe4SdnjqX4e2
 RQgrdWzbBdM0U6pOl0J9bHtwkMIzfuLeWMrLghKc37pm1zsfzhrRkwYCKT7yGv/tExyE kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3014598r3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:51:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2pvQa064798;
        Fri, 27 Mar 2020 02:51:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3006r9hssb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:51:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R2pu4s024019;
        Fri, 27 Mar 2020 02:51:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:51:56 -0700
Date:   Thu, 26 Mar 2020 19:51:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't flush the entire filesystem when a buffered
 write runs out of space
Message-ID: <20200327025153.GP29351@magnolia>
References: <20200327014558.GG29339@magnolia>
 <20200327022714.GQ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327022714.GQ10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=2
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=2 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 01:27:14PM +1100, Dave Chinner wrote:
> On Thu, Mar 26, 2020 at 06:45:58PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A customer reported rcu stalls and softlockup warnings on a computer
> > with many CPU cores and many many more IO threads trying to write to a
> > filesystem that is totally out of space.  Subsequent analysis pointed to
> > the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> > which causes a lot of wb_writeback_work to be queued.  The writeback
> > worker spends so much time trying to wake the many many threads waiting
> > for writeback completion that it trips the softlockup detector, and (in
> > this case) the system automatically reboots.
> 
> That doesn't sound right. Each writeback work that is queued via
> sync_inodes_sb should only have a single process waiting on it's
> completion. And how many threads do you actually have to need to
> wake up for it to trigger a 10s soft-lockup timeout?
> 
> More detail, please?

It's a two socket 64-core system with some sort of rdma/infiniband magic
and somewhere between 600-900 processes doing who knows what with the
magic.  Each of those threads *also* is writing trace data to its own
separate trace file (three private log files per process).  Hilariously
they never check the return code from write() so they keep pounding the
system forever.

(I don't know what the rdma/infiniband magic is, they won't tell me.)

When the filesystem fills up all the way (it's a 10G fs with 8,207
blocks free) they keep banging away on it until something finally dies.

I tried writing a dumb fstest to simulate the log writer part, but that
never succeeds in triggering the rcu stalls.

If you want the gory dmesg details I can send you some dmesg log.

> > In addition, they complain that the lengthy xfs_flush_inodes scan traps
> > all of those threads in uninterruptible sleep, which hampers their
> > ability to kill the program or do anything else to escape the situation.
> > 
> > Fix this by replacing the full filesystem flush (which is offloaded to a
> > workqueue which we then have to wait for) with directly flushing the
> > file that we're trying to write.
> 
> Which does nothing to flush -other- outstanding delalloc
> reservations and allow the eofblocks/cowblock scan to reclaim unused
> post-EOF speculative preallocations.
> 
> That's the purpose of the xfs_flush_inodes() - without it we can get
> very premature ENOSPC, especially on small filesystems when writing
> largish files in the background. So I'm not sure that dropping the
> sync is a viable solution. It is actually needed.

Yeah, I did kinda wonder about that...

> Perhaps we need to go back to the ancient code thatonly allowed XFS
> to run a single xfs_flush_inodes() at a time - everything else
> waited on the single flush to complete, then all returned at the
> same time...

That might work too.  Admittedly it's pretty silly to be running this
scan over and over and over considering that there's never going to be
any more free space.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
