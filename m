Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TLV4gW185151 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 16:31:04 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Q06XLDDuyuP4vt0A for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 14:31:02 -0700 (PDT)
Date: Fri, 30 Mar 2012 08:31:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors
Message-ID: <20120329213100.GA18323@dastard>
References: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
	<20120329064054.GP5091@dastard>
	<002501cd0dbe$24be21c0$6e3a6540$@tx.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <002501cd0dbe$24be21c0$6e3a6540$@tx.rr.com>
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
To: Kirk Anderson <kirkande@tx.rr.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 29, 2012 at 10:10:55AM -0500, Kirk Anderson wrote:
> Thank you for the reply.  I apologize as I do not know how to reply back in
> the thread.  I ran the xfs_repair command below:

Just reply to all - the list sets up the reply-to headers
automatically for this. I've re-cc'd the list.

> xfs_repair -n /dev/md2
> 
> The output is 21,078 lines.  The first few are below.
> 
> I am just trying to make sure I do not dig this hole any deeper than it has
> to be.  Is there anything of this that you would need to look at or do I
> just run the xfs_repair without any flags?
> 
> I appreciate your help.   Thanks, Kirk
> 
> No modify flag set, skipping phase 5
> ..
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> bad magic # 0xb5524a00 for agf 0
> bad version # -447948225 for agf 0
> bad sequence # -920712132 for agf 0

Oh, that's really bad. Something has gone disasterously wrong with
your RAID device. The first thing you ned to check is whether it got
put back together in the correct order - it may be that the disk
that is supposed to be the first in the array isn't anymore...

Have a look at the first sector of each device in the RAID array -
the one that should be first needs to have an XFS superblock in that
sector. The easy way to check that is to run:

$ sudo dd if=/dev/vda bs=512 count=1 2> /dev/null | hexdump -C
00000000  58 46 53 42 00 00 10 00  00 00 00 00 00 10 00 00  |XFSB............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  27 04 1a bb 8d cc 47 ea  b4 18 be 11 84 43 e2 56  |'.....G......C.V|
00000030  00 00 00 00 00 08 00 04  00 00 00 00 00 00 00 80  |................|
00000040  00 00 00 00 00 00 00 81  00 00 00 00 00 00 00 82  |................|
00000050  00 00 00 01 00 04 00 00  00 00 00 04 00 00 00 00  |................|
00000060  00 00 0a 00 b4 b4 02 00  01 00 00 10 00 00 00 00  |................|
00000070  00 00 00 00 00 00 00 00  0c 09 08 04 12 00 00 19  |................|
00000080  00 00 00 00 00 00 2d 00  00 00 00 00 00 00 00 83  |......-.........|
00000090  00 00 00 00 00 0c 4e e8  00 00 00 00 00 00 00 00  |......N.........|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000000b0  00 00 00 00 00 00 00 02  00 00 00 00 00 00 00 00  |................|
000000c0  00 00 00 00 00 00 00 01  00 00 00 0a 00 00 00 0a  |................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

And the superblock has that "XFSB" magic number as the first 4 bytes
of the output.  Similarly, the second sector should contain an AGF
(magic number XAGF), the third sector an AGI (magic XAGI).

If the first device in the array does not have a XFSB at sector
zero, then the device definitely has been Sewn Back Together Wrong.

If that isn't the problem, then I think it is likely you are going
to lose a lot of data, and you should look disaster recovery tools
like xfs_irecover to extract the intact data rather than trying to
repair it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
