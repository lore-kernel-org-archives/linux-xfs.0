Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0RJOeYB209746 for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 13:24:40 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5579193E87
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 11:25:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kHDsHZzJdpwXWkjC for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2010 11:25:44 -0800 (PST)
Message-ID: <4B60932D.7060709@sandeen.net>
Date: Wed, 27 Jan 2010 13:25:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: Automatic build dependency calculations
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1264053773-6054-3-git-send-email-david@fromorbit.com>
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

Dave Chinner wrote:
> Currently the xfstest builds do not have any automatic dependency
> calculations. It relies on a separate make depend run to build or
> update dependency information. It also relies on an external
> makedepend binary. If that binary does not exist, the dependencies
> do not get calculated.
> 
> To remove the dependency on makedepend, gcc can be used instead as
> it has a command to generate dependency information. This patch
> changes the dependency rule building to use gcc.
> 
> In case anyone uses an old (several years) gcc compiler or a
> compiler that doesn't support gcc compatible dependency generation,
> a new configure check is added to turn off dependency checking so
> builds can still be done.
> 
> To use the dependencies automatically, we need to use a special
> include makefile directive to include the build dependencies into
> the current makefile.  Essentially once the dependencies are
> calculated, they can be included into the makefile and make will
> recalculate the build dependencies automatically based on that
> information.
> 
> Hence we get a build that automatically calculates and keeps
> dependencies up to date without dependence on any external tools.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

seems to be some fallout from this at least on my F10 box:

/usr/bin/makedepend: warning:  ignoring option -Wall
/usr/bin/makedepend: error:  cannot open "no-strict-aliasing"

also this change:

-       preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
-       fs_perms testx looptest locktest unwritten_mmap \
+       ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
        bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \

...


+PREALLO_TARGETS = preallo_rw_pattern_reader

seems to have lost the build of preallo_rw_pattern_reader & writer.

Was that stray, or what were you going for there?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
