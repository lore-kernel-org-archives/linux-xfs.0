Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C4kiYU140409 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 22:46:44 -0600
Subject: Re: [PATCH 12/12] xfs: kill support/debug.[ch]
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294792553-8378-13-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-13-git-send-email-david@fromorbit.com>
Date: Tue, 11 Jan 2011 22:48:53 -0600
Message-ID: <1294807733.3115.137.camel@doink>
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

On Wed, 2011-01-12 at 11:35 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The remaining functionality in debug.[ch] is effectively just assert
> handling, conditional debug definitions and hex dumping. The hex
> dumping and assert function can be moved into the new printk module,
> while the rest can be moved into top-level header files. This allows
> fs/xfs/support/debug.[ch] to be completely removed from the
> codebase.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile               |    1 -
>  fs/xfs/linux-2.6/xfs_linux.h  |   21 +++++++++++++++++++

You need to delete the #include <support/debug.h>
that remains in linux-2.6/xfs_linux.h too.

					-Alex



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
