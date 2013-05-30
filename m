Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 067777F37
	for <linux-xfs@oss.sgi.com>; Wed, 29 May 2013 20:54:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A49EDAC001
	for <linux-xfs@oss.sgi.com>; Wed, 29 May 2013 18:54:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oFhAD9GFJK09Gk8D for <linux-xfs@oss.sgi.com>;
	Wed, 29 May 2013 18:53:59 -0700 (PDT)
Date: Thu, 30 May 2013 11:53:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel 3.3 XFS: Assertion failed: xfs_trans_get_block_res(tp) > 0
Message-ID: <20130530015355.GJ29466@dastard>
References: <1369842978624-35000.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369842978624-35000.post@n7.nabble.com>
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
To: kdasu <kdasu.kdev@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Wed, May 29, 2013 at 08:56:18AM -0700, kdasu wrote:
> kernel 3.3. instability with
> 
> When writing  3 real-time and 1 regular file on disk simultaneously
> (sync is blocking function). the rcu stall detection kicks in every
> time when 3rd-4th attempt.

Doesn't happen on my test rig running a 3.10-rc3 kernel using
default mkfs/mount parameters for a rt fs on x86-64. more
information about your system is needed.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> XFS: Assertion failed: xfs_trans_get_block_res(tp) > 0, file: fs/xfs/xfs_bmap.c,
>  line: 5203

I don't see that either, but that indicates you are probably using a
non-default realtime extent size configuration. That's something
xfs_info output will tell us.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
