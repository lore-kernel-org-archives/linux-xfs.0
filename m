Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A29C7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 19:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F3EF28F8039
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 17:59:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	129P9EiFhBaxRA2i for <xfs@oss.sgi.com>;
	Mon, 15 Aug 2016 17:59:33 -0700 (PDT)
Date: Tue, 16 Aug 2016 10:59:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on top of LVM span in AWS.  Stripe or are AG's good enough?
Message-ID: <20160816005931.GD19025@dastard>
References: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>
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
To: Jeff Gibson <jgibson@spscommerce.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Aug 15, 2016 at 11:36:14PM +0000, Jeff Gibson wrote:
> So I'm creating an LVM volume with 8 AWS EBS disks that are
> spanned (linear) per Redhat's documentation for Gluster
> (https://access.redhat.com/documentation/en-US/Red_Hat_Storage/3.1/html/Deployment_Guide_for_Public_Cloud/ch02s03.html#Provisioning_Storage_for_Three-way_Replication_Volumes).
> 
> 2 questions-
> 
> 1.  Will XFS's Allocation Groups essentially stripe the data for
> me

No. XFS does not stripe data. It does, however, *distribute* data
different AGs according to locality policy (e.g. inode32 vs
inode64), so it uses all the AGs as the directory structure grows.

> or should I stripe the underlying volumes with LVM?

No, you're using EBS. Forget anything you know about storage layout
and geometry, because EBS has no guaranteed physical layout you can
optimise for.

> I'm not
> worried as much about data integrity with a stripe/span since
> Gluster is doing the redundancy work.
> 
> 2.  AWS volumes sometimes have inconsistent performance.  If I
> understand things correctly, AG's run in parallel.

Define "run". AGs can allocate/free blocks in parallel. If IO does
not require allocation, then AGs play no part in the IO path.

> In a
> non-striped volume, if some of the AGs are temporarily slower to
> respond than others due to one of the underlying volumes being
> slow, will XFS prefer the quicker responding AGs

No, it does not.

> or is I/O always
> evenly distributed?

No, it is not.

> If XFS prefers the more responsive AG's it
> seems to me that it would be better NOT to stripe the underlying
> disk since all AG's that are distributed in a stripe will
> continuously hit all component volumes, including the slow volume
> (unless if XFS compensates for this?)

I think you have the wrong idea about what allocation groups do.
They are for maintaining allocation concurrency and locality of
related objects on disk - they have no influence on where IO is
directed based on IO load or response time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
