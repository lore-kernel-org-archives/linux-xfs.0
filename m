Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 02:04:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5N94JU2029953
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 02:04:20 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA14990 for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:05:18 +1000
Date: Mon, 23 Jun 2008 19:08:20 +1000
Subject: REVIEW: XFSQA test for CI testing
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Message-ID: <op.uc62b6dy3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Stresses create/unlink in multiple directory forms, including
leaf-traversal testing by making sure all filenames have the
same on-disk hash value.

I added a CI function to nametest.c which randomly changes the
case of a letter in the filename.

genhashname.c generates the number of specified filenames of
the optionally specified hashvalue (or a random one is chosen).



===========================================================================
xfstests/188
===========================================================================

--- a/xfstests/188	2006-06-17 00:58:24.000000000 +1000
+++ b/xfstests/188	2008-06-23 18:53:52.603966583 +1000
@@ -0,0 +1,75 @@
+#! /bin/sh
+# FS QA Test No. 188
+#
+# drive the src/nametest program for CI mode
+# which does a heap of open(create)/unlink/stat
+# and checks that error codes make sense with its
+# memory of the files created.
+#
+# All filenames generated map to the same hash
+# value in XFS stressing leaf block traversal in
+# node form directories as well.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=bnaujok@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    rm -rf $SCRATCH_MNT/$seq
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+if [ $XFSPROGS_VERSION -lt 21000 ]; then
+    _notrun "this test required case-insensitive support"
+fi
+
+_require_scratch
+rm -f $seq.full
+
+_scratch_mkfs -n version=ci >/dev/null 2>&1
+_scratch_mount
+
+status=1 # default failure
+sourcefile=$tmp.ci_nametest
+seed=1
+
+# need to create an input file with a list of filenames on each line
+# do number of files for testing to try each directory format
+
+# start with small number of files and increase by 4x for each run
+max_files=6144
+num_files=6
+
+mkdir $SCRATCH_MNT/$seq
+while [ $num_files -le $max_files ]; do
+  iterations=`expr $num_files \* 10`
+  $here/src/genhashnames $SCRATCH_MNT/$seq/$num_files $num_files $seed  
>>$sourcefile
+  mkdir $SCRATCH_MNT/$seq/$num_files
+  $here/src/nametest -l $sourcefile -s $seed -i $iterations -z -c
+  num_files=`expr $num_files \* 4`
+done
+
+# success, all done
+status=0
+exit

===========================================================================
xfstests/188.out
===========================================================================

