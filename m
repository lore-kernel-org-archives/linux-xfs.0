Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF07629DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 20:32:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C129E30407F
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 18:32:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	t3w2MS3kO1pCB3uf for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 18:32:07 -0700 (PDT)
Date: Fri, 26 Apr 2013 11:32:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: shutdown filesystem if xfs_perag_get fails
Message-ID: <20130426013204.GW30622@dastard>
References: <20130421174107.007313126@sgi.com> <5174603A.8030208@sandeen.net>
	<51753EDE.6000301@sgi.com> <51754A13.5000808@sandeen.net>
	<5175532B.3050509@sgi.com> <20130422233033.GK30622@dastard>
	<51769111.3050103@sgi.com>
	<1366732475.3762.32402.camel@chandra-dt.ibm.com>
	<20130423204956.GM10481@dastard>
	<1366929706.4098.6.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366929706.4098.6.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Apr 25, 2013 at 05:41:46PM -0500, Chandra Seetharaman wrote:
> In which case something along the lines of
> 
> --- 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 3806088..3fb2fa6 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -203,7 +203,13 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t
> agno)
>         if (pag) {
>                 ASSERT(atomic_read(&pag->pag_ref) >= 0);
>                 ref = atomic_inc_return(&pag->pag_ref);
> -       }
> +       } else 
> +               /*
> +                * xfs_perag_get() is called with invalid agno,
> +                * which cannot happen. This indicates a problem
> +                * in the calling code.
> +                */
> +               BUG();

That's btrfs-style error handling. ;)

In reality, your patch is much worse than just letting the caller
dereference a null pointer, because it happens inside an RCU read
lock. That's guaranteed to hang the system, not just have the thread
that triggers a null pointer dereference go away. And further....

>         rcu_read_unlock();
>         trace_xfs_perag_get(mp, agno, ref, _RET_IP_);

... it means we can't catch the tracepoint with the bad agno in it.

>         return pag;
> --------
> 
> would be useful ?. Since we have a NULL pag, we will trip somewhere
> else. At least with this, there is a pointer to the debugger/sysadmin
> about where/what to look for (may be with more valuable/correct comment
> than above).

The current failure case is pretty damn obvious, so adding a BUG
doesn't make it any better. In fact, it makes it worse because it
prevents a caller from being able to handle a NULL perag return....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
