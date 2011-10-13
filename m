Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DJp9aj204167 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 14:51:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C5901C537E
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 12:51:07 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 9GwSvIfQfLn5ohEL for <xfs@oss.sgi.com>;
	Thu, 13 Oct 2011 12:51:07 -0700 (PDT)
Message-ID: <4E974129.3010708@sandeen.net>
Date: Thu, 13 Oct 2011 14:51:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: libxfs: Don't forget to initialize the radix
	tree subsystem
References: <201110131850.p9DIoEvU006578@stout.americas.sgi.com>
In-Reply-To: <201110131850.p9DIoEvU006578@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On 10/13/11 1:50 PM, Alex Elder wrote:
> The libxfs code uses radix tree routines to manage a mount
> point's m_perag_tree.  But the radix tree routines assume
> that radix_tree_init() has been called to initialize the
> height_to_maxindex[] global array, and this was not being
> done.
> 
> This showed up when running mkfs.xfs on an ia64 system.  Since
> it wasn't initialized, the array was filled with zeroes.  The
> first time radix_tree_extend() got called (with index 0), the
> height would be set to 1 and all would seem fine.
> 
> The *second* time it got called (with index 1) a problem would
> arise--though we were apparently "lucky" enough for it not to
> matter.  The following loop would simply reference invalid slots
> beyond the end of the array until it happened upon one that was
> non-zero.  (I've expanded the function radix_tree_maxindex() here.)
> 
>         /* Figure out what the height should be.  */
>         height = root->height + 1;
>         while (index > height_to_maxindex[height])
>                 height++;
> 
> As an example, this looped 1937 times before it found a non-zere
> value that would cause it to break out of the loop.
> 
> Even that *seemed* to be OK.  But at the end of mkfs.xfs, when
> it calls libxfs_umount(), non-initialized "slots" are dereferenced
> and we hit a fault.
> 
> Wow.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

I suppose if we have an init function we may as well call it at
least once.  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/init.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/libxfs/init.c
> ===================================================================
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -249,6 +249,8 @@ libxfs_init(libxfs_init_t *a)
>  	fd = -1;
>  	flags = (a->isreadonly | a->isdirect);
>  
> +	radix_tree_init();
> +
>  	if (a->volname) {
>  		if(!check_open(a->volname,flags,&rawfile,&blockfile))
>  			goto done;
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
