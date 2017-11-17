Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57572 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755539AbdKQCrK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 21:47:10 -0500
Subject: Re: [PATCH v4 2/2] fiemap: Implement ranged query
References: <1510747821-13270-1-git-send-email-nborisov@suse.com>
 <1510747821-13270-2-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <26736c47-b807-62eb-202b-4a959f16832c@sandeen.net>
Date: Thu, 16 Nov 2017 20:47:08 -0600
MIME-Version: 1.0
In-Reply-To: <1510747821-13270-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, eguan@redhat.com, david@fromorbit.com, darrick.wong@oracle.com

On 11/15/17 6:10 AM, Nikolay Borisov wrote:
> Currently the fiemap implementation of xfs_io doesn't support making ranged
> queries. This patch implements two optional arguments which take the starting
> offset and the length of the region to be queried. This also requires changing
> of the final hole range is calculated. Namely, it's now being done as
> [last_logical, logical addres of next extent] rather than being statically
> determined by [last_logical, filesize].
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Ok, so first an apology for taking so long to really, really look at this.

When I started reviewing this, and dreading the complexity of the fiemap loop
control (why /is/ it so complicated today, anyway?) I started wondering: why
do we need a lot more logic?  Why can't we simply:

1) Set a non-zero mapping start
2) Set a non-maximal mapping length
3) Decrement that length as we map, and
4) When the kernel tells us mapped_extents for the range is 0, stop.

And this is what I ended up with, which seems a lot simpler.  Is there any
problem with this approach?

This /almost/ passes your test; what it doesn't do is show holes at the edges
of the mapping range, but I think that's ok.

The interface itself says nothing about holes, it only maps allocated ranges.

If we ask for a ranged query, I think it's appropriate to /not/ print holes
on either side of the requested range.


Thoughts?



diff --git a/io/fiemap.c b/io/fiemap.c
index bdcfacd..bbf6d63 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -49,6 +49,8 @@ fiemap_help(void)
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
 " -n -- query n extents.\n"
 " -v -- Verbose information\n"
+" offset is the starting offset to map, and is optional.  If offset is\n"
+" specified, mapping length may (optionally) be specified as well."
 "\n"));
 }
 
@@ -235,9 +237,15 @@ fiemap_f(
 	int		boff_w = 16;
 	int		tot_w = 5;	/* 5 since its just one number */
 	int		flg_w = 5;
-	__u64		last_logical = 0;
+	__u64		last_logical = 0;	/* last extent offset handled */
+	off64_t		start_offset = 0;	/* mapping start */
+	off64_t		length = -1LL;		/* mapping length */
+	off64_t		range_end = -1LL;	/* mapping end*/
+	size_t		fsblocksize, fssectsize;
 	struct stat	st;
 
+	init_cvtnum(&fsblocksize, &fssectsize);
+
 	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
 		switch (c) {
 		case 'a':
@@ -257,6 +265,27 @@ fiemap_f(
 		}
 	}
 
+	/* Range start (optional) */
+	if (optind < argc) {
+		start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (start_offset < 0) {
+			printf("non-numeric offset argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		last_logical = start_offset;
+		optind++;
+	}
+
+	/* Range length (optional if range start was specified) */
+	if (optind < argc) {
+		length = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (length < 0) {
+			printf("non-numeric len argument -- %s\n", argv[optind]);
+			return 0;
+		}
+		range_end = start_offset + length;
+	}
+
 	map_size = sizeof(struct fiemap) +
 		(EXTENT_BATCH * sizeof(struct fiemap_extent));
 	fiemap = malloc(map_size);
@@ -274,7 +303,7 @@ fiemap_f(
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1LL;
+		fiemap->fm_length = range_end - last_logical;
 		fiemap->fm_extent_count = EXTENT_BATCH;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -336,7 +365,8 @@ fiemap_f(
 		return 0;
 	}
 
-	if (cur_extent && last_logical < st.st_size)
+	/* Print last hole to EOF only if range end was not specified */
+	if (cur_extent && (range_end == -1LL) && (last_logical < st.st_size))
 		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
 			   BTOBBT(last_logical), BTOBBT(st.st_size));
 
@@ -353,7 +383,7 @@ fiemap_init(void)
 	fiemap_cmd.argmin = 0;
 	fiemap_cmd.argmax = -1;
 	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	fiemap_cmd.args = _("[-alv] [-n nx]");
+	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
 	fiemap_cmd.oneline = _("print block mapping for a file");
 	fiemap_cmd.help = fiemap_help;
 

