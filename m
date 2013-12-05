Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A09DA7F6D
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 16:20:22 -0600 (CST)
Date: Thu, 5 Dec 2013 16:20:19 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: growfs overruns AGFL buffer on V4 filesystems
Message-ID: <20131205222019.GN1935@sgi.com>
References: <1385008866-22256-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385008866-22256-1-git-send-email-david@fromorbit.com>
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

On Thu, Nov 21, 2013 at 03:41:06PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This loop in xfs_growfs_data_private() is incorrect for V4
> superblocks filesystems:
> 
> 		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
> 			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
> 
> For V4 filesystems, we don't have a agfl header structure, and so
> XFS_AGFL_SIZE() returns an entire sector's worth of entries, which
> we then index from an offset into the sector. Hence: buffer overrun.
> 
> This problem was introduced in 3.10 by commit 77c95bba ("xfs: add
> CRC checks to the AGFL") which changed the AGFL structure but failed
> to update the growfs code to handle the different structures.
> 
> Fix it by using the correct offset into the buffer for both V4 and
> V5 filesystems.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied this one.  I'll add it to an upcoming 3.13 pull request as well.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
