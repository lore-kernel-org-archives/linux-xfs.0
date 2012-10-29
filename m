Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TCpi8R165955 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 07:51:44 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XfDXRFinhFgLCzzt for <xfs@oss.sgi.com>;
	Mon, 29 Oct 2012 05:53:32 -0700 (PDT)
Date: Mon, 29 Oct 2012 23:53:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Daily crash in xfs_cmn_err
Message-ID: <20121029125330.GS29378@dastard>
References: <CADLDEKtkwaitKCsU21JnsesM70H5AwkEFQFcdmOHE0JU9Oa8nw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADLDEKtkwaitKCsU21JnsesM70H5AwkEFQFcdmOHE0JU9Oa8nw@mail.gmail.com>
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
To: Juerg Haefliger <juergh@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 11:55:15AM +0100, Juerg Haefliger wrote:
> Hi,
> 
> I have a node that used to crash every day at 6:25am in xfs_cmn_err
> (Null pointer dereference).

Stack trace, please.

> 1) I was under the impression that during the mounting of an XFS
> volume some sort of check/repair is performed.  How does that differ
> from running xfs_check and/or xfs_repair?

Journal recovery is performed at mount time, not a consistency
check.

http://en.wikipedia.org/wiki/Filesystem_journaling

> 2) Any ideas how the filesystem might have gotten into this state? I
> don't have the history of that node but it's possible that it crashed
> previously due to an unrelated problem. Could this have left the
> filesystem is this state?

<shrug>

How long is a piece of string?

> 3) What exactly does the ouput of the xfs_check mean? How serious is
> it? Are those warning or errors? Will some of them get cleanup up
> during the mounting of the filesystem?

xfs_check is deprecated.  The output of xfs_repair indicates
cross-linked extent indexes. Will only get properly detected and
fixed by xfs_repair. And "fixed" may mean corrupt files are removed
from the filesystem - repair does nto guarantee that your data is
preserved or consistent after it runs, just that the filesystem is
consistent and error free.

> 4) We have a whole bunch of production nodes running the same kernel.
> I'm more than a little concerned that we might have a ticking timebomb
> with some filesystems being in a state that might trigger a crash
> eventually. Is there any way to perform a live check on a mounted
> filesystem so that I can get an idea of how big of a problem we have
> (if any)?

Read the xfs_repair man page?

-n     No modify mode. Specifies that xfs_repair should not
       modify the filesystem but should only scan the  filesystem
       and indicate what repairs would have been made.
.....

-d     Repair dangerously. Allow xfs_repair to repair an XFS
       filesystem mounted read only. This is typically done on a
       root fileystem from single user mode, immediately followed by
       a reboot.

So, remount read only, run xfs_repair -d -n will check the
filesystem as best as can be done online. If there are any problems,
then you can repair them and immediately reboot.

> i don't claim to know exactly what I'm doing but I picked a
> node, froze the filesystem and then ran a modified xfs_check (which
> bypasses the is_mounted check and ignores non-committed metadata) and
> it did report some issues. At this point I believe those are false
> positive. Do you have any suggestions short of rebooting the nodes and
> running xfs_check on the unmounted filesystem?

Don't bother with xfs_check. xfs_repair will detect all the same
errors (and more) and can fix them at the same time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
