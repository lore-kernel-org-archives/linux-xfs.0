Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28Ldt3t088092 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 15:39:55 -0600
Message-ID: <4F592728.9060706@sgi.com>
Date: Thu, 08 Mar 2012 15:39:52 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: deprecate the "-F" foreign flag
References: <4F2AC948.1050909@redhat.com>
In-Reply-To: <4F2AC948.1050909@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 02/02/12 11:35, Eric Sandeen wrote:
> There's no real reason to force the user to specify "-F" for non-xfs
> files, when we can just test for that after it's opened.
>
> * Remove the -F flag from usage()&  man pages, but still accept it.
> * Set IO_FOREIGN when we open the file, if the fd tests as non-xfs.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---



> diff --git a/io/open.c b/io/open.c
> index f1a6501..97631e2 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -163,17 +163,9 @@ openfile(
>   		}
>   	}
>
> -	if (!geom)
> +	if (!platform_test_xfs_fd(fd))
>   		return fd;
>
> -	if (!platform_test_xfs_fd(fd)) {
> -		fprintf(stderr, _("%s: specified file "
> -			"[\"%s\"] is not on an XFS filesystem\n"),
> -			progname, path);
> -		close(fd);
> -		return -1;
> -	}
> -
>   	if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom)<  0) {
>   		perror("XFS_IOC_FSGEOMETRY");
>   		close(fd);
> @@ -282,10 +274,10 @@ open_f(
>   		return 0;
>   	}
>
> -	while ((c = getopt(argc, argv, "FRacdfm:nrstx")) != EOF) {
> +	while ((c = getopt(argc, argv, "Racdfm:nrstx")) != EOF) {
>   		switch (c) {
>   		case 'F':
> -			flags |= IO_FOREIGN;
> +			/* Ignored / deprecated now, handled automatically */
>   			break;


The "-F" is still in the command line open's help in open.

cxfs_io> help open
open [-acdrstx] [path] -- open the file specified by path

  opens a new file in the requested mode

  Example:
  'open -cd /tmp/data' - creates/opens data file read-write for direct IO

  Opens a file for subsequent use by all of the other xfs_io commands.
  With no arguments, open uses the stat command to show the current file.
  -F -- foreign filesystem file, disallow XFS-specific commands
  -a -- open with the O_APPEND flag (append-only mode)
  -d -- open with O_DIRECT (non-buffered IO, note alignment constraints)
  -f -- open with O_CREAT (create the file if it doesn't exist)
  -m -- permissions to use in case a new file is created (default 0600)
  -n -- open with O_NONBLOCK
  -r -- open with O_RDONLY, the default is O_RDWR
  -s -- open with O_SYNC
  -t -- open with O_TRUNC (truncate the file to zero length if it exists)
  -R -- mark the file as a realtime XFS file immediately after opening it
  Note1: usually read/write direct IO requests must be blocksize aligned;
         some kernels, however, allow sectorsize alignment for direct IO.
  Note2: the bmap for non-regular files can be obtained provided the file
         was opened correctly (in particular, must be opened read-only).


The "F" was taken out of the command line's getopt(), so it can't be 
specified. I guess either put the "F" back in the the open.c getopt() or 
take it complete from the command line.

xfs_io> open -F somefile
open: invalid option -- 'F'
open [-acdrstx] [path] -- open the file specified by path

Thanks,

--Mark Tinguely
tinguely@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
