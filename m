Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67KY1BF194086 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 15:34:01 -0500
Subject: Re: [PATCH 3/5] xfs: remove confusing ail cursor wrapper
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309757260-5484-4-git-send-email-david@fromorbit.com>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-4-git-send-email-david@fromorbit.com>
Date: Thu, 7 Jul 2011 15:33:56 -0500
Message-ID: <1310070836.1980.66.camel@doink>
MIME-Version: 1.0
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

On Mon, 2011-07-04 at 15:27 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans_ail_cursor_set() doesn't set the cursor to the current log
> item, it sets it to the next item. There is already a function for
> doing this - xfs_trans_ail_cursor_next() - and the _set function is
> simply a two line wrapper.  Remove it and open code the setting of
> the cursor in the two locations that call it to remove the
> confusion.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Good idea.  I also appreciate the comment improvement;
the "returns NULL" is something I wanted to suggest
while looking at the previous patch, but that section
of the file wasn't in that patch.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
