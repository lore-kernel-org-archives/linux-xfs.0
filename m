Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60266 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeCTTz4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 15:55:56 -0400
Subject: Re: [PATCH 2/4] libfrog: fs_table_lookup_mount should realpath the
 argument
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151531216.18312.5625644435478815432.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <382b94f4-e12d-a8d7-058d-22ab71bbaaad@sandeen.net>
Date: Tue, 20 Mar 2018 14:55:55 -0500
MIME-Version: 1.0
In-Reply-To: <152151531216.18312.5625644435478815432.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/19/18 10:08 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Call realpath on the dir argument so that we're comparing canonical
> paths when looking for the mountpoint.  This fixes the problem where
> '/home/' doesn't match '/home' even though they refer to the same thing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yeah, not sure why this wasn't done.  This stuff always seems fiddly
but I can't see anything wrong with doing this, soooo

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libfrog/paths.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index 62b4eda..19ee1ea 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -102,16 +102,19 @@ fs_table_lookup_mount(
>  	uint		i;
>  	dev_t		dev = 0;
>  	char		rpath[PATH_MAX];
> +	char		dpath[PATH_MAX];
>  
>  	if (fs_device_number(dir, &dev))
>  		return NULL;
> +	if (!realpath(dir, dpath))
> +		return NULL;
>  
>  	for (i = 0; i < fs_count; i++) {
>  		if (fs_table[i].fs_flags != FS_MOUNT_POINT)
>  			continue;
>  		if (!realpath(fs_table[i].fs_dir, rpath))
>  			continue;
> -		if (strcmp(rpath, dir) == 0)
> +		if (strcmp(rpath, dpath) == 0)
>  			return &fs_table[i];
>  	}
>  	return NULL;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
