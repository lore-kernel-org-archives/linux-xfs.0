Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8DED7F52
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 11:04:50 -0500 (CDT)
Message-ID: <51A4D5D7.1040708@sgi.com>
Date: Tue, 28 May 2013 11:05:43 -0500
From: Rich Johnston <rjohnston@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On 05/23/2013 11:33 PM, Theodore Ts'o wrote:
> The generic/286 test tests SEEK_HOLE and SEEK_DATA, and is reasonably
> fast.  We should just run the test by default.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>   tests/generic/group | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/generic/group b/tests/generic/group
> index e2ef70e..bd443c1 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -103,7 +103,7 @@
>   277 auto ioctl quick metadata
>   280 auto quota freeze dangerous
>   285 auto rw
> -286 other
> +286 auto quick other
>   288 auto quick ioctl trim
>   294 auto quick
>   299 auto aio enospc rw stress
>
Thanks, this patch has been committed:

commit f45c6881577221e04f6cfe19d25e571bee088996
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue May 28 11:01:01 2013 -0500

     xfstests: add generic/286 to the auto and quick groups

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
