Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9NI74gZ225536 for <xfs@oss.sgi.com>; Fri, 23 Oct 2009 13:07:04 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 1/2]  add lpath_to_handle to libhandle
Date: Fri, 23 Oct 2009 13:08:37 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE08@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <4AE08DC7.7000200@sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

Bill Kendall wrote:
> path_to_handle() is not reliable when called on a path which
> is a symlink. If the symlink is dangling, or if its points
> to a non-XFS filesystem then path_to_handle() will fail. The
> reason is that path_to_handle() must open the path in order
> to obtain an fd for the xfsctl call.
> 
> It's common during xfsrestore to have dangling symlinks since
> the target of the link may not be restored before the symlink.
> 
> This patch adds a new function to libhandle, lpath_to_handle.
> It is just like path_to_handle, except it takes a filesystem
> path in addition to the path which you want convert to a
> handle.
> 
> Alex Elder is going to take care of bumping the libhandle
> minor number, and adjusting the xfsdump/xfsprogs version numbers
> and dependencies to ensure a compatible libhandle is installed
> for xfsdump.

Looks good.  I will up the version number after get this pulled in.
I will publish this and get the version number/dependency stuff
straightened out before I take the change for xfsrestore.

					-Alex

> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/include/handle.h b/include/handle.h
> index b211a2f..3f1a137 100644
> --- a/include/handle.h
> +++ b/include/handle.h
> @@ -27,6 +27,8 @@ struct attrlist_cursor;
>   struct parent;
> 
>   extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
> +extern int  lpath_to_handle (char *__fspath, char *__path,
> +			     void **__hanp, size_t *__hlen);
>   extern int  path_to_fshandle (char *__path, void **__fshanp, size_t *__fshlen);
>   extern int  handle_to_fshandle (void *__hanp, size_t __hlen, void **__fshanp,
>   				size_t *__fshlen);
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index 6276797..6c9380d 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -111,16 +111,29 @@ path_to_handle(
>   	void		**hanp,		/* output, pointer to data */
>   	size_t		*hlen)		/* output, size of returned data */
>   {
> +	return lpath_to_handle(path, path, hanp, hlen);
> +}
> +
> +/* Like path_to_handle, but reliable for paths which are either dangling
> + * symlinks or symlinks whose targets are not in XFS filesystems.
> + */
> +int
> +lpath_to_handle(
> +	char		*fspath,	/* input,  path in filesystem */
> +	char		*path,		/* input,  path to convert */
> +	void		**hanp,		/* output, pointer to data */
> +	size_t		*hlen)		/* output, size of returned data */
> +{
>   	int		fd;
>   	int		result;
>   	comarg_t	obj;
> 
> -	fd = open(path, O_RDONLY);
> +	fd = open(fspath, O_RDONLY);
>   	if (fd < 0)
>   		return -1;
> 
>   	obj.path = path;
> -	result = obj_to_handle(path, fd, XFS_IOC_PATH_TO_HANDLE,
> +	result = obj_to_handle(fspath, fd, XFS_IOC_PATH_TO_HANDLE,
>   				obj, hanp, hlen);
>   	close(fd);
>   	return result;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
