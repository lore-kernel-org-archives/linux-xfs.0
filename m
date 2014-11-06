Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 931FD7F3F
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 15:49:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2036DAC008
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 13:49:54 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oMC8dEej3pXlGIom for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 13:49:52 -0800 (PST)
Date: Fri, 7 Nov 2014 08:49:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: scratch filesystem corruptions
Message-ID: <20141106214934.GF23575@dastard>
References: <545B541A.60800@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <545B541A.60800@oracle.com>
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
To: alexander.tsvetkov@oracle.com
Cc: xfs@oss.sgi.com

On Thu, Nov 06, 2014 at 01:57:30PM +0300, alexander.tsvetkov@oracle.com wrote:
> Hello,
> 
> I've noted that the enabling of scratch device post checks after
> xfstests commit
> "common: Check the file system consistency on SCRATCH_DEV" has
> started to show
> the scratch filesystem corruptions for the following tests runs:
> xfs/050,134,187,244,287.
> I have these corruptions reproduced with upstream linux kernel of
> version 3.15 and
> the latest xfsprogs/xfstests. Are these known issues?

# ./check xfs/050 xfs/134 xfs/187 xfs/244 xfs/287
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 test2 3.18.0-rc2-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/050 3s ... 4s
xfs/134 0s ... 0s
xfs/187 1s ... 1s
_check_xfs_filesystem: filesystem on /dev/vdb is inconsistent (c) (see /home/dave/src/xfstests-dev/results//xfs/187.full)
_check_xfs_filesystem: filesystem on /dev/vdb is inconsistent (r) (see /home/dave/src/xfstests-dev/results//xfs/187.full)
xfs/244 0s ... 1s
xfs/287 1s ... 0s
Ran: xfs/050 xfs/134 xfs/187 xfs/244 xfs/287
Passed all 5 tests

# cat  ~/results/xfs/187.full
....
_check_xfs_filesystem: filesystem on /dev/vdb is inconsistent
*** xfs_check output ***
sb_features2 (0x2) not same as sb_bad_features2 (0xa)
*** end xfs_check output
.....

The xfs/187 failure needs investigation - that's a bad_features2
mismatch, but it's been way down my list of priorities...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
