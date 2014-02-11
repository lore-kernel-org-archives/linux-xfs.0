Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47F777F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 16:27:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37711304067
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:27:31 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lyLNZU0KPb3ZIFlJ for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 14:27:19 -0800 (PST)
Date: Wed, 12 Feb 2014 09:27:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: add xfs_verifier_error()
Message-ID: <20140211222714.GN13647@dastard>
References: <52F99426.3010409@sandeen.net> <52F9957A.4050301@sandeen.net>
	<52FA7FEE.7040307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FA7FEE.7040307@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 11, 2014 at 01:54:22PM -0600, Eric Sandeen wrote:
> On 2/10/14, 9:14 PM, Eric Sandeen wrote:
> > We want to distinguish between corruption and CRC errors.
> > In addition, the full stack trace on verifier errors
> > seems less than helpful; it looks more like an oops than
> > corruption.
> > 
> > Create a new function to specifically alert the user to
> > verifier errors, which can differentiate between
> > EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
> > unless the xfs error level is turned up high.
> > 
> > Define a new error message (EFSBADCRC) to clearly identify
> > CRC errors.  (Defined to EILSEQ, bad byte sequence)
> 
> So, this now looks like:
> 
> [259116.148375] XFS (loop0): Metadata corruption detected at xfs_sb_read_verify+0x118/0x150 [xfs], block 0x0. Unmount and run xfs_repair
> [259116.160345] ffff88022bab0000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 00 00  XFSB............
> [259116.169109] ffff88022bab0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [259116.177872] ffff88022bab0020: 73 df 07 64 a6 50 4d 5b 8d eb 2c 06 a1 ed e3 5c  s..d.PM[..,....\
> [259116.186638] ffff88022bab0030: 00 00 00 00 00 02 00 04 00 00 00 00 00 00 00 80  ................
> [259116.195413] XFS (loop0): SB validate failed with error 117.
> 
> when something fails.
> 
> We should probably put a period after "xfs_repair" and also print
> one more line about what the hex spew means - "XFS (loop0): first
> 64 bytes of corrupted metadata buffer:" or something similar.

Yeah, I think we need to split that long line, too. i.e:

XFS (loop0): Metadata corruption detected at xfs_sb_read_verify+0x118/0x150 [xfs], block 0x0.
XFS (loop0): Please unmount and run xfs_repair.
XFS (loop0): First 64 bytes of corrupted metadata buffer contains:
ffff88022bab0000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 00 00  XFSB............
ffff88022bab0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff88022bab0020: 73 df 07 64 a6 50 4d 5b 8d eb 2c 06 a1 ed e3 5c  s..d.PM[..,....\
ffff88022bab0030: 00 00 00 00 00 02 00 04 00 00 00 00 00 00 00 80  ................
XFS (loop0): SB validate failed with error 117.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
