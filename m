Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FFlfLn195795 for <xfs@oss.sgi.com>; Tue, 15 May 2012 10:47:41 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id OHxAF57Y2s55gzQv for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 08:47:39 -0700 (PDT)
Message-ID: <4FB27A9B.1070800@sandeen.net>
Date: Tue, 15 May 2012 10:47:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfstests README: added 'make install' to building
	steps
References: <1335351177-3014-1-git-send-email-tmarek@redhat.com>
In-Reply-To: <1335351177-3014-1-git-send-email-tmarek@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tom Marek <tmarek@redhat.com>
Cc: lczerner@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On 4/25/12 5:52 AM, Tom Marek wrote:
> There was no mention of 'make install' step in the README file.
> Run make install added to section 'Building Linux'.

Ok, I'll merge this.  TBH I've never run "make install" ;)

-Eric

> Signed-off-by: Tom Marek <tmarek@redhat.com>
> ---
>  README |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/README b/README
> index 0f52f02..d81ede9 100644
> --- a/README
> +++ b/README
> @@ -3,7 +3,9 @@ BUILDING THE FSQA SUITE
>  _______________________
>  
>  Building Linux:
> -	- cd into the xfstests directory and run make.
> +	- cd into the xfstests directory
> +	- run make
> +	- run make install
>  	
>  Building IRIX:
>  	- cd into the xfstests directory 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
