Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE3E171C
	for <linux-xfs@vger.kernel.org>; Fri,  8 Dec 2023 00:28:44 -0800 (PST)
Received: from dggpeml500017.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Smkn42Vfdz14LqS;
	Fri,  8 Dec 2023 16:28:40 +0800 (CST)
Received: from [10.174.178.2] (10.174.178.2) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 8 Dec
 2023 16:28:42 +0800
Message-ID: <374531c8-e2e7-4d96-8fe9-19f7357b08dc@huawei.com>
Date: Fri, 8 Dec 2023 16:28:41 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_grow: Remove xflag and iflag to reduce redundant
 temporary variables.
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
To: <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>
CC: <louhongxiang@huawei.com>
References: <619020bd-800a-431a-bb1d-937ad1cdc270@huawei.com>
In-Reply-To: <619020bd-800a-431a-bb1d-937ad1cdc270@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected

Both xflag and iflag are log flags. We can use the bits of lflag to
indicate all log flags, which is a small code reconstruction.

Signed-off-by: Wu YiFeng <wuyifeng10@huawei.com>
---
  growfs/xfs_growfs.c | 22 +++++++++++-----------
  1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 683961f6..5fb1a9d2 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -8,6 +8,10 @@
  #include "libfrog/paths.h"
  #include "libfrog/fsgeom.h"

+#define LOG_GROW	(1<<0)	/* -l flag: grow log section */
+#define LOG_EXT2INT	(1<<1)	/* -i flag: convert log from external to 
internal format */
+#define LOG_INT2EXT	(1<<2)	/* -x flag: convert log from internal to 
external format */
+
  static void
  usage(void)
  {
@@ -45,7 +49,6 @@ main(int argc, char **argv)
  	long			esize;	/* new rt extent size */
  	int			ffd;	/* mount point file descriptor */
  	struct xfs_fsop_geom	geo;	/* current fs geometry */
-	int			iflag;	/* -i flag */
  	int			isint;	/* log is currently internal */
  	int			lflag;	/* -l flag */
  	long long		lsize;	/* new log size in fs blocks */
@@ -55,7 +58,6 @@ main(int argc, char **argv)
  	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
  	int			rflag;	/* -r flag */
  	long long		rsize;	/* new rt size in fs blocks */
-	int			xflag;	/* -x flag */
  	char			*fname;	/* mount point name */
  	char			*datadev; /* data device name */
  	char			*logdev;  /*  log device name */
@@ -72,7 +74,7 @@ main(int argc, char **argv)

  	maxpct = esize = 0;
  	dsize = lsize = rsize = 0LL;
-	aflag = dflag = iflag = lflag = mflag = nflag = rflag = xflag = 0;
+	aflag = dflag = lflag = mflag = nflag = rflag = 0;

  	while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
  		switch (c) {
@@ -87,13 +89,13 @@ main(int argc, char **argv)
  			rflag = 1;
  			break;
  		case 'i':
-			lflag = iflag = 1;
+			lflag |= LOG_EXT2INT;
  			break;
  		case 'L':
  			lsize = strtoll(optarg, NULL, 10);
  			fallthrough;
  		case 'l':
-			lflag = 1;
+			lflag |= LOG_GROW;
  			break;
  		case 'm':
  			mflag = 1;
@@ -115,7 +117,7 @@ main(int argc, char **argv)
  			mtab_file = optarg;
  			break;
  		case 'x':
-			lflag = xflag = 1;
+			lflag |= LOG_INT2EXT;
  			break;
  		case 'V':
  			printf(_("%s version %s\n"), progname, VERSION);
@@ -124,9 +126,7 @@ main(int argc, char **argv)
  			usage();
  		}
  	}
-	if (argc - optind != 1)
-		usage();
-	if (iflag && xflag)
+	if (argc - optind != 1 || ((lflag & LOG_EXT2INT) && (lflag & 
LOG_INT2EXT)))
  		usage();
  	if (dflag + lflag + rflag + mflag == 0)
  		aflag = 1;
