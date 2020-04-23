Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A674DC54FD0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910032075A
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 04:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgDWES2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 00:18:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42836 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgDWES2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:18:28 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6EA503A33E7;
        Thu, 23 Apr 2020 14:18:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTJf-0000BT-5o; Thu, 23 Apr 2020 14:18:23 +1000
Date:   Thu, 23 Apr 2020 14:18:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 03/13] xfs: fallthru to buffer attach on error and
 simplify error handling
Message-ID: <20200423041823.GH27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-4-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=IXHGlfvkjkBMOR-GMAoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:19PM -0400, Brian Foster wrote:
> The inode flush code has several layers of error handling between
> the inode and cluster flushing code. If the inode flush fails before
> acquiring the backing buffer, the inode flush is aborted. If the
> cluster flush fails, the current inode flush is aborted and the
> cluster buffer is failed to handle the initial inode and any others
> that might have been attached before the error.
> 
> Since xfs_iflush() is the only caller of xfs_iflush_cluster(), the
> error handling between the two can be condensed in the top-level
> function. If we update xfs_iflush_int() to always fall through to
> the log item update and attach the item completion handler to the
> buffer, any errors that occur after the first call to
> xfs_iflush_int() can be handled with a buffer I/O failure.
> 
> Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
> and consolidate with the existing error handling. This also replaces
> the need to release the buffer because failing the buffer with
> XBF_ASYNC drops the current reference.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Needs a better subject line, because I had no idea what it meant
until I got to the last hunks in the patch.  Perhaps: "Simplify
inode flush error handling" would be a better summary of the
patch....

> @@ -3791,6 +3758,7 @@ xfs_iflush_int(
>  	struct xfs_inode_log_item *iip = ip->i_itemp;
>  	struct xfs_dinode	*dip;
>  	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;

There needs to be a comment added to this function to explain why we
always attached the inode to the buffer and update the flush state,
even on error. This:

> @@ -3914,10 +3885,10 @@ xfs_iflush_int(
>  				&iip->ili_item.li_lsn);
>  
>  	/*
> -	 * Attach the function xfs_iflush_done to the inode's
> -	 * buffer.  This will remove the inode from the AIL
> -	 * and unlock the inode's flush lock when the inode is
> -	 * completely written to disk.
> +	 * Attach the inode item callback to the buffer whether the flush
> +	 * succeeded or not. If not, the caller will shut down and fail I/O
> +	 * completion on the buffer to remove the inode from the AIL and release
> +	 * the flush lock.
>  	 */
>  	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);

isn't obviously associated with the "flush_out" label, and so the
structure of the function really isn't explained until you get to
the end of the function. And that's still easy to miss...

Other than that, the code looks OK.

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
