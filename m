Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MEGsrb080089 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 08:16:55 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1DCEABC1A
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 06:16:09 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id iPWxJaHk4HBxYWyr for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 06:16:09 -0800 (PST)
Date: Thu, 22 Jan 2009 15:15:59 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
In-Reply-To: <20090122030955.GT10158@disturbed>
Message-ID: <alpine.DEB.2.00.0901221514190.4084@bogon.housecafe.de>
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>
	<20090121225453.GN10158@disturbed>
	<20090122030955.GT10158@disturbed>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Owen Dunn <osd1000@cam.ac.uk>, xfs@oss.sgi.com

On Thu, 22 Jan 2009, Dave Chinner wrote:
> The only way to fix this is to move data around to free up space
> below 1TB. Find your oldest data (i.e. that was around before even
> the first grow) and move it off the filesystem (move, not copy).
> Then if you copy it back on, the data blocks will end up above 1TB
> and that should leave you with plenty of space for inodes below 1TB.

With volumes bigger and bigger, should this procedure be mentioned in 
the xfs_growfs manpage or in the XFS FAQ?

Christian.
-- 
BOFH excuse #53:

Little hamster in running wheel had coronary; waiting for replacement to be Fedexed from Wyoming

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
