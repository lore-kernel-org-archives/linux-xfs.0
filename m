Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MNMIlW054921
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 18:22:23 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20C1B159D8AD
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 16:25:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nakgdQThY6bnHUKx for <linux-xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 16:25:17 -0700 (PDT)
Date: Wed, 23 Mar 2011 10:25:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110322232504.GC15270@dastard>
References: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

On Fri, Mar 18, 2011 at 11:46:04AM -0400, Sean Noonan wrote:
> Using the attached program, we are able to reproduce this bug reliably.
> $ make vmtest
> $ ./vmtest /xfs/hugefile.dat $(( 16 * 1024 * 1024 * 1024 )) # vmtest <path_to_file> <size_in_bytes>
> /xfs/hugefile.dat: mapped 17179869184 bytes in 33822066943 ticks
> 749660: avg 13339 max 234667 ticks
> 371945: avg 26885 max 281616 ticks
> ---
> At this point, we see the following on the console:
> [593492.694806] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> [593506.724367] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> [593524.837717] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> [593556.742386] XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

What is the configuration of the machine you are testing on? I can't
reproduce this on a current 2.6.39-tot tree on a 2p/2GB RAM VM that
has it's blockdev images on a single SATA drive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
