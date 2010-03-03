Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o23MsmJd116610 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 16:54:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E3B92163CE
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 14:56:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	tlDdkEAZnvJBPOeZ for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 14:56:15 -0800 (PST)
Date: Thu, 4 Mar 2010 09:56:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfsqa: fix size specification for scratch mkfs
Message-ID: <20100303225612.GB14317@discord.disaster>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
	<1267597162-12092-3-git-send-email-david@fromorbit.com>
	<20100303125809.GB26672@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100303125809.GB26672@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Mar 03, 2010 at 07:58:09AM -0500, Christoph Hellwig wrote:
> On Wed, Mar 03, 2010 at 05:19:21PM +1100, Dave Chinner wrote:
> > When making a specifically sized scratch filesystem, we need to
> > calculate the size rather than assigning the caclculation expression
> > to a variable and passing that into the _scratch_mkfs_sized
> > function. Currently sized filesystems are failing to be made and the
> > code is falling back to full sized filesystems so we are not testing
> > enospc issues correctly.
> 
> This seems rather fragile.  Maybe instead of calculating the bignums
> which I suspect are the problem could we pass symbolic values like 104M
> in and parse them in _scratch_mkfs_sized?

The problem was that "mkfs.xfs -d size=104*1024*1024 ..." fails
because $fssize was not a numeric value.

There's no problem with 64 bit numbers with expr:

$ expr 5 \* 1024 \* 1024 \* 1024 \* 1024
5497558138880

So specifying large sizes by a byte count like this is not an
issue. Lots of other tests use expr in this way.

If we change the calculations in _scratch_mkfs_sized() to use expr
then there's no 32 bit overflow issues, either. This seems like a
simpler way to go to introduce the complexity of symbolic values
and parsing, esp. as we'd still have to handle 64 bit values
correctly...

The updated patch below uses expr in _scratch_mkfs_sized as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfsqa: fix size specification for scratch mkfs

When making a specifically sized scratch filesystem, we need to
calculate the size rather than assigning the caclculation expression
to a variable and passing that into the _scratch_mkfs_sized
function. Currently sized filesystems are failing to be made and the
code is falling back to full sized filesystems so we are not testing
enospc issues correctly.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 077       |    2 +-
 204       |    2 +-
 common.rc |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/077 b/077
index 72f1b2a..4e12163 100755
--- a/077
+++ b/077
@@ -62,7 +62,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-let SIZE=50*1024*1024
+SIZE=`expr 50 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE                   >>$seq.full 2>&1 \
 	|| _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
diff --git a/204 b/204
index 14ebcdc..8b94f60 100755
--- a/204
+++ b/204
@@ -40,7 +40,7 @@ _supported_os Linux
 
 _require_scratch
 
-SIZE=104*1024*1024
+SIZE=`expr 104 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE  &> /dev/null
 _scratch_mount
 
diff --git a/common.rc b/common.rc
index ca2cd2c..d71e0a2 100644
--- a/common.rc
+++ b/common.rc
@@ -320,7 +320,7 @@ _scratch_mkfs_sized()
     fssize=$1
     blocksize=$2
     [ -z "$blocksize" ] && blocksize=4096
-    let blocks=$fssize/$blocksize
+    blocks=`expr $fssize / $blocksize`
 
     case $FSTYP in
     xfs)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
