Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46560 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbeGZPxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jul 2018 11:53:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id h14-v6so1948222wrw.13
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jul 2018 07:35:52 -0700 (PDT)
Date: Thu, 26 Jul 2018 16:35:48 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V3] xfs_io: Document shutdown -f
Message-ID: <20180726143548.rzfdupxsaxvf5m43@odin.usersys.redhat.com>
References: <20180510091030.15619-1-cmaiolino@redhat.com>
 <b83b3da7-2549-0778-580e-2decbefbe790@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b83b3da7-2549-0778-580e-2decbefbe790@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 25, 2018 at 05:07:13PM -0700, Eric Sandeen wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Add help and manpage information for xfs_io shutdown -f
> [sandeen: more editing for clarity]
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

I'm fine with the changes, thanks for fixing and sending the V3 Eric.

Since the patch has mine SoB too, I think I'm not supposed to add a reviewed by
just due your updates, but FWIW, I'm ok with them :P


> 
> V2: Add more detailed information about what shutdown command does
> V3: more editing
> 
> diff --git a/io/shutdown.c b/io/shutdown.c
> index 7ceed7a..052d3de 100644
> --- a/io/shutdown.c
> +++ b/io/shutdown.c
> @@ -35,6 +35,22 @@ shutdown_f(
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
> +" By default, shutdown will not flush completed transactions to disk\n"
> +" before shutting the filesystem down, simulating a disk failure or crash.\n"
> +" With -f, the log will be flushed to disk, matching XFS behavior when\n"
> +" metadata corruption is encountered.\n"
> +"\n"
> +" -f -- Flush completed transactions to disk before shut down.\n"
> +"\n"));
> +}
> +
>  void
>  shutdown_init(void)
>  {
> @@ -44,6 +60,7 @@ shutdown_init(void)
>  	shutdown_cmd.argmax = 1;
>  	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
>  	shutdown_cmd.args = _("[-f]");
> +	shutdown_cmd.help = shutdown_help;
>  	shutdown_cmd.oneline =
>  		_("shuts down the filesystem where the current file resides");
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index dd91589..54a077c 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1017,8 +1017,23 @@ Note \-\- this can be useful for exercising out of space behavior.
>  Only available in expert mode and requires privileges.
>  .TP
>  .BR shutdown " [ " \-f " ]"
> -Force the filesystem to shutdown (with or without flushing the log).
> +Force the filesystem to shut down, preventing any further IO.
> +XFS and other filesystems implement this functionality, although implementation
> +details may differ slightly.
>  Only available in expert mode and requires privileges.
> +.PP
> +.RS
> +By default, XFS will not attempt to flush completed transactions to disk before
> +shutting down the filesystem.  This simulates a disk failure or crash.
> +.RE
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-f
> +Force XFS to flush all completed transactions to disk before shutting down,
> +matching XFS behavior when critical corruption is encountered.
> +.PD
> +.RE
>  .TP
>  .BR stat " [ " \-v "|" \-r " ]"
>  Selected statistics from
> 

-- 
Carlos
