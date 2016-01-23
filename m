Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA4737F3F
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 22:56:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6ACD3AC001
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 20:55:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id C6nb1Au1sh11PXhG for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 20:55:53 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3FD3F63D5B55
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 22:55:53 -0600 (CST)
Subject: Re: [PATCH 1/5] xfs_io: detect the '-R' option in getopt
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A307D8.60202@sandeen.net>
Date: Fri, 22 Jan 2016 22:55:52 -0600
MIME-Version: 1.0
In-Reply-To: <20160123003502.2475.99558.stgit@birch.djwong.org>
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
To: xfs@oss.sgi.com

On 1/22/16 6:35 PM, Darrick J. Wong wrote:
> Configure getopt to accept the -R argument to pwrite.

Did you have anything against "F" and "B"? :)

(They're missing too but in the case statements & help)

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/pwrite.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index fd9114d..c6efee9 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -259,7 +259,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:Cdf:i:qs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:Cdf:i:qRs:S:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
