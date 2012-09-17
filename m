Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HNn3eJ237057 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 18:49:03 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	o6ffGvYOpwoMY1nc for <xfs@oss.sgi.com>;
	Mon, 17 Sep 2012 16:50:12 -0700 (PDT)
Date: Tue, 18 Sep 2012 09:49:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS (sdd1): Internal error xfs_da_do_buf(2) at line 2097 of file
	/usr/src/packages/BUILD/kernel-default-3.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.
Message-ID: <20120917234926.GJ13691@dastard>
References: <50573A13.7000206@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50573A13.7000206@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 17, 2012 at 04:56:19PM +0200, Richard Ems wrote:
> Hi all,
> 
> saturday morning one hard disc on our RAID6 failed. About one hour later,
>  the XFS running on that device reported the following error:
> 
> XFS (sdd1): Internal error xfs_da_do_buf(2) at line 2097 of file /usr/src/packages/BUILD/kernel-default-3.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.
.....
> Sep 15 07:30:51 fs1 kernel: [7369085.792619] XFS (sdd1): Corruption detected. Unmount and run xfs_repair
> 
> 
> And this repeating again and again ...
> 
> This system has been running fine for 87 days, no power outages or such.
> It's connected to an UPS, and the H800 Raid Controller has a BBU installed.
.....
> Why could this have happened?

Something went wrong at the RAID level (i.e. your hardware) in
handling the disk failure and recovering the array. It corrupted
blocks in the volume rather than recovering them cleanly without
errors. The corrupted blocks happened to be in a directory block,
and a frequently accessed one according to the errors in the log.

What you found in lost+found was the recoverable fragments of the
directory and whatever else was corrupted during the disk failure
incident.

> What more info can I provide to understand this issue and avoid
> this to happen again?

I'd be asking your hardware vendor about why it corrupted the
volume on a single disk failure when it is supposed to be able to
transparently handle double disk failures without losing/corrupting
data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
