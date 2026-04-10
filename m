Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE0280338
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802187; cv=none; b=skMZMCXK2EjDtlPbSKVkdWZei6KpQWppAUo+nxSoDmahHFYxGWNw6r8f6xGkO75+hnu5txjuKHPCYFnyerpgGE7Z+odGgndncA4O/mi2UQauJtBfpGaJgqJwFT6LOFJ1ePkAP3FKMx+TqHtqtBACJNrsht+KTOBamqtBJ0B3dKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802187; c=relaxed/simple;
	bh=zKM0RXCTu3Zcpssy6+WaBjEudG1vAIgvrTMCyVg8D1I=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZGr124DBjRQwL0B1SNc/6nvbgQWdDlDexmOnjhsNKRPRxdkkmapsIQprwat3bFXbGA0irAAMUMmVdq2FKicWWQadxapTzET7knn+W8zyEDjAVTiJ0/s6sABcOhxxEhqBlza2Bqf6r8aSYtjdNioA0sObFymwN/fwn5vd9zPWafM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6N+S10y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6N+S10y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB125C19421;
	Fri, 10 Apr 2026 06:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802187;
	bh=zKM0RXCTu3Zcpssy6+WaBjEudG1vAIgvrTMCyVg8D1I=;
	h=Date:Subject:From:To:Cc:From;
	b=q6N+S10yn3kmIyYOuGnBdhotkVfPvb18p8L5OsOHNAF2AkoE1j+KqRytFoqo3ZnFg
	 jFiITG1PvhpJKn1OwOj4DrP8HaAvSEJ4pb32D3eNKoU+SWEANW8glgNIYnMhu8A/TK
	 Vy2Mpe8DeLYc2MIJyfGtXf4bhK60P0OFWKKgaao0BSgpAN3/JJRI3nOumNVvutj6Ae
	 JTOmgMZCUEE9nQbDW/qOC3a9boqdy/gXusX+3OUoh/ao+/Pr8ev6Q0SgcCgkkDMNG2
	 jVLPoeAFG2HvrA01BP/iMzNfJDIBH5SnxyvJ2PaFCnqjt95DVINiPGaogNSf4akCSM
	 AbMWF6N1KE2dQ==
Date: Thu, 09 Apr 2026 23:23:06 -0700
Subject: [GIT PULL 1/2] xfsprogs: autonomous self healing of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577387510.2091101.13337858710361219214.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 7.0-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 9d0bd1ecce3dc176a974d2021b1a329936294781:

