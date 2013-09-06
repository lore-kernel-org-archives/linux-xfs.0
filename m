Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B47A7F54
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 16:41:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D2718F8035
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:41:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mHj8IgeD446Pzbsp for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 14:41:36 -0700 (PDT)
Date: Sat, 7 Sep 2013 07:41:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 37/55] xfs: remove __KERNEL__ from debug code
Message-ID: <20130906214133.GE12541@dastard>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-38-git-send-email-david@fromorbit.com>
	<522A10A4.3000003@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <522A10A4.3000003@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 06, 2013 at 12:28:04PM -0500, Mark Tinguely wrote:
> On 09/04/13 17:05, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >There is no reason the remaining kernel-only debug code needs to
> >remain kernel-only. Kill the __KERNEL__ part of the defines, and let
> >userspace handle the debug code appropriately.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> user equivalent of the for Linux 3.12 kernel patch 30/50.
> 
> the real time kernel and user xfs_rtalloc.c files are not synced.
> It is okay with me.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Yes, they still need to be split up on the kernel side. the rtdev is
not a high priority for testing, so I haven't done this yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
