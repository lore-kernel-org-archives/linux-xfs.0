Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B05247F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 13:54:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E9F9304032
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 11:54:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ERp9QGoCfiDd6NXx for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2015 11:54:37 -0800 (PST)
Date: Tue, 15 Dec 2015 06:54:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20151214195422.GM26718@dastard>
References: <20151214180048.GA15690@glen>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151214180048.GA15690@glen>
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
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 14, 2015 at 07:00:48PM +0100, Andrea Gelmini wrote:
> Hi everybody,
>    using dev kernel v4.4, I have this:
> 
> [40240.371807] ==================================================================
> [40240.371826] BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0 at addr ffff88001ed15428
> [40240.371832] Read of size 4 by task xfsaild/dm-0/332
> [40240.371834] =============================================================================
> [40240.371839] BUG xfs_ili (Tainted: G    B          ): kasan: bad access detected
> [40240.371842] -----------------------------------------------------------------------------
.....

What line of code does this address correspond to in your kernel?

	xfs_iflush_cluster+0x9d7

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
