Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN0ldGT004824 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 18:47:39 -0600
Date: Fri, 23 Nov 2012 11:49:37 +1100
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs: fix attr tree double split corruption
Message-ID: <20121123004937.GC18889@devil.redhat.com>
References: <1353625175-29479-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1353625175-29479-1-git-send-email-peterhuewe@gmx.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ben Myers <bpm@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

[added xfs@oss.sgi.com]

On Thu, Nov 22, 2012 at 11:59:35PM +0100, Peter Huewe wrote:
> In certain circumstances, a double split of an attribute tree is
> needed to insert or replace an attribute. In rare situations, this
> can go wrong, leaving the attribute tree corrupted. In this case,
> the attr being replaced is the last attr in a leaf node, and the
> replacement is larger so doesn't fit in the same leaf node.
> When we have the initial condition of a node format attribute
> btree with two leaves at index 1 and 2. Call them L1 and L2.  The
> leaf L1 is completely full, there is not a single byte of free space
> in it. L2 is mostly empty.  The attribute being replaced - call it X
> - is the last attribute in L1.

Hi Peter,

While I appreciate what you are doing here, can you please send
stable backport patches to the xfs@oss.sgi.com list for review
before sending them to stable@vger.kernel.org? There may already be
someone doing this work, and we want to make sure that backports are
correct, tested and worth the risk of fixing before asking the
(already overworked) stable kernel maintainers to include it.

As such, how did you test that the fix works on the stable kernels
you are targetting? AFAIK, I'm the only person who has the
filesystem images that reproducably triggered this corruption
problem....

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> Cc: <stable@vger.kernel.org> # 3.6.x
> Cc: <stable@vger.kernel.org> # 3.4.x
> Cc: <stable@vger.kernel.org> # 3.2.x

If we are pushing this fix back to stable kernels, then it
should go back to 3.0.x as well.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
