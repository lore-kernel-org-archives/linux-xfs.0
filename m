Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDB887F58
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 06:41:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC9518F8052
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 04:41:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Zz9UrCGV2342gatg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Aug 2014 04:41:17 -0700 (PDT)
Date: Fri, 22 Aug 2014 07:35:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: lseek: the "whence" argument is called "whence"
Message-ID: <20140822113550.GE3152@laptop.bfoster>
References: <53F55765.6030205@redhat.com> <53F64723.4070001@sandeen.net>
	<53F648CC.9080604@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F648CC.9080604@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 02:30:20PM -0500, Eric Sandeen wrote:
> For some reason, the older commit:
> 
>     965c8e5 lseek: the "whence" argument is called "whence"
> 
>     lseek: the "whence" argument is called "whence"
>     
>     But the kernel decided to call it "origin" instead.
>     Fix most of the sites.
> 
> left out xfs.  So fix xfs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1da3b7d..0fe36e4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1322,16 +1322,16 @@ STATIC loff_t
>  xfs_file_llseek(
>  	struct file	*file,
>  	loff_t		offset,
> -	int		origin)
> +	int		whence)
>  {
> -	switch (origin) {
> +	switch (whence) {
>  	case SEEK_END:
>  	case SEEK_CUR:
>  	case SEEK_SET:
> -		return generic_file_llseek(file, offset, origin);
> +		return generic_file_llseek(file, offset, whence);
>  	case SEEK_HOLE:
>  	case SEEK_DATA:
> -		return xfs_seek_hole_data(file, offset, origin);
> +		return xfs_seek_hole_data(file, offset, whence);
>  	default:
>  		return -EINVAL;
>  	}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
