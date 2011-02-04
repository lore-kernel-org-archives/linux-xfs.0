Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p14KlATI034676
	for <linux-xfs@oss.sgi.com>; Fri, 4 Feb 2011 14:47:11 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44BBF2B29C8
	for <linux-xfs@oss.sgi.com>; Fri,  4 Feb 2011 12:49:40 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fNQsZHAvFHgSNUrb for <linux-xfs@oss.sgi.com>;
	Fri, 04 Feb 2011 12:49:40 -0800 (PST)
Date: Sat, 5 Feb 2011 07:49:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug
	get into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Message-ID: <20110204204927.GZ11040@dastard>
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
	<4D4C0965.9010905@lueckdatasystems.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D4C0965.9010905@lueckdatasystems.com>
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
To: Michael Lueck <mlueck@lueckdatasystems.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>

On Fri, Feb 04, 2011 at 09:12:53AM -0500, Michael Lueck wrote:
> Dave Chinner wrote:
> >Ok, so xfsdump i seeing a short bulkstat, then an EINVAL returned
> >from the next bulkstat. That's not a race condition, and makes me
> >think you have some kind of on-disk corruption.
> 
> Very odd that some kind of on-disk corruption is suddenly causing
> xfsdump problems starting with Ubuntu 10.04 (Lucid) kernel
> 2.6.32-27 and persisting in 2.6.32-28.

Not really. The newer kernels have code in them that does more
validity checks than previous kernels, so older kernels would have
erroneously and silently returned unlinked files to xfsdump and have
them backed up. IOWs, you'd never notice such a corruption with
xfsdump. On the new kernel, xfsdump gets an EINVAL error to such
occurrences, which it should have in the first place.

> And there is one other person who confirmed this xfsdump problem
> running Lucid with kernel 2.6.32-28. They reported their "me too"
> in the Ubuntu bug tracker.
> 
> Could it be that 2.6.32-26 and prior managed to write something to
> disk corrupted, and the newer code is tripping on it?

That's what I'm trying to find out. Or it could be something as
simple as your disk has had an undetected bit error that has flipped
a bit in the inode allocation btree.

> I shall reboot the server to the 2.6.32-28 kernel and perform the
> tests you requested.

No need to change kernels to run xfs_repair....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
