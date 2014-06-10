Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F09CA7F55
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 16:54:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2519304039
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 14:54:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FdGymZzsPUXtenWV for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 14:54:34 -0700 (PDT)
Date: Wed, 11 Jun 2014 07:54:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140610215420.GI9508@dastard>
References: <20140609223320.GE9508@dastard> <20140610060944.GG9508@dastard>
	<53971184.50008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53971184.50008@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Jun 10, 2014 at 09:09:08AM -0500, Eric Sandeen wrote:
> On 6/10/14, 1:09 AM, Dave Chinner wrote:
> 
> > There is a new version of this work (Eric's patches and the base
> > libxfs restructure) here:
> > 
> > 	git://oss.sgi.com/xfs/xfs.git xfs-libxfs-restructure
> > 
> > It's based on 3.15 with the current for-next branch merged into it
> > and then the changes done over the top, so it's about as up-to-date
> > as it can be. Comments welcome...
> 
> Comment 1: doesn't build ;)
> 
> 
> make[1]: *** No rule to make target `fs/xfs/xfs_dir2_readdir.o', needed by `fs/xfs/xfs.o'.  Stop.
> make[1]: *** Waiting for unfinished jobs....
>   CC [M]  fs/xfs/xfs_buf.o
> make: *** [_module_fs/xfs] Error 2

Ah, that's an issue....

> problems w/ xfs_rtbitmap.o as well, patch follows.
> 
> Comment 2: Coverity thinks this adds about 25 defects, I'll have to go
> look at why...

Probably because it ignores issues based on path/filename, and the
path changed...

> 
> -Eric
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index a22a6b8..0b7b3b3 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -43,6 +43,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_dir2_data.o \
>  				   xfs_dir2_leaf.o \
>  				   xfs_dir2_node.o \
> +				   xfs_dir2_readdir.o \

No, the xfs_dir2_readdir.c file should not have been moved - it's
kernel only functionality.

>  				   xfs_dir2_sf.o \
>  				   xfs_dquot_buf.o \
>  				   xfs_ialloc.o \
> @@ -55,6 +56,9 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_trans_resv.o \
>  				   )
>  
> +xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
> +				   xfs_rtbitmap.o \
> +				   )

But that needs fixing, yes.

Makes me wonder why it linked here - must have found stale .o files
in the build area and linked them even though the files didn't get
built.

Anyway, I'll fix it, and restart the errno negation rebase....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
