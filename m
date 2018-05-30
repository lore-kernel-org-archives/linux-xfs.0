Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932394AbeE3WIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 18:08:53 -0400
Date: Wed, 30 May 2018 15:08:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3.5/4 V2] mkfs.xfs: document defaults config file details
Message-ID: <20180530220830.GX837@magnolia>
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-4-mcgrof@kernel.org>
 <7f30d5cb-800e-13a2-9ad7-d884cebc31e4@sandeen.net>
 <cbffce6a-718b-6a0a-e78d-043999053bd1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbffce6a-718b-6a0a-e78d-043999053bd1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Wed, May 30, 2018 at 03:51:48PM -0500, Eric Sandeen wrote:
> Document the mkfs default config file behavior.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: implement most of darrick's suggestions
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..ca8c775 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -4,6 +4,10 @@ mkfs.xfs \- construct an XFS filesystem
>  .SH SYNOPSIS
>  .B mkfs.xfs
>  [
> +.B \-c
> +.I configuration
> +] [
> +[
>  .B \-b
>  .I block_size_options
>  ] [
> @@ -121,8 +125,41 @@ when parameters are quantified in those units.
>  .PP
>  Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
> +.SH DEFAULT VALUES
> +.BR mkfs.xfs (8)
> +contains built-in default values for every option as described in the sections
> +below.
> +These built-in defaults may evolve over time as new capabilities are added.
> +If the file
> +.B /etc/xfs/mkfs/default
> +exists, it will be parsed to override built-in defaults, and the defaults
> +described in sections below may no longer apply.
> +.PP
> +The
> +.B \-c
> +option may also be used to specify an alternate configuration file
> +as described in the OPTIONS section.
>  .SH OPTIONS
>  .TP
> +.BI \-c " configuration"
> +This option may be used to specify a configuration file other than
> +.B /etc/xfs/mkfs/default
> +to override selected built-in parameter defaults.
> +If
> +.B configuration
> +is a simple filename with no path components, it will be searched in the
> +.B /etc/xfs/mkfs/
> +directory.
> +If
> +.B configuration
> +is an absolute pathname, that path will be used to find the configuration file.
> +Otherwise, if
> +.B configuration
> +begins with
> +.BR \'./\' " or " \'../\'
> +it will be treated as a pathname relative to the current working directory.
> +See also the CONFIGURATION FILE FORMAT section below.
> +.TP
>  .BI \-b " block_size_options"
>  This option specifies the fundamental block size of the filesystem.
>  The valid
> @@ -920,6 +957,55 @@ Do not attempt to discard blocks at mkfs time.
>  .TP
>  .B \-V
>  Prints the version number and exits.
> +.SH CONFIGURATION FILE FORMAT
> +The optional default configuration file in
> +.B /etc/xfs/mkfs/default
> +as well as any alternate configuration file specified via the
> +.B \-c
> +option must follow a simple ini-style format as shown below.
> +Available options consist of a subset of the parameters available
> +via the
> +.BR mkfs.xfs (8)
> +command line.
> +Currently all default parameters can only be either enabled or disabled,
> +with a value of 1 to enable or 0 to disable.
> +See below for a list of all supported configuration parameters and their
> +current built-in default settings.
> +.PP
> +.BI [data]
> +.br
> +.BI noalign=0
> +.PP
> +.BI [inode]
> +.br
> +.BI align=1
> +.br
> +.BI projid32bit=1
> +.br
> +.BI sparse=0

sparse=1

Otherwise this looks ok provided we ensure the code does what the docs
say.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> +.PP
> +.BI [log]
> +.br
> +.BI lazy-count=1
> +.PP
> +.BI [metadata]
> +.br
> +.BI crc=1
> +.br
> +.BI finobt=1
> +.br
> +.BI rmapbt=0
> +.br
> +.BI reflink=0
> +.PP
> +.BI [naming]
> +.br
> +.BI ftype=1
> +.PP
> +.BI [rtdev]
> +.br
> +.BI noalign=0
> +.PP
>  .SH SEE ALSO
>  .BR xfs (5),
>  .BR mkfs (8),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
