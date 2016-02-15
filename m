Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7A9629DF5
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 17:46:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E911AC003
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 15:46:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qdC7rGBR6RLlwPsZ for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 15:46:15 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 62A1963C5FF0
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 17:46:15 -0600 (CST)
Subject: Re: [PATCH 3/3] xfs_io: add support for changing the new inode DAX
	attribute
References: <1455514346-15481-1-git-send-email-david@fromorbit.com>
	<1455514346-15481-4-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C26346.6070609@sandeen.net>
Date: Mon, 15 Feb 2016 17:46:14 -0600
MIME-Version: 1.0
In-Reply-To: <1455514346-15481-4-git-send-email-david@fromorbit.com>
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

On 2/14/16 11:32 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is changed via the FS_IOC_FSSETXATTR ioctl, so add the new flag
> to the platform definitions for  userspace that don't this API. Then
> add support to the relevant xfs_io chattr and stat commands.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/darwin.h  | 1 +
>  include/freebsd.h | 1 +
>  include/irix.h    | 1 +
>  include/linux.h   | 1 +
>  io/attr.c         | 5 ++++-
>  5 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/darwin.h b/include/darwin.h
> index 2baa536..a52030d 100644
> --- a/include/darwin.h
> +++ b/include/darwin.h
> @@ -312,6 +312,7 @@ struct fsxattr {
>  #define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
>  #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
>  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> +#define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
>  #define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
> diff --git a/include/freebsd.h b/include/freebsd.h
> index fe567d4..f7e0c75 100644
> --- a/include/freebsd.h
> +++ b/include/freebsd.h
> @@ -202,6 +202,7 @@ struct fsxattr {
>  #define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
>  #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
>  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> +#define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
>  #define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
> diff --git a/include/irix.h b/include/irix.h
> index bdb4b6a..c2191ee 100644
> --- a/include/irix.h
> +++ b/include/irix.h
> @@ -447,6 +447,7 @@ struct fsxattr {
>  #define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
>  #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
>  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> +#define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
>  #define FS_IOC_FSGETXATTR		F_FSGETXATTR
> diff --git a/include/linux.h b/include/linux.h
> index 17391c3..cc0f70c 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -205,6 +205,7 @@ struct fsxattr {
>  #define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
>  #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
>  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> +#define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
>  #define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
> diff --git a/io/attr.c b/io/attr.c
> index 6fa08bf..0186b1d 100644
> --- a/io/attr.c
> +++ b/io/attr.c
> @@ -47,9 +47,10 @@ static struct xflags {
>  	{ FS_XFLAG_EXTSZINHERIT,	"E", "extsz-inherit"	},
>  	{ FS_XFLAG_NODEFRAG,		"f", "no-defrag"	},
>  	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
> +	{ FS_XFLAG_DAX,			"x", "dax"		},
>  	{ 0, NULL, NULL }
>  };
> -#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfS"
> +#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSx"
>  
>  static void
>  lsattr_help(void)
> @@ -73,6 +74,7 @@ lsattr_help(void)
>  " E -- children created in this directory inherit the extent size value\n"
>  " f -- do not include this file when defragmenting the filesystem\n"
>  " S -- enable filestreams allocator for this directory\n"
> +" x -- Use direct access (DAX) for data in this file\n"
>  "\n"
>  " Options:\n"
>  " -R -- recursively descend (useful when current file is a directory)\n"
> @@ -108,6 +110,7 @@ chattr_help(void)
>  " +/-E -- set/clear the extent-size inheritance flag\n"
>  " +/-f -- set/clear the no-defrag flag\n"
>  " +/-S -- set/clear the filestreams allocator flag\n"
> +" +/-x -- set/clear the direct access (DAX) flag\n"
>  " Note1: user must have certain capabilities to modify immutable/append-only.\n"
>  " Note2: immutable/append-only files cannot be deleted; removing these files\n"
>  "        requires the immutable/append-only flag to be cleared first.\n"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
