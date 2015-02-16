Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7076C7F54
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:53:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FCB18F8037
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 15:53:51 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	L4W4sKeYa7sbQNeH for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 15:53:49 -0800 (PST)
Date: Tue, 17 Feb 2015 10:53:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Message-ID: <20150216235346.GD4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-2-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424101680-3301-2-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:48AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> FALLOC_FL_INSERT_RANGE command is the opposite command of
> FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> for writing new data within a file after shifting extents to right as given
> length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> that is block boundary and use ftruncate(2) for crosses EOF.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Cc: Brian Foster<bfoster@redhat.com>
> ---
>  fs/open.c                   |    8 +++++++-
>  include/uapi/linux/falloc.h |   17 +++++++++++++++++
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 813be03..762fb45 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -232,7 +232,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  
>  	/* Return error if mode is not supported */
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> +		     FALLOC_FL_INSERT_RANGE))
>  		return -EOPNOTSUPP;

Can we create a FALLOC_FL_SUPPORTED_MASK define in falloc.h
so that we only need to add new flags to the mask in rather than
change this code every time we add a new flag?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
