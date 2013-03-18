Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0630C7F3F
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:34:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9E84304070
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 16:33:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6n7eExxlPStO5bEB for <linux-xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 16:33:54 -0700 (PDT)
Date: Tue, 19 Mar 2013 10:33:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount XFS partition fail after repair when uquota and gquota are
	used
Message-ID: <20130318233353.GT6369@dastard>
References: <1363600796196-34996.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363600796196-34996.post@n7.nabble.com>
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
To: anciaux <guillaume.anciaux@epfl.ch>
Cc: linux-xfs@oss.sgi.com

On Mon, Mar 18, 2013 at 02:59:56AM -0700, anciaux wrote:
> I have been struggling to repair a partition after a RAID disk set failure.
> 
> Apparently the data is accessible with no problem since I can mount the
> partition.
> 
> The problem is ONLY when I use the uquota and gquota mount option (which I
> was using freely before the disk failure).
> 
> The syslog shows: 
> 
> Mar 18 09:35:50 storage kernel: [  417.885430] XFS (sdb1): Internal error
> xfs_iformat(1) at line 319 of file

And the line before this in your log should tell you what inode was
corrupt. Can you paste it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
