Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49787 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbdKUOSz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 09:18:55 -0500
Subject: Re: [PATCH] xfs_io: implement ranged fiemap query
References: <c1bec5de-57de-a451-08b9-80376b635d28@redhat.com>
 <20171121052531.GH2749@eguan.usersys.redhat.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b7ca2898-12b5-c03b-dab7-38807370433c@suse.com>
Date: Tue, 21 Nov 2017 16:18:53 +0200
MIME-Version: 1.0
In-Reply-To: <20171121052531.GH2749@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 21.11.2017 07:25, Eryu Guan wrote:
> On Fri, Nov 17, 2017 at 11:22:07AM -0600, Eric Sandeen wrote:
>> From: Nikolay Borisov <nborisov@suse.com>
>>
>> Currently the fiemap implementation of xfs_io doesn't support making ranged
>> queries. This patch implements two optional arguments which take the starting
>> offset and the length of the region to be queried.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> [sandeen: simplify/rewrite ranged logic]
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> ---
>>
>> I think this is a simpler approach.  There are some questions about how
>> the fiemap command should handle holes and ranges, however.
>>
>> First and foremost, the kernel will return any extent(s) which overlap(s)
>> with the requested range.  Holes are simply inferred by xfs_io from the
> 
> So it's expected that data range won't be truncated on boundaries? e.g.
> 
> # xfs_io -fc "pwrite 4k 4k" -c "pwrite 12k 4k" -c fsync -c "fiemap" -c "fiemap 6k 2k" testfile
> wrote 4096/4096 bytes at offset 4096
> 4 KiB, 1 ops; 0.0000 sec (300.481 MiB/sec and 76923.0769 ops/sec)
> wrote 4096/4096 bytes at offset 12288
> 4 KiB, 1 ops; 0.0000 sec (781.250 MiB/sec and 200000.0000 ops/sec)
> testfile:
>         0: [0..7]: hole
>         1: [8..15]: 1300882584..1300882591
>         2: [16..23]: hole
>         3: [24..31]: 1300882592..1300882599
> testfile:
>         0: [8..15]: 1300882584..1300882591  <=== not truncated on range boundaries
> xfs_io: ioctl(FS_IOC_FIEMAP) ["testfile"]: Invalid argument

Fixed the invalid argument, however I have another question, you are
right that the output is no truncated on range boundaries for extents,
however for holes it is:


xfs_io -fc "pwrite 4k 4k" -c "pwrite 12k 4k" -c "fsync" -c "fiemap" -c
"fiemap 6k 4k" testfile
wrote 4096/4096 bytes at offset 4096
4 KiB, 1 ops; 0.0000 sec (186,012 MiB/sec and 47619,0476 ops/sec)
wrote 4096/4096 bytes at offset 12288
4 KiB, 1 ops; 0.0000 sec (1,272 GiB/sec and 333333,3333 ops/sec)
testfile:
	0: [0..7]: hole
	1: [8..15]: 87260408..87260415
	2: [16..23]: hole
	3: [24..31]: 87260416..87260423
testfile:
	0: [8..15]: 87260408..87260415
	1: [16..19]: hole <===== truncated on range boundaries

This discrepancy currently doesn't break any tests and I think it's
rather minor but I'd like people's opinion on whether it's ok. Actually
fixing it might be a bit cumbersome since this would mean we need to do
another fiemap query to get the next extent and I doubt it it's worth it.


Btw with this patch it's not even necessary to change the existing
xfstest punchole tests i.e. the output fixup and the change in the
output files. So this patch is definitely better.



> 
> And the "Invalid argument" looks suspicious too. Note that I applied
> this patch on top of latest for-next branch.
> 
> Another very minor issue on the extent sequence number:
> 
> # xfs_io -fc "pwrite 4k 4k" -c "pwrite 12k 4k" -c fsync -c "fiemap" -c "fiemap 4k 8k" testfile
> wrote 4096/4096 bytes at offset 4096
> 4 KiB, 1 ops; 0.0000 sec (325.521 MiB/sec and 83333.3333 ops/sec)
> wrote 4096/4096 bytes at offset 12288
> 4 KiB, 1 ops; 0.0000 sec (781.250 MiB/sec and 200000.0000 ops/sec)
> testfile:
>         0: [0..7]: hole
>         1: [8..15]: 1300882584..1300882591
>         2: [16..23]: hole
>         3: [24..31]: 1300882592..1300882599
> testfile:
>         0: [8..15]: 1300882584..1300882591
>         2: [16..23]: hole>
> Range "4k 8k" includes two extents, from the full-file fiemap result
> the extents are continuous (extent 1 2), but the range results list the
> extents as 0 and 2. It should be continuous too?

