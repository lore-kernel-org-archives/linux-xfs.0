Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49902 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbeGZCiR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:38:17 -0400
Subject: Re: [PATCH 09/10] xfs_io: wire up repair ioctl stuff
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006772758.20121.12001635681077633355.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ae4340a4-5472-9543-2a2f-bbc92a5ac34e@sandeen.net>
Date: Wed, 25 Jul 2018 18:23:54 -0700
MIME-Version: 1.0
In-Reply-To: <153006772758.20121.12001635681077633355.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/26/18 7:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Wire up the repair ioctl (which is really the scrub ioctl with special
> flags) and the force-repair error injection point.


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/init.c         |    1 +
>  io/io.h           |    1 +
>  io/scrub.c        |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 |    8 ++++
>  4 files changed, 107 insertions(+)
> 
> 
> diff --git a/io/init.c b/io/init.c
> index 3f637e5a..a65f81d6 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -85,6 +85,7 @@ init_commands(void)
>  	quit_init();
>  	readdir_init();
>  	reflink_init();
> +	repair_init();
>  	resblks_init();
>  	scrub_init();
>  	seek_init();
> diff --git a/io/io.h b/io/io.h
> index fa0cdff7..ab217789 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -198,3 +198,4 @@ extern void		log_writes_init(void);
>  #endif
>  
>  extern void		scrub_init(void);
> +extern void		repair_init(void);
> diff --git a/io/scrub.c b/io/scrub.c
> index 75a8ff15..c2c08e6b 100644
> --- a/io/scrub.c
> +++ b/io/scrub.c
> @@ -26,6 +26,7 @@
>  #include "io.h"
>  
>  static struct cmdinfo scrub_cmd;
> +static struct cmdinfo repair_cmd;
>  
>  /* Type info and names for the scrub types. */
>  enum scrub_type {
> @@ -249,3 +250,99 @@ scrub_init(void)
>  
>  	add_command(&scrub_cmd);
>  }
> +
> +static void
> +repair_help(void)
> +{
> +	const struct scrub_descr	*d;
> +	int				i;
> +
> +	printf(_(
> +"\n"
> +" Repairs a piece of XFS filesystem metadata.  The first argument is the type\n"
> +" of metadata to examine.  Allocation group metadata types take one AG number\n"
> +" as the second parameter.  Inode metadata types act on the currently open file\n"
> +" or (optionally) take an inode number and generation number to act upon as\n"
> +" the second and third parameters.\n"
> +"\n"
> +" Example:\n"
> +" 'repair inobt 3' - repairs the inode btree in AG 3.\n"
> +" 'repair bmapbtd 128 13525' - repairs the extent map of inode 128 gen 13525.\n"
> +"\n"
> +" Known metadata repairs types are:"));
> +	for (i = 0, d = scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
> +		printf(" %s", d->name);
> +	printf("\n");
> +}
> +
> +static void
> +repair_ioctl(
> +	int				fd,
> +	int				type,
> +	uint64_t			control,
> +	uint32_t			control2)
> +{
> +	struct xfs_scrub_metadata	meta;
> +	const struct scrub_descr	*sc;
> +	int				error;
> +
> +	sc = &scrubbers[type];
> +	memset(&meta, 0, sizeof(meta));
> +	meta.sm_type = type;
> +	switch (sc->type) {
> +	case ST_PERAG:
> +		meta.sm_agno = control;
> +		break;
> +	case ST_INODE:
> +		meta.sm_ino = control;
> +		meta.sm_gen = control2;
> +		break;
> +	case ST_NONE:
> +	case ST_FS:
> +		/* no control parameters */
> +		break;
> +	}
> +	meta.sm_flags = XFS_SCRUB_IFLAG_REPAIR;
> +
> +	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
> +	if (error)
> +		perror("scrub");
> +	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		printf(_("Corruption remains.\n"));
> +	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
> +		printf(_("Optimization possible.\n"));
> +	if (meta.sm_flags & XFS_SCRUB_OFLAG_XFAIL)
> +		printf(_("Cross-referencing failed.\n"));
> +	if (meta.sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
> +		printf(_("Corruption still detected during cross-referencing.\n"));
> +	if (meta.sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
> +		printf(_("Repair was not complete.\n"));
> +	if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
> +		printf(_("Metadata did not need repair or optimization.\n"));
> +}
> +
> +static int
> +repair_f(
> +	int				argc,
> +	char				**argv)
> +{
> +	return parse_args(argc, argv, &repair_cmd, repair_ioctl);
> +}
> +
> +void
> +repair_init(void)
> +{
> +	if (!expert)
> +		return;
> +	repair_cmd.name = "repair";
> +	repair_cmd.altname = "fix";
> +	repair_cmd.cfunc = repair_f;
> +	repair_cmd.argmin = 1;
> +	repair_cmd.argmax = -1;
> +	repair_cmd.flags = CMD_NOMAP_OK;
> +	repair_cmd.args = _("type [agno|ino gen]");
> +	repair_cmd.oneline = _("repairs filesystem metadata");
> +	repair_cmd.help = repair_help;
> +
> +	add_command(&repair_cmd);
> +}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index dd91589b..60f7a21c 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1167,6 +1167,14 @@ inode number and generation number are specified.
>  .RE
>  .PD
>  .TP
> +.BI "repair " type " [ " agnumber " | " "ino" " " "gen" " ]"
> +Repair internal XFS filesystem metadata.  The
> +.BI type
> +parameter specifies which type of metadata to repair.
> +For AG metadata, one AG number must be specified.
> +For file metadata, the repair is applied to the open file unless the
> +inode number and generation number are specified.
> +.TP
>  .BI "log_writes \-d " device " \-m "  mark
>  Create a mark named
>  .I mark
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
