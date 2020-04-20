Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076E2C54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 03:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7402074B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 03:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDTDI5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 23:08:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58516 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbgDTDI5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 23:08:57 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 174BD7EA6CE;
        Mon, 20 Apr 2020 13:08:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQMnk-0007yK-Cl; Mon, 20 Apr 2020 13:08:52 +1000
Date:   Mon, 20 Apr 2020 13:08:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: always attach iflush_done and simplify error
 handling
Message-ID: <20200420030852.GF9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-4-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=ruTNIax-VCUu2wHmjy0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:50AM -0400, Brian Foster wrote:
> The inode flush code has several layers of error handling between
> the inode and cluster flushing code. If the inode flush fails before
> acquiring the backing buffer, the inode flush is aborted. If the
> cluster flush fails, the current inode flush is aborted and the
> cluster buffer is failed to handle the initial inode and any others
> that might have been attached before the error.
> 
> Since xfs_iflush() is the only caller of xfs_iflush_cluser(), the

xfs_iflush_cluster()

> error handling between the two can be condensed in the top-level
> function. If we update xfs_iflush_int() to attach the item
> completion handler to the buffer first, any errors that occur after
> the first call to xfs_iflush_int() can be handled with a buffer
> I/O failure.
> 
> Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
> and consolidate with the existing error handling. This also replaces
> the need to release the buffer because failing the buffer with
> XBF_ASYNC drops the current reference.

Yeah, that makes sense. I've lifted the cluster flush error handling
into the callers, even though xfs_iflush() has gone away.

However...

> @@ -3798,6 +3765,13 @@ xfs_iflush_int(
>  	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  	ASSERT(iip != NULL && iip->ili_fields != 0);
>  
> +	/*
> +	 * Attach the inode item callback to the buffer. Whether the flush
> +	 * succeeds or not, buffer I/O completion processing is now required to
> +	 * remove the inode from the AIL and release the flush lock.
> +	 */
> +	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
> +
>  	/* set *dip = inode's place in the buffer */
>  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);

...I'm not convinced this is a valid thing to do at this point. The
inode item has not been set up yet with the correct state that is
associated with the flushing of the inode (e.g. lsn, last_flags,
etc) and so this kinda leaves a landmine in the item IO completion
processing in that failure cannot rely on any of the inode log item
state to make condition decisions.

While it's technically not wrong, it just makes me uneasy, as in
future the flush abort code will have to be careful about using
inode state in making decisions, and there's not comments in the
abort code to indicate that the state may be invalid...

/me has chased several subtle issues through this code recently...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
