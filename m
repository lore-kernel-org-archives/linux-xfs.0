Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25F677F5E
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 15:36:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12E7D30404E
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 13:36:17 -0700 (PDT)
Received: from Galois.linutronix.de (www.linutronix.de [62.245.132.108]) by
	cuda.sgi.com with ESMTP id A72tw4V6dEmiMwMN (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 05 Jul 2014 13:36:16 -0700 (PDT)
Date: Sat, 5 Jul 2014 22:36:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
In-Reply-To: <537CFECF.9070701@ccur.com>
Message-ID: <alpine.DEB.2.10.1407052233230.22031@nanos>
References: <537CFECF.9070701@ccur.com>
MIME-Version: 1.0
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
To: John Blackwood <john.blackwood@ccur.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Austin Schuh <austin@peloton-tech.com>, xfs@oss.sgi.com

On Wed, 21 May 2014, John Blackwood wrote:
> I'm not 100% sure that the patch below will fix your problem, but we
> saw something that sounds pretty familiar to your issue involving the
> nvidia driver and the preempt-rt patch.  The nvidia driver uses the
> completion support to create their own driver's notion of an internally
> used semaphore.

And why should we care about that? If they abuse the completion code
then it's their problem. And it has nothing to do at all with the
problem Austin is observing.
 
> Some tasks were failing to ever wakeup from wait_for_completion() calls
> due to a race in the underlying do_wait_for_common() routine.

Why are you not fixing the nvidia crap instead of hacking utter shite
into the core kernel?

Thanks,

	tglx

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
