Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752847AbdICDlv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 Sep 2017 23:41:51 -0400
Subject: Re: [PATCH] misc: fix more stupid compiler warnings
References: <20170901222157.GL3775@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ec6ee070-0cb3-70d0-80c4-c1629f618753@redhat.com>
Date: Sat, 2 Sep 2017 22:41:50 -0500
MIME-Version: 1.0
In-Reply-To: <20170901222157.GL3775@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 9/1/17 5:21 PM, Darrick J. Wong wrote:
> Fix more compiler warnings about pointless checks, unchecked return
> values, brace problems, and missing parentheses.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c           |    2 --
>  libxfs/init.c        |   17 ++++++++++++-----
>  libxfs/libxfs_priv.h |    4 ++--
>  libxfs/xfs_bmap.c    |    2 +-
>  repair/phase6.c      |    4 ++--
>  repair/rmap.c        |    2 +-
>  6 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 12a0aed..6076540 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3220,9 +3220,7 @@ process_leaf_node_dir_v2_free(
>  		return;
>  	}
>  	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
> -				be32_to_cpu(free->hdr.nvalid) < 0 ||
>  				be32_to_cpu(free->hdr.nused) > maxent ||
> -				be32_to_cpu(free->hdr.nused) < 0 ||
>  				be32_to_cpu(free->hdr.nused) >
>  					be32_to_cpu(free->hdr.nvalid)) {
>  		if (!sflag || v)
> diff --git a/libxfs/init.c b/libxfs/init.c
> index d77a9e6..2479220 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -262,7 +262,10 @@ libxfs_init(libxfs_init_t *a)
>  	a->dsize = a->lbsize = a->rtbsize = 0;
>  	a->dbsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
>  
> -	(void)getcwd(curdir,MAXPATHLEN);
> +	if (!getcwd(curdir, MAXPATHLEN)) {
> +		perror("getcwd");
> +		strcpy(curdir, ".");
> +	}

I can't quite figure out what this curdir/needcd stuff is
for, but assuming it's not pointless, crazy cruft, I don't
think this is safe; later code does "chdir(curdir)"
and chdir(".") isn't going to do what the code expects, is
it?

>  	needcd = 0;
>  	fd = -1;
>  	flags = (a->isreadonly | a->isdirect);
> @@ -284,7 +287,8 @@ libxfs_init(libxfs_init_t *a)
>  	}
>  	if (dname) {
>  		if (dname[0] != '/' && needcd)
> -			chdir(curdir);
> +			if (chdir(curdir))
> +				perror(curdir);

and again, if we fail, we print something and carry on?
It may shut up gcc, but this doesn't look like error handling to me :)

Could you tell what this chdir/curdir/needcd stuff is for?

-Eric