--- a/xfstests/188.out	2006-06-17 00:58:24.000000000 +1000
+++ b/xfstests/188.out	2008-06-23 18:58:43.942490269 +1000
@@ -0,0 +1,65 @@
+QA output created by 188
+seed = 1, hash = 0x0aa84949
+.Seed = 1 (use "-s 1" to re-execute this test)
+
+creates:     15 OK,      5 EEXIST  (    20 total, 25% EEXIST)
+removes:     13 OK,     17 ENOENT  (    30 total, 56% ENOENT)
+lookups:      3 OK,      7 ENOENT  (    10 total, 70% ENOENT)
+total  :     31 OK,     29 w/error (    60 total, 48% w/error)
+
+cleanup:      2 removes
+seed = 1, hash = 0x0aa84949
+.Seed = 1 (use "-s 1" to re-execute this test)
+..
+creates:     58 OK,     50 EEXIST  (   108 total, 46% EEXIST)
+removes:     40 OK,     48 ENOENT  (    88 total, 54% ENOENT)
+lookups:     20 OK,     24 ENOENT  (    44 total, 54% ENOENT)
+total  :    118 OK,    122 w/error (   240 total, 50% w/error)
+
+cleanup:     18 removes
+seed = 1, hash = 0x0aa84949
+.Seed = 1 (use "-s 1" to re-execute this test)
+.........
+creates:    216 OK,    185 EEXIST  (   401 total, 46% EEXIST)
+removes:    152 OK,    179 ENOENT  (   331 total, 54% ENOENT)
+lookups:    113 OK,    115 ENOENT  (   228 total, 50% ENOENT)
+total  :    481 OK,    479 w/error (   960 total, 49% w/error)
+
+cleanup:     64 removes
+seed = 1, hash = 0x0aa84949
+.Seed = 1 (use "-s 1" to re-execute this test)
+.......................................
+creates:    858 OK,    638 EEXIST  (  1496 total, 42% EEXIST)
+removes:    595 OK,    830 ENOENT  (  1425 total, 58% ENOENT)
+lookups:    414 OK,    505 ENOENT  (   919 total, 54% ENOENT)
+total  :   1867 OK,   1973 w/error (  3840 total, 51% w/error)
+.
+cleanup:    263 removes
+seed = 1, hash = 0x0aa84949
+.Seed = 1 (use "-s 1" to re-execute this test)
+.......................................................................
+.........................................................................
+..........
+creates:   3511 OK,   2589 EEXIST  (  6100 total, 42% EEXIST)
+removes:   2363 OK,   3132 ENOENT  (  5495 total, 56% ENOENT)
+lookups:   1668 OK,   2097 ENOENT  (  3765 total, 55% ENOENT)
+total  :   7542 OK,   7818 w/error ( 15360 total, 50% w/error)
+..........
+cleanup:   1148 removes
+seed = 1, hash = 0x0aa84949
+.Seed = 1 (use "-s 1" to re-execute this test)
+.......................................................................
+.........................................................................
+.........................................................................
+.........................................................................
+.........................................................................
+.........................................................................
+.........................................................................
+.........................................................................
+.................................
+creates:  14155 OK,  10391 EEXIST  ( 24546 total, 42% EEXIST)
+removes:   9680 OK,  12484 ENOENT  ( 22164 total, 56% ENOENT)
+lookups:   6508 OK,   8222 ENOENT  ( 14730 total, 55% ENOENT)
+total  :  30343 OK,  31097 w/error ( 61440 total, 50% w/error)
+...........................................
+cleanup:   4475 removes

===========================================================================
xfstests/group
===========================================================================

--- a/xfstests/group	2008-06-23 19:00:32.000000000 +1000
+++ b/xfstests/group	2008-06-23 17:31:24.239390417 +1000
@@ -86,6 +86,9 @@ dmapi
  # filestreams based tests
  filestreams	dgc@sgi.com

+# case-insensitive based tests
+ci		bnaujok@sgi.com
+
  # test-group association ... one line per test
  #
  001 rw dir udf auto
@@ -275,3 +278,4 @@ filestreams	dgc@sgi.com
  185 dmapi auto
  186 attr auto
  187 attr auto
+188 ci dir auto

===========================================================================
xfstests/src/Makefile
===========================================================================

--- a/xfstests/src/Makefile	2008-06-23 19:00:32.000000000 +1000
+++ b/xfstests/src/Makefile	2008-06-23 15:49:40.318538740 +1000
@@ -6,7 +6,7 @@ TOPDIR = ..
  include $(TOPDIR)/include/builddefs

  TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
-	nametest permname randholes runas truncfile usemem \
+	genhashnames nametest permname randholes runas truncfile usemem \
  	mmapcat append_reader append_writer dirperf metaperf \
  	devzero feature alloc fault fstest t_access_root \
  	godown resvtest writemod makeextents itrash \
@@ -52,6 +52,9 @@ truncfile: truncfile.o $(LIBTEST)
  dbtest:	dbtest.o $(LIBTEST)
  	$(LINKTEST) $(LIBTEST) $(LIBGDBM) $(LDLIBS)

+genhashnames: genhashnames.o
+	$(LINKTEST)
+
  nametest: nametest.o $(LIBTEST)
  	$(LINKTEST) $(LIBTEST) $(LDLIBS)


===========================================================================
xfstests/src/genhashnames.c
===========================================================================

