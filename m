Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755071AbeFNQn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 12:43:28 -0400
Date: Thu, 14 Jun 2018 09:43:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/2] mkfs: manpage fixups in config file section
Message-ID: <20180614164325.GA8128@magnolia>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <bc2a4277-cbe2-c3e7-ad92-e2a67f9102cf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc2a4277-cbe2-c3e7-ad92-e2a67f9102cf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 14, 2018 at 10:43:37AM -0500, Eric Sandeen wrote:
> A bit more clarification in the CONFIGURATION FILE FORMAT
> section of the mkfs.xfs manpage.
> 
> Primarily, map the commandline switches to the section names
> explicitly.
> 
> "optional default" sounds pretty weird, so call it the
> "defaults" configuration file instead.
> 
> Document the comment format by example.
> 
> Fix the sparse inode default setting in the example.
> 
> Change the .BI tags to .B (there is no bold/italic switching).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index cf4bdf8..9c0c1a8 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -957,53 +957,61 @@ Do not attempt to discard blocks at mkfs time.
>  .B \-V
>  Prints the version number and exits.
>  .SH CONFIGURATION FILE FORMAT
> -The optional default configuration file in
> +The optional defaults configuration file in
>  .B @sysconfdir@/xfs/mkfs/default
>  as well as any alternate configuration file specified via the
>  .B \-c
> -option follow a simple ini-style format as shown below.
> -Available options consist of a small subset of the parameters available
> -via the
> -.BR mkfs.xfs (8)
> -command line.
> -Currently all default parameters can only be either enabled or disabled,
> +option follow a simple ini-style format as shown below, with section names
> +corresponding to command-line options as follows:
> +.BR "\-d [data]" ,
> +.BR "\-i [inode]" ,
> +.BR "\-l [log]" ,
> +.BR "\-m [metadata]" ,
> +.BR "\-n [naming]" ,
> +.BR "\-r [rtdev]" .
> +.br
> +In each of these sections, a subset of the command-line suboptions may be
> +specified to override built-in default settings.
> +Currently all parameters can only be either enabled or disabled,
>  with a value of 1 to enable or 0 to disable.
>  See below for a list of all supported configuration parameters and their
>  current built-in default settings.
>  .PP
> -.BI [data]
> +.B # Comments and blank lines  are allowed
> +.br
> +.B [data]
>  .br
> -.BI noalign=0
> +.B noalign=0
>  .PP
> -.BI [inode]
> +.B [inode]
>  .br
> -.BI align=1
> +.B align=1
>  .br
> -.BI projid32bit=1
> +.B projid32bit=1
>  .br
> -.BI sparse=0
> +.B sparse=1
>  .PP
> -.BI [log]
> +.B [log]
>  .br
> -.BI lazy-count=1
> +.B lazy-count=1
>  .PP
> -.BI [metadata]
> +.B [metadata]
>  .br
> -.BI crc=1
> +.B crc=1
>  .br
> -.BI finobt=1
> +.B finobt=1
>  .br
> -.BI rmapbt=0
> +.B rmapbt=0
>  .br
> -.BI reflink=0
> +.B reflink=0
>  .PP
> -.BI [naming]
> +.B [naming]
>  .br
> -.BI ftype=1
> +.B ftype=1
>  .PP
> -.BI [rtdev]
> +.B [rtdev]
>  .br
> -.BI noalign=0
> +.B noalign=0

I would add a note that configuration files are still considered an
experimental feature.  With that,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  .PP
>  .SH SEE ALSO
>  .BR xfs (5),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
