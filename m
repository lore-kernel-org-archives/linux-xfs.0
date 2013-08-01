Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3546F29DFB
	for <linux-xfs@oss.sgi.com>; Thu,  1 Aug 2013 09:11:43 -0500 (CDT)
Message-ID: <51FA6C9B.3010101@sgi.com>
Date: Thu, 01 Aug 2013 09:11:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs:free bp in xlog_find_tail() error path
References: <51F9BAFB.9000808@redhat.com>
In-Reply-To: <51F9BAFB.9000808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 07/31/13 20:33, Eric Sandeen wrote:
> xlog_find_tail() currently leaks a bp on one error path.
>
> There is no error target, so manually free the bp before
> returning the error.
>
> Found by Coverity.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> p.s. this can be merged to userspace as well.

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
