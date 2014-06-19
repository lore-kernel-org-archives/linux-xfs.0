Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50F537F51
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 08:02:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3ECF3304067
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 06:02:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Rj0tpwifghF8NrD6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Jun 2014 06:02:04 -0700 (PDT)
Date: Thu, 19 Jun 2014 09:02:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] mkfs: add "-m" options to the man page
Message-ID: <20140619130200.GB9043@bfoster.bfoster>
References: <1403156032-18525-1-git-send-email-david@fromorbit.com>
	<1403156032-18525-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403156032-18525-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 19, 2014 at 03:33:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because they are missing.
> 
> Reported-by: Matthias Schniedermeyer <ms@citd.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  man/man8/mkfs.xfs.8 | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 8184e10..4ba07bf 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -7,6 +7,9 @@ mkfs.xfs \- construct an XFS filesystem
>  .B \-b
>  .I block_size
>  ] [
> +.B \-m
> +.I global_metadata_options
> +] [
>  .B \-d
>  .I data_section_options
>  ] [
> @@ -125,6 +128,50 @@ The default value is 4096 bytes (4 KiB), the minimum is 512, and the
>  maximum is 65536 (64 KiB).
>  XFS on Linux currently only supports pagesize or smaller blocks.
>  .TP
> +.BI \-m " global_metadata_options"
> +These options specify metadata format options that either apply to the entire
> +filesystem or aren't easily characterised by a specific functionality group. The
> +valid
> +.I global_metadata_options
> +are:
> +.RS 1.2i
> +.TP
> +.BI crc= value
> +This is used to create a filesystem which maintains and checks CRC information
> +in all metadata objects on disk. The value is either 0 to disable the feature,
> +or 1 to enable the use of CRCs.
> +.IP
> +CRCs enable enhanced error detection due to
> +hardware issues, whilst the format changes also improves crash recovery
> +algorithms and  the ability of various tools to validate and repair metadata
		 ^ extra space

The rest looks good to me. Thanks for writing up the finobt bits!

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +corruptions when they are found.
> +The CRC algorithm used is CRC32c, so the overhead is dependent on CPU
> +architecture as some CPUs have hardware acceleration of this algorithm.
> +Typically the overhead of calculating and checking the CRCs is not noticable in
> +normal operation.
> +.IP
> +By default,
> +.B mkfs.xfs
> +will not enable metadata CRCs.
> +.TP
> +.BI finobt= value
> +This option enables the use of a separate free inode btree index in each
> +allocation group. The value is either 0 to disable the feature, or 1 to create
> +a free inode btree in each allocation group.
> +.IP
> +The free inode btree mirrors the existing allocated inode btree index which
> +indexes both used and free inodes. The free inode btree does not index used
> +inodes, allowing faster, more consistent inode allocation performance as
> +filesystems age.
> +.IP
> +By default,
> +.B mkfs.xfs
> +will not create free inode btrees. This feature is also currently only available
> +for filesystems created with the
> +.B \-m crc=1
> +option set.
> +.RE
> +.TP
>  .BI \-d " data_section_options"
>  These options specify the location, size, and other parameters of the
>  data section of the filesystem. The valid
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