--- a/xfstests/src/genhashnames.c	2006-06-17 00:58:24.000000000 +1000
+++ b/xfstests/src/genhashnames.c	2008-06-23 15:52:23.405528316 +1000
@@ -0,0 +1,178 @@
+/*
+ * Creates a bunch of files in the specified directory with the same
+ * hashvalue on-disk.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/time.h>
+
+#define rol32(x,y) (((x) << (y)) | ((x) >> (32 - (y))))
+
+/*
+ * Implement a simple hash on a character string.
+ * Rotate the hash value by 7 bits, then XOR each character in.
+ * This is implemented with some source-level loop unrolling.
+ */
+static uint32_t xfs_da_hashname(const char *name, int namelen)
+{
+	uint32_t	hash;
+
+	/*
+	 * Do four characters at a time as long as we can.
+	 */
+	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
+		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
+		       (name[3] << 0) ^ rol32(hash, 7 * 4);
+
+	/*
+	 * Now do the rest of the characters.
+	 */
+	switch (namelen) {
+	case 3:
+		return (name[0] << 14) ^ (name[1] << 7) ^ (name[2] << 0) ^
+		       rol32(hash, 7 * 3);
+	case 2:
+		return (name[0] << 7) ^ (name[1] << 0) ^ rol32(hash, 7 * 2);
+	case 1:
+		return (name[0] << 0) ^ rol32(hash, 7 * 1);
+	default: /* case 0: */
+		return hash;
+	}
+}
+
+static int is_invalid_char(char c)
+{
+	return (c <= ' ' || c > '~' || c == '/' || (c >= 'A' && c <= 'Z'));
+}
+
+static char random_char(void)
+{
+	char	c;
+
+	/* get a character of "0"-"9" or "a"-"z" */
+
+	c = lrand48() % 36;
+
+	return (c >= 10) ? c + 87 : c + 48;
+}
+
+static int generate_names(const char *path, long amount, uint32_t  
desired_hash)
+{
+	char		**names;
+	char		fullpath[PATH_MAX];
+	char		*filename;
+	long		count;
+	long		i;
+	uint32_t	base_hash;
+	uint32_t	hash;
+
+	names = malloc(amount * sizeof(char *));
+	if (!names) {
+		fprintf(stderr, "genhashnames: malloc(%lu) failed!\n",
+					amount * sizeof(char *));
+		return 1;
+	}
+
+	strcpy(fullpath, path);
+	filename = fullpath + strlen(fullpath);
+	if (filename[-1] != '/')
+		*filename++ = '/';
+
+	for (count = 0; count < amount; count++) {
+		for (;;) {
+			base_hash = 0;
+			for (i = 0; i < 6; i++) {
+				filename[i] = random_char();
+				base_hash = filename[i] ^ rol32(base_hash, 7);
+			}
+			while (i < 200) {
+				filename[i] = random_char();
+				base_hash = filename[i] ^ rol32(base_hash, 7);
+				i++;
+				hash = rol32(base_hash, 3) ^ desired_hash;
+
+				filename[i] = (hash >> 28) |
+							(random_char() & 0xf0);
+				if (is_invalid_char(filename[i]))
+					continue;
+
+				filename[i + 1] = (hash >> 21) & 0x7f;
+				if (is_invalid_char(filename[i + 1]))
+					continue;
+				filename[i + 2] = (hash >> 14) & 0x7f;
+				if (is_invalid_char(filename[i + 2]))
+					continue;
+				filename[i + 3] = (hash >> 7) & 0x7f;
+				if (is_invalid_char(filename[i + 3]))
+					continue;
+				filename[i + 4] = (hash ^ (filename[i] >> 4))
+									& 0x7f;
+				if (is_invalid_char(filename[i + 4]))
+					continue;
+				break;
+			}
+			if (i < NAME_MAX)
+				break;
+		}
+		filename[i + 5] = '\0';
+		if (xfs_da_hashname(filename, i + 5) != desired_hash) {
+			fprintf(stderr, "genhashnames: Hash mismatch!\n");
+			return 1;
+		}
+
+		for (i = 0; i < count; i++) {
+			if (strcmp(fullpath, names[i]) == 0)
+				break;
+		}
+		if (i == count) {
+			names[count] = strdup(fullpath);
+			puts(fullpath);
+		} else
+			count--;
+	}
+	return 0;
+}
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: genhashnames <directory> <amount> "
+			"[seed] [hashvalue]\n");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	long		seed;
+	uint32_t	desired_hash;
+
+	if (argc < 3 || argc > 5)
+		usage();
+
+	if (argc >= 4)
+		seed = strtol(argv[3], NULL, 0);
+	else {
+		struct timeval	tv;
+		gettimeofday(&tv, NULL);
+		seed = tv.tv_usec / 1000 + (tv.tv_sec % 1000) * 1000;
+	}
+	srand48(seed);
+
+	/*
+	 * always generate hash from random so if hash is specified, random
+	 * sequence is the same as a randomly generated hash of the same value.
+	 */
+	desired_hash = (uint32_t)mrand48();
+	if (argc >= 5)
+		desired_hash = (uint32_t)strtoul(argv[4], NULL, 0);
+
+	fprintf(stderr, "seed = %ld, hash = 0x%08x\n", seed, desired_hash);
+
+	return generate_names(argv[1], strtol(argv[2], NULL, 0), desired_hash);
+}

