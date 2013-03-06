Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 675E87F63
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 10:24:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47CC8304043
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 08:23:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6hjFm13CdKYOuPyL for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 08:23:57 -0800 (PST)
Message-ID: <51376A61.6060807@redhat.com>
Date: Wed, 06 Mar 2013 10:10:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: don't assume that falloc_punch implies falloc
	in test 255
References: <1362506382-26974-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1362506382-26974-1-git-send-email-tytso@mit.edu>
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

On 3/5/13 11:59 AM, Theodore Ts'o wrote:
> As of Linux 3.9-rc1, ext4 will support the punch operation on file
> systems using indirect blocks, but it can not support the fallocate
> operation (since there is no way to mark a block as uninitialized
> using indirect block scheme).  This caused test 255 to fail, since it
> only used _require_xfS_io_falloc_punch assuming that all file systems
> which supported punch can also support fallocate.  Fix this.

Seems fine to avoid the incorrect failure, so as far as that goes:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

But we probably can & should still test punch in this situation,
so we need a new test to exercise that I guess.

-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  255 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/255 b/255
> index 0083963..ae1d8e0 100755
> --- a/255
> +++ b/255
> @@ -48,6 +48,7 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_xfs_io_falloc_punch
> +_require_xfs_io_falloc
>  _require_xfs_io_fiemap
>  
>  testfile=$TEST_DIR/255.$$
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
