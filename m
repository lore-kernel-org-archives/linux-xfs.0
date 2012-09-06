Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86Ff1xK106762 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 10:41:01 -0500
Date: Thu, 6 Sep 2012 10:41:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Oops from unlock in xfs_trans_ail_delete_bulk()
Message-ID: <20120906154158.GM3274@sgi.com>
References: <504891EB.2090202@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <504891EB.2090202@inktank.com>
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
To: Alex Elder <elder@inktank.com>
Cc: xfs@oss.sgi.com

Hi Alex,

On Thu, Sep 06, 2012 at 07:07:07AM -0500, Alex Elder wrote:
> I'm trying to capture something useful here because I need to move
> on with what I'm doing.  I was running xfstests using a kernel with
> this as the latest commit affecting fs/xfs:
> 
>     commit a0e881b7c189fa2bd76c024dbff91e79511c971d
>     Merge: eff0d13 dbc6e02
>     Author: Linus Torvalds <torvalds@linux-foundation.org>
>     Date:   Wed Aug 1 10:26:23 2012 -0700
> 
>     Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/vi
> 
> While running test 135 (it had started but its completion time had
> not yet been reported) I got an oops whose details I'll include below.
> 
> My console window isn't properly wrapping long lines so some info
> has been truncated below.  The fault address is at
> __ticket_spin_is_locked+0x10, called via xfs_trans_ail_delete_bulk().
> 
> I may be able to offer a little more information if someone is
> interested, and if I find this is repeatable I will certainly
> report it.

Thanks for the report.  This is one we've been struggling with for a little
while.

Mark has a patch in this thread that seems to work ok:
http://oss.sgi.com/archives/xfs/2012-08/msg00463.html

And Dave is also working toward a fix in this thread:
http://oss.sgi.com/archives/xfs/2012-08/threads.html#00493

I think that this will be resolved soon.  For now there are a few options that
seem to work around the problem, as described in the first thread.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
