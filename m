Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14400 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752490AbeEPFvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 01:51:01 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fIpKz-0006BX-Jg
        for linux-xfs@vger.kernel.org; Wed, 16 May 2018 15:50:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fIpKz-0000ik-HN
        for linux-xfs@vger.kernel.org; Wed, 16 May 2018 15:50:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs_io: set exitcode on failure appropriately
Date: Wed, 16 May 2018 15:50:57 +1000
Message-Id: <20180516055057.2731-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Many operations don't set the exitcode when they fail, resulting
in xfs_io exiting with a zero (no failure) exit code despite the
command failing and returning an error. The command return code is
really a boolean to tell the libxcmd command loop whether to
continue processing or not, while exitcode is the actual xfs_io exit
code returned to the parent on exit.

This patchset just makes the code do the right thing. It's not the
nicest code, but it's a start at producing correct behaviour.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 io/attr.c            | 18 +++++++---
 io/copy_file_range.c | 13 +++++--
 io/cowextsize.c      |  5 +++
 io/encrypt.c         | 11 +++++-
 io/fadvise.c         |  9 ++++-
 io/fiemap.c          |  3 ++
 io/file.c            |  1 +
 io/fsmap.c           |  9 +++--
 io/fsync.c           |  2 ++
 io/getrusage.c       |  1 +
 io/imap.c            |  4 ++-
 io/inject.c          |  1 +
 io/link.c            |  1 +
 io/log_writes.c      |  7 ++--
 io/madvise.c         | 10 +++++-
 io/mincore.c         | 10 +++++-
 io/mmap.c            | 63 ++++++++++++++++++++++++++------
 io/open.c            | 85 ++++++++++++++++++++++++++++++++------------
 io/parent.c          |  1 +
 io/pread.c           | 19 ++++++++--
 io/prealloc.c        | 57 +++++++++++++++++++++++------
 io/pwrite.c          | 31 +++++++++++++---
 io/readdir.c         | 10 ++++--
 io/reflink.c         | 30 +++++++++++++---
 io/resblks.c         |  3 ++
 io/seek.c            | 12 +++++--
 io/sendfile.c        | 18 ++++++++--
 io/shutdown.c        |  2 ++
 io/stat.c            | 13 ++++++-
 io/sync_file_range.c |  8 ++++-
 io/truncate.c        |  2 ++
 io/utimes.c          |  3 ++
 32 files changed, 378 insertions(+), 84 deletions(-)

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
index 99fba20a4953..5604068bfa62 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -103,6 +103,7 @@ copy_range_f(int argc, char **argv)
 			src = strtoull(optarg, &sp, 10);
 			if (!sp || sp == optarg) {
 				printf(_("invalid source offset -- %s\n"), sp);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -110,6 +111,7 @@ copy_range_f(int argc, char **argv)
 			dst = strtoull(optarg, &sp, 10);
 			if (!sp || sp == optarg) {
 				printf(_("invalid destination offset -- %s\n"), sp);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -117,18 +119,23 @@ copy_range_f(int argc, char **argv)
 			len = strtoull(optarg, &sp, 10);
 			if (!sp || sp == optarg) {
 				printf(_("invalid length -- %s\n"), sp);
+				exitcode = 1;
 				return 0;
 			}
 			break;
 		}
 	}
 
-	if (optind != argc - 1)
+	if (optind != argc - 1) {
+		exitcode = 1;
 		return command_usage(&copy_range_cmd);
+	}
 
 	fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
