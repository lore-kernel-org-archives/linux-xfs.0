Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG4GGq3058245 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 22:16:16 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zqIEL1HlOnj68B58 for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 20:18:21 -0800 (PST)
Message-ID: <50A5BE8C.1050308@sandeen.net>
Date: Thu, 15 Nov 2012 22:18:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: correctly initialise the default path
References: <1353028488-24436-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1353028488-24436-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/15/12 7:14 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we initial xfs_quota, we place lots of information into the
> fs_table. This includes all the devices/mount points the user has
> specified as a global command line parameter to report on, as well
> as all the paths under project quota control.
> 
> There is a "current path" pointer (fs_path) maintained by the code
> that points somewhere into the fs_table. After the table is
> initialised, fs_path always points to the last entry in the table,
> and hence has to be re-initialised to point at the desired entry
> before it can be used properly.
> 
> In the case of xfs_quota, if the command passed on the command line
> is a non-global command, the command is called multiple times, each
> time after the libxcmd args_command() callback is run. That starts
> with an index of 0, and until the callback returns zero it will keep
> passing whatever the last returned value was into the callback.
> 
> xfs_quota supplies such a callback, and it's purpose is to iterate
> over the fs_table setting fs_path to the next mount point in the
> table. IOWs, non-global quota functions get called once for each
> mount point specified on the command line. However, it also means
> that for global functions, the fs_path pointer is not
> re-initialised and hence if there are project quotas configured the
> fs_path pointer does not point to a mount point andhence commands
> may malfunction..
> 
> The problem that demonstrated this is the report function. It does
> it's own fs_table iteration if the command requires it, and so only
> should be called once to avoid outputting the same information
> multiple times.  That's what the previous patch fixed by making the
> command global, but this now has the effect of making commands that
> need to operate on the device specified on the global command rely
> on the fs_path variable pointing at that device.
> 
> Further, commands executed by the interactive method are always
> treated as global commands, so the report command never worked as a
> global command in the presence of a configured project quota setup.
> 
> Fix the problem by initialising the fs_path pointer correctly.

tl;dr ;)  I'm all for detailed commit messages but you lost me there.
If I were searching for this fix I'd have no idea what behavior this
commit actually . . . fixes. :)

Can you say:

a) what the "previous patch" commit was, and
b) what commandline triggers this problem, and what the result is?

Sorry if I'm dense,
-Eric


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  quota/init.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/quota/init.c b/quota/init.c
> index 3293b90..0b481f7 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -140,6 +140,15 @@ init(
>  
>  	init_commands();
>  	add_args_command(init_args_command);
> +
> +	/*
> +	 * Ensure that global commands don't end up with an invalid path pointer
> +	 * by setting the default device at the first specified on the CLI
> +	 */
> +	if (argc != optind)
> +		fs_path = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
> +	else
> +		fs_path = &fs_table[0];
>  }
>  
>  int
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
