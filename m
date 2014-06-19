Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6AC47F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 21:04:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38D99AC005
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 19:04:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XrKtgtKTLkPv2fPl for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 19:03:54 -0700 (PDT)
Date: Thu, 19 Jun 2014 12:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS WARN_ON in xfs_vm_writepage
Message-ID: <20140619020340.GI4453@dastard>
References: <20140613051631.GA9394@redhat.com> <20140613062645.GZ9508@dastard>
	<20140613141925.GA24199@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140613141925.GA24199@redhat.com>
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
To: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

On Fri, Jun 13, 2014 at 10:19:25AM -0400, Dave Jones wrote:
> On Fri, Jun 13, 2014 at 04:26:45PM +1000, Dave Chinner wrote:
> 
> > >  970         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
> > >  971                         PF_MEMALLOC))
> >
> > What were you running at the time? The XFS warning is there to
> > indicate that memory reclaim is doing something it shouldn't (i.e.
> > dirty page writeback from direct reclaim), so this is one for the mm
> > folk to work out...
> 
> Trinity had driven the machine deeply into swap, and the oom killer was
> kicking in pretty often. Then this happened.

Yup, sounds like a problem somewhere in mm/vmscan.c....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
