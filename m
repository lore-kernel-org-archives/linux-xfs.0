Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B26C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 17:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554082469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 17:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VqkevkkO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgB1RKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 12:10:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1RKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 12:10:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SGvtHB169838;
        Fri, 28 Feb 2020 17:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=tHh4IykYklDSXe+CFzNuxoKstdPt/Vd9+ZLonQkz4wQ=;
 b=VqkevkkOPBzIMZV6Yd9vRPa4BG76bj6QVDd9I+nKwVKDI2vYYuX/ShGCdQpLU6SV+ZhP
 f82JaZajZZ35IMo9CdinflkSiK92J+z42Anf7seTGvyxKxo46IotoSPFlQ9jfjybSmMr
 UO3pE8D6/gmBHOPP7czUzhg3lQbuLjvcI7b+ooF8EN4UwaPkiXjW0EcVL7eCrIc11Vz8
 d6Q8QBAvpLNR7chxNxSPyJW1RXE6h2wTfQA7sAVjU9LOx41srtj+bXKInz+BOc4qH3cj
 THY507zjjbcB8plYwRAUPMYp2UQWOlsOm785REHLHw//J6/kyohkhHxTZpHhqrGiGvHz 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yf0dmagcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 17:10:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SGwIXA004611;
        Fri, 28 Feb 2020 17:10:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4r96ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 17:10:18 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SHAHY6029911;
        Fri, 28 Feb 2020 17:10:17 GMT
Received: from localhost (/10.159.226.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 09:10:17 -0800
Date:   Fri, 28 Feb 2020 09:10:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200228171014.GC8070@magnolia>
References: <20200227203636.317790-1-preichl@redhat.com>
 <20200227203636.317790-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227203636.317790-2-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 09:36:33PM +0100, Pavel Reichl wrote:
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> state of rw_semaphores hold by inode.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> ---
> Changes from V5:
> 	Drop shared flag from __xfs_rwsem_islocked()
> 
> 
>  fs/xfs/xfs_inode.c | 42 ++++++++++++++++++++++++++----------------
>  fs/xfs/xfs_inode.h |  2 +-
>  2 files changed, 27 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..4faf7827717b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -345,32 +345,42 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +static inline bool
> +__xfs_rwsem_islocked(
> +	struct rw_semaphore	*rwsem,
> +	bool			excl)
> +{
> +	if (!rwsem_is_locked(rwsem))
> +		return false;

So, uh, I finally made the time to dig through what exactly lockdep
provides as far as testing functions, and came up with the following
truth table for the old xfs_isilocked behavior w.r.t. IOLOCK:

(nolockdep corresponds to debug_locks == 0)

RWSEM STATE		PARAMETERS TO XFS_ISILOCKED:
			SHARED	EXCL	SHARED | EXCL
readlocked		y	n	y
writelocked		y	y	y
unlocked		n	n	n
nolockdep readlocked	y	y	y
nolockdep writelocked	y	y	y
nolockdep unlocked	n	y	n

Note that EXCL × nolockdep_unlocked returns an incorrect result, but
because we only use it with ASSERTs there haven't been any failures
reported.

And here's your new version:

readlocked		y	y	y
writelocked		y	n	n
unlocked		n	n	n
nolockdep readlocked	y	y	y
nolockdep writelocked	y	y	y
nolockdep unlocked	n	n	n

Thanks for fixing the false positive that I mentioned above.

> +
> +	if (debug_locks && excl)
> +		return lockdep_is_held_type(rwsem, 1);

This is wrong, the second parameter of lockdep_is_held_type is 0 to test
if the rwsem is write-locked; 1 to test if it is read-locked; or -1 to
test if the rwsem is read or write-locked.

So, this function's call signature should change so that callers can
communicate both _SHARED and _EXCL; and then you can pick the correct
"r" parameter value for the lockdep_is_held_type() call.  Then all of
this becomes:

	if !debug_locks:
		return rwsem_is_locked(rwsem)

	if shared and excl:
		r = -1
	elif shared:
		r = 1
	else:
		r = 0
	return lockdep_is_held_type(rwsem, r)

Note also that you don't necessarily need to pass shared and excl as
separate parameters (as you did in v3); the XFS_*LOCK_{EXCL,SHARED}
definitions enable you to take care of all that with some clever bit
shifting and masking.

--D

> +
> +	return true;
> +}
> +
> +bool
>  xfs_isilocked(
> -	xfs_inode_t		*ip,
> +	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> -		if (!(lock_flags & XFS_ILOCK_SHARED))
> -			return !!ip->i_lock.mr_writer;
> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
> +				(lock_flags & XFS_ILOCK_EXCL));
>  	}
>  
> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
> -			return !!ip->i_mmaplock.mr_writer;
> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
> +				(lock_flags & XFS_MMAPLOCK_EXCL));
>  	}
>  
> -	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
> -		if (!(lock_flags & XFS_IOLOCK_SHARED))
> -			return !debug_locks ||
> -				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
> -		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
> +	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> +		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
> +				(lock_flags & XFS_IOLOCK_EXCL));
>  	}
>  
>  	ASSERT(0);
> -	return 0;
> +	return false;
>  }
>  #endif
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 492e53992fa9..3d7ce355407d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -416,7 +416,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
>  void		xfs_iunlock(xfs_inode_t *, uint);
>  void		xfs_ilock_demote(xfs_inode_t *, uint);
> -int		xfs_isilocked(xfs_inode_t *, uint);
> +bool		xfs_isilocked(xfs_inode_t *, uint);
>  uint		xfs_ilock_data_map_shared(struct xfs_inode *);
>  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  
> -- 
> 2.24.1
> 
