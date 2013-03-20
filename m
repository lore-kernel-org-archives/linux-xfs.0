Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 790C57CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 16:15:00 -0500 (CDT)
Date: Wed, 20 Mar 2013 16:14:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/21] xfs: add CRC checks to remote symlinks
Message-ID: <20130320211457.GM22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-11-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Tue, Mar 12, 2013 at 11:30:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a header to the remote symlink block, containing location and
> owner information, as well as CRCs and LSN fields. This requires
> verifiers to be added to the remote symlink buffers for CRC enabled
> filesystems.
> 
> This also fixes a bug reading multiple block symlinks, where the second block
> overwrites the first block when copying out the link name.

Huh.  This commit message doesn't say anything about moving symlink related
code from xfs_vnodeops.c to a new file xfs_symlink.c.  If you're going to cut
and paste code en masse from one file to the next, that's perfectly fine with
me.  But please do that in a separate patch than the code you're adding for a
feature so that I can focus on the new code in the review.

Looks like you need to add a GPL notice.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
