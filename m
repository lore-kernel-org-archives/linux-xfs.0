Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B995A7F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 10:35:50 -0500 (CDT)
Message-ID: <51C32157.9010403@sgi.com>
Date: Thu, 20 Jun 2013 10:35:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/60] xfs: update mount options documentation
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-2-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/18/13 23:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Because it's horribly out of date.
>
> And mark various deprecated options as deprecated and give them a
> removal date.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   Documentation/filesystems/xfs.txt |  317 ++++++++++++++++++++++++-------------
>   1 file changed, 209 insertions(+), 108 deletions(-)
>
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 83577f0..12525b1 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -18,6 +18,8 @@ Mount Options
>   =============
>
>   When mounting an XFS filesystem, the following options are accepted.
> +For boolean mount options, the names with the (*) suffix is the
> +default behaviour.
>
>     allocsize=size
>   	Sets the buffered I/O end-of-file preallocation size when
> @@ -25,97 +27,128 @@ When mounting an XFS filesystem, the following options are accepted.
>   	Valid values for this option are page size (typically 4KiB)
>   	through to 1GiB, inclusive, in power-of-2 increments.
>
> -  attr2/noattr2
> -	The options enable/disable (default is disabled for backward
> -	compatibility on-disk) an "opportunistic" improvement to be
> -	made in the way inline extended attributes are stored on-disk.
> -	When the new form is used for the first time (by setting or
> -	removing extended attributes) the on-disk superblock feature
> -	bit field will be updated to reflect this format being in use.
> +	The default behaviour is for dynamic end-of-file
> +	preallocation size, which uses a set of heuristics to
> +	optimise the preallocation size based on the current
> +	allocation patterns within the file and the access patterns
> +	to the file. Specifying a fixed allocsize value turns off
> +	the dynamic behaviour.
> +
> +  attr2
> +  noattr2
> +	The options enable/disable an "opportunistic" improvement to
> +	be made in the way inline extended attributes are stored
> +	on-disk.  When the new form is used for the first time when
> +	attr2 is selected (either when setting or removing extended
> +	attributes) the on-disk superblock feature bit field will be
> +	updated to reflect this format being in use.
> +
> +	The default behaviour is determined by the on-disk feature
> +	bit indicating that attr2 behaviour is active. If either
> +	mount option it set, then that becomes the new default used
> +	by the filesystem.
>
>   	CRC enabled filesystems always use the attr2 format, and so
>   	will reject the noattr2 mount option if it is set.
>

Thanks for doing this.

allocsize and attr/noattr seem a bit too run-on for me, *but* we all 
have our writing style; mine is terrible so you can ignore the below if 
you want. The "(?)" are added if the noattr2 command is also added.

Rest looks good to me and consider it:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

   allocsize=size
         Sets the buffered I/O end-of-file preallocation size when
         doing delayed allocation writeout. The default size is 64KiB is
         and valid values for this option are page size (typically 4KiB)
         through to 1GiB, inclusive, in power-of-2 increments.

         The default behaviour is to use the dynamic end-of-file
         preallocation size, which uses a set of heuristics to
         optimise the preallocation size based on the current
         allocation patterns within the file and the access patterns
         to the file. Specifying a fixed allocsize value turns off
         the dynamic behaviour.

   attr2
   noattr2
         The options enable/disable the "opportunistic" improvement
         in the way inline extended attributes are stored on-disk.
         When the new attribute storage form is used for the first time
         (that usuage may be either when setting or removing extended
         attributes) after selecting (?one of ?) the attr2 (? or noattr2?)
         option(?s), the on-disk superblock feature bit field will be 
updated
         to reflect this is the format to be used.

         The default behaviour is determined by the on-disk feature
         bit indicating that attr2 behaviour is active. If either
         mount option it set, then that becomes the new default used
         by the filesystem.

         CRC enabled filesystems always use the attr2 format, and so
         will reject the noattr2 mount option if it is set.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
