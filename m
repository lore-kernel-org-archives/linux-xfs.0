Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 403E28070
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 17:32:09 -0600 (CST)
Date: Thu, 14 Feb 2013 17:32:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v4 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
Message-ID: <20130214233205.GL22182@sgi.com>
References: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 11, 2013 at 10:08:20AM -0500, Brian Foster wrote:
> Hi all,
> 
> Here is v4 of the spinlock recursion fix. The only update is to the comment in
> patch 1. These changes have been run through the reproducer over the weekend
> without a failure.
> 
> I've also run another xfstests run while including the following patch from Dave:
> 
> xfs: xfs_bmap_add_attrfork_local is too generic
> 
> ... due to seeing the same issue Lukas reproduced in test 013 (I saw it in 070 as
> well). That problem no longer occurs with this patch included, but I have hit
> an error in test 178 that didn't fire in my baseline run. It persists if I revert
> back to TOT, so I'm posting this set as is and I'll see if I can trace where that
> one came from...

Applied these two.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
