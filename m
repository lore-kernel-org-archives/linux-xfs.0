Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A5FC7F89
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 12:01:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88185304077
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 10:01:45 -0700 (PDT)
Received: from mail-da0-f42.google.com (mail-da0-f42.google.com
	[209.85.210.42]) by cuda.sgi.com with ESMTP id DqMdQ6DzDnXViSI3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 May 2013 10:01:44 -0700 (PDT)
Received: by mail-da0-f42.google.com with SMTP id n15so736564dad.15
	for <xfs@oss.sgi.com>; Wed, 01 May 2013 10:01:43 -0700 (PDT)
Date: Wed, 1 May 2013 10:01:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: deadlock on vmap_area_lock
In-Reply-To: <20130501164406.GC2404@BohrerMBP.rgmadvisors.com>
Message-ID: <alpine.DEB.2.02.1305010959070.16591@chino.kir.corp.google.com>
References: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com>
	<alpine.DEB.2.02.1305010855440.4547@chino.kir.corp.google.com>
	<20130501164406.GC2404@BohrerMBP.rgmadvisors.com>
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
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 1 May 2013, Shawn Bohrer wrote:

> Correct it doesn't and I can't prove the find command is not making
> progress, however these finds normally complete in under 15 min and
> we've let the stuck ones run for days.  Additionally if this was just
> contention I'd expect to see multiple threads/CPUs contending and I
> only have a single CPU pegged running find at 99%. I should clarify
> that the perf snippet above was for the entire system.  Profiling just
> the find command shows:
> 
>     82.56%     find  [kernel.kallsyms]  [k] _raw_spin_lock

Couple of options to figure out what spinlock this is: use lockstat (see 
Documentation/lockstat.txt), which will also require a kernel rebuild, 
some human intervention to collect the stats, and the accompanying 
performance degradation, or you could try collecting
/proc/$(pidof find)/stack at regular intervals and figure out which 
spinlock it is.

> > Depending on your 
> > definition of "occassionally", would it be possible to run with 
> > CONFIG_PROVE_LOCKING and CONFIG_LOCKDEP to see if it uncovers any real 
> > deadlock potential?
> 
> Yeah, I can probably enable these on a few machines and hope I get
> lucky.  These machines are used for real work so I'll have to gauge
> what how significant the performance impact is to determine how many
> machines I can sacrifice to the cause.
> 

You'll probably only need to enable it on one machine, if a deadlock 
possibility exists here then lockdep will find it even without hitting it, 
it simply has to exercise the path that leads to it.  It does have a 
performance degradation for that one machine, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
