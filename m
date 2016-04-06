Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B9EC7CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 16:10:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9176AAC002
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 14:10:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4XmqZvE38mUUm6eB for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 14:10:04 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id AA6BA16C150
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 16:10:03 -0500 (CDT)
Subject: Re: [PATCH 18/19] mkfs: unit conversions are case insensitive
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-19-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57057B2A.3000100@sandeen.net>
Date: Wed, 6 Apr 2016 16:10:02 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-19-git-send-email-jtulak@redhat.com>
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

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Jan Tulak <jtulak@redhat.com>
> 
> Solves the question "Should I use 10g or 10G?"

Might be nicer to do it like the cvtnum in libxcmd:

        c = tolower(*sp);
        switch (c) {
        case 'b':
                return i * blocksize;
...

(hm, why do we have 3 copies of cvtnum?)
 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2bb3b35..680c6c4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3625,17 +3625,17 @@ cvtnum(
>  	if (*sp == 's' && sp[1] == '\0')
>  		return i * sectsize;
>  
> -	if (*sp == 'k' && sp[1] == '\0')
> +	if ((*sp == 'k'  || *sp == 'K' ) && sp[1] == '\0')
                        ^ 1 space is enough, no?

I guess doing it this way doesn't really bother me, but
the whitespace is messy and if you're here anyway,
tolower() might be simpler.

-Eric

>  		return 1024LL * i;
> -	if (*sp == 'm' && sp[1] == '\0')
> +	if ((*sp == 'm'  || *sp == 'M' ) && sp[1] == '\0')
>  		return 1024LL * 1024LL * i;
> -	if (*sp == 'g' && sp[1] == '\0')
> +	if ((*sp == 'g'  || *sp == 'G' ) && sp[1] == '\0')
>  		return 1024LL * 1024LL * 1024LL * i;
> -	if (*sp == 't' && sp[1] == '\0')
> +	if ((*sp == 't'  || *sp == 'T' ) && sp[1] == '\0')
>  		return 1024LL * 1024LL * 1024LL * 1024LL * i;
> -	if (*sp == 'p' && sp[1] == '\0')
> +	if ((*sp == 'p'  || *sp == 'P' ) && sp[1] == '\0')
>  		return 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * i;
> -	if (*sp == 'e' && sp[1] == '\0')
> +	if ((*sp == 'e'  || *sp == 'E' ) && sp[1] == '\0')
>  		return 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * i;
>  	return -1LL;
>  }
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
