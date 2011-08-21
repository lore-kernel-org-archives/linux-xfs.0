Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7LNX9Za008868 for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 18:33:09 -0500
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DEF71387F5C
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 16:35:39 -0700 (PDT)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id qr5yzWasmrlMBx0y for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2011 16:35:39 -0700 (PDT)
Subject: Bug#553875: replacing libreadline5-dev build dependency with
	libreadline-dev
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.553875.B553875.131396936119760@bugs.debian.org>
Date: Mon, 22 Aug 2011 09:29:13 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20110821232913.GA3162@dastard>
References: <20110820220123.GA27252@volta.aurel32.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110820220123.GA27252@volta.aurel32.net>
Reply-To: Dave Chinner <david@fromorbit.com>, 553875@bugs.debian.org
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
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: 553875@bugs.debian.org, XFS Development Team <xfs@oss.sgi.com>

On Sun, Aug 21, 2011 at 12:01:23AM +0200, Aurelien Jarno wrote:
> Hi,
> 
> I have just done an NMU of xfsprogs to fix this longstanding issue. You
> will find below the diff of the NMU.

That was resolved in the upstream repository back in April:

commit 9de4c6df018f029d9266536a0ae961929a4a76ae
Author: Nathan Scott <nathans@aconex.com>
Date:   Thu Apr 28 23:15:30 2011 +0000

    xfsprogs: resolve Debian readline build issue
    
    Address the recently reported build issue with libreadline5/6, via
    the gplv2 route.  Since this appears to be a relatively recent pkg,
    I made its use conditional so the deb build continues to work for
    everyone not running a bleeding edge distro.  Works For Me (tm).
    
    This addresses Debian bug 553875: libreadline5-dev removal pending
    
    Signed-off-by: Nathan Scott <nathans@debian.org>
    Signed-off-by: Alex Elder <aelder@sgi.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
