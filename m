Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6649D29DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 16:39:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44EF3304070
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 14:39:37 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	W7VFYiezLlE4gTex for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 14:39:35 -0700 (PDT)
Date: Fri, 26 Apr 2013 07:39:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
Message-ID: <20130425213933.GP30622@dastard>
References: <20130412145555.GF30622@dastard>
 <51795BD1.8020003@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51795BD1.8020003@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 25, 2013 at 11:37:37AM -0500, Mark Tinguely wrote:
> On 04/12/13 09:55, Dave Chinner wrote:
> >Hi folks,
> >
> >I've attached a tarball containing the patch series that adds
> >metadata CRC support to xfsprogs. It is still very much a work in
> >progress, but is sufficient to start running xfstests on CRC enable
> >filesystems.
> >
> >THere is much missing functionality, especially with respect to
> >directly/attribute modifications. Only mkfs and xfs_repair have been
> >updated to explicitly support CRC on directory/sttribute blocks,
> >though all the other tools will stil run the result might be a
> >little unpredictable.
> >
> >The patch series is as follows:
> >
> >Dave Chinner (26):
> >       xfsprogs: sync code to current kernel code
> >       xfsprogs: update libxfs to 3.9-rc1 + xfsdev
> >       xfsprogs: add CRC32c infrastructure
> >       xfsprogs: updata libxlog to current kernel code
> >       libxfs: add crc format changes to generic btrees
> >       xfsprogs: add crc format chagnes to ag headers
> >       libxfs: change quota buffer formats
> >       libxfs: add version 3 inode support
> >       libxfs: add support for crc headers on remote symlinks
> >       xfs: add CRC checks to block format directory blocks
> >       xfs: add CRC checking to dir2 free blocks
> >       xfs: add CRC checking to dir2 data blocks
> >       xfs: add CRC checking to dir2 leaf blocks
> >       xfs: shortform directory offsets change for dir3 format
> >       xfs: add CRCs to dir2/da node blocks
> >       xfs: add CRCs to attr leaf blocks
> >       xfs: split remote attribute code out
> >       xfs: add CRC protection to remote attributes
> >       xfs: add buffer types to directory and attribute buffers
> >       xfs: buffer type overruns blf_flags field
> >       xfs: add CRC checks to the superblock
> >       xfs: implement extended feature masks
> >       xfsprogs: introduce CRC support into mkfs.xfs
> >       xfsprogs: add crc format support to repair
> >       xfsprogs: add crc format support to db
> >       xfs_repair: update for dir/attr crc format changes.
> 
> The patch "logprint-agi-dump" needs a commit message and Signed-off-by.
> 
> The patch "debug" be removed (empty) from series and directory.

Looks like I didn't clear out a couple of debug-only patches from
the tarball properly. I'll fix that for the next release...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
