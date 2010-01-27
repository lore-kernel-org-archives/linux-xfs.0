Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0RMuwfr234427 for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 16:56:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA2331C83850
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 14:58:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	dq1ZJ7ssthlARvCK for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2010 14:58:00 -0800 (PST)
Date: Thu, 28 Jan 2010 09:57:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: Automatic build dependency calculations
Message-ID: <20100127225737.GG15853@discord.disaster>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-3-git-send-email-david@fromorbit.com>
	<4B60932D.7060709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B60932D.7060709@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Jan 27, 2010 at 01:25:33PM -0600, Eric Sandeen wrote:
> Dave Chinner wrote:
> > Currently the xfstest builds do not have any automatic dependency
> > calculations. It relies on a separate make depend run to build or
> > update dependency information. It also relies on an external
> > makedepend binary. If that binary does not exist, the dependencies
> > do not get calculated.
> > 
> > To remove the dependency on makedepend, gcc can be used instead as
> > it has a command to generate dependency information. This patch
> > changes the dependency rule building to use gcc.
> > 
> > In case anyone uses an old (several years) gcc compiler or a
> > compiler that doesn't support gcc compatible dependency generation,
> > a new configure check is added to turn off dependency checking so
> > builds can still be done.
> > 
> > To use the dependencies automatically, we need to use a special
> > include makefile directive to include the build dependencies into
> > the current makefile.  Essentially once the dependencies are
> > calculated, they can be included into the makefile and make will
> > recalculate the build dependencies automatically based on that
> > information.
> > 
> > Hence we get a build that automatically calculates and keeps
> > dependencies up to date without dependence on any external tools.
> > 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> seems to be some fallout from this at least on my F10 box:
> 
> /usr/bin/makedepend: warning:  ignoring option -Wall
> /usr/bin/makedepend: error:  cannot open "no-strict-aliasing"
> 
> also this change:
> 
> -       preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
> -       fs_perms testx looptest locktest unwritten_mmap \
> +       ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
>         bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
> 
> ...
> 
> 
> +PREALLO_TARGETS = preallo_rw_pattern_reader
> 
> seems to have lost the build of preallo_rw_pattern_reader & writer.
> 
> Was that stray, or what were you going for there?

I thought I fixed all that up after hch's patches went in. Bugger.
I'll try to get a few minutes at lunchtime to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
