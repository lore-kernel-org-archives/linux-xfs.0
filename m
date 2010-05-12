Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4CMJc87184149 for <xfs@oss.sgi.com>; Wed, 12 May 2010 17:19:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3E1413BADDA
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 15:21:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	G4WPsm3msIII4d4M for <xfs@oss.sgi.com>;
	Wed, 12 May 2010 15:21:50 -0700 (PDT)
Date: Thu, 13 May 2010 08:21:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: open_by_handle on a file ?
Message-ID: <20100512222147.GD13617@dastard>
References: <4BEACBC0.3080300@cea.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BEACBC0.3080300@cea.fr>
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
To: DENIEL Philippe <philippe.deniel@CEA.FR>
Cc: xfs@oss.sgi.com

On Wed, May 12, 2010 at 05:39:44PM +0200, DENIEL Philippe wrote:
> Hi,
> 
> I start using libhandle.so from xfsprogs-3.0.3 package. I meet an
> issue here : I can get a handle from files or directory.
> When used on diretories, open_by_handle works fine : I can read
> entries in it by using getdents, create stuff / removing stuff by
> using the ATFILE_FUNCTION (mkdirat, renameat, ...)
> 
> Trouble start when I want to open a file with open_by_handle. I have
> a small test program that does this :
> 
>        rc = path_to_fshandle( path_dir,  (void **)(&fshandle),
>    &fshandlelen) ;
>      if( rc < 0 ) exit( -1)
>      rc = path_to_handle( path_dir,  (void **)(&filehandle), &handlelen) ;
>      if( rc < 0 ) exit( -1 )
> 
>      fd = open_by_handle( filehandle, handlelen, O_RDONLY ) ;
>      printf( "open_by_handle: fd=%d \n", fd ) ;
>      if( fd < 0 )
>           printf( "----> Error=%d | %s\n", errno, strerror( errno ) ) ;
> 
> The open_by_handle failed with errno=20 aka ENOTDIR, which is true,
> this is a file and no directory.

I think that is because the path_dir points to a regular file and
so path_to_fshandle() is generating a fshandle that points to a file
instead of a directory. This handle is cached inside libhandle, and
then use for subsequent handle calls like open_by_handle(). The
kernel rejects the request is the fshandle does not point to a
directory.

Try using the mount point or a directory within the mount for
the path_to_fshandle() call and see if that fixes the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
