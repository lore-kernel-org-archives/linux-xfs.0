Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C60587F61
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 10:22:57 -0500 (CDT)
Date: Tue, 1 Oct 2013 10:22:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Use kmem_free() instead of free()
Message-ID: <20131001152254.GM10553@sgi.com>
References: <1380638873-5181-1-git-send-email-treding@nvidia.com>
	<524AE39B.3040505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <524AE39B.3040505@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Alex Elder <elder@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 01, 2013 at 10:00:43AM -0500, Mark Tinguely wrote:
> On 10/01/13 09:47, Thierry Reding wrote:
> >This fixes a build failure caused by calling the free() function which
> >does not exist in the Linux kernel.
> >
> >Signed-off-by: Thierry Reding<treding@nvidia.com>
> >---
> >  fs/xfs/xfs_log_recover.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >index 4324058..3979749 100644
> >--- a/fs/xfs/xfs_log_recover.c
> >+++ b/fs/xfs/xfs_log_recover.c
> >@@ -1585,7 +1585,7 @@ xlog_recover_add_to_trans(
> >  		"bad number of regions (%d) in inode log format",
> >  				  in_f->ilf_size);
> >  			ASSERT(0);
> >-			free(ptr);
> >+			kmem_free(ptr);
> >  			return XFS_ERROR(EIO);
> >  		}
> >
> 
> Looks good. I will remove the other list items in another patch.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Gah.  Build Fail.  Apparently things were getting a little punchy over here.

Applied, and thanks Thierry.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
