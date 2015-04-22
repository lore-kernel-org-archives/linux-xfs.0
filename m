Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D6427F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 14:11:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C572304062
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 12:11:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uUUD5EtffDKelEJq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 12:11:44 -0700 (PDT)
Date: Wed, 22 Apr 2015 15:11:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical
	section
Message-ID: <20150422191137.GF6688@bfoster.bfoster>
References: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Waiman Long <Waiman.Long@hp.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 22, 2015 at 01:33:41PM -0400, Waiman Long wrote:
> The commit f7be2d7f594cbc ("xfs: push down inactive transaction
> mgmt for truncate") refactored the xfs_inactive() function
> in fs/xfs/xfs_inode.c.  However, it also moved the call to
> xfs_idestroy_fork() from inside the xfs_ilock() critical section to
> outside. That was causing memory corruption and strange failures like
> deferencing NULL pointers in some circumstances.
> 
> This patch moves the xfs_idestroy_fork() call back into an xfs_ilock()
> critical section to avoid memory corruption problem.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---

Interesting... so from your previous mail we have an inactive/reclaim
racing with an xfs_iflush_fork() of the attr fork, or something of that
nature? Is there a specific reproducer or is it some kind of stress
test?

Good catch in any case, it looks like a deviation from the previous
code...

>  fs/xfs/xfs_inode.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6163767..31850fb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1900,8 +1900,11 @@ xfs_inactive(
>  			return;
>  	}
>  
> -	if (ip->i_afp)
> +	if (ip->i_afp) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	}

It probably doesn't matter, but I wonder if it would be better to just
place the lock outside of the ip->i_afp check to preserve the original
behavior if nothing else...

Brian

>  
>  	ASSERT(ip->i_d.di_anextents == 0);
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
