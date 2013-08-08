Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B5DE7F51
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:06:05 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:06:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 0/14] xfsprogs: various issues from review
Message-ID: <20130808210600.GN3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130806214154.GM3111@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

Hey,

On Tue, Aug 06, 2013 at 04:41:54PM -0500, Ben Myers wrote:
> On Fri, Jun 07, 2013 at 10:25:23AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is the latest update of the series of patches tht introduces
> > CRC support into xfsprogs. Of note, for CRC enabled filesystems;
> > 
> > 	- write support for xfs-db is disabled
> > 	- obfuscation for metadump is disabled
> > 	- xfs_check does nothing ("always succeed") so that xfstests
> > 	  can run without needing this
> > 	- all structures shoul dbe supported for printing in xfs_db
> > 	- xfs_repair should be able to fully validate the structure
> > 	  of a CRC enabled filesystem.
> > 	- xfs_repair still ignores CRC validation errors when
> > 	  reading metadata
> > 	- mkfs.xfs enforces limitations on the format of CRC enabled
> > 	  filesystems (inode size, attr format, projid32bit, etc).
> > 	- whenever a v5 superblock is parsed on read by any utility,
> > 	  it outputs a wanring about it being an experimental
> > 	  format.
> > 
> > Bug reports, patches, comments, reviews, etc all welcome.
> 
> Pulled in 1-48 of the first series and 1-12 of the second.

Here is a patch series that addresses some of my outstanding concerns from
review.  Some may be already fixed in the 2nd series, I'm not sure.  Eric also
mentioned that he put the updated branch through coverity and found some
defects.  There may be some overlap there too.

Some of these are just reminders for myself to make sure certain items are
addressed eventually.  Sorry for the noise.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
