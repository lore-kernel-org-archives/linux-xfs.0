Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TDbM68073952 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 08:37:22 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 101FB543A5F
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 06:37:21 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id lJyDndIlh2mp7JQB for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2011 06:37:21 -0700 (PDT)
Date: Mon, 29 Aug 2011 09:37:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] xfstests: don't print "do not support" warnings unless
	verbose is specified
Message-ID: <20110829133718.GD12187@thunk.org>
References: <1314467002-20297-1-git-send-email-tytso@mit.edu>
	<20110829053621.GH32358@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110829053621.GH32358@dastard>
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 29, 2011 at 03:36:21PM +1000, Dave Chinner wrote:
> On Sat, Aug 27, 2011 at 01:43:22PM -0400, Theodore Ts'o wrote:
> > Commit 630421f6d449 attempts to avoid printing the "fallocate not
> > supported" warning if the -q (quiet) option is specified on the
> > command-line.  Unfortunately tests 75 and 112 don't set the -q flag.
> > This causes test failures for file systems that don't support
> > fallocate or the punch hole functionality.
> > 
> > I considered changing tests 75 and 112 to pass -q to fsx, but that
> > would suppress other warning messages that could be legitimate test
> > failures, so I decided to add a new -v (vebose) flag.
> 
> Oh, so now we can have verbose quietness? Or is it quiet verbosity?
> That quickly leads to insanity.... :/
> 
> The quiet flag only suppresses output that is otherwise logged and
> output when a failure occurs. Hence setting the quiet won't cause
> any loss of functionality or error detection for these tests so you
> should just add the quiet flag to the tests.

OK, I'll resubmit a patch which changes the tests (i.e., 75 and 112)
to pass the -q flag to fsx.  I had thought _not_ passing -q was
deliberate, but reviewing the output, it does seem that none of the
!quiet messages are all that important.

					- Ted


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
