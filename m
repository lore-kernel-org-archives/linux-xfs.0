Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0E1A7F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 15:46:28 -0500 (CDT)
Date: Mon, 22 Jul 2013 15:46:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/30] mkfs: fix realtime device initialisation
Message-ID: <20130722204628.GE3111@sgi.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<1368789205-19969-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368789205-19969-2-git-send-email-david@fromorbit.com>
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

On Fri, May 17, 2013 at 09:12:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The method that libxfs uses for logging inodes is not followed by rtinit().
> It fails to join the realtime bitmap inode to the final extent free
> transactions, and so mkfs.xfs dies when trying to log changes to the bitmap
> inode. Fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied to the master branch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
