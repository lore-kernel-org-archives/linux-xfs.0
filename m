Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 022657F54
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 01:11:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83A04AC002
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 23:11:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	p0cvdqPOAsURYxHi for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 23:11:40 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1Ukptj-0004dd-5r
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 16:11:39 +1000
Date: Fri, 7 Jun 2013 16:11:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/48] xfsprogs: CRC support
Message-ID: <20130607061139.GM29338@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:23AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is the latest update of the series of patches tht introduces
> CRC support into xfsprogs. Of note, for CRC enabled filesystems;
> 
> 	- write support for xfs-db is disabled
> 	- obfuscation for metadump is disabled
> 	- xfs_check does nothing ("always succeed") so that xfstests
> 	  can run without needing this
> 	- all structures shoul dbe supported for printing in xfs_db
> 	- xfs_repair should be able to fully validate the structure
> 	  of a CRC enabled filesystem.
> 	- xfs_repair still ignores CRC validation errors when
> 	  reading metadata
> 	- mkfs.xfs enforces limitations on the format of CRC enabled
> 	  filesystems (inode size, attr format, projid32bit, etc).
> 	- whenever a v5 superblock is parsed on read by any utility,
> 	  it outputs a wanring about it being an experimental
> 	  format.
> 
> Bug reports, patches, comments, reviews, etc all welcome.

I've just realised that I haven't ported any of the recent kernel
fixes across to this patch set, so there will be another few patches
needed for those as well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
