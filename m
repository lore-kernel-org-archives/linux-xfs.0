Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLK2A8165769 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:02 -0600
Subject: Re: [PATCH 1/8] xfs: fix log ticket leak on forced shutdown.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-2-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-2-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:22:22 -0600
Message-ID: <1296076942.1980.930.camel@doink>
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

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The kmemleak detector shows this after test 139:
> 
> unreferenced object 0xffff880079b88bb0 (size 264):

. . .

>     [<ffffffff81123117>] generic_writepages+0x27/0x30
>     [<ffffffff814aba5d>] xfs_vm_writepages+0x5d/0x80
> 
> By inspection, the leak occurs when xlog_write() returns and error
> and we jump to the abort path without dropping the reference on the
> active ticket.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
