Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56922 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388457AbeGYBLq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 21:11:46 -0400
Subject: Re: [PATCH V2] xfs_io: Document shutdown -f
References: <20180510091030.15619-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b599ab51-3361-c1a8-2581-d5b4a221abab@sandeen.net>
Date: Tue, 24 Jul 2018 17:02:48 -0700
MIME-Version: 1.0
In-Reply-To: <20180510091030.15619-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 5/10/18 2:10 AM, Carlos Maiolino wrote:
> Add help and manpage information for xfs_io shutdown -f
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> V2:
> 	Add more detailed information about what shutdown command does
> 
>  io/shutdown.c     | 16 ++++++++++++++++
>  man/man8/xfs_io.8 | 16 +++++++++++++++-
>  2 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/io/shutdown.c b/io/shutdown.c
> index 022a0e9a..8ac64d63 100644
> --- a/io/shutdown.c
> +++ b/io/shutdown.c
> @@ -47,6 +47,21 @@ shutdown_f(
>  	return 0;
>  }
>  
> +static void
> +shutdown_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Shuts down the filesystem and prevents any further IO from occurring.\n"
> +"\n"
> +" With no arguments, shutdown will not attempt to flush completed transactions\n"
> +" to disk before marking the log as being shut down. Simulating an IO error\n"
> +" behavior.\n"

I'd like to get this merged, but I think something like:

" Shuts down the filesystem and prevents any further IO from occurring.\n"
"\n"
" By default, shutdown will not flush completed transactions to disk\n"
" before marking the log as being shut down, simulating a disk failure\n"
" or system crash.\n"
" With -f, the log will be flushed to disk, matching XFS behavior when\n"
" metadata corruption is encountered.\n"
"\n"
" -f -- Flush completed transactions to disk before shut down.\n"

is more accurate.  I can edit the manpage to match, probably mentioning that
other filesystem implementations may vary.

(by default we're NOLOGFLUSH, meaning /nothing/ goes to disk.  no user
data, no log.  It's the same as unplugging a disk (or crashing the system).

With -f we do flush the log, which is what a metadata IO error would do
when it causes a shutdown.  Right?)

Sound OK?

-Eric

> +"\n"
> +" -f -- Flush completed transactions to disk before shut down.\n"
> +"\n"));
> +}
> +
>  void
>  shutdown_init(void)
>  {
> @@ -56,6 +71,7 @@ shutdown_init(void)
>  	shutdown_cmd.argmax = 1;
>  	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
>  	shutdown_cmd.args = _("[-f]");
> +	shutdown_cmd.help = shutdown_help;
>  	shutdown_cmd.oneline =
>  		_("shuts down the filesystem where the current file resides");
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index c3ab532d..d4c28a0a 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1007,8 +1007,22 @@ Note \-\- this can be useful for exercising out of space behavior.
>  Only available in expert mode and requires privileges.
>  .TP
>  .BR shutdown " [ " \-f " ]"
> -Force the filesystem to shutdown (with or without flushing the log).
> +Force a shutdown of the filesystem, but keep consistency. It does not unmount
> +the filesystem, but prevents any other IO to happen on it.
>  Only available in expert mode and requires privileges.
> +.PP
> +.RS
> +By default, XFS will not attempt to flush completed transactions to disk before
> +marking the log as being shut down.
> +.RE
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-f
> +Force XFS to flush all completed transactions to disk before marking the log as
> +shut down.
> +.PD
> +.RE
>  .TP
>  .BR stat " [ " \-v "|" \-r " ]"
>  Selected statistics from
> 
