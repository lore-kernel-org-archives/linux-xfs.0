Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DMHBZq214453 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 17:17:11 -0500
Subject: Re: [PATCH] xfs: fix duplicate message output
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302615260-29450-1-git-send-email-david@fromorbit.com>
References: <1302615260-29450-1-git-send-email-david@fromorbit.com>
Date: Wed, 13 Apr 2011 17:19:39 -0500
Message-ID: <1302733179.2023.147.camel@doink>
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

On Tue, 2011-04-12 at 23:34 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 957935dc ("xfs: fix xfs_debug warnings" broke the logic in
> __xfs_printk(). Instead of only printing one of two possible output
> strings based on whether the fs has a name or not, it outputs both.
> Fix it to only output one message again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
