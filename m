Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58444 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeBXR6e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Feb 2018 12:58:34 -0500
Subject: Re: [PATCH] xfs: fix potential memory leak in mount option parsing
References: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net>
Date: Sat, 24 Feb 2018 11:58:33 -0600
MIME-Version: 1.0
In-Reply-To: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chengguang Xu <cgxu519@icloud.com>, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

On 2/24/18 4:33 AM, Chengguang Xu wrote:
> When specifying string type mount option (e.g., logdev)
> several times in a mount, current option parsing may
> cause memory leak. Hence, call kfree for previous one
> in this case.
> 
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>

IMHO multiple specifications of logdev or rtdev should not
be allowed; only one may be chosen, and specifying twice
should probably be considered and administrative error.

I'd rather see something that fails and cleans up properly
if either option is respecified.

Thanks,
-Eric

> ---
>  fs/xfs/xfs_super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7aba628..93588ea 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -250,6 +250,7 @@ enum {
>  				return -EINVAL;
>  			break;
>  		case Opt_logdev:
> +			kfree(mp->m_logname);
>  			mp->m_logname = match_strdup(args);
>  			if (!mp->m_logname)
>  				return -ENOMEM;
> @@ -258,6 +259,7 @@ enum {
>  			xfs_warn(mp, "%s option not allowed on this system", p);
>  			return -EINVAL;
>  		case Opt_rtdev:
> +			kfree(mp->m_rtname);
>  			mp->m_rtname = match_strdup(args);
>  			if (!mp->m_rtname)
>  				return -ENOMEM;
> 
