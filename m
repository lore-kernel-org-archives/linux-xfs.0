Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QLtqxA100893 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 16:55:52 -0500
Date: Mon, 26 Mar 2012 16:56:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Message-ID: <20120326215601.GY7762@sgi.com>
References: <1331804042-11580-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331804042-11580-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <elder@kernel.org>, stable@kernel.org, xfs@oss.sgi.com

On Thu, Mar 15, 2012 at 10:34:02AM +0100, Jan Kara wrote:
> When an IO error happens during inode deletion run from
> xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
> attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
> count with the fact that read of a buffer which was read a while ago can
> really fail which results in the oops on
>   agi = XFS_BUF_TO_AGI(agibp);
> 
> Fix the problem by cleaning up the buffer handling in
> xlog_recover_process_iunlinks() as suggested by Dave Chinner. We release buffer
> lock but keep buffer reference to AG buffer. That is enough for buffer to stay
> pinned in memory and we don't have to call xfs_read_agi() all the time.
> 
> CC: stable@kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me...
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
