Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DA3C7FC6
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 23:39:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D0B1304059
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 21:39:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YTXzNC5svUZUnE1D for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 21:39:17 -0700 (PDT)
Date: Tue, 30 Sep 2014 14:39:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question: How to use systemtap count the total inode read from
	disk
Message-ID: <20140930043913.GP4758@dastard>
References: <6AA21C22F0A5DA478922644AD2EC308C8C986B@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6AA21C22F0A5DA478922644AD2EC308C8C986B@SHSMSX101.ccr.corp.intel.com>
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
To: "Ma, Jianpeng" <jianpeng.ma@intel.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Sep 30, 2014 at 02:39:28AM +0000, Ma, Jianpeng wrote:
> Hi all,
>   I want to count the total read inode from disk. 

XFS already does that for you:

$ pminfo -tf xfs.inode_ops.ig_missed

xfs.inode_ops.ig_missed [number of failed in memory inode lookup operations]
    value 1835354
$

And that's the number read from disk as reported by PCP.  If you
don't have PCP:

$ awk '/ig/ {print $5}' /proc/fs/xfs/stat
1835354
$

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
