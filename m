Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCC2329DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:37:33 -0500 (CDT)
Message-ID: <51795BD1.8020003@sgi.com>
Date: Thu, 25 Apr 2013 11:37:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
References: <20130412145555.GF30622@dastard>
In-Reply-To: <20130412145555.GF30622@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/12/13 09:55, Dave Chinner wrote:
> Hi folks,
>
> I've attached a tarball containing the patch series that adds
> metadata CRC support to xfsprogs. It is still very much a work in
> progress, but is sufficient to start running xfstests on CRC enable
> filesystems.
>
> THere is much missing functionality, especially with respect to
> directly/attribute modifications. Only mkfs and xfs_repair have been
> updated to explicitly support CRC on directory/sttribute blocks,
> though all the other tools will stil run the result might be a
> little unpredictable.
>
> The patch series is as follows:
>
> Dave Chinner (26):
>        xfsprogs: sync code to current kernel code
>        xfsprogs: update libxfs to 3.9-rc1 + xfsdev
>        xfsprogs: add CRC32c infrastructure
>        xfsprogs: updata libxlog to current kernel code
>        libxfs: add crc format changes to generic btrees
>        xfsprogs: add crc format chagnes to ag headers
>        libxfs: change quota buffer formats
>        libxfs: add version 3 inode support
>        libxfs: add support for crc headers on remote symlinks
>        xfs: add CRC checks to block format directory blocks
>        xfs: add CRC checking to dir2 free blocks
>        xfs: add CRC checking to dir2 data blocks
>        xfs: add CRC checking to dir2 leaf blocks
>        xfs: shortform directory offsets change for dir3 format
>        xfs: add CRCs to dir2/da node blocks
>        xfs: add CRCs to attr leaf blocks
>        xfs: split remote attribute code out
>        xfs: add CRC protection to remote attributes
>        xfs: add buffer types to directory and attribute buffers
>        xfs: buffer type overruns blf_flags field
>        xfs: add CRC checks to the superblock
>        xfs: implement extended feature masks
>        xfsprogs: introduce CRC support into mkfs.xfs
>        xfsprogs: add crc format support to repair
>        xfsprogs: add crc format support to db
>        xfs_repair: update for dir/attr crc format changes.

The patch "logprint-agi-dump" needs a commit message and Signed-off-by.

The patch "debug" be removed (empty) from series and directory.

Thanks,

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
