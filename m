Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NMTPim087581 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 16:29:25 -0600
Subject: Re: [PATCH] xfs_repair: inode flags check should use flags
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1298500151-27017-1-git-send-email-david@fromorbit.com>
References: <1298500151-27017-1-git-send-email-david@fromorbit.com>
Date: Wed, 23 Feb 2011 16:31:46 -0600
Message-ID: <1298500306.2453.28.camel@doink>
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

On Thu, 2011-02-24 at 09:29 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The RT bitmap inode format flag check should use the flag, not the
> bit definition. As a result, it is incorrectly detecting inodes with
> the prealloc flag set as has having an invalid bit set.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com> 

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
