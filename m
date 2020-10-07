Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61743C41604
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 15:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E1BE21548
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 15:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gTbYYG1D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgJGP0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 11:26:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgJGP0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 11:26:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097FJTuc187549;
        Wed, 7 Oct 2020 15:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vSTDtErYZQDYS2y1xIwY3nGdlAv0/UPz/TgL2PmwPgY=;
 b=gTbYYG1DxQnJRrz+Q5MhBVRTLNYCqJ+EWQB3dRiHbtZUbZmDSsRAnoVCd8TRfQbATVhx
 bviVa3/ohMr/vDdYHuTLSXuogejz4MggbMILlEGW7CtTDRkslCY3RyBoFwWvj7MNjXuT
 nYhEeth54p6IGDVwFhV9WlPlWkRO/1Me7hYaIT7fqR2tpCvAtvMeV9a/3mvxLd71cJtX
 MC+Mow+xdH/F+e4LBhLUT3+OqSUfrVoQuzkMkmafLF/0f0dx7kWWCvwgpiOFk6GS6e/P
 kHE2/jlFI/cf3Qrcocx0u9HS6ngjXr/vtT37zbGtvDtfmYyvZTd4Vokyo/Ueorv5ZbrS 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxn2d3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 15:25:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097FEr1g081446;
        Wed, 7 Oct 2020 15:25:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410jys6q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 15:25:56 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097FPstG028619;
        Wed, 7 Oct 2020 15:25:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 08:25:54 -0700
Date:   Wed, 7 Oct 2020 08:25:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201007152554.GL49559@magnolia>
References: <20201006191541.115364-1-preichl@redhat.com>
 <20201006191541.115364-5-preichl@redhat.com>
 <20201007012159.GA49547@magnolia>
 <066ebfa6-25a2-aee4-a01c-3803ef716361@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <066ebfa6-25a2-aee4-a01c-3803ef716361@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070098
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 09:17:13AM -0500, Eric Sandeen wrote:
> On 10/6/20 8:21 PM, Darrick J. Wong wrote:
> > On Tue, Oct 06, 2020 at 09:15:41PM +0200, Pavel Reichl wrote:
> >> Remove mrlock_t as it does not provide any extra value over
> >> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
> >> replace mr*() functions with native rwsem calls.
> >>
> >> Release the lock in xfs_btree_split() just before the work-queue
> >> executing xfs_btree_split_worker() is scheduled and make
> >> xfs_btree_split_worker() to acquire the lock as a first thing and
> >> release it just before returning from the function. This it done so the
> >> ownership of the lock is transfered between kernel threads and thus
> >> lockdep won't complain about lock being held by a different kernel
> >> thread.
> >>
> >> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_btree.c | 14 +++++++
> >>  fs/xfs/mrlock.h           | 78 ---------------------------------------
> >>  fs/xfs/xfs_inode.c        | 36 ++++++++++--------
> >>  fs/xfs/xfs_inode.h        |  4 +-
> >>  fs/xfs/xfs_iops.c         |  4 +-
> >>  fs/xfs/xfs_linux.h        |  2 +-
> >>  fs/xfs/xfs_super.c        |  6 +--
> >>  7 files changed, 41 insertions(+), 103 deletions(-)
> >>  delete mode 100644 fs/xfs/mrlock.h
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> >> index 2d25bab68764..1d1bb8423688 100644
> >> --- a/fs/xfs/libxfs/xfs_btree.c
> >> +++ b/fs/xfs/libxfs/xfs_btree.c
> >> @@ -2816,6 +2816,7 @@ xfs_btree_split_worker(
> >>  	unsigned long		pflags;
> >>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
> >>  
> >> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
> > These calls also need a comment explaining just what they're doing.
> > 
> >>  	/*
> >>  	 * we are in a transaction context here, but may also be doing work
> >>  	 * in kswapd context, and hence we may need to inherit that state
> >> @@ -2832,6 +2833,7 @@ xfs_btree_split_worker(
> >>  	complete(args->done);
> >>  
> >>  	current_restore_flags_nested(&pflags, new_pflags);
> >> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
> > Note that as soon as you call complete(), xfs_btree_split can wake up
> > and return, which means that *args could now point to reclaimed stack
> > space.  This leads to crashes and memory corruption in generic/562 on
> > a 1k block filesystem (though in principle this can happen anywhere):
> 
> 
> What's the right way out of this; store *ip when we enter the function
> and use that to get to the map, rather than args i guess?

Er, no, because the worker could also get preempted right after
complete() and take so long to get rescheduled that the the inode have
been reclaimed.  Think about it -- the original thread is waiting on the
completion that it passed to the worker through $args, and therefore the
worker cannot touch any of the resources it was accessing through $args
after calling complete()....

--D

> Thanks,
> -Eric
