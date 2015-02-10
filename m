Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B15F7FB6
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 16:14:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27C10AC005
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 14:14:50 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0043BTFynNPnJCi5 for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2015 14:14:45 -0800 (PST)
Date: Wed, 11 Feb 2015 09:14:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfsprogs: Addition in debug option -d of xfs_spaceman
Message-ID: <20150210221421.GP4251@dastard>
References: <54ca34c6.4696420a.0f32.4513@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ca34c6.4696420a.0f32.4513@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 06:55:21PM +0530, Dhruvesh Rathore wrote:
> 
> The xfs_spaceman utility did not have a a proper title to the content
> displayed using -d (debug) option.
.....
> 
> @@ -332,20 +332,23 @@
>  static int
>  freesp_f(
>  	int		argc,
>  	char		**argv)
>  {
>  	xfs_agnumber_t	agno;		
>  
>  	if (!init(argc, argv))
>  		return 0;
>  
> +	if (dumpflag)
> +		printf("%8s %8s %8s\n", "agno", "agbno", "len");
> +
>  	for (agno = 0; agno < file->geom.agcount; agno++)  {
>  		if (inaglist(agno))
>  			scan_ag(agno);
>  	}
>  	if (histcount)
>  		printhist();		

Patch does not apply to the current tree. It's got stray whitespace
and lines in it that are in the original source file.

I've fixed this up for the moment, but please make sure your
patches apply to a clean tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
