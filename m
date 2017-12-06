Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56291 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752981AbdLFA0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 19:26:42 -0500
Date: Wed, 6 Dec 2017 11:26:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_io: fix exitcode handling (was Re: generic/399 and
 xfs_io pwrite command)
Message-ID: <20171206002638.GB5858@dastard>
References: <7235f31f-5427-ff12-11f9-cba98431e71c@tuxera.com>
 <20171204222842.GX4094@dastard>
 <35d2712c-b036-d017-2d42-f74bbc4444a9@tuxera.com>
 <20171205211850.GA5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171205211850.GA5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ari Sundholm <ari@tuxera.com>
Cc: fstests@vger.kernel.org, Emil Karlson <jkarlson@tuxera.com>, linux-xfs@vger.kernel.org

On Wed, Dec 06, 2017 at 08:18:50AM +1100, Dave Chinner wrote:
> On Tue, Dec 05, 2017 at 04:23:43PM +0200, Ari Sundholm wrote:
> > On 12/05/2017 12:28 AM, Dave Chinner wrote:
> > >On Thu, Nov 30, 2017 at 04:21:47PM +0200, Ari Sundholm wrote:
> > >>Hi!
> > >>
> > >>While debugging an issue, we found out that generic/399 seems to
> > >>rely on a behavior that is specific to ext4 in the following section
> > >>of code:
> > >>----------------8<--------snip--------8<------------------------------
> > >>#
> > >># Write files of 1 MB of all the same byte until we hit ENOSPC.
> > >>Note that we
> > >># must not create sparse files, since the contents of sparse files are not
> > >># stored on-disk.  Also, we create multiple files rather than one big file
> > >># because we want to test for reuse of per-file keys.
> > >>#
> > >>total_file_size=0
> > >>i=1
> > >>while true; do
> > >>	file=$SCRATCH_MNT/encrypted_dir/file$i
> > >>	if ! $XFS_IO_PROG -f $file -c 'pwrite 0 1M' &> $tmp.out; then
> > >>		if ! grep -q 'No space left on device' $tmp.out; then
> > >>			echo "FAIL: unexpected pwrite failure"
> > >>			cat $tmp.out
> > >>		elif [ -e $file ]; then
> > >>			total_file_size=$((total_file_size + $(stat -c %s $file)))
> > >>		fi
> > >>		break
> > >>	fi
> > >>	total_file_size=$((total_file_size + $(stat -c %s $file)))
> > >>	i=$((i + 1))
> > >>	if [ $i -gt $fs_size_in_mb ]; then
> > >>		echo "FAIL: filesystem never filled up!"
> > >>		break
> > >>	fi
> > >>done
> > >>----------------8<--------snip--------8<------------------------------
> > >>
> > >>What happens with ext4 is that the xfs_io command gives a nonzero
> > >>exit value not when the pwrite command fails with ENOSPC but during
> > >>the *next* iteration when opening the file fails with ENOSPC. Turns
> > >>out the pwrite command failing does not cause xfs_io to give a
> > >>nonzero exit value.
> > >
> > >That implies ext4 is returning zero bytes written to the pwrite()
> > >call rather than ENOSPC. i.e.:
> > >
> > >                 bytes = do_pwrite(file->fd, off, cnt, buffersize,
> > >                                 pwritev2_flags);
> > >                 if (bytes == 0)
> > >                         break;
> > >                 if (bytes < 0) {
> > >                         perror("pwrite");
> > >                         return -1;
> > >                 }
> > >
> > >So if it's exiting with no error, then we can't have got an error
> > >from ext4 at ENOSPC. If that's the case, it probably should be
> > >considered an ext4 bug, not an issue with xfs_io...
> > >
> > 
> > No, according to what we've observed, that is not what happens. The
> > pwrite() call does fail and errno is ENOSPC after the call. The
> > immediate problem is that xfs_io does not reflect this failure in
> > its exit value and thus the check in generic/399 does not work in
> > this case. Only when open() fails during the next iteration does
> > xfs_io give a nonzero exit value and cause the check in the test
> > case to allow the test case to end successfully.
> 
> Ah, io/pwrite.c fails to set exitcode on failure iappropriately
> before returning. Looks like there is a bunch of xfs_io commands
> that fail to do this properly.
> 
> > What is specific to ext4 here is, as stated in my original message,
> > that open() fails.
> 
> Because there are no more inodes to allocate (i.e. inode table is
> full) and so attempts to create more fail with ENOSPC. The xfs_io
> open command set exitcode appropriately, and that's why it finally
> triggers a test abort.
> 
> Looks like xfs_io does need fixing to set exitcode appropriately on
> all failures...

