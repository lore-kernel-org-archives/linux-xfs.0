Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DC417CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 22:30:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F0628F8035
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 20:30:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mGXY9xuBCDE2zIqk for <xfs@oss.sgi.com>;
	Tue, 26 Jan 2016 20:30:25 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EFA76660086B
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 22:30:24 -0600 (CST)
Subject: Re: [PATCH 1/5 v2] xfs_io: detect the '-R' option in getopt
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
	<20160127005845.GC5852@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A847E0.3030607@sandeen.net>
Date: Tue, 26 Jan 2016 22:30:24 -0600
MIME-Version: 1.0
In-Reply-To: <20160127005845.GC5852@birch.djwong.org>
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

Rockin!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

On 1/26/16 6:58 PM, Darrick J. Wong wrote:
> Configure getopt to accept the -R argument to pwrite.
> 
> v2: Accept -F and -B while we're at it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/pwrite.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index fd9114d..4fc8de6 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -259,7 +259,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:Cdf:i:qs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
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
