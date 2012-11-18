Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAINn1MM195119 for <xfs@oss.sgi.com>; Sun, 18 Nov 2012 17:49:01 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FB1rDD2HQhFa2hSe for <xfs@oss.sgi.com>;
	Sun, 18 Nov 2012 15:51:08 -0800 (PST)
Date: Mon, 19 Nov 2012 10:51:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121118235105.GT14281@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
	<CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
	<CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
	<CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Nov 18, 2012 at 04:29:22PM +0100, Torsten Kaiser wrote:
> On Sun, Nov 18, 2012 at 11:24 AM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
> > On Tue, Oct 30, 2012 at 9:37 PM, Torsten Kaiser
> > <just.for.lkml@googlemail.com> wrote:
> >> I will keep LOCKDEP enabled on that system, and if there really is
> >> another splat, I will report back here. But I rather doubt that this
> >> will be needed.
> >
> > After the patch, I did not see this problem again, but today I found
> > another LOCKDEP report that also looks XFS related.
> > I found it twice in the logs, and as both were slightly different, I
> > will attach both versions.
> 
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104353] 3.7.0-rc4 #1 Not tainted
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104355] inconsistent
> > {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104430]        CPU0
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104431]        ----
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104432]   lock(&(&ip->i_lock)->mr_lock);
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104433]   <Interrupt>
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104434]
> > lock(&(&ip->i_lock)->mr_lock);
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104435]
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104435]  *** DEADLOCK ***
> 
> Sorry! Copied the wrong report. Your fix only landed in -rc5, so my
> vanilla -rc4 did (also) report the old problem again.
> And I copy&pasted that report instead of the second appearance of the
> new problem.

Can you repost it with line wrapping turned off? The output simply
becomes unreadable when it wraps....

Yeah, I know I can put it back together, but I've got better things
to do with my time than stitch a couple of hundred lines of debug
back into a readable format....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
