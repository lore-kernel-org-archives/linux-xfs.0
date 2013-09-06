Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0153D7F3F
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 10:30:06 -0500 (CDT)
Message-ID: <5229F4FD.8060304@sgi.com>
Date: Fri, 06 Sep 2013 10:30:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 32/55] xfs: create xfs_bmap_util.[ch]
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-33-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> There is a bunch of code in xfs_bmap.c that is kernel specific and
> not shared with userspace. to minimise the difference between the
> kernel and userspace code, shift this unshared code to
> xfs_bmap_util.c, and the declarations to xfs_bmap_util.h.
>
> The biggest issue here is xfs_bmap_finish() - userspce has it's own
> definition of this function, and so we need to move it out of
> xfs_bmap.[ch]. This means several other files need to include
> xfs_bmap_util.c as well.
>
> It also introduces and interesting dance for the stack switching
> code in xfs_bmapi_allocate(). The stack switching/workqueue code is
> actually moved to xfs_bmap_util.c, so that userspace can simply use
> a #define in a header file to connect the dots without needing to
> know about the stack switch code at all.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Skipped patch 31 because there are issues that I do not see resolved by 
the end of the series. I will come back to it.

This patch did not change from last posting. User equivalent of kernel 
patch 21/50.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
