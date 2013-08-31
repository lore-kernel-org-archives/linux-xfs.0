Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 842E87F37
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 20:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DFAE8F804B
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 18:23:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SYPkYw8N7aCBbYds for <xfs@oss.sgi.com>;
	Fri, 30 Aug 2013 18:23:50 -0700 (PDT)
References: <1377882590-22852-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1377882590-22852-1-git-send-email-cmaiolino@redhat.com>
Message-Id: <9C022AEE-245C-4E07-ADFB-155F34D5DC59@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V3] mkfs: add noalign option to usage()
Date: Fri, 30 Aug 2013 20:23:47 -0500
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Aug 30, 2013, at 12:09 PM, Carlos Maiolino <cmaiolino@redhat.com> wrote:

> Although it has been added to manpage, there is no information about the
> existence of noalign option into the usage().
> 
> Changelog:
> 
> V2: Remove space in comma separated options
> V3: Aligned the option together with another alignment options to make mutual
>    exclusive options more visible
> 
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> mkfs/xfs_mkfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4bdacee..b0c3ce5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3032,7 +3032,7 @@ usage( void )
> /* blocksize */        [-b log=n|size=num]\n\
> /* metadata */        [-m crc=[0|1]\n\
> /* data subvol */    [-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
> -                (sunit=value,swidth=value|su=num,sw=num),\n\
> +                (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>                sectlog=n|sectsize=num\n\
> /* force overwrite */    [-f]\n\
> /* inode size */    [-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> -- 
> 1.8.1.4
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
