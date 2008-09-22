Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 16:40:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MNdvVb009618
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 16:39:57 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FE7846E7AA
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 16:41:29 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 3NXRPQ8dFEitl6Cu for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 16:41:29 -0700 (PDT)
Date: Tue, 23 Sep 2008 09:41:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/10] xfs: Fix error handling in
	write_super_lockfs/unlockfs
Message-ID: <20080922234120.GV5811@disturbed>
References: <20080922195637t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922195637t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Sep 22, 2008 at 07:56:37PM +0900, Takashi Sato wrote:
> I've changed write_super_lockfs/unlockfs so that they always return
> 0 (success) to keep a current behavior.
> 
> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
> ---
>  xfs_super.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -uprN -X linux-2.6.27-rc7-lockfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c linux-
> 2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c
> --- linux-2.6.27-rc7-lockfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 07:29:55.000000000 +0900
> +++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 10:13:39.000000000 +0900
> @@ -1351,7 +1351,7 @@ xfs_fs_remount(
>   * need to take care of themetadata. Once that's done write a dummy
>   * record to dirty the log in case of a crash while frozen.
>   */
> -STATIC void
> +STATIC int
>  xfs_fs_lockfs(
>  	struct super_block	*sb)
>  {
> @@ -1359,6 +1359,7 @@ xfs_fs_lockfs(
>  
>  	xfs_attr_quiesce(mp);
>  	xfs_fs_log_dummy(mp);
> +	return 0;
>  }

xfs_fs_log_dummy() currently is void because it had nowhere to
return errors to. It silently throws away errors because of this.
Hence the correct thing to do here is to fix xfs_fs_log_dummy()
to return the errors it currently ignores. i.e. catch the errors
from xfs_trans_reserve() and xfs_trans_commit() calls in
xfs_fs_log_dummy().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
