Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B78977F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 10:59:42 -0500 (CDT)
Message-ID: <5228AA6D.5030108@sgi.com>
Date: Thu, 05 Sep 2013 10:59:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/55] libxfs: sync attr code with kernel
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-10-git-send-email-david@fromorbit.com>
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
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

This patch has not changed since the previous posting.

This patch starts the sync with the 3.12 kernel patch series.

When I reviewed these patches, I applied the kernel patch and compared 
the files that changed with the user patch. I will do spot checks as I 
go through this series again.

My review on the original post was:
syncs the code in libxfs/xfs_attr.c and libxfs/xfs_attr_leaf.c to kernel 
files with exception of the part in xfs_attr_shortform_to_leaf() that 
gets updated by patch 14/49.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
