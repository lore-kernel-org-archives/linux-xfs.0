Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 405EF7F3F
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 10:01:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C775BAC00B
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:01:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uiTjAj9iV76b7XoC for
	<xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:01:37 -0800 (PST)
Date: Fri, 14 Feb 2014 11:01:23 -0500
From: Dave Jones <davej@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214160123.GA28125@redhat.com>
References: <52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard> <20140214002427.GN13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140214002427.GN13997@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, Feb 14, 2014 at 11:24:27AM +1100, Dave Chinner wrote:
 
 > > I can fix this one easily - we already have a workqueue for doing
 > > async log pushes (will split the stack between xlog_cil_force_lsn
 > > and xlog_cil_push), but the reason we haven't used it for synchronous
 > > log forces is that screws up fsync performance on CFQ. We don't
 > > recommend CFQ with XFS anyway, so I think I'll make this change
 > > anyway.
 > 
 > Dave, the patch below should chop off the stack usage from
 > xfs_log_force_lsn() issuing IO by deferring it to the CIL workqueue.
 > Can you given this a run?

Looks like it's survived an overnight run..

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