libxfs: fix printing of cache.c_maxcount. (2026-04-08 21:39:57 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/health-monitoring_2026-04-09

for you to fetch changes up to bd61d2b9c8527f1f7bf86df45280ab46592bea7d:

debian: enable xfs_healer on the root filesystem by default (2026-04-09 15:30:18 -0700)

----------------------------------------------------------------
xfsprogs: autonomous self healing of filesystems [v11 1/4]

This patchset builds new functionality to deliver live information about
filesystem health events to userspace.  This is done by creating an
anonymous file that can be read() for events by userspace programs.
Events are captured by hooking various parts of XFS and iomap so that
metadata health failures, file I/O errors, and major changes in
filesystem state (unmounts, shutdowns, etc.) can be observed by
programs.

When an event occurs, the hook functions queue an event object to each
event anonfd for later processing.  Programs must have CAP_SYS_ADMIN
to open the anonfd and there's a maximum event lag to prevent resource
overconsumption.  The events themselves can be read() from the anonfd
as C structs for the xfs_healer daemon.

In userspace, we create a new daemon program that will read the event
objects and initiate repairs automatically.  This daemon is managed
entirely by systemd and will not block unmounting of the filesystem
unless repairs are ongoing.  They are auto-started by a starter
service that uses fanotify.

v11: various minor bug fixes detected by static checkers
v10: move the xfs_scrub cleanups and changes to their own patchset,
improve the commit messages to explain why we use getmntent and
statmount
v9: move listmount/statmount to libfrog; improve documentation about why
we dance with getmntent; enhance getmntent reconnection with
listmount; move --svcname helpers to xfs_{healer,scrub}; improve
commit messages; various tweaks to fstests
v8: clean up userspace for merging now that the kernel part is upstream
v7: more cleanups of the media verification ioctl, improve comments, and
reuse the bio
v6: fix pi-breaking bugs, make verify failures trigger health reports
v5: add verify-media ioctl, collapse small helper funcs with only
one caller
v4: drop multiple client support so we can make direct calls into
healthmon instead of chasing pointers and doing indirect calls
v3: drag out of rfc status

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (26):
libfrog: add a function to grab the path from an open fd and a file handle
libfrog: create healthmon event log library functions
libfrog: add support code for starting systemd services programmatically
libfrog: hoist a couple of service helper functions
libfrog: add wrappers for listmount and statmount
man2: document the healthmon ioctl
man2: document the media verification ioctl
xfs_io: monitor filesystem health events
xfs_io: add a media verify command
xfs_healer: create daemon to listen for health events
xfs_healer: enable repairing filesystems
xfs_healer: use getparents to look up file names
xfs_healer: create a per-mount background monitoring service
xfs_healer: create a service to start the per-mount healer service
xfs_healer: don't start service if kernel support unavailable
xfs_healer: use the autofsck fsproperty to select mode
xfs_healer: run full scrub after lost corruption events or targeted repair failure
xfs_healer: use getmntent to find moved filesystems
xfs_healer: use statmount to find moved filesystems even faster
xfs_healer: validate that repair fds point to the monitored fs
xfs_healer: add a manual page
xfs_scrub: print systemd service names
xfs_io: add listmount and statmount commands
mkfs: enable online repair if all backrefs are enabled
debian/control: listify the build dependencies
debian: enable xfs_healer on the root filesystem by default

healer/xfs_healer.h                            |  92 ++++
include/linux.h                                |   8 +-
io/io.h                                        |   8 +
libfrog/flagmap.h                              |  23 +
libfrog/fsproperties.h                         |   5 +
libfrog/getparents.h                           |   4 +
libfrog/healthevent.h                          |  55 ++
libfrog/statmount.h                            | 104 ++++
libfrog/systemd.h                              |  55 ++
scrub/xfs_scrub.h                              |   3 +
Makefile                                       |   5 +
configure.ac                                   |  13 +
debian/control                                 |  14 +-
debian/postinst                                |   8 +
debian/prerm                                   |  13 +
debian/rules                                   |   3 +-
healer/Makefile                                |  69 +++
healer/fsrepair.c                              | 342 ++++++++++++
healer/system-xfs_healer.slice                 |  31 ++
healer/weakhandle.c                            | 296 +++++++++++
healer/xfs_healer.c                            | 693 +++++++++++++++++++++++++
healer/xfs_healer@.service.in                  | 108 ++++
healer/xfs_healer_start.c                      | 371 +++++++++++++
healer/xfs_healer_start.service.in             |  85 +++
include/builddefs.in                           |  15 +
io/Makefile                                    |   9 +-
io/healthmon.c                                 | 191 +++++++
io/init.c                                      |   3 +
io/listmount.c                                 | 367 +++++++++++++
io/verify_media.c                              | 181 +++++++
libfrog/Makefile                               |  19 +
libfrog/flagmap.c                              |  79 +++
libfrog/getparents.c                           |  93 +++-
libfrog/healthevent.c                          | 477 +++++++++++++++++
libfrog/statmount.c                            |  76 +++
libfrog/systemd.c                              | 188 +++++++
m4/package_libcdev.m4                          | 129 +++++
man/man2/ioctl_xfs_health_fd_on_monitored_fs.2 |  75 +++
man/man2/ioctl_xfs_health_monitor.2            | 464 +++++++++++++++++
man/man2/ioctl_xfs_verify_media.2              | 197 +++++++
man/man8/Makefile                              |  40 +-
man/man8/xfs_healer.8                          | 121 +++++
man/man8/xfs_healer_start.8                    |  37 ++
man/man8/xfs_io.8                              | 133 +++++
mkfs/xfs_mkfs.c                                |   9 +
scrub/Makefile                                 |  16 +-
scrub/xfs_scrub.c                              |  82 ++-
47 files changed, 5350 insertions(+), 59 deletions(-)
create mode 100644 healer/xfs_healer.h
create mode 100644 libfrog/flagmap.h
create mode 100644 libfrog/healthevent.h
create mode 100644 libfrog/statmount.h
create mode 100644 libfrog/systemd.h
create mode 100644 debian/prerm
create mode 100644 healer/Makefile
create mode 100644 healer/fsrepair.c
create mode 100644 healer/system-xfs_healer.slice
create mode 100644 healer/weakhandle.c
create mode 100644 healer/xfs_healer.c
create mode 100644 healer/xfs_healer@.service.in
create mode 100644 healer/xfs_healer_start.c
create mode 100644 healer/xfs_healer_start.service.in
create mode 100644 io/healthmon.c
create mode 100644 io/listmount.c
create mode 100644 io/verify_media.c
create mode 100644 libfrog/flagmap.c
create mode 100644 libfrog/healthevent.c
create mode 100644 libfrog/statmount.c
create mode 100644 libfrog/systemd.c
create mode 100644 man/man2/ioctl_xfs_health_fd_on_monitored_fs.2
create mode 100644 man/man2/ioctl_xfs_health_monitor.2
create mode 100644 man/man2/ioctl_xfs_verify_media.2
create mode 100644 man/man8/xfs_healer.8
create mode 100644 man/man8/xfs_healer_start.8

The range-diff since the last posting is as follows:

 1:  3dc02291efcba4 =  1:  917ba08a8f0ea7 libfrog: add a function to grab the path from an open fd and a file handle
 2:  ccf72cb7d9841a !  2:  ccf9050728956f libfrog: create healthmon event log library functions
    @@ libfrog/flagmap.c (new)
     +
     +	for (; map->string; map++) {
     +		seen |= map->flag;
     +
     +		if (mask & map->flag) {
     +			w = snprintf(buf, bufsize, "%s%s", tag, _(map->string));
    -+			if (w > bufsize)
    ++			if (w >= bufsize)
     +				return;
     +
     +			buf += w;
     +			bufsize -= w;
     +
     +			tag = delimiter;
 3:  3946d940288cf6 !  3:  903037248315d5 libfrog: add support code for starting systemd services programmatically
    @@ libfrog/systemd.c (new)
     +	close(pipe_fds[1]);
     +	bytes = read(pipe_fds[0], unitname, unitnamelen - 1);
     +	close(pipe_fds[0]);
     +
     +	waitpid(child_pid, &child_status, 0);
     +	if (!WIFEXITED(child_status) || WEXITSTATUS(child_status) != 0) {
    -+		errno = 0;
    ++		errno = ENODATA;
    ++		return -1;
    ++	}
    ++
    ++	if (bytes < 0) {
    ++		errno = EIO;
     +		return -1;
     +	}
     +
     +	/* Terminate string at first newline or end of buffer. */
     +	for (i = 0; i < bytes; i++) {
     +		if (unitname[i] == '\n') {
     +			unitname[i] = 0;
     +			break;
     +		}
     +	}
    -+	if (i == bytes)
    -+		unitname[unitnamelen - 1] = 0;
    ++	if (i == bytes) {
    ++		/*
    ++		 * Didn't find a newline to zero out?  That means the unit name
    ++		 * is longer than the bufffer.
    ++		 */
    ++		errno = E2BIG;
    ++		return -1;
    ++	}
     +
     +	return 0;
     +}
     +
     +static const char *systemd_unit_manage_string(enum systemd_unit_manage how)
     +{
 4:  36eeca10b3f6e6 =  4:  45923bf4a3103f libfrog: hoist a couple of service helper functions
 5:  b025853d281d9b =  5:  c7b914ca4b94ab libfrog: add wrappers for listmount and statmount
 6:  5108080090fb05 !  6:  506a4212391506 man2: document the healthmon ioctl
    @@ man/man2/ioctl_xfs_health_monitor.2 (new)
     +.BR errno (3)
     +manual page for more information.
     +.RE
     +.SH CONFORMING TO
     +This API is specific to XFS filesystem on the Linux kernel.
     +.SH SEE ALSO
    -+.BR ioctl_xfs_health_samefs (2)
    ++.BR ioctl_xfs_health_fd_on_monitored_fs (2)
 7:  751c9423500ceb !  7:  14a64af67680d8 man2: document the media verification ioctl
    @@ man/man2/ioctl_xfs_verify_media.2 (new)
     +If errors are found, report the error to the kernel so that it can generate
     +health events for the health monitoring system and fsnotify.
     +The verification request is conveyed in a structure of the following form:
     +.PP
     +.in +4n
     +.nf
    -+struct xfs_verify_error {
    ++struct xfs_verify_media {
     +	__u32	me_dev;
     +	__u32	me_flags;
     +	__u64	me_start_daddr;
     +	__u64	me_end_daddr;
     +	__u32	me_ioerror;
    ++	__u32	me_max_io_size;
    ++	__u32	me_rest_us;
     +	__u32	me_pad;
     +};
     +.fi
     +.in
     +.PP
     +The field
    @@ man/man2/ioctl_xfs_verify_media.2 (new)
     +series of secondary calls to this ioctl with smaller ranges to discover the
     +exact location and type of media error.
     +The type of media error will be written to the
     +.I me_ioerror
     +field.
     +
    ++The
    ++.I me_max_io_size
    ++field, if nonzero, is an upper bound on the I/O operations that the kernel will
    ++issue to the block device.
    ++
    ++The
    ++.I me_rest_us
    ++is the time duration, in microseconds, for which the kernel will wait between
    ++issuing I/O operations.
    ++
     +.PP
     +The field
     +.I me_dev
     +must be one of the following values:
     +.RS 0.4i
     +.TP
 8:  0a30e443b44344 !  8:  3b444702ec9022 xfs_io: monitor filesystem health events
    @@ io/healthmon.c (new)
     +
     +	ret = 0;
     +
     +out_buf:
     +	free(buf);
     +out_mon:
    -+	close(mon_fd);
    ++	if (!consume)
    ++		close(mon_fd);
     +	return ret;
     +}
     +
     +static int
     +healthmon_f(
     +	int			argc,
    @@ io/healthmon.c (new)
     +	int			delay_ms = 0;
     +	int			c;
     +
     +	while ((c = getopt(argc, argv, "b:cd:pv")) != EOF) {
     +		switch (c) {
     +		case 'b':
    ++			const size_t minsz =
    ++				sizeof(struct xfs_health_monitor_event);
    ++
     +			errno = 0;
     +			c = atoi(optarg);
    -+			if (c < 0 || errno) {
    -+				printf("%s: bufsize must be positive\n",
    -+						optarg);
    ++			if (c < minsz || errno) {
    ++				printf(
    ++ "%s: bufsize must be at least one event %zd\n",
    ++						optarg, minsz);
     +				exitcode = 1;
     +				return 0;
     +			}
     +			bufsize = c;
     +			break;
     +		case 'c':
 9:  88c12ca0314f5f !  9:  8cbf38312c0ddb xfs_io: add a media verify command
    @@ io/verify_media.c (new)
     +		fprintf(stderr,
     + "%s: verify error at offset %llu length %llu: %s\n",
     +				verifydev,
     +				BBTOB(me.me_start_daddr),
     +				BBTOB(me.me_end_daddr - me.me_start_daddr),
     +				strerror(me.me_ioerror));
    ++		exitcode = 1;
     +	} else {
     +		unsigned long long	total;
     +
     +		if (me.me_end_daddr > orig_start_daddr)
     +			total = BBTOB(me.me_end_daddr - orig_start_daddr);
     +		else
10:  868f262cba395d ! 10:  e0ea21f248d5a2 xfs_healer: create daemon to listen for health events
    @@ healer/xfs_healer.c (new)
     +		close(ctx->mnt.fd);
     +	ctx->mnt.fd = -1;
     +	return -1;
     +}
     +
     +/* Monitor the given mountpoint for health events. */
    -+static void
    ++static int
     +monitor(
     +	struct healer_ctx	*ctx)
     +{
     +	bool			mounted = true;
     +	size_t			nr;
    ++	int			ret = 0;
     +
     +	do {
     +		struct xfs_health_monitor_event	*hme;
    -+		int		ret;
     +
     +		hme = malloc(sizeof(*hme));
     +		if (!hme) {
     +			pthread_mutex_lock(&ctx->conlock);
     +			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
     +					_("could not allocate event object"));
     +			pthread_mutex_unlock(&ctx->conlock);
    ++			ret = -1;
     +			break;
     +		}
     +
     +		nr = fread(hme, sizeof(*hme), 1, ctx->mon_fp);
    ++		if (ferror(ctx->mon_fp)) {
    ++			pthread_mutex_lock(&ctx->conlock);
    ++			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
    ++					_("error reading event file"),
    ++					strerror(ret));
    ++			pthread_mutex_unlock(&ctx->conlock);
    ++			free(hme);
    ++			ret = -1;
    ++			break;
    ++		}
     +		if (nr == 0) {
     +			free(hme);
     +			break;
     +		}
     +
     +		if (hme->type == XFS_HEALTH_MONITOR_TYPE_UNMOUNT)
    @@ healer/xfs_healer.c (new)
     +					strerror(ret));
     +			pthread_mutex_unlock(&ctx->conlock);
     +			free(hme);
     +			break;
     +		}
     +	} while (nr > 0 && mounted);
    ++
    ++	return ret;
     +}
     +
     +/* Tear down all the resources that we created for monitoring */
     +static void
     +teardown_monitor(
     +	struct healer_ctx	*ctx)
    @@ healer/xfs_healer.c (new)
     +	ctx.mntpoint = argv[optind];
     +
     +	ret = setup_monitor(&ctx);
     +	if (ret)
     +		goto out_events;
     +
    -+	monitor(&ctx);
    ++	ret = monitor(&ctx);
     +
     +out_events:
     +	teardown_monitor(&ctx);
     +	free((char *)ctx.fsname);
     +	return systemd_service_exit(ret);
     +}
11:  4adc92d604209d ! 11:  f68cd2283a7c9a xfs_healer: enable repairing filesystems
    @@ healer/xfs_healer.c: event_loggable(
     +	const struct healer_ctx			*ctx,
     +	const struct xfs_health_monitor_event	*hme)
     +{
     +	if (event_not_actionable(hme))
     +		return false;
     +
    ++	/*
    ++	 * We never repair corruptions that are found by xfs_scrub because it
    ++	 * also knows how to initiate repairs.
    ++	 */
     +	return ctx->want_repair && hme->type == XFS_HEALTH_MONITOR_TYPE_SICK;
     +}
     +
      /* Handle an event asynchronously. */
      static void
      handle_event(
    @@ healer/xfs_healer.c: usage(void)
      	fprintf(stderr, "\n");
      	fprintf(stderr, _("Options:\n"));
      	fprintf(stderr, _("  --debug       Enable debugging messages.\n"));
      	fprintf(stderr, _("  --everything  Capture all events.\n"));
      	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
      	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
    -+	fprintf(stderr, _("  --repair      Always repair corrupt metadata.\n"));
    ++	fprintf(stderr, _("  --repair      Repair corrupt metadata found at runtime.\n"));
      	fprintf(stderr, _("  -V            Print version.\n"));
      
      	exit(EXIT_FAILURE);
      }
      
      enum long_opt_nr {
12:  df7d9595e26ee6 = 12:  65b6910a1ffa96 xfs_healer: use getparents to look up file names
13:  6b2232591366af ! 13:  3431e65d2cd3b7 xfs_healer: create a per-mount background monitoring service
    @@ healer/xfs_healer.c: main(
     +	}
     +
      	ret = setup_monitor(&ctx);
      	if (ret)
      		goto out_events;
      
    - 	monitor(&ctx);
    + 	ret = monitor(&ctx);
      
     
      ## healer/xfs_healer@.service.in (new) ##
     @@
     +# SPDX-License-Identifier: GPL-2.0-or-later
     +#
14:  3c6e5b8effc251 ! 14:  3a28cd6ca8e33f xfs_healer: create a service to start the per-mount healer service
    @@ healer/xfs_healer_start.c (new)
     +						info->info_type, info->len);
     +			break;
     +		}
     +	}
     +}
     +
    -+/* Extract mount attachment notifications from fanotify. */
    -+static void
    -+handle_notifications(
    -+	char				*buffer,
    -+	ssize_t				len,
    -+	int				mnt_ns_fd)
    -+{
    -+	struct fanotify_event_metadata	*event =
    -+		(struct fanotify_event_metadata *) buffer;
    -+
    -+	for (; FAN_EVENT_OK(event, len); event = FAN_EVENT_NEXT(event, len)) {
    -+
    -+		switch (event->mask) {
    -+		case FAN_MNT_ATTACH:
    -+			handle_mount_event(event, mnt_ns_fd);
    -+			break;
    -+		default:
    -+			if (debug)
    -+				fprintf(stderr,
    -+ "Unexpected fanotify mark: 0x%llx\n",
    -+					(unsigned long long)event->mask);
    -+			break;
    -+		}
    -+	}
    -+}
    -+
     +#define NR_MNT_IDS		(32)
     +
     +/* Start healer services for existing XFS mounts. */
     +static int
     +start_existing_mounts(
     +	int			mnt_ns_fd)
    @@ healer/xfs_healer_start.c (new)
     +		return -1;
     +	}
     +
     +	return 0;
     +}
     +
    ++/* Extract mount attachment notifications from fanotify. */
    ++static void
    ++handle_notifications(
    ++	char				*buffer,
    ++	ssize_t				len,
    ++	int				mnt_ns_fd)
    ++{
    ++	struct fanotify_event_metadata	*event =
    ++		(struct fanotify_event_metadata *) buffer;
    ++
    ++	for (; FAN_EVENT_OK(event, len); event = FAN_EVENT_NEXT(event, len)) {
    ++
    ++		switch (event->mask) {
    ++		case FAN_MNT_ATTACH:
    ++			handle_mount_event(event, mnt_ns_fd);
    ++			break;
    ++		case FAN_Q_OVERFLOW:
    ++			start_existing_mounts(mnt_ns_fd);
    ++			break;
    ++		default:
    ++			if (debug)
    ++				fprintf(stderr,
    ++ "Unexpected fanotify mark: 0x%llx\n",
    ++					(unsigned long long)event->mask);
    ++			break;
    ++		}
    ++	}
    ++}
    ++
     +static void __attribute__((noreturn))
     +usage(void)
     +{
     +	fprintf(stderr, "%s %s %s\n", _("Usage:"), progname, _("[OPTIONS]"));
     +	fprintf(stderr, "\n");
     +	fprintf(stderr, _("Options:\n"));
15:  b80574072b4f70 ! 15:  c75cd17ac46d53 xfs_healer: don't start service if kernel support unavailable
    @@ healer/xfs_healer.c: healer_nproc(
      }
      
     +enum mon_state {
     +	MON_START,
     +	MON_EXIT,
     +	MON_ERROR,
    ++	MON_UNSUPPORTED,
     +};
     +
      /* Set ourselves up to monitor the given mountpoint for health events. */
     -static int
     +static enum mon_state
      setup_monitor(
      	struct healer_ctx	*ctx)
      {
      	const long		BUF_SIZE = sysconf(_SC_PAGE_SIZE) * 2;
    ++	enum mon_state		outcome = MON_ERROR;
      	int			mon_fd;
      	int			ret;
      
      	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
      	if (ret) {
      		perror(ctx->mntpoint);
     -		return -1;
    -+		return MON_ERROR;
    ++		return outcome;
      	}
      
      	ret = try_capture_fsinfo(ctx);
      	if (ret) {
      		fprintf(stderr, "%s: %s\n", ctx->mntpoint,
      				_("Not a XFS mount point."));
     @@ healer/xfs_healer.c: setup_monitor(
    + 	if (mon_fd < 0) {
    + 		switch (errno) {
    + 		case ENOTTY:
    + 		case EOPNOTSUPP:
    + 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
    +  _("XFS health monitoring not supported."));
    ++			outcome = MON_UNSUPPORTED;
    + 			break;
    + 		case EEXIST:
    + 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
    +  _("XFS health monitoring already running."));
    + 			break;
    + 		default:
    +@@ healer/xfs_healer.c: setup_monitor(
      
      		goto out_mnt_fd;
      	}
      	close(ctx->mnt.fd);
      	ctx->mnt.fd = -1;
      
    @@ healer/xfs_healer.c: setup_monitor(
      		close(mon_fd);
      out_mnt_fd:
      	if (ctx->mnt.fd >= 0)
      		close(ctx->mnt.fd);
      	ctx->mnt.fd = -1;
     -	return -1;
    -+	return MON_ERROR;
    ++	return outcome;
      }
      
      /* Monitor the given mountpoint for health events. */
    - static void
    + static int
      monitor(
      	struct healer_ctx	*ctx)
     @@ healer/xfs_healer.c: usage(void)
      	fprintf(stderr, _("Options:\n"));
      	fprintf(stderr, _("  --debug       Enable debugging messages.\n"));
      	fprintf(stderr, _("  --everything  Capture all events.\n"));
      	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
      	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
    - 	fprintf(stderr, _("  --repair      Always repair corrupt metadata.\n"));
    + 	fprintf(stderr, _("  --repair      Repair corrupt metadata found at runtime.\n"));
     +	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
      	fprintf(stderr, _("  -V            Print version.\n"));
      
      	exit(EXIT_FAILURE);
      }
      
    @@ healer/xfs_healer.c: main(
      	}
      
     -	ret = setup_monitor(&ctx);
     -	if (ret)
     -		goto out_events;
     +	switch (setup_monitor(&ctx)) {
    ++	case MON_UNSUPPORTED:
    ++		ret = 1; /* condition not met */
    ++		break;
     +	case MON_ERROR:
    -+		ret = -1;
    ++		ret = 255; /* service failed */
     +		break;
     +	case MON_EXIT:
     +		ret = 0;
     +		break;
     +	case MON_START:
    -+		ret = 0;
    -+		monitor(&ctx);
    ++		ret = monitor(&ctx);
     +		break;
     +	}
      
    --	monitor(&ctx);
    +-	ret = monitor(&ctx);
     -
     -out_events:
      	teardown_monitor(&ctx);
      	free((char *)ctx.fsname);
     +	if (ctx.support_check)
    -+		return systemd_service_exit_now(ret);
    ++		return ret;
      	return systemd_service_exit(ret);
      }
     
      ## healer/xfs_healer@.service.in ##
     @@ healer/xfs_healer@.service.in: ConditionCapability=CAP_DAC_OVERRIDE
      ConditionPathIsMountPoint=%f
16:  39d9eb575ee03f ! 16:  69715b6cd33567 xfs_healer: use the autofsck fsproperty to select mode
    @@ healer/xfs_healer.c: healer_nproc(
     +}
     +
      enum mon_state {
      	MON_START,
      	MON_EXIT,
      	MON_ERROR,
    + 	MON_UNSUPPORTED,
      };
    - 
     @@ healer/xfs_healer.c: setup_monitor(
      	if (ret) {
      		fprintf(stderr, "%s: %s\n", ctx->mntpoint,
      				_("Not a XFS mount point."));
      		goto out_mnt_fd;
      	}
    @@ healer/xfs_healer.c: setup_monitor(
     +		switch (want_repair_from_autofsck(ctx)) {
     +		case WR_EXIT:
     +			printf("%s: %s\n", ctx->mntpoint,
     + _("Disabling daemon per autofsck directive."));
     +			fflush(stdout);
     +			close(ctx->mnt.fd);
    -+			return MON_EXIT;
    ++			return MON_UNSUPPORTED;
     +		case WR_REPAIR:
     +			ctx->want_repair = 1;
     +			printf("%s: %s\n", ctx->mntpoint,
     + _("Automatically repairing per autofsck directive."));
     +			fflush(stdout);
     +			break;
     +		case WR_LOG_ONLY:
     +			ctx->want_repair = 0;
    -+			ctx->log = 1;
    -+			printf("%s: %s\n", ctx->mntpoint,
    ++			if (ctx->log != 0) {
    ++				printf("%s: %s\n", ctx->mntpoint,
     + _("Only logging errors per autofsck directive."));
    -+			fflush(stdout);
    ++				fflush(stdout);
    ++			}
     +			break;
     +		}
     +	}
     +
     +	/* Check that the kernel supports repairs at all. */
     +	if (ctx->want_repair && !healer_can_repair(ctx)) {
    @@ healer/xfs_healer.c: usage(void)
      	fprintf(stderr, _("Options:\n"));
      	fprintf(stderr, _("  --debug       Enable debugging messages.\n"));
      	fprintf(stderr, _("  --everything  Capture all events.\n"));
      	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
     +	fprintf(stderr, _("  --no-autofsck Do not use the \"autofsck\" fs property to decide to repair.\n"));
      	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
    - 	fprintf(stderr, _("  --repair      Always repair corrupt metadata.\n"));
    + 	fprintf(stderr, _("  --repair      Repair corrupt metadata found at runtime.\n"));
      	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
      	fprintf(stderr, _("  -V            Print version.\n"));
      
      	exit(EXIT_FAILURE);
     @@ healer/xfs_healer.c: usage(void)
      
17:  79663ebd48e0f7 ! 17:  46054ee7a8e73d xfs_healer: run full scrub after lost corruption events or targeted repair failure
    @@ healer/xfs_healer.c: handle_event(
      		hme_report_event(&pfx, hme);
      		pthread_mutex_unlock(&ctx->conlock);
      	}
      
     +	/*
     +	 * If we didn't ask for all the metadata reports (including the healthy
    -+	 * ones) and the kernel tells us it lost something, run the full scan.
    ++	 * ones) and the kernel tells us it lost something, run a full repair
    ++	 * if we're expected to fix things.
     +	 */
    -+	if (hme->type == XFS_HEALTH_MONITOR_TYPE_LOST && !ctx->everything)
    ++	if (hme->type == XFS_HEALTH_MONITOR_TYPE_LOST && !ctx->everything &&
    ++	    ctx->want_repair)
     +		run_full_repair(ctx);
     +
      	/* Initiate a repair if appropriate. */
      	if (will_repair)
      		repair_metadata(ctx, &pfx, hme);
      
18:  845560683dc0b8 = 18:  c8e1f49aea6e85 xfs_healer: use getmntent to find moved filesystems
19:  19362c796f8262 ! 19:  eb57b42646d577 xfs_healer: use statmount to find moved filesystems even faster
    @@ Commit message
     
         The key here is that the struct mount object is moved, and no new ones
         are created.  Therefore, the original mnt_id is still usable.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
     
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
    +
      ## healer/xfs_healer.h ##
     @@ healer/xfs_healer.h: struct healer_ctx {
      	/* Shared reference to the user's mountpoint for logging */
      	const char		*mntpoint;
      
      	/* Shared reference to the getmntent fsname for reconnecting */
    @@ healer/xfs_healer.c: handle_event(
     +			STATMOUNT_SB_SOURCE | STATMOUNT_MNT_BASIC,
     +			smbuf, smbuf_size);
     +	if (ret || !(smbuf->mask & STATMOUNT_SB_SOURCE))
     +		goto fallback;
     +
     +	ctx->fsname = strdup(smbuf->str + smbuf->sb_source);
    ++	if (!ctx->fsname)
    ++		return -1;
     +	ctx->mnt_id = smbuf->mnt_id;
     +	return 0;
     +
     +fallback:
     +	/*
     +	 * If statmount isn't available for whatever reason, fall back to
20:  1b1d989ab653b2 = 20:  449dfc4d12417c xfs_healer: validate that repair fds point to the monitored fs
21:  5dfe625d642963 ! 21:  935323bfb5c127 xfs_healer: add a manual page
    @@ man/man8/xfs_healer.8 (new)
     +Prints the version number and exit.
     +
     +.SH AUTOFSCK
     +By default, this program will read the
     +.I autofsck
     +filesystem property to decide if it should try to repair corruptions.
    -+If the property is set to the value
    -+.B repair
    -+then corruptions will be repaired.
    -+If the property is not set but the filesystem supports all back-reference
    ++If the property is set to these values:
    ++
    ++.RS
    ++.TP
    ++.I repair
    ++Corruptions will be repaired.
    ++.TP
    ++.IR check " or " optimize
    ++Corruptions will be logged.
    ++.TP
    ++.I none
    ++The program will exit.
    ++.RE
    ++
    ++If the property is not set but the filesystem supports any back-reference
     +metadata (reverse mappings and parent pointers), then corruptions will be
    -+repaired.
    ++logged.
    ++If no back-reference metadata are present, the program will exit.
     +
     +See the
     +.BR xfs_scrub (8)
     +manual page for more details on this filesystem property.
     +
     +.SH CAVEATS
    @@ man/man8/xfs_healer_start.8 (new)
     +.SH SYNOPSIS
     +.B xfs_healer_start
     +[
     +.B OPTIONS
     +]
     +.br
    -+.B xfs_healer \-V
    ++.B xfs_healer_start \-V
     +.SH DESCRIPTION
     +.B xfs_healer_start
     +starts the xfs_healer service whenever the kernel mounts an XFS filesystem in
     +the current mount namespace.
     +.PP
     +.B WARNING!
22:  1cbb6b1423709f ! 22:  8de0bb7542115e xfs_scrub: print systemd service names
    @@ scrub/Makefile
      	xfs_scrub_media_fail@.service \
      	xfs_scrub_all.service \
      	xfs_scrub_all_fail.service \
      	xfs_scrub_all.timer \
      	system-xfs_scrub.slice
      OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
    +@@ scrub/Makefile: xfs_scrub_all.timer: xfs_scrub_all.timer.in $(builddefs)
    + 	$(Q)$(SED) -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" < $< > $@
    + 
    + $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
    + 	@echo "    [SED]    $@"
    + 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
    + 		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
    +-		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
    ++		   -e "s|@scrub_media_svcname@|$(XFS_SCRUB_MEDIA_SVCNAME)|g" \
    + 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
    + 		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
    + 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
    + 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
    + 		   -e '/@INIT_GETTEXT@/r $(TOPDIR)/libfrog/gettext.py' \
    + 		   -e '/@INIT_GETTEXT@/d' \
     
      ## scrub/xfs_scrub.c ##
     @@ scrub/xfs_scrub.c: parse_o_opts(
      			usage();
      			break;
      		}
23:  5270bbe303f7a4 ! 23:  2bd6234d02edd6 xfs_io: add listmount and statmount commands
    @@ io/listmount.c (new)
     +		return true;
     +
     +	if (!(smbuf->mask & STATMOUNT_FS_TYPE))
     +		return false;
     +
     +	if (smbuf->mask & STATMOUNT_FS_SUBTYPE)
    -+		snprintf(real_fstype, sizeof(fstype), "%s.%s",
    ++		snprintf(real_fstype, sizeof(real_fstype), "%s.%s",
     +				smbuf->str + smbuf->fs_type,
     +				smbuf->str + smbuf->fs_subtype);
     +	else
    -+		snprintf(real_fstype, sizeof(fstype), "%s",
    ++		snprintf(real_fstype, sizeof(real_fstype), "%s",
     +				smbuf->str + smbuf->fs_type);
     +
     +	return strcmp(fstype, real_fstype) == 0;
     +}
     +
     +static void
    @@ io/listmount.c (new)
     +	uint64_t		cursor = LISTMOUNT_INIT_CURSOR;
     +	uint64_t		statmount_flags = -1ULL;
     +	uint64_t		mnt_id = LSMT_ROOT;
     +	struct statmount	*smbuf;
     +	const char		*fstype = NULL;
     +	unsigned long long	rows = 0;
    -+	const size_t		smbuf_size = libfrog_statmount_sizeof(4096);
    ++	const size_t		smbuf_size = libfrog_statmount_sizeof(65536);
     +	int			mnt_ns_fd = DEFAULT_MOUNTNS_FD;
     +	int			rawflag = 0;
     +	int			c;
     +	int			ret;
     +
     +	while ((c = getopt(argc, argv, "f:i:n:rt:")) > 0) {
    @@ io/listmount.c (new)
     +					mnt_ids, NR_MNT_IDS)) > 0) {
     +		for (c = 0; c < ret; c++) {
     +			ret = libfrog_statmount(mnt_ids[c], mnt_ns_fd,
     +					statmount_flags, smbuf, smbuf_size);
     +			if (ret) {
     +				perror("statmount");
    ++				exitcode = 1;
     +				goto out_smbuf;
     +			}
     +
     +			if (!match_mount(smbuf, fstype))
     +				continue;
     +
    @@ io/listmount.c (new)
     +					(unsigned long long)mnt_ids[c]);
     +
     +			dump_mountinfo(smbuf, rawflag);
     +		}
     +	}
     +
    -+	if (ret < 0)
    ++	if (ret < 0) {
     +		perror("listmount");
    ++		exitcode = 1;
    ++	}
     +
     +out_smbuf:
     +	free(smbuf);
    ++	if (mnt_ns_fd != DEFAULT_MOUNTNS_FD)
    ++		close(mnt_ns_fd);
     +	return 0;
     +}
     +
     +static const struct cmdinfo listmount_cmd = {
     +	.name		= "listmount",
     +	.cfunc		= listmount_f,
     +	.argmin		= -1,
     +	.argmax		= -1,
    -+	.flags		= CMD_NOFILE_OK | CMD_FOREIGN_OK | CMD_NOMAP_OK,
    ++	.flags		= CMD_FLAG_ONESHOT | CMD_NOFILE_OK | CMD_FOREIGN_OK | CMD_NOMAP_OK,
     +	.oneline	= N_("list mounted filesystems"),
     +	.help		= listmount_help,
     +};
     +
     +static void
     +statmount_help(void)
    @@ io/listmount.c (new)
     +statmount_f(
     +	int			argc,
     +	char			**argv)
     +{
     +	uint64_t		statmount_flags = -1ULL;
     +	struct statmount	*smbuf;
    -+	const size_t		smbuf_size = libfrog_statmount_sizeof(4096);
    ++	const size_t		smbuf_size = libfrog_statmount_sizeof(65536);
     +	int			rawflag = 0;
     +	int			c;
     +	int			ret;
     +
     +	while ((c = getopt(argc, argv, "f:r")) > 0) {
     +		switch (c) {
    @@ io/listmount.c (new)
     +		return 1;
     +	}
     +
     +	ret = libfrog_fstatmount(file->fd, statmount_flags, smbuf, smbuf_size);
     +	if (ret) {
     +		perror("statmount");
    ++		exitcode = 1;
     +		goto out_smbuf;
     +	}
     +
     +	printf("path: %s\n", file->name);
     +
     +	dump_mountinfo(smbuf, rawflag);
24:  7ad3e7a84dbc00 = 24:  af5fa3a7690db2 mkfs: enable online repair if all backrefs are enabled
25:  0a2b8738bcb5b6 = 25:  7bc82b8953968d debian/control: listify the build dependencies
26:  e4047f01a1a987 = 26:  1ba45609813860 debian: enable xfs_healer on the root filesystem by default
27:  f4001d0ce7e348 ! 27:  4bfbffe50965c3 libfrog: allow bitmap_free to handle a null bitmap pointer
    @@ Commit message
     
         Allow bitmap_free() callers to pass a pointer to a NULL pointer.
         This will help subsequent refactorings in xfs_scrub have cleaner
         bitmap_free callsites.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## libfrog/bitmap.c ##
     @@ libfrog/bitmap.c: bitmap_free(
      	struct bitmap		*bmap;
      	struct avl64node	*node;
      	struct avl64node	*n;
28:  d7c29fa6572138 ! 28:  f342b3df3d4d99 mkfs: rename byte unit conversion macros
    @@ Commit message
         mkfs: rename byte unit conversion macros
     
         Rename these macros so that we can promote the generic ones in the next
         patch.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## mkfs/xfs_mkfs.c ##
     @@
      #include "libfrog/dahashselftest.h"
      #include "libfrog/fsproperties.h"
      #include "libfrog/zones.h"
29:  d9999cbb584891 ! 29:  0d739632759595 libfrog: lift *BYTES helpers to convert.h
    @@ Commit message
         Move these byte unit conversion macros to convert.h and amend the macros
         to cast to unsigned long long to avoid shifting issues.  Now we can use
         these same macros throughout the codebase instead of opencoding shifts
         and possibly suffering from integer shifting problems.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## libfrog/convert.h ##
     @@ libfrog/convert.h: extern void cvtstr(double value, char *str, size_t sz);
      extern time64_t cvttime(char *s);
      
      extern uid_t	uid_from_string(char *user);
30:  c1a3e39750c61e ! 30:  f05a45e0968bb4 xfs_scrub: report truncated devices as media errors
    @@ Commit message
         Also fix the mistake that flushing the verify-pools of the log/rt
         devices doesn't actually cause scrub to abort.
     
         Cc: <linux-xfs@vger.kernel.org> # v6.13.0
         Fixes: a6e089903f2f58 ("xfs_scrub: tread zero-length read verify as an IO error")
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/phase6.c ##
     @@ scrub/phase6.c: phase6_func(
      		str_liberror(ctx, ret3, _("flushing rtdev verify pool"));
      
      	/*
31:  da10b296a3162b ! 31:  67fd2a92e53bcf xfs_scrub: fix i18n of the decode_special_owner return value
    @@ Commit message
         for a local language translation, which leads to annoying multilanguage
         failure messages.  Fix that by adding the appropriate wrappers.
     
         Cc: <linux-xfs@vger.kernel.org> # v4.15.0
         Fixes: b364a9c008fc04 ("xfs_scrub: scrub file data blocks")
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/phase6.c ##
     @@ scrub/phase6.c: struct disk_ioerr_report {
      struct owner_decode {
      	uint64_t		owner;
      	const char		*descr;
32:  f5c43e830d262b = 32:  7125b9730bae01 scrub: remove the unused io_disk field in struct read_verify
33:  5be36c0ea05431 ! 33:  bba7dd4dfc8bfa xfs_scrub: move read verification scheduling to phase6.c
    @@ Commit message
     
         Let's fix this by moving the per-thread schedule accumulation to
         phase6.c before the next patches constrain the number of IO threads
         sending verification requests to the kernel.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/read_verify.h ##
     @@
      #define XFS_SCRUB_READ_VERIFY_H_
      
      struct scrub_ctx;
    @@ scrub/phase6.c: check_rmap(
     +	struct ptvar			*ptv,
     +	void				*data,
     +	void				*foreach_arg)
     +{
     +	struct read_verify_schedule	*rs = data;
     +
    -+	return read_verify_schedule_now(rs);
    ++	return -read_verify_schedule_now(rs);
     +}
     +
      /* Wait for read/verify actions to finish, then return # bytes checked. */
      static int
      clean_pool(
      	struct read_verify_pool	*rvp,
34:  d92d7ff9efaf8c = 34:  b8e8c02d768f16 scrub: simplify the read_verify_pool_alloc interface
35:  98d6e58a90f32f ! 35:  41cc77c31691f6 xfs_scrub: don't pass the io_end_arg around everywhere
    @@ Commit message
     
         The value is the same across all callers and read-verify pools, so let's
         just pass it into read_verify_pool_alloc instead of making temporary
         aliases everywhere and increasing memory usage.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/read_verify.h ##
     @@
      struct scrub_ctx;
      struct read_verify_pool;
      struct disk;
36:  160174eb22034e = 36:  63af889b2eb0bf scrub: use enum xfs_device for read verification
37:  ddaa2bd3925eed ! 37:  c8dda35fdc1f8a xfs_scrub: rename nr_io_threads
    @@ Commit message
     
         This variable really describes the number of threads that we should
         start up to scan metadata.  Rename it to reduce confusion with the media
         verification code, which also initiates IO.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/xfs_scrub.h ##
     @@ scrub/xfs_scrub.h: struct scrub_ctx {
      	enum error_action	error_action;
      
      	/* xfrog context for the mount point */
38:  3b1f5735857d32 ! 38:  8ec0f0c40d85f7 scrub: simplify verifier threads calculation
    @@ scrub/phase6.c: phase6_estimate(
     -	if (ctx->verify_disks[XFS_DEV_RT])
     -		*nr_threads += disk_heads(ctx->verify_disks[XFS_DEV_RT]);
     -	if (ctx->verify_disks[XFS_DEV_LOG])
     -		*nr_threads += disk_heads(ctx->verify_disks[XFS_DEV_LOG]);
     +	*nr_threads = read_verify_nproc(ctx);
     +	if (ctx->fsinfo.fs_rt)
    -+		*nr_threads = read_verify_nproc(ctx);
    ++		*nr_threads += read_verify_nproc(ctx);
     +	if (ctx->fsinfo.fs_log)
    -+		*nr_threads = read_verify_nproc(ctx);
    ++		*nr_threads += read_verify_nproc(ctx);
      	*rshift = 20;
      	return 0;
      }
     
      ## scrub/read_verify.c ##
     @@ scrub/read_verify.c: struct read_verify_pool {
39:  25a281639d4bad ! 39:  1e3c06dce81279 xfs_scrub: move disk media verification error injection
    @@ scrub/read_verify.c: read_verify_pool_destroy(
     +		p = getenv("XFS_SCRUB_DISK_ERROR_INTERVAL");
     +		if (p == NULL) {
     +			interval = -1;
     +			return 0;
     +		}
     +		interval = strtoull(p, NULL, 10);
    -+		interval &= (rvp->miniosz - 1);
    ++		interval &= ~(rvp->miniosz - 1);
     +	}
     +	if (interval <= 0) {
     +		interval = -1;
     +		return 0;
     +	}
     +
40:  a4b09ac35752c1 = 40:  16efacf6af2387 xfs_scrub: use the verify media ioctl during phase 6 if possible
41:  fd056e22b1576a = 41:  da299afa6ba05d scrub: don't allocate disk for ioctl-based media verify
42:  5abf44870dfe54 ! 42:  15f4cb15c04978 xfs_scrub: perform media scanning of the log region
    @@ Commit message
         xfs_scrub: perform media scanning of the log region
     
         Scan the log area for media errors because a defect in a region could
         prevent the user from being able to perform log recovery.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
    +
    + ## scrub/fscounters.h ##
    +@@
    + #ifndef XFS_SCRUB_FSCOUNTERS_H_
    + #define XFS_SCRUB_FSCOUNTERS_H_
    + 
    + int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
    + 		unsigned long long *d_blocks, unsigned long long *d_bfree,
    + 		unsigned long long *r_blocks, unsigned long long *r_bfree,
    +-		unsigned long long *f_files_used);
    ++		unsigned long long *f_files_used, unsigned long long *l_blocks);
    + int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
    + 
    + #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
    +
    + ## scrub/fscounters.c ##
    +@@ scrub/fscounters.c: int
    + scrub_scan_estimate_blocks(
    + 	struct scrub_ctx		*ctx,
    + 	unsigned long long		*d_blocks,
    + 	unsigned long long		*d_bfree,
    + 	unsigned long long		*r_blocks,
    + 	unsigned long long		*r_bfree,
    +-	unsigned long long		*f_files_used)
    ++	unsigned long long		*f_files_used,
    ++	unsigned long long		*l_blocks)
    + {
    + 	struct xfs_fsop_counts		fc;
    + 	int				error;
    + 
    + 	/* Fetch the filesystem counters. */
    + 	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
    +@@ scrub/fscounters.c: scrub_scan_estimate_blocks(
    + 
    + 	*d_blocks = ctx->mnt.fsgeom.datablocks;
    + 	*d_bfree = fc.freedata;
    + 	*r_blocks = ctx->mnt.fsgeom.rtblocks;
    + 	*r_bfree = fc.freertx * ctx->mnt.fsgeom.rtextsize;
    + 	*f_files_used = fc.allocino - fc.freeino;
    ++	*l_blocks = ctx->mnt.fsgeom.logblocks;
    + 
    + 	return 0;
    + }
     
      ## scrub/phase6.c ##
     @@ scrub/phase6.c: struct media_verify_state {
      
      	struct read_verify_pool	*rvp_data;
      	struct read_verify_pool	*rvp_log;
    @@ scrub/phase6.c: phase6_func(
      out_rbad:
      	bitmap_free(&vs.r_bad);
      out_dbad:
      	bitmap_free(&vs.d_bad);
      	return ret;
      }
    +@@ scrub/phase6.c: phase6_estimate(
    + {
    + 	unsigned long long	d_blocks;
    + 	unsigned long long	d_bfree;
    + 	unsigned long long	r_blocks;
    + 	unsigned long long	r_bfree;
    + 	unsigned long long	dontcare;
    ++	unsigned long long	l_blocks;
    + 	int			ret;
    + 
    + 	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
    +-			&r_bfree, &dontcare);
    ++			&r_bfree, &dontcare, &l_blocks);
    + 	if (ret) {
    + 		str_liberror(ctx, ret, _("estimating verify work"));
    + 		return ret;
    + 	}
    + 
    + 	*items = cvt_off_fsb_to_b(&ctx->mnt,
    + 			(d_blocks - d_bfree) + (r_blocks - r_bfree));
    + 
    ++	/* count external logs now that we scan them */
    ++	if (ctx->fsinfo.fs_log)
    ++		*items += cvt_off_fsb_to_b(&ctx->mnt, l_blocks);
    ++
    + 	/*
    + 	 * Each read-verify pool starts a thread pool, and each worker thread
    + 	 * can contribute to the progress counter.  Hence we need to set
    + 	 * nr_threads appropriately to handle that many threads.
    + 	 */
    + 	*nr_threads = read_verify_nproc(ctx);
    +
    + ## scrub/phase7.c ##
    +@@ scrub/phase7.c: phase7_func(
    + 	uint64_t		counted_inodes = 0;
    + 	unsigned long long	absdiff;
    + 	unsigned long long	d_blocks;
    + 	unsigned long long	d_bfree;
    + 	unsigned long long	r_blocks;
    + 	unsigned long long	r_bfree;
    ++	unsigned long long	l_blocks;
    + 	bool			complain;
    + 	int			ip;
    + 	int			error;
    + 
    + 	summary_count_init(&totalcount);
    + 
    +@@ scrub/phase7.c: phase7_func(
    + 	if (error) {
    + 		str_liberror(ctx, error, _("counting inodes"));
    + 		return error;
    + 	}
    + 
    + 	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
    +-			&r_bfree, &used_files);
    ++			&r_bfree, &used_files, &l_blocks);
    + 	if (error) {
    + 		str_liberror(ctx, error, _("estimating verify work"));
    + 		return error;
    + 	}
    + 
    + 	/*
    +@@ scrub/phase7.c: phase7_func(
    + 	/* Report on what we found. */
    + 	used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
    + 	used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
    + 	stat_data = totalcount.dbytes;
    + 	stat_rt = totalcount.rbytes;
    + 
    ++	/* only count internal logs for data device summary */
    ++	if (!ctx->fsinfo.fs_log)
    ++		used_data += cvt_off_fsb_to_b(&ctx->mnt, l_blocks);
    ++
    + 	/*
    + 	 * Complain if the counts are off by more than 10% unless
    + 	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.
    + 	 */
    + 	absdiff = 1ULL << 25;
    + 	complain = verbose;
43:  568a18a548aa30 ! 43:  69fe924518c970 xfs_scrub: index read-verify pools by xfs_device ids
    @@ Commit message
     
         Refactor the read-verify pool array in struct media_verify_state so that
         we can index them via enum xfs_device.  This will enable further
         cleanups in the next few patches.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/phase6.c ##
     @@
      
      /* Verify disk blocks with GETFSMAP */
      
    @@ scrub/phase6.c: static int
      			" offset %"PRIu64" len %"PRIu64" flags 0x%x\n",
      			major(map->fmr_device), minor(map->fmr_device),
      			(uint64_t)map->fmr_physical, (int64_t)map->fmr_owner,
      			(uint64_t)map->fmr_offset, (uint64_t)map->fmr_length,
      			map->fmr_flags);
     @@ scrub/phase6.c: force_one_verify(
    - 	return read_verify_schedule_now(rs);
    + 	return -read_verify_schedule_now(rs);
      }
      
      /* Wait for read/verify actions to finish, then return # bytes checked. */
      static int
      clean_pool(
     -	struct read_verify_pool	*rvp,
44:  c60e71a63a139c ! 44:  81e7ac2ef94f2b xfs_scrub: move failmap and other outputs into read_verify_pool
    @@ Commit message
         Remove all the indirect verify IO error function calls and whatnot by
         making the read_verify_pool track the ranges of failed media and other
         problems.  Add some new helper functions that report on the outcome of
         the read verifciation so that phase6 can report on what happened.
     
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/read_verify.h ##
     @@ scrub/read_verify.h: struct read_verify_schedule {
      /* Function called when an IO error happens. */
      typedef void (*read_verify_ioerr_fn_t)(struct scrub_ctx *ctx,
      		enum xfs_device dev, uint64_t start, uint64_t length,
    @@ scrub/read_verify.c: read_verify_one(
     +read_verify_error(
     +	struct read_verify_pool		*rvp,
     +	uint64_t			start,
     +	uint64_t			length,
     +	int				error)
     +{
    ++	static pthread_mutex_t		lock = PTHREAD_MUTEX_INITIALIZER;
     +	int				ret;
     +
     +	if (!length) {
     +		rvp->truncated = true;
     +		return 0;
     +	}
     +
     +	if (!rvp->failmap) {
    -+		ret = -bitmap_alloc(&rvp->failmap);
    ++		struct bitmap *failmap;
    ++
    ++		ret = -bitmap_alloc(&failmap);
     +		if (ret) {
     +			str_liberror(rvp->ctx, ret,
     + _("allocating bad block bitmap"));
     +			return ret;
     +		}
    ++
    ++		pthread_mutex_lock(&lock);
    ++		if (!rvp->failmap)
    ++			rvp->failmap = failmap;
    ++		else
    ++			bitmap_free(&failmap);
    ++		pthread_mutex_unlock(&lock);
     +	}
     +
     +	ret = -bitmap_set(rvp->failmap, start, length);
     +	if (ret) {
     +		str_liberror(rvp->ctx, ret, _("setting bad block bitmap"));
     +		return ret;
    @@ scrub/read_verify.c: read_verify_one(
      /*
       * Issue a read-verify IO in big batches.
       */
      static void
      read_verify(
      	struct workqueue		*wq,
    +@@ scrub/read_verify.c: read_verify(
    + 	struct read_verify_pool		*rvp;
    + 	unsigned long long		verified = 0;
    + 	ssize_t				io_max_size;
    + 	ssize_t				sz;
    + 	ssize_t				len;
    + 	int				read_error;
    +-	int				ret;
    ++	int				ret = 0, ret2;
    + 
    + 	rvp = (struct read_verify_pool *)wq->wq_ctx;
    + 	if (rvp->runtime_error)
    + 		return;
    + 
    + 	io_max_size = rvp_io_max_size();
     @@ scrub/read_verify.c: read_verify(
      			 * through single blocks.  Mark everything bad from
      			 * io_start to the next miniosz block.
      			 */
      			sz = rvp->miniosz - (rv->io_start % rvp->miniosz);
      			dbg_printf("IOERR %u @ %"PRIu64" %zu err %d\n",
    @@ scrub/read_verify.c: read_verify(
      		rv->io_length -= sz;
      		background_sleep();
      	}
      
     +out_err:
      	free(rv);
    - 	ret = ptcounter_add(rvp->verified_bytes, verified);
    +-	ret = ptcounter_add(rvp->verified_bytes, verified);
    ++	ret2 = ptcounter_add(rvp->verified_bytes, verified);
    ++	if (!ret && ret2)
    ++		ret = ret2;
      	if (ret)
      		rvp->runtime_error = ret;
      }
      
    + /* Queue a read verify request immediately. */
    + int
     @@ scrub/read_verify.c: try_read_verify_schedule_io(
      		return true;
      	}
      
      	return false;
      }
45:  c879364f2a7218 ! 45:  a6dd12dd7b1629 xfs_scrub: clean up device-related error messages
    @@ Commit message
         xfs_scrub: clean up device-related error messages
     
         Use consistent terminology for the data/log/rt device in the error
         messages.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/phase6.c ##
     @@ scrub/phase6.c: report_all_media_errors(
      	struct media_verify_state	*vs)
      {
      	int				ret;
46:  f716beb3812e6e ! 46:  fd062e67bbe88b xfs_scrub: drop SCSI_VERIFY code from disk.
    @@ Commit message
         code.
     
         A subsequent patch will enable larger verification IO sizes, which this
         old code cannot handle.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/disk.h ##
     @@
       * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
       * Author: Darrick J. Wong <djwong@kernel.org>
       */
47:  10156fb4718fde ! 47:  00b0b68654581b xfs_scrub: raise media verification IO limits
    @@ Commit message
         However, these limits were set in 2018 when areal densities were lower
         and disk bandwidth was more limited.  Increase them now to reduce scan
         time on the author's system by 10% in foreground and 50% in background
         mode.
     
         Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## scrub/read_verify.c ##
     @@
      #include <stdint.h>
      #include <stdlib.h>
      #include <sys/statvfs.h>
