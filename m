Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BD967F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 01:41:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 172158F8039
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 23:41:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NwpD52FX1pZSzsON for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 23:41:38 -0700 (PDT)
Date: Tue, 16 Jul 2013 16:41:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716064104.GF11674@dastard>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard>
	<20130716061601.GM4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130716061601.GM4165@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, Jul 16, 2013 at 07:16:02AM +0100, Al Viro wrote:
> On Tue, Jul 16, 2013 at 04:03:51PM +1000, Dave Chinner wrote:
> 
> > I posted patches to fix this i_mutex/i_iolock inversion a couple of
> > years ago (july 2011):
> > 
> > https://lkml.org/lkml/2011/7/18/4
> > 
> > And V2 was posted here and reviewed (aug 2011):
> > 
> > http://xfs.9218.n7.nabble.com/PATCH-0-2-splice-i-mutex-vs-splice-write-deadlock-V2-tt4072.html#none
> 
> Unless I'm misreading the patch, you end up doing file_remove_suid()
> without holding i_mutex at all...

We've been calling file_remove_suid() since at least 2010 without
i_mutex held through the direct IO write path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
