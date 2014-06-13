Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24F997F58
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 09:19:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05A0C8F8039
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 07:19:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id F5WYoeZsR801nCBv for
	<xfs@oss.sgi.com>; Fri, 13 Jun 2014 07:19:41 -0700 (PDT)
Date: Fri, 13 Jun 2014 10:19:25 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS WARN_ON in xfs_vm_writepage
Message-ID: <20140613141925.GA24199@redhat.com>
References: <20140613051631.GA9394@redhat.com> <20140613062645.GZ9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140613062645.GZ9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jun 13, 2014 at 04:26:45PM +1000, Dave Chinner wrote:

> >  970         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
> >  971                         PF_MEMALLOC))
>
> What were you running at the time? The XFS warning is there to
> indicate that memory reclaim is doing something it shouldn't (i.e.
> dirty page writeback from direct reclaim), so this is one for the mm
> folk to work out...

Trinity had driven the machine deeply into swap, and the oom killer was
kicking in pretty often. Then this happened.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