-	if (fd < 0)
+	if (fd < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (src == 0 && dst == 0 && len == 0) {
 		len = copy_src_filesize(fd);
@@ -137,6 +144,8 @@ copy_range_f(int argc, char **argv)
 
 	ret = copy_file_range_cmd(fd, &src, &dst, len);
 	close(fd);
+	if (ret < 0)
+		exitcode = 1;
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
index 26ab97ce614b..acc6112a0fc4 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -205,6 +205,7 @@ set_encpolicy_f(int argc, char **argv)
 					&policy.contents_encryption_mode)) {
 				fprintf(stderr, "invalid contents encryption "
 					"mode: %s\n", optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -213,12 +214,14 @@ set_encpolicy_f(int argc, char **argv)
 					&policy.filenames_encryption_mode)) {
 				fprintf(stderr, "invalid filenames encryption "
 					"mode: %s\n", optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
 		case 'f':
 			if (!parse_byte_value(optarg, &policy.flags)) {
 				fprintf(stderr, "invalid flags: %s\n", optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -226,18 +229,22 @@ set_encpolicy_f(int argc, char **argv)
 			if (!parse_byte_value(optarg, &policy.version)) {
 				fprintf(stderr, "invalid policy version: %s\n",
 					optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&set_encpolicy_cmd);
 		}
 	}
 	argc -= optind;
 	argv += optind;
 
-	if (argc > 1)
+	if (argc > 1) {
+		exitcode = 1;
 		return command_usage(&set_encpolicy_cmd);
+	}
 
 	/* Parse key descriptor if specified */
 	if (argc > 0) {
@@ -249,6 +256,7 @@ set_encpolicy_f(int argc, char **argv)
 		if (strlen(keydesc) != FS_KEY_DESCRIPTOR_SIZE * 2) {
 			fprintf(stderr, "invalid key descriptor: %s\n",
 				keydesc);
+			exitcode = 1;
 			return 0;
 		}
 
@@ -256,6 +264,7 @@ set_encpolicy_f(int argc, char **argv)
 		if (tmp == keydesc || *tmp != '\0') {
 			fprintf(stderr, "invalid key descriptor: %s\n",
 				keydesc);
+			exitcode = 1;
 			return 0;
 		}
 
diff --git a/io/fadvise.c b/io/fadvise.c
index 46174f34680e..1a59f3511eb7 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -77,19 +77,23 @@ fadvise_f(
 			range = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&fadvise_cmd);
 		}
 	}
 	if (range) {
 		size_t	blocksize, sectsize;
 
-		if (optind != argc - 2)
+		if (optind != argc - 2) {
+			exitcode = 1;
 			return command_usage(&fadvise_cmd);
+		}
 		init_cvtnum(&blocksize, &sectsize);
 		offset = cvtnum(blocksize, sectsize, argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		optind++;
@@ -97,14 +101,17 @@ fadvise_f(
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else if (optind != argc) {
+		exitcode = 1;
 		return command_usage(&fadvise_cmd);
 	}
 
 	if (posix_fadvise(file->fd, offset, length, advise) < 0) {
 		perror("fadvise");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/fiemap.c b/io/fiemap.c
index 2f1265264896..ce52ee6f57f7 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -269,6 +269,7 @@ fiemap_f(
 			vflag++;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&fiemap_cmd);
 		}
 	}
@@ -278,6 +279,7 @@ fiemap_f(
 		start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
 		if (start_offset < 0) {
 			printf("non-numeric offset argument -- %s\n", argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		last_logical = start_offset;
@@ -289,6 +291,7 @@ fiemap_f(
 		length = cvtnum(fsblocksize, fssectsize, argv[optind]);
 		if (length < 0) {
 			printf("non-numeric len argument -- %s\n", argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		range_end = start_offset + length;
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
index e46fdbaa148c..74c1d18f3ac0 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -430,13 +430,16 @@ fsmap_f(
 			vflag++;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&fsmap_cmd);
 		}
 	}
 
 	if ((dflag + lflag + rflag > 1) || (mflag > 0 && vflag > 0) ||
-	    (argc > optind && dflag + lflag + rflag == 0))
+	    (argc > optind && dflag + lflag + rflag == 0)) {
+		exitcode = 1;
 		return command_usage(&fsmap_cmd);
+	}
 
 	if (argc > optind) {
 		start = cvtnum(fsblocksize, fssectsize, argv[optind]);
@@ -444,6 +447,7 @@ fsmap_f(
 			fprintf(stderr,
 				_("Bad rmap start_bblock %s.\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		start <<= BBSHIFT;
@@ -455,6 +459,7 @@ fsmap_f(
 			fprintf(stderr,
 				_("Bad rmap end_bblock %s.\n"),
 				argv[optind + 1]);
+			exitcode = 1;
 			return 0;
 		}
 		end <<= BBSHIFT;
@@ -508,8 +513,8 @@ fsmap_f(
 				" iflags=0x%x [\"%s\"]: %s\n"),
 				progname, head->fmh_iflags, file->name,
 				strerror(errno));
-			free(head);
 			exitcode = 1;
+			free(head);
 			return 0;
 		}
 		if (head->fmh_entries > map_size + 2) {
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
index fc3cf25639cc..8cbaeb398db7 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -129,6 +129,7 @@ inject_f(
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
diff --git a/io/log_writes.c b/io/log_writes.c
index 46ea1c26215e..d5180e48a488 100644
--- a/io/log_writes.c
+++ b/io/log_writes.c
@@ -65,7 +65,6 @@ log_writes_f(
 	const char 	*mark = NULL;
 	int 		c;
 
-	exitcode = 1;
 	while ((c = getopt(argc, argv, "d:m:")) != EOF) {
 		switch (c) {
 		case 'd':
@@ -75,15 +74,17 @@ log_writes_f(
 			mark = optarg;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&log_writes_cmd);
 		}
 	}
 
-	if (device == NULL || mark == NULL)
+	if (device == NULL || mark == NULL) {
+		exitcode = 1;
 		return command_usage(&log_writes_cmd);
+	}
 
 	if (mark_log(device, mark))
-		exitcode = 0;
 
 	return 0;
 }
diff --git a/io/madvise.c b/io/madvise.c
index 1d8b53cb516f..132243af8978 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -72,6 +72,7 @@ madvise_f(
 			advise = MADV_WILLNEED;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&madvise_cmd);
 		}
 	}
@@ -85,6 +86,7 @@ madvise_f(
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		optind++;
@@ -92,23 +94,29 @@ madvise_f(
 		if (llength < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		} else if (llength > (size_t)llength) {
 			printf(_("length argument too large -- %lld\n"),
 				(long long)llength);
+			exitcode = 1;
 			return 0;
 		} else
 			length = (size_t)llength;
 	} else {
+		exitcode = 1;
 		return command_usage(&madvise_cmd);
 	}
 
 	start = check_mapping_range(mapping, offset, length, 1);
-	if (!start)
+	if (!start) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (madvise(start, length, advise) < 0) {
 		perror("madvise");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/mincore.c b/io/mincore.c
index 9e0d3a620319..c3f3a0b03222 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -46,36 +46,44 @@ mincore_f(
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[1]);
+			exitcode = 1;
 			return 0;
 		}
 		llength = cvtnum(blocksize, sectsize, argv[2]);
 		if (llength < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[2]);
+			exitcode = 1;
 			return 0;
 		} else if (llength > (size_t)llength) {
 			printf(_("length argument too large -- %lld\n"),
 				(long long)llength);
+			exitcode = 1;
 			return 0;
 		} else
 			length = (size_t)llength;
 	} else {
+		exitcode = 1;
 		return command_usage(&mincore_cmd);
 	}
 
 	start = check_mapping_range(mapping, offset, length, 1);
-	if (!start)
+	if (!start) {
+		exitcode = 1;
 		return 0;
+	}
 
 	vec = calloc(length/pagesize, sizeof(unsigned char));
 	if (!vec) {
 		perror("calloc");
+		exitcode = 1;
 		return 0;
 	}
 
 	if (mincore(start, length, vec) < 0) {
 		perror("mincore");
 		free(vec);
+		exitcode = 1;
 		return 0;
 	}
 
diff --git a/io/mmap.c b/io/mmap.c
index 106be4998981..6f3925275f5f 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -125,6 +125,7 @@ mapset_f(
 	i = atoi(argv[1]);
 	if (i < 0 || i >= mapcount) {
 		printf("value %d is out of range (0-%d)\n", i, mapcount);
+		exitcode = 1;
 	} else {
 		mapping = &maptable[i];
 		maplist_f();
@@ -174,6 +175,7 @@ mmap_f(
 		fprintf(stderr, file ?
 			_("no mapped regions, try 'help mmap'\n") :
 			_("no files are open, try 'help open'\n"));
+		exitcode = 1;
 		return 0;
 	} else if (argc == 2) {
 		if (mapping)
@@ -181,9 +183,11 @@ mmap_f(
 		fprintf(stderr, file ?
 			_("no mapped regions, try 'help mmap'\n") :
 			_("no files are open, try 'help open'\n"));
+		exitcode = 1;
 		return 0;
 	} else if (!file) {
 		fprintf(stderr, _("no files are open, try 'help open'\n"));
+		exitcode = 1;
 		return 0;
 	}
 
@@ -217,30 +221,36 @@ mmap_f(
 			length2 = cvtnum(blocksize, sectsize, optarg);
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&mmap_cmd);
 		}
 	}
 	if (!prot)
 		prot = PROT_READ | PROT_WRITE | PROT_EXEC;
 
-	if (optind != argc - 2)
+	if (optind != argc - 2) {
+		exitcode = 1;
 		return command_usage(&mmap_cmd);
+	}
 
 	offset = cvtnum(blocksize, sectsize, argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 	optind++;
 	length = cvtnum(blocksize, sectsize, argv[optind]);
 	if (length < 0) {
 		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
 	filename = strdup(file->name);
 	if (!filename) {
 		perror("strdup");
+		exitcode = 1;
 		return 0;
 	}
 
@@ -260,6 +270,7 @@ mmap_f(
 	if (address == MAP_FAILED) {
 		perror("mmap");
 		free(filename);
+		exitcode = 1;
 		return 0;
 	}
 
@@ -271,6 +282,7 @@ mmap_f(
 		mapcount = 0;
 		munmap(address, length);
 		free(filename);
+		exitcode = 1;
 		return 0;
 	}
 
@@ -325,6 +337,7 @@ msync_f(
 			flags |= MS_SYNC;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&msync_cmd);
 		}
 	}
@@ -338,6 +351,7 @@ msync_f(
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		optind++;
@@ -345,18 +359,25 @@ msync_f(
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else {
+		exitcode = 1;
 		return command_usage(&msync_cmd);
 	}
 
 	start = check_mapping_range(mapping, offset, length, 1);
-	if (!start)
+	if (!start) {
+		exitcode = 1;
 		return 0;
+	}
 
-	if (msync(start, length, flags) < 0)
+	if (msync(start, length, flags) < 0) {
 		perror("msync");
+		exitcode = 1;
+		return 0;
+	}
 
 	return 0;
 }
@@ -411,6 +432,7 @@ mread_f(
 			dump = 1;	/* mapping offset dump */
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&mread_cmd);
 		}
 	}
@@ -424,6 +446,7 @@ mread_f(
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		optind++;
@@ -431,23 +454,29 @@ mread_f(
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else {
+		exitcode = 1;
 		return command_usage(&mread_cmd);
 	}
 
 	start = check_mapping_range(mapping, offset, length, 0);
-	if (!start)
+	if (!start) {
+		exitcode = 1;
 		return 0;
+	}
 	dumpoffset = offset - mapping->offset;
 	if (dump == 2)
 		printoffset = offset;
 	else
 		printoffset = dumpoffset;
 
-	if (alloc_buffer(pagesize, 0, 0) < 0)
+	if (alloc_buffer(pagesize, 0, 0) < 0) {
+		exitcode = 1;
 		return 0;
+	}
 	bp = (char *)buffer;
 
 	dumplen = length % pagesize;
@@ -499,6 +528,7 @@ munmap_f(
 
 	if (munmap(mapping->addr, mapping->length) < 0) {
 		perror("munmap");
+		exitcode = 1;
 		return 0;
 	}
 	free(mapping->name);
@@ -570,6 +600,7 @@ mwrite_f(
 			}
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&mwrite_cmd);
 		}
 	}
@@ -583,6 +614,7 @@ mwrite_f(
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 		optind++;
@@ -590,15 +622,19 @@ mwrite_f(
 		if (length < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else {
+		exitcode = 1;
 		return command_usage(&mwrite_cmd);
 	}
 
 	start = check_mapping_range(mapping, offset, length, 0);
-	if (!start)
+	if (!start) {
+		exitcode = 1;
 		return 0;
+	}
 
 	offset -= mapping->offset;
 	if (rflag) {
@@ -654,17 +690,21 @@ mremap_f(
 			flags = MREMAP_MAYMOVE;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&mremap_cmd);
 		}
 	}
 
-	if (optind != argc - 1)
+	if (optind != argc - 1) {
+		exitcode = 1;
 		return command_usage(&mremap_cmd);
+	}
 
 	new_length = cvtnum(blocksize, sectsize, argv[optind]);
 	if (new_length < 0) {
 		printf(_("non-numeric offset argument -- %s\n"),
 			argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
@@ -674,13 +714,14 @@ mremap_f(
 	else
 		new_addr = mremap(mapping->addr, mapping->length,
 		                  new_length, flags, new_addr);
-	if (new_addr == MAP_FAILED)
+	if (new_addr == MAP_FAILED) {
 		perror("mremap");
-	else {
-		mapping->addr = new_addr;
-		mapping->length = new_length;
+		exitcode = 1;
+		return 0;
 	}
 
+	mapping->addr = new_addr;
+	mapping->length = new_length;
 	return 0;
 }
 #endif /* HAVE_MREMAP */
diff --git a/io/open.c b/io/open.c
index 2cce0455263a..4a5a0fd6946c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -213,6 +213,7 @@ open_f(
 		if (file)
 			return stat_f(argc, argv);
 		fprintf(stderr, _("no files are open, try 'help open'\n"));
+		exitcode = 1;
 		return 0;
 	}
 
@@ -235,6 +236,7 @@ open_f(
 			mode = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
 				printf(_("non-numeric mode -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -258,26 +260,36 @@ open_f(
 			flags |= IO_TMPFILE;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&open_cmd);
 		}
 	}
 
-	if (optind != argc - 1)
+	if (optind != argc - 1) {
+		exitcode = 1;
 		return command_usage(&open_cmd);
+	}
 
 	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
 		fprintf(stderr, _("-T and -r options are incompatible\n"));
+		exitcode = 1;
 		return -1;
 	}
 
 	fd = openfile(argv[optind], &geometry, flags, mode, &fsp);
-	if (fd < 0)
+	if (fd < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (!platform_test_xfs_fd(fd))
 		flags |= IO_FOREIGN;
 
-	addfile(argv[optind], fd, &geometry, flags, &fsp);
+	if (addfile(argv[optind], fd, &geometry, flags, &fsp) != 0) {
+		exitcode = 1;
+		return 0;
+	}
+
 	return 0;
 }
 
@@ -291,6 +303,7 @@ close_f(
 
 	if (close(file->fd) < 0) {
 		perror("close");
+		exitcode = 1;
 		return 0;
 	}
 	free(file->name);
@@ -346,9 +359,12 @@ lsproj_callback(
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
@@ -374,19 +390,23 @@ lsproj_f(
 			recurse_dir = 0;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&lsproj_cmd);
 		}
 	}
 
-	if (argc != optind)
+	if (argc != optind) {
+		exitcode = 1;
 		return command_usage(&lsproj_cmd);
+	}
 
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
@@ -418,9 +438,12 @@ chproj_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
-		if (setprojid(path, fd, prid) < 0)
+		if (setprojid(path, fd, prid) < 0) {
 			perror("setprojid");
+			exitcode = 1;
+		}
 		close(fd);
 	}
 	return 0;
@@ -445,24 +468,30 @@ chproj_f(
 			recurse_dir = 0;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&chproj_cmd);
 		}
 	}
 
-	if (argc != optind + 1)
+	if (argc != optind + 1) {
+		exitcode = 1;
 		return command_usage(&chproj_cmd);
+	}
 
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
 
@@ -486,7 +515,7 @@ get_extsize(const char *path, int fd)
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
-		return 0;
+		return -1;
 	}
 	printf("[%u] %s\n", fsx.fsx_extsize, path);
 	return 0;
@@ -500,12 +529,12 @@ set_extsize(const char *path, int fd, long extsz)
 
 	if (fstat(fd, &stat) < 0) {
 		perror("fstat");
-		return 0;
+		return -1;
 	}
 	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
 		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
 			progname, path, strerror(errno));
-		return 0;
+		return -1;
 	}
 
 	if (S_ISREG(stat.st_mode)) {
@@ -514,14 +543,14 @@ set_extsize(const char *path, int fd, long extsz)
 		fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
 	} else {
 		printf(_("invalid target file type - file %s\n"), path);
-		return 0;
+		return -1;
 	}
 	fsx.fsx_extsize = extsz;
 
 	if ((xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx)) < 0) {
 		printf("%s: FS_IOC_FSSETXATTR %s: %s\n",
 			progname, path, strerror(errno));
-		return 0;
+		return -1;
 	}
 
 	return 0;
@@ -542,8 +571,10 @@ get_extsize_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
-		get_extsize(path, fd);
+		if (get_extsize(path, fd) < 0)
+			exitcode = 1;
 		close(fd);
 	}
 	return 0;
@@ -564,8 +595,10 @@ set_extsize_callback(
 	if ((fd = open(path, O_RDONLY)) == -1) {
 		fprintf(stderr, _("%s: cannot open %s: %s\n"),
 			progname, path, strerror(errno));
+		exitcode = 1;
 	} else {
-		set_extsize(path, fd, extsize);
+		if (set_extsize(path, fd, extsize) < 0)
+			exitcode = 1;
 		close(fd);
 	}
 	return 0;
@@ -592,6 +625,7 @@ extsize_f(
 			recurse_dir = 0;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&extsize_cmd);
 		}
 	}
@@ -601,6 +635,7 @@ extsize_f(
 		if (extsize < 0) {
 			printf(_("non-numeric extsize argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			return 0;
 		}
 	} else {
@@ -611,10 +646,10 @@ extsize_f(
 		nftw(file->name, (extsize >= 0) ?
 			set_extsize_callback : get_extsize_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	else if (extsize >= 0)
-		set_extsize(file->name, file->fd, extsize);
-	else
-		get_extsize(file->name, file->fd);
+	else if (extsize >= 0 && set_extsize(file->name, file->fd, extsize) < 0)
+		exitcode = 1;
+	else if (get_extsize(file->name, file->fd) < 0)
+		exitcode = 1;
 	return 0;
 }
 
@@ -652,6 +687,7 @@ get_last_inode(void)
 		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
 				&bulkreq)) {
 			perror("XFS_IOC_FSINUMBERS");
+			exitcode = 1;
 			return 0;
 		}
 
@@ -697,6 +733,7 @@ inode_f(
 			ret_next = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&inode_cmd);
 		}
 	}
@@ -714,12 +751,16 @@ inode_f(
 	}
 
 	/* Extra junk? */
-	if (optind < argc)
+	if (optind < argc) {
+		exitcode = 1;
 		return command_usage(&inode_cmd);
+	}
 
 	/* -n option requires an inode number */
-	if (ret_next && userino == NULLFSINO)
+	if (ret_next && userino == NULLFSINO) {
+		exitcode = 1;
 		return command_usage(&inode_cmd);
+	}
 
 	if (userino == NULLFSINO) {
 		/* We are finding last inode in use */
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
index 60650aa340f6..32bf951de043 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -400,6 +400,7 @@ pread_f(
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
 			if (tmp < 0) {
 				printf(_("non-numeric bsize -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			bsize = tmp;
@@ -431,6 +432,7 @@ pread_f(
 			if (!sp || sp == optarg) {
 				printf(_("non-numeric vector count == %s\n"),
 					optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -439,21 +441,26 @@ pread_f(
 			zeed = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
 				printf(_("non-numeric seed -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&pread_cmd);
 		}
 	}
-	if (optind != argc - 2)
+	if (optind != argc - 2) {
+		exitcode = 1;
 		return command_usage(&pread_cmd);
+	}
 
 	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
 	if (offset < 0 && (direction & (IO_RANDOM|IO_BACKWARD))) {
 		eof = -1;	/* read from EOF */
 	} else if (offset < 0) {
 		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 	optind++;
@@ -462,11 +469,14 @@ pread_f(
 		eof = -1;	/* read to EOF */
 	} else if (count < 0) {
 		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
-	if (alloc_buffer(bsize, uflag, 0xabababab) < 0)
+	if (alloc_buffer(bsize, uflag, 0xabababab) < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	gettimeofday(&t1, NULL);
 	switch (direction) {
@@ -486,8 +496,11 @@ pread_f(
 	default:
 		ASSERT(0);
 	}
-	if (c < 0)
+	if (c < 0) {
+		exitcode = 1;
 		return 0;
+	}
+
 	if (qflag)
 		return 0;
 	gettimeofday(&t2, NULL);
diff --git a/io/prealloc.c b/io/prealloc.c
index 572197c0446e..efa599a3aa7e 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -88,11 +88,14 @@ allocsp_f(
 {
 	xfs_flock64_t	segment;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (xfsctl(file->name, file->fd, XFS_IOC_ALLOCSP64, &segment) < 0) {
 		perror("XFS_IOC_ALLOCSP64");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -105,11 +108,14 @@ freesp_f(
 {
 	xfs_flock64_t	segment;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (xfsctl(file->name, file->fd, XFS_IOC_FREESP64, &segment) < 0) {
 		perror("XFS_IOC_FREESP64");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -122,11 +128,14 @@ resvsp_f(
 {
 	xfs_flock64_t	segment;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (xfsctl(file->name, file->fd, XFS_IOC_RESVSP64, &segment) < 0) {
 		perror("XFS_IOC_RESVSP64");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -139,11 +148,14 @@ unresvsp_f(
 {
 	xfs_flock64_t	segment;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (xfsctl(file->name, file->fd, XFS_IOC_UNRESVSP64, &segment) < 0) {
 		perror("XFS_IOC_UNRESVSP64");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -156,11 +168,14 @@ zero_f(
 {
 	xfs_flock64_t	segment;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (xfsctl(file->name, file->fd, XFS_IOC_ZERO_RANGE, &segment) < 0) {
 		perror("XFS_IOC_ZERO_RANGE");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -216,18 +231,24 @@ fallocate_f(
 			mode = FALLOC_FL_UNSHARE_RANGE;
 			break;
 		default:
+			exitcode = 1;
 			command_usage(&falloc_cmd);
 		}
 	}
-        if (optind != argc - 2)
+        if (optind != argc - 2) {
+		exitcode = 1;
                 return command_usage(&falloc_cmd);
+	}
 
-	if (!offset_length(argv[optind], argv[optind+1], &segment))
+	if (!offset_length(argv[optind], argv[optind+1], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (fallocate(file->fd, mode,
 			segment.l_start, segment.l_len)) {
 		perror("fallocate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -241,12 +262,15 @@ fpunch_f(
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (fallocate(file->fd, mode,
 			segment.l_start, segment.l_len)) {
 		perror("fallocate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -260,12 +284,15 @@ fcollapse_f(
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_COLLAPSE_RANGE;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (fallocate(file->fd, mode,
 			segment.l_start, segment.l_len)) {
 		perror("fallocate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -279,12 +306,15 @@ finsert_f(
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_INSERT_RANGE;
 
-	if (!offset_length(argv[1], argv[2], &segment))
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (fallocate(file->fd, mode,
 			segment.l_start, segment.l_len)) {
 		perror("fallocate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -304,12 +334,15 @@ fzero_f(
 		index++;
 	}
 
-	if (!offset_length(argv[index], argv[index + 1], &segment))
+	if (!offset_length(argv[index], argv[index + 1], &segment)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (fallocate(file->fd, mode,
 			segment.l_start, segment.l_len)) {
 		perror("fallocate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
@@ -325,11 +358,13 @@ funshare_f(
 	int		index = 1;
 
 	if (!offset_length(argv[index], argv[index + 1], &segment))
+		exitcode = 1;
 		return 0;
 
 	if (fallocate(file->fd, mode,
 			segment.l_start, segment.l_len)) {
 		perror("fallocate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/pwrite.c b/io/pwrite.c
index d06af4b3c177..f7412bd19817 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -308,6 +308,7 @@ pwrite_f(
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
 			if (tmp < 0) {
 				printf(_("non-numeric bsize -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			bsize = tmp;
@@ -346,6 +347,7 @@ pwrite_f(
 			skip = cvtnum(fsblocksize, fssectsize, optarg);
 			if (skip < 0) {
 				printf(_("non-numeric skip -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -353,6 +355,7 @@ pwrite_f(
 			seed = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
 				printf(_("non-numeric seed -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -368,6 +371,7 @@ pwrite_f(
 			if (!sp || sp == optarg) {
 				printf(_("non-numeric vector count == %s\n"),
 					optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -382,11 +386,13 @@ pwrite_f(
 			zeed = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
 				printf(_("non-numeric seed -- %s\n"), optarg);
+				exitcode = 1;
 				return 0;
 			}
 			break;
 		default:
 			/* Handle ifdef'd-out options above */
+			exitcode = 1;
 			if (c != '?')
 				printf(_("%s: command -%c not supported\n"), argv[0], c);
 			else
@@ -394,28 +400,38 @@ pwrite_f(
 			return 0;
 		}
 	}
-	if (((skip || dflag) && !infile) || (optind != argc - 2))
+	if (((skip || dflag) && !infile) || (optind != argc - 2)) {
+		exitcode = 1;
 		return command_usage(&pwrite_cmd);
-	if (infile && direction != IO_FORWARD)
+	}
+	if (infile && direction != IO_FORWARD) {
+		exitcode = 1;
 		return command_usage(&pwrite_cmd);
+	}
 	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 	optind++;
 	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
 	if (count < 0) {
 		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
-	if (alloc_buffer(bsize, uflag, seed) < 0)
+	if (alloc_buffer(bsize, uflag, seed) < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	c = IO_READONLY | (dflag ? IO_DIRECT : 0);
-	if (infile && ((fd = openfile(infile, NULL, c, 0, NULL)) < 0))
+	if (infile && ((fd = openfile(infile, NULL, c, 0, NULL)) < 0)) {
+		exitcode = 1;
 		return 0;
+	}
 
 	gettimeofday(&t1, NULL);
 	switch (direction) {
@@ -438,20 +454,25 @@ pwrite_f(
 		total = 0;
 		ASSERT(0);
 	}
-	if (c < 0)
+	if (c < 0) {
+		exitcode = 1;
 		goto done;
+	}
 	if (Wflag) {
 		if (fsync(file->fd) < 0) {
 			perror("fsync");
+			exitcode = 1;
 			goto done;
 		}
 	}
 	if (wflag) {
 		if (fdatasync(file->fd) < 0) {
 			perror("fdatasync");
+			exitcode = 1;
 			goto done;
 		}
 	}
+
 	if (qflag)
 		goto done;
 	gettimeofday(&t2, NULL);
diff --git a/io/readdir.c b/io/readdir.c
index ca7a881d27e4..6dca6ba700cc 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -163,18 +163,22 @@ readdir_f(
 			verbose = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&readdir_cmd);
 		}
 	}
 
 	dfd = dup(file->fd);
-	if (dfd < 0)
-		return -1;
+	if (dfd < 0) {
+		exitcode = 1;
+		return 0;
+	}
 
 	dir = fdopendir(dfd);
 	if (!dir) {
 		close(dfd);
-		return -1;
+		exitcode = 1;
+		return 0;
 	}
 
 	if (offset == -1) {
diff --git a/io/reflink.c b/io/reflink.c
index f584e8f1fe43..71a3698c2cea 100644
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
@@ -129,34 +130,42 @@ dedupe_f(
 			quiet_flag = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&dedupe_cmd);
 		}
 	}
-	if (optind != argc - 4)
+	if (optind != argc - 4) {
+		exitcode = 1;
 		return command_usage(&dedupe_cmd);
+	}
 	infile = argv[optind];
 	optind++;
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
@@ -250,11 +259,14 @@ reflink_f(
 			quiet_flag = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&reflink_cmd);
 		}
 	}
-	if (optind != argc - 4 && optind != argc - 1)
+	if (optind != argc - 4 && optind != argc - 1) {
+		exitcode = 1;
 		return command_usage(&reflink_cmd);
+	}
 	infile = argv[optind];
 	optind++;
 	if (optind == argc)
@@ -262,29 +274,37 @@ reflink_f(
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
 
 clone_all:
 	fd = openfile(infile, NULL, IO_READONLY, 0, NULL);
-	if (fd < 0)
+	if (fd < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	gettimeofday(&t1, NULL);
 	total = reflink_ioctl(fd, soffset, doffset, count, &ops);
-	if (ops == 0 || quiet_flag)
+	if (ops == 0)
+		goto done;
+
+	if (quiet_flag)
 		goto done;
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
diff --git a/io/resblks.c b/io/resblks.c
index 06903f5bb748..c78174e4c086 100644
--- a/io/resblks.c
+++ b/io/resblks.c
@@ -36,15 +36,18 @@ resblks_f(
 		blks = cvtnum(file->geom.blocksize, file->geom.sectsize, argv[1]);
 		if (blks < 0) {
 			printf(_("non-numeric argument -- %s\n"), argv[1]);
+			exitcode = 1;
 			return 0;
 		}
 		res.resblks = blks;
 		if (xfsctl(file->name, file->fd, XFS_IOC_SET_RESBLKS, &res) < 0) {
 			perror("XFS_IOC_SET_RESBLKS");
+			exitcode = 1;
 			return 0;
 		}
 	} else if (xfsctl(file->name, file->fd, XFS_IOC_GET_RESBLKS, &res) < 0) {
 		perror("XFS_IOC_GET_RESBLKS");
+		exitcode = 1;
 		return 0;
 	}
 	printf(_("reserved blocks = %llu\n"),
diff --git a/io/seek.c b/io/seek.c
index 871b47262f03..c944359b41b6 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -132,15 +132,20 @@ seek_f(
 			startflag = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&seek_cmd);
 		}
 	}
-	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1)
+	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1) {
+		exitcode = 1;
 		return command_usage(&seek_cmd);
+	}
 
 	start = offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
-	if (offset < 0)
+	if (offset < 0) {
+		exitcode = 1;
 		return command_usage(&seek_cmd);
+	}
 
 	/*
 	 * check to see if the offset is a data or hole entry and
@@ -186,9 +191,10 @@ found_hole:
 	for (c = 0; flag; c++) {
 		if (offset == -1) {
 			/* print error or eof if the only entry */
-			if (errno != ENXIO || c == 0 )
+			if (errno != ENXIO || c == 0 ) {
 				seek_output(startflag, seekinfo[current].name,
 					    start, offset);
+			}
 			return 0;	/* stop on error or EOF */
 		}
 
diff --git a/io/sendfile.c b/io/sendfile.c
index 063fa7f48114..5f070ebe4434 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -100,6 +100,7 @@ sendfile_f(
 			if (fd < 0 || fd >= filecount) {
 				printf(_("value %d is out of range (0-%d)\n"),
 					fd, filecount-1);
+				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -107,22 +108,28 @@ sendfile_f(
 			infile = optarg;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&sendfile_cmd);
 		}
 	}
-	if (infile && fd != -1)
+	if (infile && fd != -1) {
+		exitcode = 1;
 		return command_usage(&sendfile_cmd);
+	}
 
 	if (!infile)
 		fd = filetable[fd].fd;
-	else if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0)
+	else if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0) {
+		exitcode = 1;
 		return 0;
+	}
 
 	if (optind == argc - 2) {
 		offset = cvtnum(blocksize, sectsize, argv[optind]);
 		if (offset < 0) {
 			printf(_("non-numeric offset argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			goto done;
 		}
 		optind++;
@@ -130,6 +137,7 @@ sendfile_f(
 		if (count < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
+			exitcode = 1;
 			goto done;
 		}
 	} else {
@@ -137,6 +145,7 @@ sendfile_f(
 
 		if (fstat(fd, &stat) < 0) {
 			perror("fstat");
+			exitcode = 1;
 			goto done;
 		}
 		count = stat.st_size;
@@ -144,8 +153,11 @@ sendfile_f(
 
 	gettimeofday(&t1, NULL);
 	c = send_buffer(offset, count, fd, &total);
-	if (c < 0)
+	if (c < 0) {
+		exitcode = 1;
 		goto done;
+	}
+
 	if (qflag)
 		goto done;
 	gettimeofday(&t2, NULL);
diff --git a/io/shutdown.c b/io/shutdown.c
index 022a0e9a07ae..7c62d8c161cb 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -36,12 +36,14 @@ shutdown_f(
 			flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&shutdown_cmd);
 		}
 	}
 
 	if ((xfsctl(file->name, file->fd, XFS_IOC_GOINGDOWN, &flag)) < 0) {
 		perror("XFS_IOC_GOINGDOWN");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/stat.c b/io/stat.c
index 41d421525791..ba285e8e31f7 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -146,15 +146,19 @@ stat_f(
 			verbose = 1;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&stat_cmd);
 		}
 	}
 
-	if (raw && verbose)
+	if (raw && verbose) {
+		exitcode = 1;
 		return command_usage(&stat_cmd);
+	}
 
 	if (fstat(file->fd, &st) < 0) {
 		perror("fstat");
+		exitcode = 1;
 		return 0;
 	}
 
@@ -193,6 +197,7 @@ statfs_f(
 	printf(_("fd.path = \"%s\"\n"), file->name);
 	if (platform_fstatfs(file->fd, &st) < 0) {
 		perror("fstatfs");
+		exitcode = 1;
 	} else {
 		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
 		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
@@ -207,6 +212,7 @@ statfs_f(
 		return 0;
 	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
 		perror("XFS_IOC_FSGEOMETRY_V1");
+		exitcode = 1;
 	} else {
 		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
 		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
@@ -223,6 +229,7 @@ statfs_f(
 	}
 	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
 		perror("XFS_IOC_FSCOUNTS");
+		exitcode = 1;
 	} else {
 		printf(_("counts.freedata = %llu\n"),
 			(unsigned long long) fscounts.freedata);
@@ -327,6 +334,7 @@ statx_f(
 				if (!p || p == optarg) {
 					printf(
 				_("non-numeric mask -- %s\n"), optarg);
+					exitcode = 1;
 					return 0;
 				}
 			}
@@ -346,6 +354,7 @@ statx_f(
 			atflag |= AT_STATX_DONT_SYNC;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&statx_cmd);
 		}
 	}
@@ -356,8 +365,10 @@ statx_f(
 	memset(&stx, 0xbf, sizeof(stx));
 	if (_statx(file->fd, "", atflag | AT_EMPTY_PATH, mask, &stx) < 0) {
 		perror("statx");
+		exitcode = 1;
 		return 0;
 	}
+	exitcode = 0;
 
 	if (raw)
 		return dump_raw_statx(&stx);
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 7e4f3e6da397..bedcdf2ab694 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -58,6 +58,7 @@ sync_range_f(
 			sync_mode = SYNC_FILE_RANGE_WRITE;
 			break;
 		default:
+			exitcode = 1;
 			return command_usage(&sync_range_cmd);
 		}
 	}
@@ -66,13 +67,16 @@ sync_range_f(
 	if (!sync_mode)
 		sync_mode = SYNC_FILE_RANGE_WRITE;
 
-	if (optind != argc - 2)
+	if (optind != argc - 2) {
+		exitcode = 1;
 		return command_usage(&sync_range_cmd);
+	}
 	init_cvtnum(&blocksize, &sectsize);
 	offset = cvtnum(blocksize, sectsize, argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"),
 			argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 	optind++;
@@ -80,11 +84,13 @@ sync_range_f(
 	if (length < 0) {
 		printf(_("non-numeric length argument -- %s\n"),
 			argv[optind]);
+		exitcode = 1;
 		return 0;
 	}
 
 	if (sync_file_range(file->fd, offset, length, sync_mode) < 0) {
 		perror("sync_file_range");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/truncate.c b/io/truncate.c
index 20bada82c4aa..3212536e30df 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -35,11 +35,13 @@ truncate_f(
 	offset = cvtnum(blocksize, sectsize, argv[1]);
 	if (offset < 0) {
 		printf(_("non-numeric truncate argument -- %s\n"), argv[1]);
+		exitcode = 1;
 		return 0;
 	}
 
 	if (ftruncate(file->fd, offset) < 0) {
 		perror("ftruncate");
+		exitcode = 1;
 		return 0;
 	}
 	return 0;
diff --git a/io/utimes.c b/io/utimes.c
index faf9b8d55dbc..1341e20ff0b0 100755
--- a/io/utimes.c
+++ b/io/utimes.c
@@ -48,17 +48,20 @@ utimes_f(
 	result = timespec_from_string(argv[1], argv[2], &t[0]);
 	if (result) {
 		fprintf(stderr, "Bad value for atime\n");
+		exitcode = 1;
 		return 0;
 	}
 	result = timespec_from_string(argv[3], argv[4], &t[1]);
 	if (result) {
 		fprintf(stderr, "Bad value for mtime\n");
+		exitcode = 1;
 		return 0;
 	}
 
 	/* Call futimens to update time. */
 	if (futimens(file->fd, t)) {
 		perror("futimens");
+		exitcode = 1;
 		return 0;
 	}
 
-- 
2.17.0

