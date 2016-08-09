Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 215E57CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 16:26:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6446AC001
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 14:26:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZslnHApBFRrAFalI for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2016 14:26:11 -0700 (PDT)
Date: Wed, 10 Aug 2016 07:26:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Advice needed with file system corruption
Message-ID: <20160809212607.GH19025@dastard>
References: <5787852A.7030900@st-andrews.ac.uk>
	<20160808161132.1d76eb5c@harpe.intellique.com>
	<1470670691.8958.11.camel@filmlight.ltd.uk>
	<20160808174427.24d8272c@harpe.intellique.com>
	<592673683.10446004.1470715375850.JavaMail.yahoo@mail.yahoo.com>
	<7faf941c-2188-589d-b624-9fedb22dee40@telefonica.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7faf941c-2188-589d-b624-9fedb22dee40@telefonica.net>
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
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: XFS mail list <xfs@oss.sgi.com>

On Tue, Aug 09, 2016 at 02:40:26PM +0200, Carlos E. R. wrote:
> On 2016-08-09 06:02, Gim Leong Chin wrote:
> 
> > Drives connected to RAID controllers with battery backed cache should
> > have their caches "disabled" (they are really set to write through mode
> > instead).  By the way, I found out in lab testing that 7200 RPM SATA
> > drives suffer a big performance loss when doing sequential writes in
> > cache write through mode.<http://oss.sgi.com/mailman/listinfo/xfs>
> 
> If you disable the disk internal cache, as a consequence you also
> disable the disk internal write optimizations. It has to be much slower
> at writing. It seems to me obvious.

This is why decent HW RAID controllers have a large non volatile
write cache - the caching is done in the controller where it is safe
from power loss, not in the drive where it is unsafe. Write
optimisations happen at the RAID controller level, not at the
individual drive level.

As for 10/15krpm SAS drive performance, they generally are only
slower in microbenchmark situations (e.g. sequential single sector
writes) when the write cache is disabled. These sorts of loads
aren't typically seen in the real world, so for most people there is
little difference in performance on high end enterprise SAS drives
when changing the cache mode....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
