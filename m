Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96JjG8Z198089 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 14:45:16 -0500
Date: Thu, 6 Oct 2011 15:45:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfsprogs: libxcmd: isolate strdup() calls to
	fs_table_insert()
Message-ID: <20111006194514.GB13434@infradead.org>
References: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
	<0f871eebf39384818415253082320f860739f113.1317646036.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0f871eebf39384818415253082320f860739f113.1317646036.git.aelder@sgi.com>
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

> @@ -95,21 +95,37 @@ fs_table_insert(
>  {
>  	dev_t		datadev, logdev, rtdev;
>  	struct fs_path	*tmp_fs_table;
> -
> -	if (!dir || !fsname)
> -		return EINVAL;
> +	int		error;
>  
>  	datadev = logdev = rtdev = 0;
> -	if (fs_device_number(dir, &datadev))
> -		return errno;
> -	if (fslog && fs_device_number(fslog, &logdev))
> -		return errno;
> -	if (fsrt && fs_device_number(fsrt, &rtdev))
> -		return errno;
> +	error = fs_device_number(dir, &datadev);
> +	if (error)
> +		goto out_nodev;
> +	if (fslog && (error = fs_device_number(fslog, &logdev)))
> +		goto out_nodev;
> +	if (fsrt && (error = fs_device_number(fsrt, &rtdev)))
> +		goto out_nodev;

If you touch these anyway please move assignments outside the
conditionals, e.g.

	 if (fslog) {
	 	error = fs_device_number(fslog, &logdev);
		if (error)
			goto out_nodev;
	}

> -	char		*dir = NULL, *fsname = NULL;
>  	int		error = 0;
>  
> -	if ((fs = fs_mount_point_from_path(udir)) != NULL) {
> -		dir = strdup(udir);
> -		fsname = strdup(fs->fs_name);
> -		if (dir && fsname)
> -			error = fs_table_insert(dir, prid,
> -					FS_PROJECT_PATH, fsname, NULL, NULL);
> -		else
> -			error = ENOMEM;
> +	if ((fs = fs_mount_point_from_path(dir)) != NULL) {

Same here.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