Fixed in next version.
> 
> Thanks,
> Eryu
> 
>> spaces in between.
>>
>> So there are questions about what to do if i.e. the range starts or ends
>> in a hole.
>>
>> This patch (I think!) /will/ describe a hole on either side of the requested
>> range, if it exists, with start and end points of the hole(s) based on
>> the range start & end.  i.e. with range on boundaries:
>>
>> # io/xfs_io -c "fiemap 0 12k"  alternating 
>> alternating:
>> 	0: [0..7]: hole
>> 	1: [8..15]: 60550776..60550783
>> 	2: [16..23]: hole
>>
>> with range in middle of holes, hole ranges are truncated:
>>
>> # io/xfs_io -c "fiemap 1k 10k"  alternating 
>> alternating:
>> 	0: [2..7]: hole
>> 	1: [8..15]: 60550776..60550783
>> 	2: [16..21]: hole
>>
>> i.e. note that the first hole starts at the requested 1k range, and
>> the last hole ends at the end of the requested range.
>>
>> Seems reasonable?
>>
>>
>>
>> diff --git a/io/fiemap.c b/io/fiemap.c
>> index bdcfacd..266d134 100644
>> --- a/io/fiemap.c
>> +++ b/io/fiemap.c
>> @@ -49,6 +49,8 @@ fiemap_help(void)
>>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>>  " -n -- query n extents.\n"
>>  " -v -- Verbose information\n"
>> +" offset is the starting offset to map, and is optional.  If offset is\n"
>> +" specified, mapping length may (optionally) be specified as well."
>>  "\n"));
>>  }
>>  
>> @@ -118,7 +120,7 @@ print_verbose(
>>  			flg_w, _("FLAGS"));
>>  	}
>>  
>> -	if (lstart != llast) {
>> +	if (lstart > llast) {
>>  		print_hole(foff_w, boff_w, tot_w, cur_extent, 0, false, llast,
>>  			   lstart);
>>  		cur_extent++;
>> @@ -155,7 +157,7 @@ print_plain(
>>  	len = BTOBBT(extent->fe_length);
>>  	block = BTOBBT(extent->fe_physical);
>>  
>> -	if (lstart != llast) {
>> +	if (lstart > llast) {
>>  		print_hole(0, 0, 0, cur_extent, lflag, true, llast, lstart);
>>  		cur_extent++;
>>  	}
>> @@ -235,9 +237,15 @@ fiemap_f(
>>  	int		boff_w = 16;
>>  	int		tot_w = 5;	/* 5 since its just one number */
>>  	int		flg_w = 5;
>> -	__u64		last_logical = 0;
>> +	__u64		last_logical = 0;	/* last extent offset handled */
>> +	off64_t		start_offset = 0;	/* mapping start */
>> +	off64_t		length = -1LL;		/* mapping length */
>> +	off64_t		range_end = -1LL;	/* mapping end*/
>> +	size_t		fsblocksize, fssectsize;
>>  	struct stat	st;
>>  
>> +	init_cvtnum(&fsblocksize, &fssectsize);
>> +
>>  	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>>  		switch (c) {
>>  		case 'a':
>> @@ -257,6 +265,27 @@ fiemap_f(
>>  		}
>>  	}
>>  
>> +	/* Range start (optional) */
>> +	if (optind < argc) {
>> +		start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>> +		if (start_offset < 0) {
>> +			printf("non-numeric offset argument -- %s\n", argv[optind]);
>> +			return 0;
>> +		}
>> +		last_logical = start_offset;
>> +		optind++;
>> +	}
>> +
>> +	/* Range length (optional if range start was specified) */
>> +	if (optind < argc) {
>> +		length = cvtnum(fsblocksize, fssectsize, argv[optind]);
>> +		if (length < 0) {
>> +			printf("non-numeric len argument -- %s\n", argv[optind]);
>> +			return 0;
>> +		}
>> +		range_end = start_offset + length;
>> +	}
>> +
>>  	map_size = sizeof(struct fiemap) +
>>  		(EXTENT_BATCH * sizeof(struct fiemap_extent));
>>  	fiemap = malloc(map_size);
>> @@ -274,7 +303,7 @@ fiemap_f(
>>  		memset(fiemap, 0, map_size);
>>  		fiemap->fm_flags = fiemap_flags;
>>  		fiemap->fm_start = last_logical;
>> -		fiemap->fm_length = -1LL;
>> +		fiemap->fm_length = range_end - last_logical;
>>  		fiemap->fm_extent_count = EXTENT_BATCH;
>>  
>>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
>> @@ -336,9 +365,12 @@ fiemap_f(
>>  		return 0;
>>  	}
>>  
>> -	if (cur_extent && last_logical < st.st_size)
>> +	/* Print last hole to EOF or to end of requested range */
>> +	range_end = min((uint64_t)range_end, st.st_size);
>> +
>> +	if (cur_extent && last_logical < range_end)
>>  		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
>> -			   BTOBBT(last_logical), BTOBBT(st.st_size));
>> +			   BTOBBT(last_logical), BTOBBT(range_end));
>>  
>>  out:
>>  	free(fiemap);
>> @@ -353,7 +385,7 @@ fiemap_init(void)
>>  	fiemap_cmd.argmin = 0;
>>  	fiemap_cmd.argmax = -1;
>>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>> -	fiemap_cmd.args = _("[-alv] [-n nx]");
>> +	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
>>  	fiemap_cmd.oneline = _("print block mapping for a file");
>>  	fiemap_cmd.help = fiemap_help;
>>  
>> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
>> index 9bf1a47..7633734 100644
>> --- a/man/man8/xfs_io.8
>> +++ b/man/man8/xfs_io.8
>> @@ -304,11 +304,12 @@ Prints the block mapping for the current open file. Refer to the
>>  .BR xfs_bmap (8)
>>  manual page for complete documentation.
>>  .TP
>> -.BI "fiemap [ \-alv ] [ \-n " nx " ]"
>> +.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
>>  Prints the block mapping for the current open file using the fiemap
>>  ioctl.  Options behave as described in the
>>  .BR xfs_bmap (8)
>> -manual page.
>> +manual page. Optionally, this command also supports passing the start offset
>> +from where to begin the fiemap and the length of that region.
>>  .TP
>>  .BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
>>  Prints the mapping of disk blocks used by the filesystem hosting the current
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
