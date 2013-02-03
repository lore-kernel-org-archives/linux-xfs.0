Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF44B7F54
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 17:17:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CE19AC001
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 15:17:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KlQR2o6UmoUOkZAH for <xfs@oss.sgi.com>;
	Sun, 03 Feb 2013 15:17:08 -0800 (PST)
Date: Mon, 4 Feb 2013 10:17:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump showing system problems -- ?  ideas?
Message-ID: <20130203231706.GJ2667@dastard>
References: <510DDE61.6060005@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510DDE61.6060005@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Feb 02, 2013 at 07:49:53PM -0800, Linda Walsh wrote:
> 
> 
> I was looking through my backup logs and noticed a few of the
> *logs* of the backups having abnormally high size.
> 
> In looking at them, I saw a bunch of messages (last night 3211 occurrences),
> of messages like:
> 
> xfsdump: WARNING: could not get list of root attributes for nondir
> ino 3415547687: Cannot allocate memory (12)
> xfsdump: WARNING: could not get list of secure attributes for nondir
> ino 3415547687: Cannot allocate memory (12)
> xfsdump: WARNING: could not get list of non-root attributes for
> nondir ino 3415547688: Cannot allocate memory (12)
> xfsdump: WARNIN: could not get list of non-root attributes for
> nondir ino 4225270812: Cannot allocate memory (12)
> xfsdump: WARNING: could not get list of root attributes for nondir
> ino 4225270812: Cannot allocate memory (12)
> xfsdump: WARNING: could not get list of secure attributes for nondir
> ino 4225270812: Cannot allocate memory (12)

Was fixed in 3.4:

$ gl -n 1 ad650f5
commit ad650f5b27bc9858360b42aaa0d9204d16115316
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Mar 7 04:50:21 2012 +0000

    xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
    
    xfsdump uses for a large buffer for extended attributes, which has a
    kmalloc'd shadow buffer in the kernel. This can fail after the
    system has been running for some time as it is a high order
    allocation. Add a fallback to vmalloc so that it doesn't require
    contiguous memory and so won't randomly fail while xfsdump is
    running.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
$ git describe --contains ad650f5
v3.4-rc1~55^2~11
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
