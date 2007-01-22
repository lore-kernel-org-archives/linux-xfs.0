Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Jan 2007 23:09:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0M79Iqw007915
	for <xfs@oss.sgi.com>; Sun, 21 Jan 2007 23:09:20 -0800
Message-Id: <200701220708.SAA29051@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: [PATCH] fix extent length in xfs_io bmap
Date: Mon, 22 Jan 2007 18:14:06 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200701160537.AA04877@TNESG9305.tnes.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Utako Kusaka' <utako@tnes.nec.co.jp>, xfs@oss.sgi.com

Hi Utako,

I'll push this patch in for the next xfsprogs update.

Thanks,
Barry. 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Utako Kusaka
> Sent: Tuesday, 16 January 2007 4:37 PM
> To: xfs@oss.sgi.com
> Subject: [PATCH] fix extent length in xfs_io bmap
> 
> Hi,
> 
> In bmap command in xfs_io, there is a difference in the 
> length of the extent group
> between "bmap" and "bmap -n nn". 
> It occurs if the file size > max extent size and the extents 
> are allocated contiguously.
> This patch fixes it.
> 
> Test fs:
> # xfs_info /dev/sx8/14p1
> meta-data=/dev/sx8/14p1          isize=256    agcount=16, 
> agsize=7631000 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   
> blocks=122096000, imaxpct=25
>          =                       sunit=0      swidth=0 blks, 
> unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> Example:
> u.bmx[0-5] = [startoff,startblock,blockcount,extentflag]
>  0:[      0, 1048588,2097088,0]
>  1:[2097088, 3145676,2097088,0]
>  2:[4194176, 5242764,2097088,0]
>  3:[6291264, 7339852, 291136,0]
>  4:[6582400, 8388616,2097088,0]
>  5:[8679488,10485704,1806272,0]
> 
> # xfs_io file2
> xfs_io> bmap -v
> file2:
>  EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET   
>            TOTAL
>    0: [0..52659199]:        8388704..61047903   0 
> (8388704..61047903) 52659200   ...*
>    1: [52659200..83886079]: 61048064..92274943  1 
> (64..31226943)      31226880   ...**
> xfs_io> bmap -v -n 1
> file2:
>  EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET         
>      TOTAL
>    0: [0..16776703]:   8388704..25165407  0 
> (8388704..25165407) 16776704         ...*
> xfs_io> bmap -v -n 2
> file2:
>  EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET   
>            TOTAL
>    0: [0..52659199]:        8388704..61047903   0 
> (8388704..61047903) 52659200
>    1: [52659200..69435903]: 61048064..77824767  1 
> (64..16776767)      16776704   ...**
> 
> 
> Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
> ---
> 
> --- xfsprogs-2.8.18-orgn/io/bmap.c	2006-12-13 
> 13:57:22.000000000 +0900
> +++ xfsprogs-2.8.18/io/bmap.c	2006-12-21 11:07:09.573116475 +0900
> @@ -78,6 +78,7 @@ bmap_f(
>  	int			bmv_iflags = 0;	/* flags for 
> XFS_IOC_GETBMAPX */
>  	int			i = 0;
>  	int			c;
> +	int			egcnt;
>  
>  	while ((c = getopt(argc, argv, "adln:pv")) != EOF) {
>  		switch (c) {
> @@ -136,7 +137,7 @@ bmap_f(
>  		}
>  	}
>  
> -	map_size = nflag ? nflag+1 : 32;	/* initial 
> guess - 256 */
> +	map_size = nflag ? nflag+2 : 32;	/* initial 
> guess - 256 */
>  	map = malloc(map_size*sizeof(*map));
>  	if (map == NULL) {
>  		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> @@ -232,9 +233,10 @@ bmap_f(
>  			return 0;
>  		}
>  	}
> +	egcnt = nflag ? min(nflag, map->bmv_entries) : map->bmv_entries;
>  	printf("%s:\n", file->name);
>  	if (!vflag) {
> -		for (i = 0; i < map->bmv_entries; i++) {
> +		for (i = 0; i < egcnt; i++) {
>  			printf("\t%d: [%lld..%lld]: ", i,
>  				(long long) map[i + 1].bmv_offset,
>  				(long long)(map[i + 1].bmv_offset +
> @@ -288,7 +290,7 @@ bmap_f(
>  		 * Go through the extents and figure out the width
>  		 * needed for all columns.
>  		 */
> -		for (i = 0; i < map->bmv_entries; i++) {
> +		for (i = 0; i < egcnt; i++) {
>  			snprintf(rbuf, sizeof(rbuf), "[%lld..%lld]:",
>  				(long long) map[i + 1].bmv_offset,
>  				(long long)(map[i + 1].bmv_offset +
> @@ -325,7 +327,7 @@ bmap_f(
>  			aoff_w, _("AG-OFFSET"),
>  			tot_w, _("TOTAL"),
>  			flg ? _(" FLAGS") : "");
> -		for (i = 0; i < map->bmv_entries; i++) {
> +		for (i = 0; i < egcnt; i++) {
>  			flg = FLG_NULL;
>  			if (map[i + 1].bmv_oflags & BMV_OF_PREALLOC) {
>  				flg |= FLG_PRE;
> 
> 