Try the patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs_io: set exitcode on failure appropriately

From: Dave Chinner <dchinner@redhat.com>

Many operations don't set the exitcode when they fail, resulting
in xfs_io exiting with a zero (no failure) exit code despite the
command failing and returning an error. Fix this.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 io/attr.c            | 18 ++++++++++++++----
 io/copy_file_range.c |  3 +++
 io/cowextsize.c      |  5 +++++
 io/encrypt.c         |  3 ++-
 io/fadvise.c         |  2 ++
 io/fiemap.c          |  5 ++---
 io/file.c            |  1 +
 io/fsmap.c           |  6 ++----
 io/fsync.c           |  2 ++
 io/getrusage.c       |  1 +
 io/imap.c            |  4 +++-
 io/inject.c          |  1 +
 io/link.c            |  1 +
 io/madvise.c         |  2 ++
 io/mincore.c         |  2 ++
 io/mmap.c            | 25 ++++++++++++++++++++-----
 io/open.c            | 32 +++++++++++++++++++++++++++-----
 io/parent.c          |  1 +
 io/pread.c           |  3 +++
 io/prealloc.c        | 22 ++++++++++++++++++++++
 io/pwrite.c          |  3 +++
 io/readdir.c         |  6 ++++--
 io/reflink.c         | 15 +++++++++++++--
 io/resblks.c         |  2 ++
 io/seek.c            |  6 +++++-
 io/sendfile.c        |  3 +++
 io/shutdown.c        |  2 ++
 io/stat.c            |  7 +++++++
 io/sync_file_range.c |  2 ++
 io/truncate.c        |  2 ++
 io/utimes.c          |  2 ++
 31 files changed, 161 insertions(+), 28 deletions(-)

diff --git a/io/attr.c b/io/attr.c
index 728560e1d1fb..86527b05461b 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -175,10 +175,11 @@ lsattr_callback(
 	if ((fd = open(path, O_RDONLY)) == -1)
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
-	else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0)
+	else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
-	else
+		exitcode = 1;
+	} else
 		printxattr(fsx.fsx_xflags, 0, 1, path, 0, 1);
 
 	if (fd != -1)
@@ -225,6 +226,7 @@ lsattr_f(
 	} else if ((xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
+		exitcode = 1;
 	} else {
 		printxattr(fsx.fsx_xflags, vflag, !aflag, name, vflag, !aflag);
 		if (aflag) {
@@ -257,9 +259,11 @@ chattr_callback(
 	} else {
 		attr.fsx_xflags |= orflags;
 		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0)
+		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0) {
 			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
 				progname, path, strerror(errno));
+			exitcode = 1;
+		}
 	}
 
 	if (fd != -1)
@@ -295,6 +299,7 @@ chattr_f(
 				if (!p->flag) {
 					fprintf(stderr, _("%s: unknown flag\n"),
 						progname);
+					exitcode = 1;
 					return 0;
 				}
 			}
@@ -309,12 +314,14 @@ chattr_f(
 				if (!p->flag) {
 					fprintf(stderr, _("%s: unknown flag\n"),
 						progname);
+					exitcode = 1;
 					return 0;
 				}
 			}
 		} else {
 			fprintf(stderr, _("%s: bad chattr command, not +/-X\n"),
 				progname);
+			exitcode = 1;
 			return 0;
 		}
 	}
@@ -325,12 +332,15 @@ chattr_f(
 	} else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
+		exitcode = 1;
 	} else {
 		attr.fsx_xflags |= orflags;
 		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0)
+		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0) {
 			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
 				progname, name, strerror(errno));
+			exitcode = 1;
+		}
 	}
 	return 0;
 }
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index d1dfc5a5e33a..9b737eff4c02 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -92,6 +92,7 @@ copy_range_f(int argc, char **argv)
 	int ret;
 	int fd;
 
+	exitcode = 1;
 	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
 		switch (opt) {
 		case 's':
@@ -132,6 +133,8 @@ copy_range_f(int argc, char **argv)
 
 	ret = copy_file_range(fd, &src, &dst, len);
 	close(fd);
+	if (ret >= 0)
+		exitcode = 0;
 	return ret;
 }
 
diff --git a/io/cowextsize.c b/io/cowextsize.c
index c4cd6de24da5..d5872449cb60 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -53,6 +53,7 @@ get_cowextsize(const char *path, int fd)
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
+		exitcode = 1;
 		return 0;
 	}
 	printf("[%u] %s\n", fsx.fsx_cowextsize, path);
