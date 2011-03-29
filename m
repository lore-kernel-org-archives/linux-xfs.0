Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T8ua5o218685 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 03:56:37 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41206387C24
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 01:59:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XZNK1DSGAq9u8o8H for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2011 01:59:46 -0700 (PDT)
Message-ID: <4D919F75.5070601@redhat.com>
Date: Tue, 29 Mar 2011 10:59:33 +0200
From: Avi Kivity <avi@redhat.com>
MIME-Version: 1.0
Subject: Re: Very aggressive memory reclaim
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>	<20110328215344.GC3008@dastard>
	<AANLkTi==vw7Dy-oK31PxHadwUaDRUUk+TM0ECSZ=chfv@mail.gmail.com>
In-Reply-To: <AANLkTi==vw7Dy-oK31PxHadwUaDRUUk+TM0ECSZ=chfv@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Lepikhin <johnlepikhin@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 03/29/2011 09:26 AM, John Lepikhin wrote:
> 2011/3/29 Dave Chinner<david@fromorbit.com>:
>
> >  First it would be useful to determine why the VM is reclaiming so
> >  much memory. If it is somewhat predictable when the excessive
> >  reclaim is going to happen, it might be worth capturing an event
> >  trace from the VM so we can see more precisely what it is doiing
> >  during this event. In that case, recording the kmem/* and vmscan/*
> >  events is probably sufficient to tell us what memory allocations
> >  triggered reclaim and how much reclaim was done on each event.
>
> Do you mean I must add some debug to mm functions? I don't know any
> other way to catch such events.

Download and build trace-cmd 
(git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git), 
and do

$ trace-cmd record -e kmem -e vmscan -b 30000

Hit ctrl-C when done and post the output file generated in cwd.

-- 
error compiling committee.c: too many arguments to function

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
