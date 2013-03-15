Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id E36DB7FC8
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 02:52:25 -0500 (CDT)
Date: Fri, 15 Mar 2013 00:52:24 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 05/18] xfstests: Redo option parsing
Message-ID: <20130315075224.GC9378@caliban.engr.sgi.com>
References: <20130314130611.6A23953C7F62@polaris-admin.engr.sgi.com>
	<20130315051338.GB2559@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130315051338.GB2559@dastard>
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
Cc: xfs@oss.sgi.com, Phil White <pwhite@sgi.com>

On Fri, Mar 15, 2013 at 04:13:38PM +1100, Dave Chinner wrote:
> If all the check specific option parsing is moved to check (like my
> series did), then there isn't any code left in the common file.
> 
> All i see here is a reflection of SGI's obstinate refusal to remove
> bitrotted code. If we are removing all the users of this code except
> one, it is no longer shared code and, as such, abstractions for
> sharing shoul dbe removed.
> 
> If some new script comes along that uses the *same option parsing*
> as check, then we can consider it shared code again. However, i
> can't see this ever happening, so the code should be moved the check
> script where it can be more fully integrated and simplified.
> 
> So, really, all is see from trying to retain the common file like
> this is an obstinate refusal to let go of bitrotted code and to
> re-abstract and re-implement it properly....

Dave:

I'm not sure why my preface didn't get mailed along with my patch series, but
I'll resend it presently.  I noticed that one of my patches required moderator
approval.  Perhaps that was held up as well?

As I mentioned in the preface, I have other work in the pipeline which I
believe might make use of it.  That work has been blocked on the cleanup work
here which is why I chose to pick it up, rework it without the contentious
parts, and resubmit it.

This patch series has value in cleaning up the top level directory.  It
has value in moving xfstests towards something that can be used more
reasonably on other filesystems.

I'd like that stuff to go through.  It genuinely makes xfstests better.  I
don't see value in holding back the improvements that I think we'd all like
to see in the tests.

-Phil

P.S. With respect to etiquette, do my commit messages make more sense to you?
It struck me as intensely dishonest to pass this off as your work which is
why I elected to not include your SOB.  It struck me as equally dishonest to
say it's not at all your work which is why I credited you the way I did.  Is
that fair or would you have preferred it to be done differently?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
