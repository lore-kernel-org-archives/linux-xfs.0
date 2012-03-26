Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMSFpE104514 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:28:15 -0500
Date: Mon, 26 Mar 2012 17:28:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 6/8] xfs: Account log unmount transaction correctly
Message-ID: <20120326222824.GZ7762@sgi.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332393313-1955-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 04:15:11PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There have been a few reports of this warning appearing recently:
> 
> XFS (dm-4): xlog_space_left: head behind tail
>  tail_cycle = 129, tail_bytes = 20163072
>  GH   cycle = 129, GH   bytes = 20162880
> 
> The common cause appears to be lots of freeze and unfreeze cycles,
> and the output from the warnings indicates that we are leaking
> around 8 bytes of log space per freeze/unfreeze cycle.
> 
> When we freeze the filesystem, we write an unmount record and that
> uses xlog_write directly - a special type of transaction,
> effectively. What it doesn't do, however, is correctly acocunt for
> the log space it uses. The unmount record writes an 8 byte structure
> with a special magic number into the log, and the space this
> consumes is not accounted for in the log ticket tracking the
> operation. Hence we leak 8 bytes every unmount record that is
> written.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
