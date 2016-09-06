Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA19E7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 03:48:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F2F5304032
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 01:48:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rz2pmVmw0FnEhUC6 for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2016 01:48:30 -0700 (PDT)
Date: Tue, 6 Sep 2016 18:48:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: undo block reservation correctly in
	xfs_trans_reserve()
Message-ID: <20160906084828.GK30056@dastard>
References: <1473149039-30487-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1473149039-30487-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 04:03:59PM +0800, Eryu Guan wrote:
> "blocks" should be added back to fdblocks at undo time, not taken
> away, i.e. the minus sign should not be used.

You've described the code change you made, not about the problem you
hit and are fixing.

i.e. I've got no idea how you found this, or even how to identify a
system that is tripping over this problem. By describing how you
found it and the symptoms being displayed, I'll learn from you how
to identify the problem and hence, in future, be able to identify
systems that are tripping over the problem, too.

> Fixes: 0d485ada404b ("xfs: use generic percpu counters for free block counter")

I really don't like this sort of "annotation". It wrongly implies
the commit was broken (it wasn't) and there's no scope for stating
the problem context. i.e.  that the problem is a minor regression in
a rarely travelled corner case that is unlikely to affect production
machines in any significant way. It's better to describe things with
all the relevant context:

"This is a regression introduced in commit ... and only occurs when
.... "

> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Not @redhat?

> ---
>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 5f3d33d..011dace 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -217,7 +217,7 @@ undo_log:
>  
>  undo_blocks:
>  	if (blocks > 0) {
> -		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
> +		xfs_mod_fdblocks(tp->t_mountp, ((int64_t)blocks), rsvd);

Outer () can be dropped, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
