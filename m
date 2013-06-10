Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69CE37F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:57:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 448A7304043
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 16:57:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	e6vXXWuevA7j0aN4 for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 16:57:04 -0700 (PDT)
Date: Tue, 11 Jun 2013 09:56:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/48] xfsprogs: CRC support
Message-ID: <20130610235641.GH29376@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130607061139.GM29338@dastard> <20130607210447.GP20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130607210447.GP20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 04:04:47PM -0500, Ben Myers wrote:
> Hey,
> 
> On Fri, Jun 07, 2013 at 04:11:39PM +1000, Dave Chinner wrote:
> > On Fri, Jun 07, 2013 at 10:25:23AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This is the latest update of the series of patches tht introduces
> > > CRC support into xfsprogs. Of note, for CRC enabled filesystems;
> > > 
> > > 	- write support for xfs-db is disabled
> > > 	- obfuscation for metadump is disabled
> > > 	- xfs_check does nothing ("always succeed") so that xfstests
> > > 	  can run without needing this
> > > 	- all structures shoul dbe supported for printing in xfs_db
> > > 	- xfs_repair should be able to fully validate the structure
> > > 	  of a CRC enabled filesystem.
> > > 	- xfs_repair still ignores CRC validation errors when
> > > 	  reading metadata
> > > 	- mkfs.xfs enforces limitations on the format of CRC enabled
> > > 	  filesystems (inode size, attr format, projid32bit, etc).
> > > 	- whenever a v5 superblock is parsed on read by any utility,
> > > 	  it outputs a wanring about it being an experimental
> > > 	  format.
> > > 
> > > Bug reports, patches, comments, reviews, etc all welcome.
> > 
> > I've just realised that I haven't ported any of the recent kernel
> > fixes across to this patch set, so there will be another few patches
> > needed for those as well...
> 
> These two series are applied to the crc-dev branch at
> git://oss.sgi.com/xfs/cmds/xfsprogs.git 

Hi Ben,

Thanks for doing this. This patch, however:

[PATCH 10/12] xfs: fully initialise temp leaf in xfs_attr3_leaf_compact

is missing from the branch. Can you commit it, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