@@ -67,11 +68,13 @@ set_cowextsize(const char *path, int fd, long extsz)
 
 	if (fstat64(fd, &stat) < 0) {
 		perror("fstat64");
+		exitcode = 1;
 		return 0;
 	}
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
+		exitcode = 1;
 		return 0;
 	}
 
@@ -86,6 +89,7 @@ set_cowextsize(const char *path, int fd, long extsz)
 	if ((xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx)) < 0) {
 		printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
 			progname, path, strerror(errno));
+		exitcode = 1;
 		return 0;
 	}
 
@@ -168,6 +172,7 @@ cowextsize_f(
 		if (cowextsize < 0) {
 			printf(_("non-numeric cowextsize argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else {
diff --git a/io/encrypt.c b/io/encrypt.c
index 26ab97ce614b..3351e0ff8666 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -192,6 +192,7 @@ set_encpolicy_f(int argc, char **argv)
 	struct fscrypt_policy policy;
 
 	/* Initialize the policy structure with default values */
+	exitcode = 1;
 	memset(&policy, 0, sizeof(policy));
 	policy.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
 	policy.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
@@ -269,10 +270,10 @@ set_encpolicy_f(int argc, char **argv)
 	if (ioctl(file->fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) < 0) {
 		fprintf(stderr, "%s: failed to set encryption policy: %s\n",
 			file->name, strerror(errno));
-		exitcode = 1;
 		return 0;
 	}
 
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/fadvise.c b/io/fadvise.c
index 46174f34680e..9cc91a5712e1 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -54,6 +54,7 @@ fadvise_f(
 	off64_t		offset = 0, length = 0;
 	int		c, range = 0, advise = POSIX_FADV_NORMAL;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "dnrsw")) != EOF) {
 		switch (c) {
 		case 'd':	/* Don't need these pages */
@@ -107,6 +108,7 @@ fadvise_f(
 		perror("fadvise");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/fiemap.c b/io/fiemap.c
index bdcfacdb2811..d97f53ae8d79 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -238,6 +238,7 @@ fiemap_f(
 	__u64		last_logical = 0;
 	struct stat	st;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -263,7 +264,6 @@ fiemap_f(
 	if (!fiemap) {
 		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
 			progname, map_size);
-		exitcode = 1;
 		return 0;
 	}
 
@@ -282,7 +282,6 @@ fiemap_f(
 			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAP) [\"%s\"]: "
 				"%s\n", progname, file->name, strerror(errno));
 			free(fiemap);
-			exitcode = 1;
 			return 0;
 		}
 
@@ -332,7 +331,6 @@ fiemap_f(
 		fprintf(stderr, "%s: fstat failed: %s\n", progname,
 			strerror(errno));
 		free(fiemap);
-		exitcode = 1;
 		return 0;
 	}
 
@@ -341,6 +339,7 @@ fiemap_f(
 			   BTOBBT(last_logical), BTOBBT(st.st_size));
 
 out:
+	exitcode = 0;
 	free(fiemap);
 	return 0;
 }
diff --git a/io/file.c b/io/file.c
index 349b19cdc420..2afb42e60620 100644
--- a/io/file.c
+++ b/io/file.c
@@ -79,6 +79,7 @@ file_f(
 	i = atoi(argv[1]);
 	if (i < 0 || i >= filecount) {
 		printf(_("value %d is out of range (0-%d)\n"), i, filecount-1);
+		exitcode = 1;
 	} else {
 		file = &filetable[i];
 		filelist_f();
diff --git a/io/fsmap.c b/io/fsmap.c
index 448fb5356466..4e3ae7ca2bab 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -404,6 +404,7 @@ fsmap_f(
 	bool			dumped_flags = false;
 	int			dflag, lflag, rflag;
 
+	exitcode = 1;
 	init_cvtnum(&fsblocksize, &fssectsize);
 
 	dflag = lflag = rflag = 0;
@@ -466,7 +467,6 @@ fsmap_f(
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
 				progname, file->name, strerror(errno));
-			exitcode = 1;
 			return 0;
 		}
 	}
@@ -476,7 +476,6 @@ fsmap_f(
 	if (head == NULL) {
 		fprintf(stderr, _("%s: malloc of %zu bytes failed.\n"),
 			progname, fsmap_sizeof(map_size));
-		exitcode = 1;
 		return 0;
 	}
 
@@ -509,7 +508,6 @@ fsmap_f(
 				progname, head->fmh_iflags, file->name,
 				strerror(errno));
 			free(head);
-			exitcode = 1;
 			return 0;
 		}
 		if (head->fmh_entries > map_size + 2) {
@@ -548,7 +546,6 @@ fsmap_f(
 				progname, head->fmh_iflags, file->name,
 				strerror(errno));
 			free(head);
-			exitcode = 1;
 			return 0;
 		}
 
@@ -571,6 +568,7 @@ fsmap_f(
 	if (dumped_flags)
 		dump_verbose_key();
 
+	exitcode = 0;
 	free(head);
 	return 0;
 }
diff --git a/io/fsync.c b/io/fsync.c
index 9fe5e2f50c62..61061c401a04 100644
--- a/io/fsync.c
+++ b/io/fsync.c
@@ -31,6 +31,7 @@ fsync_f(
 {
 	if (fsync(file->fd) < 0) {
 		perror("fsync");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -43,6 +44,7 @@ fdatasync_f(
 {
 	if (fdatasync(file->fd) < 0) {
 		perror("fdatasync");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/getrusage.c b/io/getrusage.c
index cf1f2afd19a8..9fc51709a73e 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -62,6 +62,7 @@ getrusage_f(
 
 	if (getrusage(RUSAGE_SELF, &rusage) < 0) {
 		perror("getrusage");
+		exitcode = 1;
 		return 0;
 	}
 
diff --git a/io/imap.c b/io/imap.c
index f52238e0c450..410e1662b76c 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -39,8 +39,10 @@ imap_f(int argc, char **argv)
 		nent = atoi(argv[1]);
 
 	t = malloc(nent * sizeof(*t));
-	if (!t)
+	if (!t) {
+		exitcode = 1;
 		return 0;
+	}
 
 	bulkreq.lastip  = &last;
 	bulkreq.icount  = nent;
diff --git a/io/inject.c b/io/inject.c
index 964ebfe13bd6..db0795023a64 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -156,6 +156,7 @@ inject_f(
 			command = XFS_IOC_ERROR_CLEARALL;
 		if ((xfsctl(file->name, file->fd, command, &error)) < 0) {
 			perror("XFS_IOC_ERROR_INJECTION");
+			exitcode = 1;
 			continue;
 		}
 	}
diff --git a/io/link.c b/io/link.c
index 9b2e8a970942..55bb806024eb 100644
--- a/io/link.c
+++ b/io/link.c
@@ -47,6 +47,7 @@ flink_f(
 
 	if (linkat(file->fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) < 0) {
 		perror("flink");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/madvise.c b/io/madvise.c
index 1d8b53cb516f..fbfe35cc1c13 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -57,6 +57,7 @@ madvise_f(
 	int		advise = MADV_NORMAL, c;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "drsw")) != EOF) {
 		switch (c) {
 		case 'd':	/* Don't need these pages */
@@ -111,6 +112,7 @@ madvise_f(
 		perror("madvise");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/mincore.c b/io/mincore.c
index 9e0d3a620319..09a165737705 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -37,6 +37,7 @@ mincore_f(
 	unsigned char	*vec;
 	int		i;
 
+	exitcode = 1;
 	if (argc == 1) {
 		offset = mapping->offset;
 		length = mapping->length;
@@ -106,6 +107,7 @@ mincore_f(
 			(unsigned long)(current - previous));
 
 	free(vec);
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/mmap.c b/io/mmap.c
index 7a8150e3d517..b0c1f764b8c4 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -121,6 +121,7 @@ mapset_f(
 	i = atoi(argv[1]);
 	if (i < 0 || i >= mapcount) {
 		printf("value %d is out of range (0-%d)\n", i, mapcount);
+		exitcode = 1;
 	} else {
 		mapping = &maptable[i];
 		maplist_f();
@@ -163,6 +164,7 @@ mmap_f(
 	size_t		blocksize, sectsize;
 	int		c, prot = 0;
 
+	exitcode = 1;
 	if (argc == 1) {
 		if (mapping)
 			return maplist_f();
@@ -263,6 +265,7 @@ mmap_f(
 	mapping->offset = offset;
 	mapping->name = filename;
 	mapping->prot = prot;
+	exitcode = 0;
 	return 0;
 }
 
@@ -294,6 +297,7 @@ msync_f(
 	int		c, flags = 0;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "ais")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -336,9 +340,12 @@ msync_f(
 	if (!start)
 		return 0;
 
-	if (msync(start, length, flags) < 0)
+	if (msync(start, length, flags) < 0) {
 		perror("msync");
+		return 0;
+	}
 
+	exitcode = 0;
 	return 0;
 }
 
@@ -380,6 +387,7 @@ mread_f(
 	int		dump = 0, rflag = 0, c;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "frv")) != EOF) {
 		switch (c) {
 		case 'f':
@@ -467,6 +475,7 @@ mread_f(
 			}
 		}
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -478,6 +487,7 @@ munmap_f(
 	ssize_t		length;
 	unsigned int	offset;
 
+	exitcode = 1;
 	if (munmap(mapping->addr, mapping->length) < 0) {
 		perror("munmap");
 		return 0;
@@ -503,6 +513,7 @@ munmap_f(
 		mapping = maptable = NULL;
 	}
 	maplist_f();
+	exitcode = 0;
 	return 0;
 }
 
@@ -538,6 +549,7 @@ mwrite_f(
 	int		c;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "rS:")) != EOF) {
 		switch (c) {
 		case 'r':
@@ -590,6 +602,7 @@ mwrite_f(
 			((char *)mapping->addr)[tmp] = seed;
 	}
 
+	exitcode = 0;
 	return 0;
 }
 
@@ -622,6 +635,7 @@ mremap_f(
 	int		c;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	init_cvtnum(&blocksize, &sectsize);
 
 	while ((c = getopt(argc, argv, "f:m")) != EOF) {
@@ -655,13 +669,14 @@ mremap_f(
 	else
 		new_addr = mremap(mapping->addr, mapping->length,
 		                  new_length, flags, new_addr);
-	if (new_addr == MAP_FAILED)
+	if (new_addr == MAP_FAILED) {
 		perror("mremap");
-	else {
-		mapping->addr = new_addr;
-		mapping->length = new_length;
+		return 0;
 	}
 
+	mapping->addr = new_addr;
+	mapping->length = new_length;
+	exitcode = 0;
 	return 0;
 }
 #endif /* HAVE_MREMAP */
diff --git a/io/open.c b/io/open.c
index 1abcb2ff2a01..0523f68263ec 100644
--- a/io/open.c
+++ b/io/open.c
@@ -209,6 +209,7 @@ open_f(
 	struct xfs_fsop_geom	geometry = { 0 };
 	struct fs_path	fsp;
 
+	exitcode = 1;
 	if (argc == 1) {
 		if (file)
 			return stat_f(argc, argv);
@@ -277,7 +278,10 @@ open_f(
 	if (!platform_test_xfs_fd(fd))
 		flags |= IO_FOREIGN;
 
-	addfile(argv[optind], fd, &geometry, flags, &fsp);
+	if (addfile(argv[optind], fd, &geometry, flags, &fsp) != 0)
+		return 0;
+
+	exitcode = 0;
 	return 0;
 }
 
@@ -289,6 +293,7 @@ close_f(
 	size_t		length;
 	unsigned int	offset;
 
+	exitcode = 1;
 	if (close(file->fd) < 0) {
 		perror("close");
 		return 0;
@@ -314,6 +319,7 @@ close_f(
 		file = filetable = NULL;
 	}
 	filelist_f();
+	exitcode = 0;
 	return 0;
 }
 
@@ -346,9 +352,12 @@ lsproj_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
 		if (getprojid(path, fd, &projid) == 0)
 			printf("[%u] %s\n", (unsigned int)projid, path);
+		else
+			exitcode = 1;
 		close(fd);
 	}
 	return 0;
@@ -384,9 +393,10 @@ lsproj_f(
 	if (recurse_all || recurse_dir)
 		nftw(file->name, lsproj_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	else if (getprojid(file->name, file->fd, &projid) < 0)
+	else if (getprojid(file->name, file->fd, &projid) < 0) {
 		perror("getprojid");
-	else
+		exitcode = 1;
+	} else
 		printf(_("projid = %u\n"), (unsigned int)projid);
 	return 0;
 }
@@ -418,9 +428,12 @@ chproj_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
-		if (setprojid(path, fd, prid) < 0)
+		if (setprojid(path, fd, prid) < 0) {
+			exitcode = 1;
 			perror("setprojid");
+		}
 		close(fd);
 	}
 	return 0;
@@ -455,14 +468,17 @@ chproj_f(
 	prid = prid_from_string(argv[optind]);
 	if (prid == -1) {
 		printf(_("invalid project ID -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
 	if (recurse_all || recurse_dir)
 		nftw(file->name, chproj_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	else if (setprojid(file->name, file->fd, prid) < 0)
+	else if (setprojid(file->name, file->fd, prid) < 0) {
 		perror("setprojid");
+		exitcode = 1;
+	}
 	return 0;
 }
 
@@ -486,6 +502,7 @@ get_extsize(const char *path, int fd)
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
+		exitcode = 1;
 		return 0;
 	}
 	printf("[%u] %s\n", fsx.fsx_extsize, path);
@@ -498,6 +515,7 @@ set_extsize(const char *path, int fd, long extsz)
 	struct fsxattr	fsx;
 	struct stat	stat;
 
+	exitcode = 1;
 	if (fstat(fd, &stat) < 0) {
 		perror("fstat");
 		return 0;
@@ -524,6 +542,7 @@ set_extsize(const char *path, int fd, long extsz)
 		return 0;
 	}
 
+	exitcode = 0;
 	return 0;
 }
 
@@ -542,6 +561,7 @@ get_extsize_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
 		get_extsize(path, fd);
 		close(fd);
@@ -564,6 +584,7 @@ set_extsize_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
 		set_extsize(path, fd, extsize);
 		close(fd);
@@ -601,6 +622,7 @@ extsize_f(
 		if (extsize < 0) {
 			printf(_("non-numeric extsize argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else {
diff --git a/io/parent.c b/io/parent.c
index 1968516d2c00..4653ddf3789a 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -387,6 +387,7 @@ parent_f(int argc, char **argv)
 	if (!fs) {
 		fprintf(stderr, _("file argument, \"%s\", is not in a mounted XFS filesystem\n"),
 			file->name);
+		exitcode = 1;
 		return 1;
 	}
 	mntpt = fs->fs_dir;
diff --git a/io/pread.c b/io/pread.c
index 60650aa340f6..7e9425fe21e8 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -390,6 +390,7 @@ pread_f(
 	int		eof = 0, direction = IO_FORWARD;
 	int		c;
 
+	exitcode = 1;
 	Cflag = qflag = uflag = vflag = 0;
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
@@ -488,6 +489,8 @@ pread_f(
 	}
 	if (c < 0)
 		return 0;
+
+	exitcode = 0;
 	if (qflag)
 		return 0;
 	gettimeofday(&t2, NULL);
diff --git a/io/prealloc.c b/io/prealloc.c
index 1a1c9ca37da2..2ddde9023760 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -88,6 +88,7 @@ allocsp_f(
 {
 	xfs_flock64_t	segment;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -95,6 +96,7 @@ allocsp_f(
 		perror("XFS_IOC_ALLOCSP64");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -105,6 +107,7 @@ freesp_f(
 {
 	xfs_flock64_t	segment;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -112,6 +115,7 @@ freesp_f(
 		perror("XFS_IOC_FREESP64");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -122,6 +126,7 @@ resvsp_f(
 {
 	xfs_flock64_t	segment;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -129,6 +134,7 @@ resvsp_f(
 		perror("XFS_IOC_RESVSP64");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -139,6 +145,7 @@ unresvsp_f(
 {
 	xfs_flock64_t	segment;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -146,6 +153,7 @@ unresvsp_f(
 		perror("XFS_IOC_UNRESVSP64");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -156,6 +164,7 @@ zero_f(
 {
 	xfs_flock64_t	segment;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -163,6 +172,7 @@ zero_f(
 		perror("XFS_IOC_ZERO_RANGE");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -198,6 +208,7 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
 		switch (c) {
 		case 'c':
@@ -230,6 +241,7 @@ fallocate_f(
 		perror("fallocate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -241,6 +253,7 @@ fpunch_f(
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -249,6 +262,7 @@ fpunch_f(
 		perror("fallocate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -260,6 +274,7 @@ fcollapse_f(
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_COLLAPSE_RANGE;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -268,6 +283,7 @@ fcollapse_f(
 		perror("fallocate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -279,6 +295,7 @@ finsert_f(
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_INSERT_RANGE;
 
+	exitcode = 1;
 	if (!offset_length(argv[1], argv[2], &segment))
 		return 0;
 
@@ -287,6 +304,7 @@ finsert_f(
 		perror("fallocate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -299,6 +317,7 @@ fzero_f(
 	int		mode = FALLOC_FL_ZERO_RANGE;
 	int		index = 1;
 
+	exitcode = 1;
 	if (strncmp(argv[index], "-k", 3) == 0) {
 		mode |= FALLOC_FL_KEEP_SIZE;
 		index++;
@@ -312,6 +331,7 @@ fzero_f(
 		perror("fallocate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
@@ -324,6 +344,7 @@ funshare_f(
 	int		mode = FALLOC_FL_UNSHARE_RANGE;
 	int		index = 1;
 
+	exitcode = 1;
 	if (!offset_length(argv[index], argv[index + 1], &segment))
 		return 0;
 
@@ -332,6 +353,7 @@ funshare_f(
 		perror("fallocate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 #endif	/* HAVE_FALLOCATE */
diff --git a/io/pwrite.c b/io/pwrite.c
index a89edfd0496f..ca262bc40b25 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -295,6 +295,7 @@ pwrite_f(
 	int		c, fd = -1;
 	int		pwritev2_flags = 0;
 
+	exitcode = 1;
 	Cflag = qflag = uflag = dflag = wflag = Wflag = 0;
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
@@ -446,6 +447,8 @@ pwrite_f(
 			goto done;
 		}
 	}
+
+	exitcode = 0;
 	if (qflag)
 		goto done;
 	gettimeofday(&t2, NULL);
diff --git a/io/readdir.c b/io/readdir.c
index ca7a881d27e4..65fe51d2ca68 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -149,6 +149,7 @@ readdir_f(
 	DIR *dir;
 	int dfd;
 
+	exitcode = 1;
 	init_cvtnum(&fsblocksize, &fssectsize);
 
 	while ((c = getopt(argc, argv, "l:o:v")) != EOF) {
@@ -169,12 +170,12 @@ readdir_f(
 
 	dfd = dup(file->fd);
 	if (dfd < 0)
-		return -1;
+		return 0;
 
 	dir = fdopendir(dfd);
 	if (!dir) {
 		close(dfd);
-		return -1;
+		return 0;
 	}
 
 	if (offset == -1) {
@@ -199,6 +200,7 @@ readdir_f(
 	printf(_("%s, %d ops, %s (%s/sec and %.4f ops/sec)\n"),
 		s1, cnt, ts, s2, tdiv(cnt, t2));
 
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/reflink.c b/io/reflink.c
index f584e8f1fe43..86a20b2c629e 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -75,6 +75,7 @@ dedupe_ioctl(
 		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
 		if (error) {
 			perror("XFS_IOC_FILE_EXTENT_SAME");
+			exitcode = 1;
 			goto done;
 		}
 		if (info->status < 0) {
@@ -139,24 +140,29 @@ dedupe_f(
 	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
 	if (soffset < 0) {
 		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 	optind++;
 	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
 	if (doffset < 0) {
 		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 	optind++;
 	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
 	if (count < 0) {
 		printf(_("non-positive length argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
 	fd = openfile(infile, NULL, IO_READONLY, 0, NULL);
-	if (fd < 0)
+	if (fd < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	gettimeofday(&t1, NULL);
 	total = dedupe_ioctl(fd, soffset, doffset, count, &ops);
@@ -237,6 +243,7 @@ reflink_f(
 	struct timeval	t1, t2;
 	int		c, ops = 0, fd = -1;
 
+	exitcode = 1;
 	condensed = quiet_flag = 0;
 	doffset = soffset = 0;
 	init_cvtnum(&fsblocksize, &fssectsize);
@@ -284,7 +291,11 @@ clone_all:
 
 	gettimeofday(&t1, NULL);
 	total = reflink_ioctl(fd, soffset, doffset, count, &ops);
-	if (ops == 0 || quiet_flag)
+	if (ops == 0)
+		goto done;
+
+	exitcode = 0;
+	if (quiet_flag)
 		goto done;
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
diff --git a/io/resblks.c b/io/resblks.c
index 06903f5bb748..33da10711a0b 100644
--- a/io/resblks.c
+++ b/io/resblks.c
@@ -32,6 +32,7 @@ resblks_f(
 	xfs_fsop_resblks_t	res;
 	long long		blks;
 
+	exitcode = 1;
 	if (argc == 2) {
 		blks = cvtnum(file->geom.blocksize, file->geom.sectsize, argv[1]);
 		if (blks < 0) {
@@ -51,6 +52,7 @@ resblks_f(
 			(unsigned long long) res.resblks);
 	printf(_("available reserved blocks = %llu\n"),
 			(unsigned long long) res.resblks_avail);
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/seek.c b/io/seek.c
index 871b47262f03..e43a8f05ea36 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -111,6 +111,7 @@ seek_f(
 	int		flag;
 	int		startflag;
 
+	exitcode = 1;
 	flag = startflag = 0;
 	init_cvtnum(&fsblocksize, &fssectsize);
 
@@ -186,9 +187,11 @@ found_hole:
 	for (c = 0; flag; c++) {
 		if (offset == -1) {
 			/* print error or eof if the only entry */
-			if (errno != ENXIO || c == 0 )
+			if (errno != ENXIO || c == 0 ) {
 				seek_output(startflag, seekinfo[current].name,
 					    start, offset);
+				exitcode = 0;
+			}
 			return 0;	/* stop on error or EOF */
 		}
 
@@ -210,6 +213,7 @@ found_hole:
 		if (offset != -1 && offset <= start)
 			goto bad_result;
 	}
+	exitcode = 0;
 	return 0;
 
 bad_result:
diff --git a/io/sendfile.c b/io/sendfile.c
index 063fa7f48114..ce6b9f127e4e 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -85,6 +85,7 @@ sendfile_f(
 	int		Cflag, qflag;
 	int		c, fd = -1;
 
+	exitcode = 1;
 	Cflag = qflag = 0;
 	init_cvtnum(&blocksize, &sectsize);
 	while ((c = getopt(argc, argv, "Cf:i:q")) != EOF) {
@@ -146,6 +147,8 @@ sendfile_f(
 	c = send_buffer(offset, count, fd, &total);
 	if (c < 0)
 		goto done;
+
+	exitcode = 0;
 	if (qflag)
 		goto done;
 	gettimeofday(&t2, NULL);
diff --git a/io/shutdown.c b/io/shutdown.c
index 022a0e9a07ae..6374c973b44d 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -30,6 +30,7 @@ shutdown_f(
 {
 	int		c, flag = XFS_FSOP_GOING_FLAGS_NOLOGFLUSH;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "fv")) != -1) {
 		switch (c) {
 		case 'f':
@@ -44,6 +45,7 @@ shutdown_f(
 		perror("XFS_IOC_GOINGDOWN");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/stat.c b/io/stat.c
index 41d421525791..2e5e90f7a172 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -137,6 +137,7 @@ stat_f(
 	struct stat	st;
 	int		c, verbose = 0, raw = 0;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "rv")) != EOF) {
 		switch (c) {
 		case 'r':
@@ -157,6 +158,7 @@ stat_f(
 		perror("fstat");
 		return 0;
 	}
+	exitcode = 0;
 
 	if (raw)
 		return dump_raw_stat(&st);
@@ -193,6 +195,7 @@ statfs_f(
 	printf(_("fd.path = \"%s\"\n"), file->name);
 	if (platform_fstatfs(file->fd, &st) < 0) {
 		perror("fstatfs");
+		exitcode = 1;
 	} else {
 		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
 		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
@@ -207,6 +210,7 @@ statfs_f(
 		return 0;
 	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
 		perror("XFS_IOC_FSGEOMETRY_V1");
+		exitcode = 1;
 	} else {
 		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
 		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
@@ -223,6 +227,7 @@ statfs_f(
 	}
 	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
 		perror("XFS_IOC_FSCOUNTS");
+		exitcode = 1;
 	} else {
 		printf(_("counts.freedata = %llu\n"),
 			(unsigned long long) fscounts.freedata);
@@ -315,6 +320,7 @@ statx_f(
 	int		atflag = 0;
 	unsigned int	mask = STATX_ALL;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
 		switch (c) {
 		case 'm':
@@ -358,6 +364,7 @@ statx_f(
 		perror("statx");
 		return 0;
 	}
+	exitcode = 0;
 
 	if (raw)
 		return dump_raw_statx(&stx);
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 7e4f3e6da397..2a9965b098d2 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -46,6 +46,7 @@ sync_range_f(
 	int		c, sync_mode = 0;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	while ((c = getopt(argc, argv, "abw")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -87,6 +88,7 @@ sync_range_f(
 		perror("sync_file_range");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/truncate.c b/io/truncate.c
index 20bada82c4aa..d741e36860b6 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -31,6 +31,7 @@ truncate_f(
 	off64_t		offset;
 	size_t		blocksize, sectsize;
 
+	exitcode = 1;
 	init_cvtnum(&blocksize, &sectsize);
 	offset = cvtnum(blocksize, sectsize, argv[1]);
 	if (offset < 0) {
@@ -42,6 +43,7 @@ truncate_f(
 		perror("ftruncate");
 		return 0;
 	}
+	exitcode = 0;
 	return 0;
 }
 
diff --git a/io/utimes.c b/io/utimes.c
index faf9b8d55dbc..9fcb44c22bc0 100755
--- a/io/utimes.c
+++ b/io/utimes.c
@@ -44,6 +44,7 @@ utimes_f(
 	struct timespec t[2];
 	int result;
 
+	exitcode = 1;
 	/* Get the timestamps */
 	result = timespec_from_string(argv[1], argv[2], &t[0]);
 	if (result) {
@@ -62,6 +63,7 @@ utimes_f(
 		return 0;
 	}
 
+	exitcode = 0;
 	return 0;
 }
 
