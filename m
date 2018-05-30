Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbeE3SbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 14:31:08 -0400
Date: Wed, 30 May 2018 11:30:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3.5/4] mkfs.xfs: document defaults config file details
Message-ID: <20180530183044.GW837@magnolia>
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-4-mcgrof@kernel.org>
 <7f30d5cb-800e-13a2-9ad7-d884cebc31e4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f30d5cb-800e-13a2-9ad7-d884cebc31e4@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Wed, May 30, 2018 at 01:10:48PM -0500, Eric Sandeen wrote:
> Here's my stab at documenting the defaults/config file behavior.
> 
> I've condensed it down to just mkfs.xfs 8 changes, and tried to
> make it more concise.  I'll let people bikeshed this while I work
> out a proper way to substitute %sysconfdir% in the text.
> 
> Note that what I describe in terms of bare filename behavior doesn't
> match the code today - I think we still need to reach a consensus
> on whether a bare filename looks in $PWD first, or only in the
> /etc/ path.  (I'd prefer the latter, I think, but still slightly
> wobbly on this)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..64853cc 100644
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
> @@ -121,8 +125,38 @@ when parameters are quantified in those units.
>  .PP
>  Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
> +.SH DEFAULT VALUES
> +.BR mkfs.xfs (8)
> +contains built-in default values for every option as described in the sections
> +below.
> +These built-in defaults may evolve over time as new capabilities are added.

Yay, each sentence starts on its own line, like regular manpages...

> +If the file
> +.B /etc/xfs/mkfs/defaults

@sysconfdir@/xfs/mkfs/defaults ?

> +exists, it will be parsed to override built-in defaults as specified in the
> +.B defaults
> +file, and the defaults described in sections below may no longer apply.

I think "as specified in the defaults file" is redundant?  We already
said that we were parsing the defaults file...

> +.PP
> +The
> +.B \-c
> +option may also be used to specify an alternate configuration file
> +as descibed in the OPTIONS section.

...described... (typo)

>  .SH OPTIONS
>  .TP
> +.BI \-c " configuration"
> +This option may be used to specify a configuration file other than
> +.B /etc/xfs/mkfs/defaults

@sysconfdir@/xfs/mkfs/defaults

> +to override selected built-in parameter defaults.
> +If
> +.B configuration
> +is a bare filename, it will be searched in the

What is a bare filename?

> +.B /etc/xfs/mkfs/

@sysco.... yeah.

> +directory.  If

Start new sentence on new line?

> +.B configuration
> +is a full pathname or a relative pathname starting with

Ugh, I still find this a little contorted...

"If $configuration is an absolute pathname, then that path will be used
to find the configuration file.

"Otherwise, if $configuration contains at least one slash, it will be
treated as a pathname relative to the current working directory.

"If $configuration contains no slashes, first the current working
directory and then @sysconfdir@/xfs/mkfs/ will be searched for that
file."

> +.BR \'./\' " or " \'../\'
> +then that explicit path to the configuration file will be used.
> +See also the CONFIGURATION FILE FORMAT section below.
> +.TP
>  .BI \-b " block_size_options"
>  This option specifies the fundamental block size of the filesystem.
>  The valid
> @@ -920,6 +954,55 @@ Do not attempt to discard blocks at mkfs time.
>  .TP
>  .B \-V
>  Prints the version number and exits.
> +.SH CONFIGURATION FILE FORMAT
> +The optional default configuration file in
> +.B /etc/xfs/mkfs/default
> +as well as any alternate configuration file specified via the
> +.B \-c
> +option follow a simple ini-style format as shown below.

"...must follow the simple ini-style format..."

> +Available options consist of a small subset of the parameters available
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

Probably we need to add a build-time helper that reads in the default
config and spits out an ini file which can then be rolled into this
manpage and/or used to generate a totally commented out defaults file.

--D

> +.PP
>  .SH SEE ALSO
>  .BR xfs (5),
>  .BR mkfs (8),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
