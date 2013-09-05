Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A32CC7F59
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:46:58 -0500 (CDT)
Message-ID: <5228A771.2090809@sgi.com>
Date: Thu, 05 Sep 2013 10:46:57 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/55] libxfs: sync xfs_da_btree.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-8-git-send-email-david@fromorbit.com>
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
> Some variables we renamed in the kernel code, and there are a few
> other minor differences. Fix them up.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Patch has not changed since last posting. My review back then was [] is 
added to make sense of the comments:

okay, only difference [between the kernel/user source files] is the 
initializing of the pagb_tree in xfs_alloc_read_agf() [it is not in the 
xfsprogs]. [Okay, because we] Don't use the busy extent tree in user space.

Still looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
