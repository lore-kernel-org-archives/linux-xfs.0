Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D92867F5F
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 10:56:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5808304066
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 08:56:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4CHWADgBdDD2eYAp for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 08:56:23 -0700 (PDT)
Message-ID: <521F6F24.2030101@sandeen.net>
Date: Thu, 29 Aug 2013 10:56:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: add noalign option to usage()
References: <1377789991-17236-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1377789991-17236-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 8/29/13 10:26 AM, Carlos Maiolino wrote:
> Although it has been added to manpage, there is no information about the
> existence of noalign option into the usage().
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4bdacee..65630d4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3033,7 +3033,7 @@ usage( void )
>  /* metadata */		[-m crc=[0|1]\n\
>  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>  			    (sunit=value,swidth=value|su=num,sw=num),\n\
> -			    sectlog=n|sectsize=num\n\
> +			    noalign, sectlog=n|sectsize=num\n\

SUPER nitpick, but other options don't have a space after the comma.

And noalign is exclusive to sunit/sw options (right?), so maybe the
output should look like:

/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,
			    (sunit=value,swidth=value|su=num,sw=num|noalign),
			    sectlog=n|sectsize=num

also: I think it's hilarious that we emit C comment strings in usage() ;)

-Eric

>  /* force overwrite */	[-f]\n\
>  /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
>  			    projid32bit=0|1]\n\
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
