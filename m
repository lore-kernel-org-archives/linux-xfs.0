Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E8477F56
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 14:22:04 -0500 (CDT)
Date: Wed, 30 Oct 2013 14:22:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/15] xfs: patches for 3.13
Message-ID: <20131030192200.GK1935@sgi.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

On Tue, Oct 29, 2013 at 10:11:43PM +1100, Dave Chinner wrote:
> This is a repost of the previous series with all the issues
> your review found fixed up. It also has a few new patches, the first
> of which is fixing the dir2/ftype offset issue you noticed.
> 
> The remaining new patches add a new validity check to the directory
> block checking code to avoid a reference outside the directory
> buffer, the patch to avoid stack overflows from the page cache which
> has been updated to remove the AOP_FLAG_NOFS usage in XFS, and then
> a final patch to clean up a bunch of new sparse warnings introduced
> by the recent round of code movement.

Applied 3-13 and 15.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
