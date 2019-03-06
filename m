Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36255 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbfCFMzO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Mar 2019 07:55:14 -0500
Date: Wed, 6 Mar 2019 20:55:08 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/5] common/rc: fix get_max_lfs_filesize
Message-ID: <20190306125508.GK2824@desktop>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
 <155173434839.767.14812800687954592485.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155173434839.767.14812800687954592485.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Mar 04, 2019 at 01:19:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Helper functions are supposed to have a leading underscore ('_') in the
> function name, but this one doesn't have it.  Unfortunately, the calling
> test cases (generic/349-351) /do/ have the leading underscore, so now
> they're broken.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 8b40aabe..1c42515f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3834,7 +3834,7 @@ _get_max_file_size()
>  }
>  
>  # get MAX_LFS_FILESIZE
> -get_max_lfs_filesize()
> +_get_max_lfs_filesize()

I introduced this bug on commit when renaming the function, I remembered
I did test it before pushing it out.. Thanks for fixing it!

Eryu
>  {
>  	case "$(getconf LONG_BIT)" in
>  	"32")
> 
