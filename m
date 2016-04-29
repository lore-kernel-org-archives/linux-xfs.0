Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FE987D06
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 14:11:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E46E8F8037
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 12:11:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rLDlM2xQ9vVG4VcY for <xfs@oss.sgi.com>;
	Fri, 29 Apr 2016 12:11:38 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 72CE12A83
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 14:11:38 -0500 (CDT)
Subject: Re: [PATCH 15/19 v3] mkfs: don't treat files as though they are block
	devices
References: <1461311383-30897-1-git-send-email-jtulak@redhat.com>
	<1461941267-31556-1-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ab11d986-a605-4070-9932-eb9dc3e9cff0@sandeen.net>
Date: Fri, 29 Apr 2016 14:11:38 -0500
MIME-Version: 1.0
In-Reply-To: <1461941267-31556-1-git-send-email-jtulak@redhat.com>
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



On 4/29/16 9:47 AM, Jan Tulak wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the device is actually a file, and "-d file" is not specified,
> mkfs will try to treat it as a block device and get stuff wrong.
> Image files don't necessarily have the same sector sizes as the
> block device or filesystem underlying the image file, nor should we
> be issuing discard ioctls on image files.
> 
> To fix this sanely, only require "-d file" if the device name is
> invalid to trigger creation of the file. Otherwise, use stat() to
> determine if the device is a file or block device and deal with that
> appropriately by setting the "isfile" variables and turning off
> direct IO. Then ensure that we check the "isfile" options before
> doing things that are specific to block devices.
> 
> Other file/blockdev issues fixed:
> 	- use getstr to detect specifying the data device name
> 	  twice.
> 	- check file/size/name parameters before anything else.
> 	- overwrite checks need to be done before the image file is
> 	  opened and potentially truncated.
> 	- blkid_get_topology() should not be called for image files,
> 	  so warn when it is called that way.
> 	- zero_old_xfs_structures() emits a spurious error:
> 		"existing superblock read failed: Success"
> 	  when it is run on a truncated image file. Don't warn if we
> 	  see this problem on an image file.
> 	- Don't issue discards on image files.
> 	- Use fsync() for image files, not BLKFLSBUF in
> 	  platform_flush_device() for Linux.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> ---
> CHANGES:
> * read image file size in advance of O_TRUNC in case of dfile&&dcreat
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  libxfs/init.c   |  21 ++++++-
>  libxfs/linux.c  |  11 +++-
>  mkfs/xfs_mkfs.c | 182 ++++++++++++++++++++++++++++++++++++++------------------
>  3 files changed, 154 insertions(+), 60 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 8d747e8..c7ae00d 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -253,8 +253,15 @@ libxfs_init(libxfs_init_t *a)
>  	rtname = a->rtname;
>  	a->dfd = a->logfd = a->rtfd = -1;
>  	a->ddev = a->logdev = a->rtdev = 0;
> -	a->dbsize = a->lbsize = a->rtbsize = 0;
> -	a->dsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
> +	a->lbsize = a->rtbsize = 0;
> +	a->logBBsize = a->logBBstart = a->rtsize = 0;
> +
> +	// We can reset dbsize only when it is not a file, or we won't
> +	// truncate it. Otherwise, we loose the size of the file forever.

please don't use c++ comments in xfsprogs, we use /* comments */

...

>  static void
> +check_device_type(
> +	const char	*name,
> +	int		*isfile,
> +	bool		no_size,
> +	bool		no_name,
> +	int		*create,
> +	bool		force_overwrite,
> +	const char	*optname)
> +{
> +	struct stat64 statbuf;
> +	/*
> +	if (*isfile && (no_size || no_name)) {
> +		fprintf(stderr,
> +	_("if -%s file then -%s name and -%s size are required\n"),
> +			optname, optname, optname);
> +		usage();
> +	}*/

What is this?

Jan, I'm just going to go back to the original patches posted in your V2 series,
and either give them Reviewed-by's, or send followup fix-up patches with a

Eric Sandeen <sandeen@redhat.com>: fixed up foo, bar, baz

tag and a Reviewed-by to go with it, I think that might be the fastest path to
finally getting this stuff merged.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
