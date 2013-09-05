Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B12A47F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 13:46:42 -0500 (CDT)
Message-ID: <5228D18E.5040600@sgi.com>
Date: Thu, 05 Sep 2013 13:46:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 11/55] libxfs: sync xfs_ialloc.c to the kernel code
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-12-git-send-email-david@fromorbit.com>
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
> include the missing xfs_difree() function. it's not used by
> userspace, but it makes no sense to have just this one arbitrary
> difference between the kernel and userspace files.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

No change in this reposting of the patch.

adds xfs_difree(). Adds parts of kernel patches 83a9ba00 and 43df2ee6.

changed variable "offset_agbno" in xfs_imap() from "xfs_agblock_t to 
"int" so patch 13/49 can move it back to "offset_agbno". good stuff.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
