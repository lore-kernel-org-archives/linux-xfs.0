Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7T5px2C051125 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 00:52:00 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E22A1E7BC0B
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 22:51:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3Ai7TZnO6bA9UGYq for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2011 22:51:58 -0700 (PDT)
Date: Mon, 29 Aug 2011 15:36:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: don't print "do not support" warnings unless
	verbose is specified
Message-ID: <20110829053621.GH32358@dastard>
References: <1314467002-20297-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314467002-20297-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Aug 27, 2011 at 01:43:22PM -0400, Theodore Ts'o wrote:
> Commit 630421f6d449 attempts to avoid printing the "fallocate not
> supported" warning if the -q (quiet) option is specified on the
> command-line.  Unfortunately tests 75 and 112 don't set the -q flag.
> This causes test failures for file systems that don't support
> fallocate or the punch hole functionality.
> 
> I considered changing tests 75 and 112 to pass -q to fsx, but that
> would suppress other warning messages that could be legitimate test
> failures, so I decided to add a new -v (vebose) flag.

Oh, so now we can have verbose quietness? Or is it quiet verbosity?
That quickly leads to insanity.... :/

The quiet flag only suppresses output that is otherwise logged and
output when a failure occurs. Hence setting the quiet won't cause
any loss of functionality or error detection for these tests so you
should just add the quiet flag to the tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
