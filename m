Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90D0C29DFA
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 07:17:32 -0500 (CDT)
Message-ID: <51961FFB.5040605@sgi.com>
Date: Fri, 17 May 2013 07:18:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: check falloc in 285
References: <1368351729-17778-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368351729-17778-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 05/12/2013 04:42 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> As linux 3.8, ext4 has supported the seek data/hole operation for
> extent-based file and indirect-based file.  But for indirect-based file
> it can not support the fallocate(2).  This causes test 285 to fail since
> it assumes that all file systems which supports seek data/hole also
> support fallocate.  So here we need to check it.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Rich Johnston <rjohnston@sgi.com>
> ---
>   tests/generic/285 | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/tests/generic/285 b/tests/generic/285
> index 22b4a08..d1a1baa 100644
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -40,6 +40,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>   _supported_fs generic
>   _supported_os Linux
>
> +_require_xfs_io_falloc
> +
>   BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
>
>   [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
