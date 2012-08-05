Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q75KvXq9006389 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 15:57:34 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NIVS3jejaKBQwQSA for <xfs@oss.sgi.com>;
	Sun, 05 Aug 2012 13:57:32 -0700 (PDT)
Date: Mon, 6 Aug 2012 06:57:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs / planned resize / performance impact
Message-ID: <20120805205728.GT2877@dastard>
References: <5017E426.2040709@profihost.ag> <20120804224336.GS2877@dastard>
	<C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Aug 05, 2012 at 07:46:33AM +0200, Stefan Priebe wrote:
> Am 05.08.2012 um 00:43 schrieb Dave Chinner <david@fromorbit.com>:
> 
> > On Tue, Jul 31, 2012 at 03:56:54PM +0200, Stefan Priebe - Profihost AG wrote:
> >> Hello list,
> >> 
> >> i'm planning to create a couple of VMs with just 30GB of space while
> >> using xfs as the main filesystem.
> >> 
> >> Now i alreay know that some of the VMs will grow up to 250GB while
> >> resizing the block device and using xfs_growfs.
> > 
> > Just use thin provisioning and make it 250GB to begin with. Thin
> > provisioning mades filsystem grow/shrink pretty much redundant....
> 
> But dm thin isn't stable isn't it?

AFAIK, It's mostly stable.

> Does xfs reallocate used parts of the block
> Device before using new parts?

Sometimes. Depends on workload, locality of reference,  patterns of
freeing and allocation, etc.

> Otherwise deleting and recreating files will result in full used space pretty fast.

fstrim. dm-thinp supports discard commands just fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
