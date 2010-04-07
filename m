Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o37E3hAi194730 for <xfs@oss.sgi.com>; Wed, 7 Apr 2010 09:03:43 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C9B5153A11A
	for <xfs@oss.sgi.com>; Wed,  7 Apr 2010 07:05:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Zh95LfUSptNkfDEb for <xfs@oss.sgi.com>;
	Wed, 07 Apr 2010 07:05:26 -0700 (PDT)
Date: Thu, 8 Apr 2010 00:05:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks,
	heavy write load, 8k stack, x86-64
Message-ID: <20100407140523.GJ11036@dastard>
References: <4BBC6719.7080304@humyo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BBC6719.7080304@humyo.com>
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
To: John Berthels <john@humyo.com>
Cc: Nick Gregory <nick@humyo.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Rob Sanderson <rob@humyo.com>

On Wed, Apr 07, 2010 at 12:06:01PM +0100, John Berthels wrote:
> Hi folks,
> 
> [I'm afraid that I'm not subscribed to the list, please cc: me on
> any reply].
> 
> Problem: kernel.org 2.6.33.2 x86_64 kernel locks up under
> write-heavy I/O load. It is "fixed" by changing THREAD_ORDER to 2.
> 
> Is this an OK long-term solution/should this be needed? As far as I
> can see from searching, there is an expectation that xfs would
> generally work with 8k stacks (THREAD_ORDER 1). We don't have xfs
> stacked over LVM or anything else.

I'm not seeing stacks deeper than about 5.6k on XFS under heavy write
loads. That's nowhere near blowing an 8k stack, so there must be
something special about what you are doing. Can you post the stack
traces that are being generated for the deepest stack generated -
/sys/kernel/debug/tracing/stack_trace should contain it.

> Background: We have a cluster of systems with roughly the following
> specs (2GB RAM, 24 (twenty-four) 1TB+ disks, Intel Core2 Duo @
> 2.2GHz).
> 
> Following a the addition of three new servers to the cluster, we
> started seeing a high incidence of intermittent lockups (up to
> several times per day for some servers) across both the old and new
> servers. Prior to that, we saw this problem only rarely (perhaps
> once per 3 months).

What is generating the write load?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