@@ -323,9 +323,9 @@ _("[EXPERIMENTAL] try to shrink unused space %lld, 
old size is %lld\n"),

  		if (!lsize)
  			lsize = dlsize / (geo.blocksize / BBSIZE);
-		if (iflag)
+		if (lflag & LOG_EXT2INT)
  			in.isint = 1;
-		else if (xflag)
+		else if (lflag & LOG_INT2EXT)
  			in.isint = 0;
  		else
  			in.isint = xi.logBBsize == 0;
-- 
2.33.0

在 2023/12/7 16:39, wuyifeng (C) 写道:
> I found that iflag and xflag can be combined with lflag to reduce the 
> number of redundant local variables, which is a refactoring to improve 
> code readability.Signed-off-by: Wu YiFeng <wuyifeng10@huawei.com>
> 
> Please help me review, thanks.
> 
> ---
>   growfs/xfs_growfs.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 683961f6..5fb1a9d2 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -8,6 +8,10 @@
>   #include "libfrog/paths.h"
>   #include "libfrog/fsgeom.h"
> 
> +#define LOG_GROW    (1<<0)    /* -l flag: grow log section */
> +#define LOG_EXT2INT    (1<<1)    /* -i flag: convert log from external 
> to internal format */
> +#define LOG_INT2EXT    (1<<2)    /* -x flag: convert log from internal 
> to external format */
> +
>   static void
>   usage(void)
>   {
> @@ -45,7 +49,6 @@ main(int argc, char **argv)
>       long            esize;    /* new rt extent size */
>       int            ffd;    /* mount point file descriptor */
>       struct xfs_fsop_geom    geo;    /* current fs geometry */
> -    int            iflag;    /* -i flag */
>       int            isint;    /* log is currently internal */
>       int            lflag;    /* -l flag */
>       long long        lsize;    /* new log size in fs blocks */
> @@ -55,7 +58,6 @@ main(int argc, char **argv)
>       struct xfs_fsop_geom    ngeo;    /* new fs geometry */
>       int            rflag;    /* -r flag */
>       long long        rsize;    /* new rt size in fs blocks */
> -    int            xflag;    /* -x flag */
>       char            *fname;    /* mount point name */
>       char            *datadev; /* data device name */
>       char            *logdev;  /*  log device name */
> @@ -72,7 +74,7 @@ main(int argc, char **argv)
> 
>       maxpct = esize = 0;
>       dsize = lsize = rsize = 0LL;
> -    aflag = dflag = iflag = lflag = mflag = nflag = rflag = xflag = 0;
> +    aflag = dflag = lflag = mflag = nflag = rflag = 0;
> 
>       while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
>           switch (c) {
> @@ -87,13 +89,13 @@ main(int argc, char **argv)
>               rflag = 1;
>               break;
>           case 'i':
> -            lflag = iflag = 1;
> +            lflag |= LOG_EXT2INT;
>               break;
>           case 'L':
>               lsize = strtoll(optarg, NULL, 10);
>               fallthrough;
>           case 'l':
> -            lflag = 1;
> +            lflag |= LOG_GROW;
>               break;
>           case 'm':
>               mflag = 1;
> @@ -115,7 +117,7 @@ main(int argc, char **argv)
>               mtab_file = optarg;
>               break;
>           case 'x':
> -            lflag = xflag = 1;
> +            lflag |= LOG_INT2EXT;
>               break;
>           case 'V':
>               printf(_("%s version %s\n"), progname, VERSION);
> @@ -124,9 +126,7 @@ main(int argc, char **argv)
>               usage();
>           }
>       }
> -    if (argc - optind != 1)
> -        usage();
> -    if (iflag && xflag)
> +    if (argc - optind != 1 || ((lflag & LOG_EXT2INT) && (lflag & 
> LOG_INT2EXT)))
>           usage();
>       if (dflag + lflag + rflag + mflag == 0)
>           aflag = 1;
> @@ -323,9 +323,9 @@ _("[EXPERIMENTAL] try to shrink unused space %lld, 
> old size is %lld\n"),
> 
>           if (!lsize)
>               lsize = dlsize / (geo.blocksize / BBSIZE);
> -        if (iflag)
> +        if (lflag & LOG_EXT2INT)
>               in.isint = 1;
> -        else if (xflag)
> +        else if (lflag & LOG_INT2EXT)
>               in.isint = 0;
>           else
>               in.isint = xi.logBBsize == 0;
