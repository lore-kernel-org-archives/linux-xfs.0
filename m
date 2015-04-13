Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC1167F47
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 19:25:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9C3A304043
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 17:25:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	04DD0QiQGDSgE4wF for <xfs@oss.sgi.com>;
	Sun, 12 Apr 2015 17:25:45 -0700 (PDT)
Date: Mon, 13 Apr 2015 10:25:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libhandle: document the need for path_to_handle
Message-ID: <20150413002531.GN15810@dastard>
References: <1504091316590.18609@sys953.ldn.framestore.com>
	<20150409133213.214186014@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150409133213.214186014@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Thu, Apr 09, 2015 at 08:31:04AM -0500, tinguely@sgi.com wrote:
> The handle ioctls require an open file descriptor to
> the XFS mount directory. This file descriptor is found
> and supplied in the libhandle code by matching the
> entry added with a path_to_handle() call. Document
> the requirement and supply a simple example.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> 
> ---
>  man/man3/handle.3 |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 69 insertions(+), 1 deletion(-)
> 
> Index: b/man/man3/handle.3
> ===================================================================
> --- a/man/man3/handle.3
> +++ b/man/man3/handle.3
> @@ -74,6 +74,12 @@ The
>  function returns the handle for the filesystem in which the object given by the
>  .I path
>  argument resides.
> +.I path
> +must be the path to the mount point or
> +.BR open_by_handle ()
> +will return the
> +.B ENOTDIR
> +error.

This is wrong. ENOTDIR is only returned by open_by_handle if the
cached fsfd is not a directory - it does not check if it's the root
of a mount point at all. i.e, filesystem root is /mnt/scratch:

$ ls -l /mnt/scratch
total 4
-rw-r--r--.   1 root root    0 Apr 13 09:57 foo
drwxr-xr-x. 102 root root 4096 Apr 11 01:49 quota_dir
$
$ sudo ./fhtest /mnt/scratch /mnt/scratch/foo
open_by_handle: Success
$ sudo ./fhtest /mnt/scratch/foo /mnt/scratch/foo
open_by_handle: Not a directory
$ sudo ./fhtest /mnt/scratch/quota_dir/ /mnt/scratch/foo
open_by_handle: Success

So, as long as the fs path points to a directory on the filesystem
in question, open_by_handle (and all the other handle functions)
works just fine.

>  .PP
>  The
>  .BR fd_to_handle ()
> @@ -95,7 +101,16 @@ The
>  function opens a file descriptor for the object referenced by a handle.
>  It is analogous and identical to
>  .BR open (2)
> -with the exception of accepting handles instead of path names.
> +with the exception of accepting handles instead of path names. The returned
> +file descriptor is opened to do invisible IO. Internally,

Invisible IO is not defined anywhere in the man page, and most
people will have no idea what it means. Either don't mention it, or
define it properly first. For simplicity, I'd just omit it.

> +.BR open_by_handle ()
> +uses the mount point file descriptor that was saved by
> +.BR path_to_fshandle ().
> +Therefore,
> +.BR path_to_fshandle ().
> +must be called before calling

I don't think you need to mention anything about internal
implemenation of libhandle, just that a call to path_to_fshandle()
is required first.

> +.BR open_by_handle ().
> +See below for an example.
>  .PP
>  The
>  .BR readlink_by_handle ()
> @@ -192,6 +207,59 @@ does not exist.
>  .TP
>  .B EPERM
>  The caller does not have sufficient privileges.
> +.SH EXAMPLE
> +Example of
> +.BR open_by_handle ().
> +.PP
> +.Vb 1
> +\& main()
> +.br
> +\& {
> +.br
> +\&	int fd;
> +.br
> +\&	size_t hlen;
> +.br
> +\&	void *han;
> +.br
> +\&	size_t sz_int_used;
> +.br
> +\&	void *hdl_int_used;
> +.br
> +\&	char *mount_path = "/mnt/";
> +.br
> +\&	char *file = "file_to_open";
> +.br
> +\&	if (path_to_handle(file, &han, &hlen) < 0) {
> +.br
> +\&		perror("path-to-handle");
> +.br
> +\&		exit(1);
> +.br
> +\&	}
> +.br
> +\&	/*
> +.br
> +\&	 * path_to_fshandle saves an internal copy of the mount point's
> +.br
> +\&	 * (/mnt in this example) file descriptor. The open_by_handle call
> +.br
> +\&	 * looks up this internal file descriptor and uses it in the
> +.br
> +\&	 * xfsctl call to the kernel. Once path_to_fshandle is called,
> +.br
> +\&	 * this internal file descriptor remains open for the remaining
> +.br
> +\&	 * life of the application.
> +.br
> +\&	 */

Again, this is internal implementation details, so isn't appropriate
for a man page documenting an API.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