===========================================================================
xfstests/src/nametest.c
===========================================================================

--- a/xfstests/src/nametest.c	2008-06-23 19:00:32.000000000 +1000
+++ b/xfstests/src/nametest.c	2008-06-20 16:55:45.323213752 +1000
@@ -72,6 +72,7 @@ int good_adds, good_rms, good_looks, goo
  int bad_adds, bad_rms, bad_looks, bad_tot;	/* ops that failed */

  int verbose;
+int mixcase;

  int	auto_lookup(struct info *);
  int	auto_create(struct info *);
@@ -82,7 +83,7 @@ void	usage(void);
  void
  usage(void)
  {
-	printf("usage: nametest [-l srcfile] [-i iterations] [-s seed] [-z]  
[-v]\n");
+	printf("usage: nametest [-l srcfile] [-i iterations] [-s seed] [-z] [-v]  
[-c]\n");
  	exit(1);
  }

@@ -96,17 +97,18 @@ main(int argc, char *argv[])
  	struct info *ip;
  	int seed, linedots;

-	linedots = zeroout = verbose = 0;
+	linedots = zeroout = verbose = mixcase = 0;
  	seed = (int)time(NULL) % 1000;
  	iterations = 100000;
  	sourcefile = "input";
-	while ((ch = getopt(argc, argv, "l:i:s:zv")) != EOF) {
+	while ((ch = getopt(argc, argv, "l:i:s:zvc")) != EOF) {
  		switch (ch) {
  		case 'l':	sourcefile = optarg;		break;
  		case 's':	seed = atoi(optarg);		break;
  		case 'i':	iterations = atoi(optarg);	break;
  		case 'z':	zeroout++;			break;
  		case 'v':	verbose++;			break;
+		case 'c':	mixcase++;			break;
  		default:	usage();			break;
  		}
  	}
@@ -303,13 +305,35 @@ main(int argc, char *argv[])
  	return 0;
  }

+char *get_name(struct info *ip)
+{
+	static char path[PATH_MAX];
+	int i;
+	char *p;
+
+	if (!mixcase)
+		return ip->name;
+
+	/* pick a random character to change case in path */
+	strcpy(path, ip->name);
+	p = strrchr(path, '/');
+	if (!p)
+		p = path;
+	p += random() % strlen(p);
+	if (islower(*p))
+		*p = toupper(*p);
+	else
+		*p = tolower(*p);
+	return path;
+}
+
  int
  auto_lookup(struct info *ip)
  {
  	struct stat64 statb;
  	int retval;

-	retval = stat64(ip->name, &statb);
+	retval = stat64(get_name(ip), &statb);
  	if (retval >= 0) {
  		good_looks++;
  		retval = 0;
@@ -352,7 +376,7 @@ auto_create(struct info *ip)
  	struct stat64 statb;
  	int retval;

-	retval = open(ip->name, O_RDWR|O_EXCL|O_CREAT, 0666);
+	retval = open(get_name(ip), O_RDWR|O_EXCL|O_CREAT, 0666);
  	if (retval >= 0) {
  		close(retval);
  		good_adds++;
@@ -400,7 +424,7 @@ auto_remove(struct info *ip)
  {
  	int retval;

-	retval = unlink(ip->name);
+	retval = unlink(get_name(ip));
  	if (retval >= 0) {
  		good_rms++;
  		retval = 0;
