Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU4SSGp026171 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 22:28:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0147913FCACC
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:30:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	660i50ZvYdBUfqCn for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 20:30:09 -0800 (PST)
Date: Tue, 30 Nov 2010 15:30:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] lib: percpu counter add unless less than functionality
Message-ID: <20101130043001.GC3556@dastard>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	<1290991002-18680-2-git-send-email-david@fromorbit.com>
	<1291032530.32004.26.camel@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291032530.32004.26.camel@laptop>
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
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 01:08:50PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-29 at 11:36 +1100, Dave Chinner wrote:
> > +int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
> > +                                                       s64 threshold);
> 
> It might make sense to implement that as;
> 
>   __percpu_counter_add_unless_lt(struct percpu_counter *fbc,
> 				 s64 amount,
> 				 s64 threshold,
> 				 s32 batch);
> 
> That way its consistent with the __percpu_counter_add() implementation
> where you can also specify the batch value.

Good point. I'll fix that up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
