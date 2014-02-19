Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 368587FEE
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 21:37:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF026AC004
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 19:36:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oPGEzeJMSmM5mbD2 for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 19:36:55 -0800 (PST)
Date: Wed, 19 Feb 2014 14:36:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] xfs: skip verification on initial "guess" superblock
	read
Message-ID: <20140219033631.GK13647@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392767549-25574-2-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 18, 2014 at 05:52:21PM -0600, Eric Sandeen wrote:
> When xfs_readsb() does the very first read of the superblock,
> it makes a guess at the length of the buffer, based on the
> sector size of the underlying storage.  This may or may
> not match the filesystem sector size in sb_sectsize, so
> we can't i.e. do a CRC check on it; it might be too short.
> 
> In fact, mounting a filesystem with sb_sectsize larger
> than the device sector size will cause a mount failure
> if CRCs are enabled, because we are checksumming a length
> which exceeds the buffer passed to it.
> 
> So always read twice; the first time we read with NULL
> buffer ops to skip verification; then set the proper
> read length, hook up the proper verifier, and give it
> another go.
> 
> Once we are sure that we've got the right buffer length,
> we can also use bp->b_length in the xfs_sb_read_verify,
> rather than the less-trusted on-disk sectorsize for
> secondary superblocks.  Before this we ran the risk of
> passing junk to the crc32c routines, which didn't always
> handle extreme values.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
