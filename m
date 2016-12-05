Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55530 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcLEOTD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Dec 2016 09:19:03 -0500
Subject: Re: [PATCH v2] xfs_io: support -c "open foo" command
References: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net>
Date: Mon, 5 Dec 2016 08:19:01 -0600
MIME-Version: 1.0
In-Reply-To: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 12/5/16 7:03 AM, Amir Goldstein wrote:
> There is an undocumented and possibly unused feature in xfs_io
> where all commands are executed per file in the file args list.
> 
> This feature creates ambiguity when trying to execute commands
> such as "open" and "file" from command line and result in an
> endless loop in the command loop code.

I may well be dense, but it's not immediately obvious what the
old and/or problematic behavior is.  Can you spell it out a bit
more?  What is an example of this loop?
 
> Also, when running xfs_io -c <cmd> without any file args, xfs_io
> exits without doing anything. This behavior is also undocumented
> and makes very little sense.

What /should/ it do if there is no file specified?  Is this just for
cmds that don't require a file, such as "-c sync?"

> Change the behavior of xfs_io to execute each command specified
> with -c <cmd> exactly once, regardless of the number of files in
> the file args list.

So then which file does it act on?  I'm not saying this is incorrect,
I'm just not quite understanding what this fixes, and what the new
behavior is, sorry.

Thanks,
-Eric

> This enables writing proper xfs_io scripts in command line, which
> include "open" and "file" commands.
> 
> This change does not modify the behavior of xfs_io in the most
> commonly used case of single file argument in command line and
> no "open" and "file" commands in command line.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  io/init.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> v2:
> - Fix the case of multiple file args
> 
> v1:
> - Fix the case of zero file args
> 
> diff --git a/io/init.c b/io/init.c
> index a9191cf..82b6700 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -90,14 +90,15 @@ init_commands(void)
>  	cowextsize_init();
>  }
>  
> +/*
> + * Return true for first call and false for the next call,
> + * to execute each command once.
> + */
>  static int
>  init_args_command(
>  	int	index)
>  {
> -	if (index >= filecount)
> -		return 0;
> -	file = &filetable[index++];
> -	return index;
> +	return !index;
>  }
>  
>  static int
> 
