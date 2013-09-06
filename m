Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FFE529DFB
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:59:38 -0500 (CDT)
Message-ID: <522A3429.2030004@sgi.com>
Date: Fri, 06 Sep 2013 14:59:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: fix memory allocation failures with ACLs
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<1378119180-31380-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378119180-31380-2-git-send-email-david@fromorbit.com>
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

On 09/02/13 05:52, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Ever since increasing the number of supported ACLs from 25 to as
> many as can fit in an xattr, there have been reports of order 4
> memory allocations failing in the ACL code. Fix it in the same way
> we've fixed all the xattr read/write code that has the same problem.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
