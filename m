Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 867547F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 16:49:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72304304053
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 14:49:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EKwUf1qOr7OFKunn for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 14:49:01 -0700 (PDT)
Date: Fri, 10 Oct 2014 08:48:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Filesystem is broken and cant repair and mount!
Message-ID: <20141009214858.GF4376@dastard>
References: <trinity-ac293e2f-55d9-464e-8eab-f32026102118-1412890652269@3capp-gmx-bs22>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <trinity-ac293e2f-55d9-464e-8eab-f32026102118-1412890652269@3capp-gmx-bs22>
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
To: Dragon <Sunghost@gmx.de>
Cc: xfs@oss.sgi.com

On Thu, Oct 09, 2014 at 11:37:32PM +0200, Dragon wrote:
> Hello Dave,
> and thx for reply. I have no backup and no disk todo this ;(.
> Here the result from xfs_repair -n:http://pastebin.com/jC5S0KSH

Looks like a handful of corrupted inode blocks, with the main
problem being that the inodes 3469995058-3469995060 (i.e. 3 inodes)
do not have the corect magic numbers in them. the rest of the inodes
in that chunk are corrupt in some way, too, so it would seem that
there's been some kind of write error to these inodes.

xfs_repair should fix this problems without issues.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
