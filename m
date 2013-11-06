Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A73729E30
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 13:44:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F104F8F8081
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 11:44:22 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kWe7rymdAAbHQbWq for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 11:44:20 -0800 (PST)
Date: Thu, 7 Nov 2013 06:44:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest failures
Message-ID: <20131106194417.GF6188@dastard>
References: <20131106105451.GA31283@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106105451.GA31283@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 02:54:51AM -0800, Christoph Hellwig wrote:
> Unfortunately it seems our number of test failures is still through the
> roof, mostly due to the lack of updates in xfstests for other changes.
> 
> To start with the quick group in xfs I see:
> 
> generic/263
> 
> 	This seems to be an old issue we've largely been ignoring
> 	forever IIRC.  Maybe we finally need an xfail group?

It passes on different configurations. e.g. it passes on my single
CPU VM with a 4k block size, but fails with 1k block size on the
same VM. It fails witha 4k block size on a 4 CPU VM but passes with
a 512 byte block size...

It's a race condition somewhere, because adding debug makes it stop
failing.  So it doesn't always fail, and it doesn't fail reliably,
either, which makes all attempts i've made to find it go nowhere.

> xfs/033
> 
> 	xfs_Repair now aborts due to a verifier failure in
> 	xfs_trans_read_buf.  I think this is a real bug introduced
> 	in xfs_repair when new changes were brought in.  Output diff
> 	attached.

It's an unexpected abort from the libxfs code from verifier detected
corruption. There's a few of these, and I'm slowly working my way
through them (e.g. the last patch in the lastest series).

> xfs/187
> 
> 	Echoes "Need to update test 187 so that initial subtests do not
> 	use features2".  Why do we make this a fail rather than notrun?

The problem is that the 32 bit project ID bit is being set by
default now, resulting in the sb_features2 field having a value set
in it.

mkfs now needs to be explicit to use 16 bit project IDs, and a
modified form of this patch needs to be added as well:

http://oss.sgi.com/archives/xfs/2013-06/msg00219.html

I need to update that patch and resend it.  I get this when I run
with a current mkfs with CRCs enabled:

xfs/187 0s ... [not run] attr v1 not supported

> xfs/199
> 
> 	Has an unexpected XFS_SB_VERSION2_PROJID32BIT in sb_features.
> 	Given that we switched to projid32 by default this should have
> 	been updated.

Well, it needs the same mkfs treatment to specifically use 16 bit
project IDs so that it still works on old kernels. And it needs the
_requires_projid16bit() from the above patch, too.

> xfs/206
> 
> 	Does not expect the ftype flag.  Didn't we change a generic
> 	filter to take care of this?

xfs/206 has it's own mkfs filter:

http://oss.sgi.com/archives/xfs/2013-10/msg00777.html

I asked that the generic mkfs filters also be modified to support
ftype, and there hasn't been any followup since then.


> xfs/296
> 
> 	Checking for capability on restored file
> 	-RESTORE_DIR/DUMP_SUBDIR/testfile cap_setgid,cap_setuid+ep
> 	-# file: RESTORE_DIR/DUMP_SUBDIR/testfile
> 	-security.capability
> 
> 	Seems like theres some issues with file capabilities.

Long standing problem with xfs_restore and the way it restores
attributes. The test was written without a fix having been made.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
