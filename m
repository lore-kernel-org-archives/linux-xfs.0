Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00B6C7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 23:54:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C19D2304059
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 21:54:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GtjJFrG2e2aypMt8 for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 21:54:24 -0700 (PDT)
Message-ID: <519EF27B.7040001@redhat.com>
Date: Thu, 23 May 2013 23:54:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] add generic/286 to the auto and quick groups
References: <1369369981-7035-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1369369981-7035-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On 5/23/13 11:33 PM, Theodore Ts'o wrote:
> The generic/286 test tests SEEK_HOLE and SEEK_DATA, and is reasonably
> fast.  We should just run the test by default.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Seems fine to me

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

another patch to follow to fix it on kernels that don't support it.

> ---
>  tests/generic/group | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/group b/tests/generic/group
> index e2ef70e..bd443c1 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -103,7 +103,7 @@
>  277 auto ioctl quick metadata
>  280 auto quota freeze dangerous
>  285 auto rw
> -286 other
> +286 auto quick other
>  288 auto quick ioctl trim
>  294 auto quick
>  299 auto aio enospc rw stress
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
