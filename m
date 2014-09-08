Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C3DC7F53
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 08:45:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C43A304048
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 06:45:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id be85qj5KNO6gcPNf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 06:45:21 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s88DjK2r001966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 8 Sep 2014 09:45:20 -0400
Date: Mon, 8 Sep 2014 09:45:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs_repair: preserve error state in
	process_shortform_attr
Message-ID: <20140908134518.GB52419@bfoster.bfoster>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410108065-18156-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 11:41:02AM -0500, Eric Sandeen wrote:
> process_shortform_attr uses the "junkit" error to
> track whether an error was found, but by assigning
> it directly to the result of valuecheck, previous
> errors are ignored, leading to unrepairable errors
> of the form i.e.
> 
> "entry has INCOMPLETE flag on in shortform attribute"
> or
> "entry contains illegal character in shortform attribute name"
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/attr_repair.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index a27a3ec..d60b664 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -914,7 +914,8 @@ process_shortform_attr(
>  
>  		/* Only check values for root security attributes */
>  		if (currententry->flags & XFS_ATTR_ROOT)
> -		       junkit = valuecheck(mp, (char *)&currententry->nameval[0],
> +		       junkit |= valuecheck(mp,
> +					(char *)&currententry->nameval[0],
>  					NULL, currententry->namelen, 
>  					currententry->valuelen);
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
