Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42696 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935065AbeEIPJ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 11:09:57 -0400
Subject: Re: [PATCH] io: Document shutdown -f
References: <20180509144320.15746-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dab48bca-0b33-5434-3d7f-e62d6ed5a11b@sandeen.net>
Date: Wed, 9 May 2018 10:09:56 -0500
MIME-Version: 1.0
In-Reply-To: <20180509144320.15746-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

I'll re-title this as "xfs_io: Document shutdown -f" FWIW

On 5/9/18 9:43 AM, Carlos Maiolino wrote:
> Add help and manpage information for xfs_io shutdown -f
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  io/shutdown.c     | 10 ++++++++++
>  man/man8/xfs_io.8 |  9 ++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/io/shutdown.c b/io/shutdown.c
> index 022a0e9a..d5e84182 100644
> --- a/io/shutdown.c
> +++ b/io/shutdown.c
> @@ -47,6 +47,15 @@ shutdown_f(
>  	return 0;
>  }
>  
> +static void
> +shutdown_help(void)
> +{
> +	printf(_(
> +"\n"

Most command long help restates the purpose with a bit more detail, and /then/ shows the options, i.e.

xfs_io> help fiemap
fiemap [-alv] [-n nx] [offset [len]] -- print block mapping for a file

 prints the block mapping for a file's data or attribute forks
 Example:
 'fiemap -v' - tabular format verbose map

 fiemap prints the map of disk blocks used by the current file.
 The map lists each extent used by the file, as well as regions in the
 file that do not have any corresponding blocks (holes).
 By default, each line of the listing takes the following form:
     extent: [startoffset..endoffset]: startblock..endblock
 Holes are marked by replacing the startblock..endblock with 'hole'.
 All the file offsets and disk blocks are in units of 512-byte blocks.
 -a -- prints the attribute fork map instead of the data fork.



so just for consistency, adding a bit more info, maybe something like:


Shuts down the filesystem and prevents any further IO from occurring,
simulating a crash.

 -f -- force log to disk before shut down


would be a bit more consistent with other long help functions.

Thanks,
-Eric

> +" -f -- force log to disk before shut down\n"
> +"\n"));
> +}
> +
>  void
>  shutdown_init(void)
>  {
> @@ -56,6 +65,7 @@ shutdown_init(void)
>  	shutdown_cmd.argmax = 1;
>  	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
>  	shutdown_cmd.args = _("[-f]");
> +	shutdown_cmd.help = shutdown_help;
>  	shutdown_cmd.oneline =
>  		_("shuts down the filesystem where the current file resides");
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index c3ab532d..d7b2d004 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1007,8 +1007,15 @@ Note \-\- this can be useful for exercising out of space behavior.
>  Only available in expert mode and requires privileges.
>  .TP
>  .BR shutdown " [ " \-f " ]"
> -Force the filesystem to shutdown (with or without flushing the log).
> +Force the filesystem to shutdown.
>  Only available in expert mode and requires privileges.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-f
> +Force a log flush before shutting the filesystem down.
> +.PD
> +.RE
>  .TP
>  .BR stat " [ " \-v "|" \-r " ]"
>  Selected statistics from
> 
