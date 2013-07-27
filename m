Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F5EA7F3F
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 12:57:44 -0500 (CDT)
Message-ID: <51F40A17.1040601@sgi.com>
Date: Sat, 27 Jul 2013 12:57:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 21/49] xfs: create xfs_bmap_util.[ch]
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-22-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:24, Dave Chinner wrote:
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

okay, function structure moved with some white space and typedef to 
struct changes and some functions in xfs_bmap.c are needed in 
xfs_bmap_util.c so they are no longer static. Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
