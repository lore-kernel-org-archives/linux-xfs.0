Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F67C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 22:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72755206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 22:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="odm7oRJL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgA2WZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 17:25:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgA2WZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 17:25:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TMNAx7147125;
        Wed, 29 Jan 2020 22:25:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8ap9izTjE8HxkmJjC/lgOXzZMyHK8M2z7MWsbJ4hmIk=;
 b=odm7oRJL+eUQf42z7WXxd0dAsn6131lSSaKdxEF51qo7gmSkZG20oXsWWUHCxcMTIsu0
 oUG8FQEICuOQnJKlVO+5yRJ7U5vwoUzJxQgvxWNM46+k+wp916I11P5myT4++Yn+qQV+
 EvuIqFYck7A3XAzNN69odrqT5v8WsiR/Ubvd7Gk9tKwr4P0tpKaMYS0/uM3iKVM/oFJr
 hW7DtC6YXWCGAhLRS8wY8wHBD3ETduHe/PwT7N2E0lp1SriLxtasMWqxYgQJClKYOmwk
 0JdOl3pbOizjLaBaqkMeJ+ZxVBlIzD5psayCEeW9Ix98AJHCdFzGBDYSRYa9XCbizYbg IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xreargedu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 22:25:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TMOawd115179;
        Wed, 29 Jan 2020 22:25:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xuhejg3xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 22:25:35 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00TMPXRF031495;
        Wed, 29 Jan 2020 22:25:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jan 2020 14:25:33 -0800
Date:   Wed, 29 Jan 2020 14:25:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: change xfs_isilocked() to always use lockdep()
Message-ID: <20200129222532.GW3447196@magnolia>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-2-preichl@redhat.com>
 <20200129221819.GO18610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129221819.GO18610@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9515 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001290172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9515 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001290172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 09:18:19AM +1100, Dave Chinner wrote:
> On Tue, Jan 28, 2020 at 03:55:25PM +0100, Pavel Reichl wrote:
> > mr_writer is obsolete and the information it contains is accesible
> > from mr_lock.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c5077e6326c7..32fac6152dc3 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -352,13 +352,17 @@ xfs_isilocked(
> >  {
> >  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> >  		if (!(lock_flags & XFS_ILOCK_SHARED))
> > -			return !!ip->i_lock.mr_writer;
> > +			return !debug_locks ||
> > +				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
> >  		return rwsem_is_locked(&ip->i_lock.mr_lock);
> >  	}
> >  
> >  	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> >  		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> > -			return !!ip->i_mmaplock.mr_writer;
> > +			return !debug_locks ||
> > +				lockdep_is_held_type(
> > +					&ip->i_mmaplock.mr_lock,
> > +					0);
> >  		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> >  	}
> 
> Ok, so this code is only called from ASSERT() statements, which
> means this turns off write lock checking for XFS debug kernels if
> lockdep is not enabled. Hence I think these checks need to be
> restructured to be based around rwsem_is_locked() first and lockdep
> second.
> 
> That is:
> 
> /* In all implementations count != 0 means locked */
> static inline int rwsem_is_locked(struct rw_semaphore *sem)
> {
>         return atomic_long_read(&sem->count) != 0;
> }
> 
> This captures both read and write locks on the rwsem, and doesn't
> discriminate at all. Now we don't have explicit writer lock checking
> in CONFIG_XFS_DEBUG=y kernels, I think we need to at least check
> that the rwsem is locked in all cases to catch cases where we are
> calling a function without the lock held. That will ctach most
> programming mistakes, and then lockdep will provide the
> read-vs-write discrimination to catch the "hold the wrong lock type"
> mistakes.
> 
> Hence I think this code should end up looking like this:
> 
> 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> 		bool locked = false;
> 
> 		if (!rwsem_is_locked(&ip->i_lock))
> 			return false;
> 		if (!debug_locks)
> 			return true;
> 		if (lock_flags & XFS_ILOCK_EXCL)
> 			locked = lockdep_is_held_type(&ip->i_lock, 0);
> 		if (lock_flags & XFS_ILOCK_SHARED)
> 			locked |= lockdep_is_held_type(&ip->i_lock, 1);
> 		return locked;
> 	}
> 
> Thoughts?

I like that a lot better, though perhaps the if body should be factored
into a separate static inline so we don't repeat that 3x.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
