Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 055917F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 16:41:58 -0500 (CDT)
Date: Tue, 6 Aug 2013 16:41:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/48] xfsprogs: CRC support
Message-ID: <20130806214154.GM3111@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

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

Pulled in 1-48 of the first series and 1-12 of the second.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
