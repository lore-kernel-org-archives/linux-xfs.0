Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 07:37:12 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VEb84p031075
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 07:37:10 -0700
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <46D826BA.1060705@sandeen.net>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>
	 <20070831135042.GD422459@sgi.com>  <46D826BA.1060705@sandeen.net>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 16:36:52 +0200
Message-Id: <1188571012.6112.67.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>

On Fri, 2007-08-31 at 09:33 -0500, Eric Sandeen wrote:

> Peter, unless there is some other reason to do so, changing xfs
> performance behavior simply to satisfy lockdep limitations* doesn't seem
> like the best plan.
> 
> I suppose one slightly flakey option would be for xfs to see whether
> lockdep is enabled and adjust cluster size based on MAX_LOCK_DEPTH... on
> the argument that lockdep is likely used in debugging kernels where
> sheer performance is less important... but, that sounds pretty flakey to me.

Agreed, that sucks too :-/

I was hoping there would be a 'nice' solution, a well, again, reality
ruins it.
