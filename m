Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85FEC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13F52145D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qUgIOMoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgJLV2Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 17:28:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729761AbgJLV2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 17:28:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09CLEEKC034160;
        Mon, 12 Oct 2020 21:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UAnGm5JzYKr7D/1aRkhxjAYsWYjSoOGfJNbuADtBquE=;
 b=qUgIOMocWmVnPUpu74ODO1jk1J7bxYrkh9GB2sGPSjYoJP7ODGJQWi5r44vkD7Be7EsK
 UU/sn9Z8Lwe+I3NnEIKuIsT38o5Z2MnGFOHFK0dSo8G/yCbSyKVqXeUyD0llfyfwlUBt
 GY/uat2Y7TCExFB2XRr+t2qVnkdIWPsvy7M9XEsOO+7yGw/+Z997GXHFPinxc9a8dEpj
 jgqY8+9tjxLBwQIsWAMatYGflbQ/eKytH2uocpGyxBvNRtq8RgI2NlMZiHE5T6GxNhER
 o3cTb7XrwwRhVxrssCcvOE4wna1Aawf56YeEc0mjhLxmz7m7JgPso+FWfYPy1eeNihUj Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wkf7cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 21:28:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09CLBUP8088279;
        Mon, 12 Oct 2020 21:28:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 344by1a0up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 21:28:20 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09CLSJo8006386;
        Mon, 12 Oct 2020 21:28:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Oct 2020 14:28:19 -0700
Date:   Mon, 12 Oct 2020 14:28:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201012212818.GX6540@magnolia>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-2-preichl@redhat.com>
 <20201012160308.GH917726@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012160308.GH917726@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9772 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9772 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010120160
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 12:03:08PM -0400, Brian Foster wrote:
> On Fri, Oct 09, 2020 at 09:55:12PM +0200, Pavel Reichl wrote:
> > Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> > __xfs_rwsem_islocked() is a helper function which encapsulates checking
> > state of rw_semaphores hold by inode.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > Suggested-by: Dave Chinner <dchinner@redhat.com>
> > Suggested-by: Eric Sandeen <sandeen@redhat.com>
> > Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c | 48 ++++++++++++++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_inode.h | 21 +++++++++++++-------
> >  2 files changed, 54 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c06129cffba9..7c1ceb4df4ec 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -345,9 +345,43 @@ xfs_ilock_demote(
> >  }
> >  
> >  #if defined(DEBUG) || defined(XFS_WARN)
> > -int
> > +static inline bool
> > +__xfs_rwsem_islocked(
> > +	struct rw_semaphore	*rwsem,
> > +	int			lock_flags)
> > +{
> > +	int			arg;
> > +
> > +	if (!debug_locks)
> > +		return rwsem_is_locked(rwsem);
> > +
> > +	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> > +		/*
> > +		 * The caller could be asking if we have (shared | excl)
> > +		 * access to the lock. Ask lockdep if the rwsem is
> > +		 * locked either for read or write access.
> > +		 *
> > +		 * The caller could also be asking if we have only
> > +		 * shared access to the lock. Holding a rwsem
> > +		 * write-locked implies read access as well, so the
> > +		 * request to lockdep is the same for this case.
> > +		 */
> > +		arg = -1;
> > +	} else {
> > +		/*
> > +		 * The caller is asking if we have only exclusive access
> > +		 * to the lock. Ask lockdep if the rwsem is locked for
> > +		 * write access.
> > +		 */
> > +		arg = 0;
> > +	}
> 
> Are these arg values documented somewhere? A quick look at the function
> below didn't show anything..

Alas, no. :(

If you trace lockdep_is_held_type -> lock_is_held_type -> __lock_is_held
then you'll notice that "if (read == -1" bit, but none of those
functions are documented.

So I have no if that's /really/ permanent, other than to say that it
exists because Dave and Christoph and I requested it years ago and
commit f8319483f57f1 has been unchanged since 2016.

--D

> Also, I find the pattern of shifting in the caller slightly confusing,
> particularly with the 'lock_flags' name being passed down through the
> caller. Any reason we couldn't pass the shift value as a parameter and
> do the shift at the top of the function so the logic is clear and in one
> place?
> 
> > +
> > +	return lockdep_is_held_type(rwsem, arg);
> > +}
> > +
> > +bool
> >  xfs_isilocked(
> > -	xfs_inode_t		*ip,
> > +	struct xfs_inode	*ip,
> >  	uint			lock_flags)
> >  {
> >  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> ...
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index e9a8bb184d1f..77776af75c77 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -268,12 +268,19 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
> >   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
> >   *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
> >   */
> > -#define	XFS_IOLOCK_EXCL		(1<<0)
> > -#define	XFS_IOLOCK_SHARED	(1<<1)
> > -#define	XFS_ILOCK_EXCL		(1<<2)
> > -#define	XFS_ILOCK_SHARED	(1<<3)
> > -#define	XFS_MMAPLOCK_EXCL	(1<<4)
> > -#define	XFS_MMAPLOCK_SHARED	(1<<5)
> > +
> > +#define XFS_IOLOCK_FLAG_SHIFT	0
> > +#define XFS_ILOCK_FLAG_SHIFT	2
> > +#define XFS_MMAPLOCK_FLAG_SHIFT	4
> > +
> > +#define XFS_SHARED_LOCK_SHIFT	1
> > +
> > +#define XFS_IOLOCK_EXCL		(1 << (XFS_IOLOCK_FLAG_SHIFT))
> > +#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> > +#define XFS_ILOCK_EXCL		(1 << (XFS_ILOCK_FLAG_SHIFT))
> > +#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> > +#define XFS_MMAPLOCK_EXCL	(1 << (XFS_MMAPLOCK_FLAG_SHIFT))
> > +#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> >  
> 
> Any reason for the extra params around the shift values?
> 
> Brian
> 
> >  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
> >  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> > @@ -412,7 +419,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
> >  int		xfs_ilock_nowait(xfs_inode_t *, uint);
> >  void		xfs_iunlock(xfs_inode_t *, uint);
> >  void		xfs_ilock_demote(xfs_inode_t *, uint);
> > -int		xfs_isilocked(xfs_inode_t *, uint);
> > +bool		xfs_isilocked(struct xfs_inode *, uint);
> >  uint		xfs_ilock_data_map_shared(struct xfs_inode *);
> >  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
> >  
> > -- 
> > 2.26.2
> > 
> 
