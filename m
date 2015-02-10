Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBBF57FAB
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 16:19:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB00B304043
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2015 14:19:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rxUF82cos6XQPuqB for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2015 14:19:31 -0800 (PST)
Date: Wed, 11 Feb 2015 09:19:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfsprogs: Adding XFS_IOC_FIEMAPFS ioctl for use in
	xfs_spaceman
Message-ID: <20150210221914.GQ4251@dastard>
References: <54ca361b.6841460a.02cf.3cca@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ca361b.6841460a.02cf.3cca@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 07:01:02PM +0530, Dhruvesh Rathore wrote:
> 
> This patch is concerned with the changes to be done in userspace code for
> turning FS_IOC_FIEMAPFS present in the earlier version of xfs_spaceman 
> into an XFS specific ioctl called XFS_IOC_FIEMAPFS, which uses all existing
> fiemap insfrastructure.
> By introducing XFS_IOC_FIMEAPFS ioctl, it can be seperated from file based
> fiemap commands and allows us to review it and push it as we need, making the
> process much simpler.
.....
>  typedef struct histent
> @@ -201,9 +201,9 @@
>  		fiemap->fm_length = length;
>  		fiemap->fm_extent_count = NR_EXTENTS;
>  
> -		ret = ioctl(file->fd, FS_IOC_FIEMAPFS, (unsigned long)fiemap);
> +		ret = xfsctl(file->name,file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
> 		if (ret < 0) {
  ^
Patch hunk is corrupt: it is missing the leading whitespace to
indicate "no change on this line".

I've fixed it up to apply the patch.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
