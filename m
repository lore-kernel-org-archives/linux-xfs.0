Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAHLDLx4054075 for <xfs@oss.sgi.com>; Sat, 17 Nov 2012 15:13:21 -0600
Message-ID: <50A7FE6D.6050206@sgi.com>
Date: Sat, 17 Nov 2012 15:15:25 -0600
From: Mark Tinguely <tinguely@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/15/12 19:14, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
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

...

fun code read :)

>   	init_commands();
>   	add_args_command(init_args_command);
> +
> +	/*
> +	 * Ensure that global commands don't end up with an invalid path pointer
> +	 * by setting the default device at the first specified on the CLI
> +	 */
> +	if (argc != optind)
> +		fs_path = fs_table_lookup(argv[optind], FS_MOUNT_POINT);

fs_table_lookup() can return NULL - especially the way I type.


--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
