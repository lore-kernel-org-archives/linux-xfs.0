Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76E887F3F
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 11:18:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E439AC005
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 09:18:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gHoaLDDms5HWbUwt for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 09:18:16 -0700 (PDT)
Date: Wed, 17 Apr 2013 02:18:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr, sunit, and swidth
Message-ID: <20130416161841.GB13938@destitution>
References: <5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
	<515C3BF3.60601@binghamton.edu> <51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <516C649A.8010003@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Apr 15, 2013 at 04:35:38PM -0400, Dave Hall wrote:
> Stan,
> 
> I understand that this will be an ongoing problem.  It seems like
> all I could do at this point would be to ' manually defrag' my
> inodes the hard way by doing this 'copy' operation whenever things
> slow down.  (Either that or go get my PHD in file systems and try to
> come up with a better inode management algorithm.)

No need, I know how to fix it for good. Just add a new btree that
tracks free inodes, rather than having to scan the allocated inode
tree to find free inodes. Shouldn't actually be too difficult to do,
as it's a generic btree and the code to keep both btrees in sync is
a copy of the way the two freespace btrees are kept in sync....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
