Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 346CE7F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 15:43:23 -0500 (CDT)
Date: Tue, 29 Oct 2013 15:43:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/15] xfs: validity check the directory block leaf
	entry count
Message-ID: <20131029204319.GG1935@sgi.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
	<1383045118-31107-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383045118-31107-14-git-send-email-david@fromorbit.com>
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

On Tue, Oct 29, 2013 at 10:11:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The directory block format verifier fails to check that the leaf
> entry count is in a valid range, and so if it is corrupted then it
> can lead to derefencing a pointer outside the block buffer. While we
> can't exactly validate the count without first walking the directory
> block, we can ensure the count lands in the valid area within the
> directory block and hence avoid out-of-block references.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
