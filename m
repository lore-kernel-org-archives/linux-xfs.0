Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14GjFs5075961 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 10:45:16 -0600
Received: from mx.meyering.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BBC41AF551
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 08:46:25 -0800 (PST)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64]) by
	cuda.sgi.com with ESMTP id irAlCiC5iTYgdhIx for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 08:46:25 -0800 (PST)
From: Jim Meyering <jim@meyering.net>
Subject: Re: [PATCH] mkfs: don't try to detect filesystems on regular files
	via blkid
In-Reply-To: <4B6AF6FC.6030101@redhat.com> (Eric Sandeen's message of "Thu, 04
	Feb 2010 10:34:04 -0600")
References: <4B6AF6FC.6030101@redhat.com>
Date: Thu, 04 Feb 2010 17:46:23 +0100
Message-ID: <878wb9j6e8.fsf@meyering.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=561870
>
> # dd if=/dev/zero of=k bs=1MB count=2 seek=20; mkfs.xfs k
> # mkfs.xfs: probe of k failed, cannot detect existing filesystem.
> # mkfs.xfs: Use the -f option to force overwrite.
>
> blkid fails to do a probe of a regular file.
>
> I wish blkid would cope with this, but for now it might
> be better to just turn it off.
>
> Reported-by: Jim Meyering <meyering@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9baf116..de87647 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -300,10 +300,15 @@ check_overwrite(
>  	int		fd;
>  	long long	size;
>  	int		bsz;
> +	struct stat	statbuf;
>
>  	if (!device || !*device)
>  		return 0;
>
> +	/* blkid can't get info from a regular file */
> +	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
> +		return 0;
> +
>  	ret = -1; /* will reset on success of all setup calls */
>
>  	fd = open(device, O_RDONLY);

Hi Eric,

Did you consider calling fstat after opening,
rather than "stat" before?

        /* blkid can't get info from a regular file */
        if (!fstat(fd, &statbuf) && S_ISREG(statbuf.st_mode)) {
                close(fd);
                return 0;
        }

That's slightly more efficient, and not prone to confusion
in the unlikely event that "device" changes inode between
the stat and the open calls.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
