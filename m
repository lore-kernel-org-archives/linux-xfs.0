Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BF8A7F6F
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 20:21:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33E59AC005
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 18:21:03 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5AsJNBj3ZXa9gCst for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 18:20:58 -0800 (PST)
Date: Fri, 14 Feb 2014 13:20:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] metadump: sanitise write_buf/index return values
Message-ID: <20140214022053.GQ13997@dastard>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
	<1390472635-17225-2-git-send-email-david@fromorbit.com>
	<52FD1D38.1010006@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FD1D38.1010006@sgi.com>
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

On Thu, Feb 13, 2014 at 01:30:00PM -0600, Mark Tinguely wrote:
> On 01/23/14 04:23, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Write_buf/write_index use confusing boolean values for return,
> >meaning that it's hard to tell what the correct error return is
> >supposed to be.  Convert them to return zero on success or a
> >negative errno otherwise so that it's clear what the error case is.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Looks like this patch broke metadumps on some corrupted filesystems.
> This is a legacy filesystem that has zeroes overwriting the
> SB/AGF/AGI on AG 1/2/3:
> 
> 
> # xfs_metadump -wgo /dev/sda8 myfile.metadata
> xfs_agf_read_verify: XFS_CORRUPTION_ERROR
> xfs_metadump: cannot init perag data (117). Continuing anyway.
> Copied 64 of 64 inodes (0 of 4 AGs) xfs_agf_write_verify: XF
> S_CORRUPTION_ERROR
> write_buf: write verifer failed on bno 0x1100919/0x200
> (no output)

Where did it crash? Can you post the stack trace from gdb? Even
better, can you send a patch to fix the problem? ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
