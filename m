Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60232 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754572AbcLOSVo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 13:21:44 -0500
Subject: Re: [PATCH 5/6] xfs_io: make various commands one-shot only
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-6-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fec1a6dd-cebd-1ff4-e916-f696139b876e@sandeen.net>
Date: Thu, 15 Dec 2016 12:21:43 -0600
MIME-Version: 1.0
In-Reply-To: <20161207034724.1613-6-david@fromorbit.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, amir73il@gmail.com

On 12/6/16 9:47 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It makes no sense to iterate the file table for some xfs_io
> commands. Some commands are already marked in this way, but lots of
> them are not and this leads to bad behaviour. For example, the open
> command will run until the process fd table is full and EMFILE is
> returned rather than just opening the specified file once.

Ok, I'm not quite clear on when we should expect commands to be
"oneshot"

With freeze, for example, this:

xfs_io -x -c freeze mnt/file mnt2/file

will freeze both filesystems today.  With this change,

xfs_io -x -c freeze mnt/file mnt2/file

freezes the mnt2 filesystem but not mnt.  Is that desired?

I guess the command /is/ documented as "freeze fs of /current/ file"
but i wonder if that's just an accident of documentation.

ditto for i.e. the inode command, or resblks - why not
iterate those?

Thanks,
-Eric

> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  io/file.c      | 2 +-
>  io/freeze.c    | 4 ++--
>  io/getrusage.c | 3 ++-
>  io/imap.c      | 2 +-
>  io/inject.c    | 2 +-
>  io/link.c      | 2 +-
>  io/mmap.c      | 3 ++-
>  io/open.c      | 7 ++++---
>  io/reflink.c   | 4 ++--
>  io/resblks.c   | 2 +-
>  io/shutdown.c  | 2 +-
>  io/sync.c      | 3 ++-
>  12 files changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/io/file.c b/io/file.c
> index 8e3f07122922..349b19cdc420 100644
> --- a/io/file.c
> +++ b/io/file.c
> @@ -95,7 +95,7 @@ file_init(void)
>  	file_cmd.cfunc = file_f;
>  	file_cmd.argmin = 0;
>  	file_cmd.argmax = 1;
> -	file_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	file_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	file_cmd.oneline = _("set the current file");
>  
>  	print_cmd.name = "print";
> diff --git a/io/freeze.c b/io/freeze.c
> index 3d0d2a4b5601..0305713d99e8 100644
> --- a/io/freeze.c
> +++ b/io/freeze.c
> @@ -65,14 +65,14 @@ freeze_init(void)
>  	freeze_cmd.cfunc = freeze_f;
>  	freeze_cmd.argmin = 0;
>  	freeze_cmd.argmax = 0;
> -	freeze_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	freeze_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	freeze_cmd.oneline = _("freeze filesystem of current file");
>  
>  	thaw_cmd.name = "thaw";
>  	thaw_cmd.cfunc = thaw_f;
>  	thaw_cmd.argmin = 0;
>  	thaw_cmd.argmax = 0;
> -	thaw_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	thaw_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	thaw_cmd.oneline = _("unfreeze filesystem of current file");
>  
>  	if (expert) {
> diff --git a/io/getrusage.c b/io/getrusage.c
> index bccf94cbc302..cf1f2afd19a8 100644
> --- a/io/getrusage.c
> +++ b/io/getrusage.c
> @@ -113,7 +113,8 @@ getrusage_init(void)
>  	getrusage_cmd.argmin = 0;
>  	getrusage_cmd.argmax = -1;
>  	getrusage_cmd.cfunc = getrusage_f;
> -	getrusage_cmd.flags = CMD_NOFILE_OK | CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	getrusage_cmd.flags = CMD_NOFILE_OK | CMD_NOMAP_OK |
> +			      CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	getrusage_cmd.oneline = _("report process resource usage");
>  
>  	if (expert)
> diff --git a/io/imap.c b/io/imap.c
> index 7123432f411f..f52238e0c450 100644
> --- a/io/imap.c
> +++ b/io/imap.c
> @@ -72,7 +72,7 @@ imap_init(void)
>  	imap_cmd.argmin = 0;
>  	imap_cmd.argmax = 1;
>  	imap_cmd.args = _("[nentries]");
> -	imap_cmd.flags = CMD_NOMAP_OK;
> +	imap_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT;
>  	imap_cmd.oneline = _("inode map for filesystem of current file");
>  
>  	if (expert)
> diff --git a/io/inject.c b/io/inject.c
> index 5d5e4aef3dfc..25c70218a1ef 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -163,7 +163,7 @@ inject_init(void)
>  	inject_cmd.cfunc = inject_f;
>  	inject_cmd.argmin = 0;
>  	inject_cmd.argmax = -1;
> -	inject_cmd.flags = CMD_NOMAP_OK;
> +	inject_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT;
>  	inject_cmd.args = _("[tag ...]");
>  	inject_cmd.oneline = _("inject errors into a filesystem");
>  	inject_cmd.help = inject_help;
> diff --git a/io/link.c b/io/link.c
> index ccf8e691bb1d..9b2e8a970942 100644
> --- a/io/link.c
> +++ b/io/link.c
> @@ -59,7 +59,7 @@ flink_init(void)
>  	flink_cmd.cfunc = flink_f;
>  	flink_cmd.argmin = 1;
>  	flink_cmd.argmax = 1;
> -	flink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	flink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	flink_cmd.args = _("filename");
>  	flink_cmd.oneline =
>  		_("link the open file descriptor to the supplied filename");
> diff --git a/io/mmap.c b/io/mmap.c
> index dc188d0557cf..e2d8d5a92326 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -674,7 +674,8 @@ mmap_init(void)
>  	mmap_cmd.cfunc = mmap_f;
>  	mmap_cmd.argmin = 0;
>  	mmap_cmd.argmax = -1;
> -	mmap_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
> +	mmap_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
> +			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	mmap_cmd.args = _("[N] | [-rwx] [-s size] [off len]");
>  	mmap_cmd.oneline =
>  		_("mmap a range in the current file, show mappings");
> diff --git a/io/open.c b/io/open.c
> index 722d0f9eacf5..a12f4a2ba528 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -918,7 +918,8 @@ open_init(void)
>  	open_cmd.cfunc = open_f;
>  	open_cmd.argmin = 0;
>  	open_cmd.argmax = -1;
> -	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
> +	open_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
> +			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	open_cmd.args = _("[-acdrstxT] [-m mode] [path]");
>  	open_cmd.oneline = _("open the file specified by path");
>  	open_cmd.help = open_help;
> @@ -936,7 +937,7 @@ open_init(void)
>  	close_cmd.cfunc = close_f;
>  	close_cmd.argmin = 0;
>  	close_cmd.argmax = 0;
> -	close_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	close_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	close_cmd.oneline = _("close the current open file");
>  
>  	statfs_cmd.name = "statfs";
> @@ -980,7 +981,7 @@ open_init(void)
>  	inode_cmd.args = _("[-nv] [num]");
>  	inode_cmd.argmin = 0;
>  	inode_cmd.argmax = 3;
> -	inode_cmd.flags = CMD_NOMAP_OK;
> +	inode_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT;
>  	inode_cmd.oneline =
>  		_("Query inode number usage in the filesystem");
>  	inode_cmd.help = inode_help;
> diff --git a/io/reflink.c b/io/reflink.c
> index a09e82dca80a..a22b6b4a07e3 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -304,7 +304,7 @@ reflink_init(void)
>  	reflink_cmd.cfunc = reflink_f;
>  	reflink_cmd.argmin = 4;
>  	reflink_cmd.argmax = -1;
> -	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	reflink_cmd.args =
>  _("infile src_off dst_off len");
>  	reflink_cmd.oneline =
> @@ -318,7 +318,7 @@ _("infile src_off dst_off len");
>  	dedupe_cmd.cfunc = dedupe_f;
>  	dedupe_cmd.argmin = 4;
>  	dedupe_cmd.argmax = -1;
> -	dedupe_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	dedupe_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	dedupe_cmd.args =
>  _("infile src_off dst_off len");
>  	dedupe_cmd.oneline =
> diff --git a/io/resblks.c b/io/resblks.c
> index 73318ae03fd2..06903f5bb748 100644
> --- a/io/resblks.c
> +++ b/io/resblks.c
> @@ -61,7 +61,7 @@ resblks_init(void)
>  	resblks_cmd.cfunc = resblks_f;
>  	resblks_cmd.argmin = 0;
>  	resblks_cmd.argmax = 1;
> -	resblks_cmd.flags = CMD_NOMAP_OK;
> +	resblks_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT;
>  	resblks_cmd.args = _("[blocks]");
>  	resblks_cmd.oneline =
>  		_("get and/or set count of reserved filesystem blocks");
> diff --git a/io/shutdown.c b/io/shutdown.c
> index d8507cc78af7..d9cd520d11e2 100644
> --- a/io/shutdown.c
> +++ b/io/shutdown.c
> @@ -54,7 +54,7 @@ shutdown_init(void)
>  	shutdown_cmd.cfunc = shutdown_f;
>  	shutdown_cmd.argmin = 0;
>  	shutdown_cmd.argmax = 1;
> -	shutdown_cmd.flags = CMD_NOMAP_OK;
> +	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT;
>  	shutdown_cmd.args = _("[-f]");
>  	shutdown_cmd.oneline =
>  		_("shuts down the filesystem where the current file resides");
> diff --git a/io/sync.c b/io/sync.c
> index 28e3a15e0a96..c77263804a35 100644
> --- a/io/sync.c
> +++ b/io/sync.c
> @@ -52,7 +52,8 @@ sync_init(void)
>  {
>  	sync_cmd.name = "sync";
>  	sync_cmd.cfunc = sync_f;
> -	sync_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
> +	sync_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
> +			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
>  	sync_cmd.oneline =
>  		_("calls sync(2) to flush all in-core filesystem state to disk");
>  
> 
