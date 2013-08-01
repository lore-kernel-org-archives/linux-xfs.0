Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C11B829DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 09:10:59 -0500 (CDT)
Message-ID: <51FA6C70.8000701@sgi.com>
Date: Thu, 01 Aug 2013 09:10:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: free bp in xlog_find_zeroed() error path
References: <51F9BAAE.2000709@redhat.com>
In-Reply-To: <51F9BAAE.2000709@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 07/31/13 20:32, Eric Sandeen wrote:
> xlog_find_zeroed() currently leaks a bp on one error path.
>
> Using the bp_err: target resolves this.
>
> Found by Coverity.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---


Looks good.


> p.s. this can be merged to userspace as well.

or get it in before the 3.12 series gets rebased.


Reviewed-by; Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
