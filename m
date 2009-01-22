Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MNQjto121736 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 17:26:45 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F295118529F6
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 15:25:59 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	fsuAq02mnCiVo9ft for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2009 15:25:59 -0800 (PST)
Date: Fri, 23 Jan 2009 10:25:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
Message-ID: <20090122232544.GX10158@disturbed>
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>
	<20090121225453.GN10158@disturbed>
	<20090122030955.GT10158@disturbed>
	<alpine.DEB.2.00.0901221514190.4084@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901221514190.4084@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Owen Dunn <osd1000@cam.ac.uk>, xfs@oss.sgi.com

On Thu, Jan 22, 2009 at 03:15:59PM +0100, Christian Kujau wrote:
> On Thu, 22 Jan 2009, Dave Chinner wrote:
>> The only way to fix this is to move data around to free up space
>> below 1TB. Find your oldest data (i.e. that was around before even
>> the first grow) and move it off the filesystem (move, not copy).
>> Then if you copy it back on, the data blocks will end up above 1TB
>> and that should leave you with plenty of space for inodes below 1TB.
>
> With volumes bigger and bigger, should this procedure be mentioned in  
> the xfs_growfs manpage or in the XFS FAQ?

Sure: the FAQ is a wiki now so you can add it yourself. ;)

http://xfs.org/index.php/XFS_FAQ

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
