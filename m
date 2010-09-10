Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ALIRGK165160 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 16:18:27 -0500
Subject: Re: [PATCH 1/4] xfs: kill XBF_FS_MANAGED buffers
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1283958778-28610-2-git-send-email-david@fromorbit.com>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-2-git-send-email-david@fromorbit.com>
Date: Fri, 10 Sep 2010 16:17:45 -0500
Message-ID: <1284153465.2468.20.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Thu, 2010-09-09 at 01:12 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Filesystem level managed buffers are buffers that have their
> lifecycle controlled by the filesystem layer, not the buffer cache.
> We currently hash these buffers, which makes cleanup and hash
> walking somewhat troublesome. Convert the fs managed buffers to
> unhashed buffers obtained by via xfs_buf_get_noaddr(), and remove the
> XBF_FS_MANAGED special cases from the buffer cache.

I've looked this over and it looks good to me.
I agree with all of Christoph's comments from
the other day.  I'll look for your update.

					-Alex

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
