Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A3907F56
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 13:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 097BEAC007
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 11:12:21 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id outve3t8rOO3ZHSI
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 11:12:17 -0700 (PDT)
Received: from [134.64.128.163] (unknown [192.65.45.20])
	by greer.hardwarefreak.com (Postfix) with ESMTPA id 536036C0A6
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 13:12:17 -0500 (CDT)
Message-ID: <544BE820.6040905@hardwarefreak.com>
Date: Sat, 25 Oct 2014 13:12:48 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: file streams allocator behavior
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I recall reading a while back something about disabling the filestreams
allocator, or at least changing its behavior, but I'm unable to find that.

What I'm trying to do is use parallel dd w/O_DIRECT to write 44 files in
parallel to 44 directories, thus all 44 AGs, in one test, then write 44
files to one dir, one AG, in another test.  The purpose of this
quick/dirty exercise is to demonstrate throughput differences due to
full platter seeking in the former case and localized seeking in the
latter case.

But of course the problem I'm running into in the single directory case
is that the filestreams allocator starts writing all of the 44 files
into the appropriate AG, but then begins allocating extents for each
file in other AGs.  This is of course defeating the purpose of the tests.

> /mnt/VOL1/43# for i in `seq 0 43`;do xfs_bmap -v test-$i;done
> test-0:
>  EXT: FILE-OFFSET         BLOCK-RANGE              AG AG-OFFSET            TOTAL FLAGS
>    0: [0..1535]:          92341791520..92341793055 43 (160..1695)           1536 01111
>    1: [1536..3071]:       92341794688..92341796223 43 (3328..4863)          1536 00011
...
>   88: [135168..136703]:   9972480..9974015          0 (9972480..9974015)    1536 00011
>   89: [136704..138239]:   9984768..9986303          0 (9984768..9986303)    1536 00011
...
>  146: [224256..225791]:   2158167552..2158169087    1 (10684032..10685567)  1536
>  147: [225792..227327]:   2158181376..2158182911    1 (10697856..10699391)  1536
...
>  160: [245760..254975]:   10744866688..10744875903  5 (7449088..7458303)    9216 00011
>  161: [254976..256511]:   10744877440..10744878975  5 (7459840..7461375)    1536 00011
...
...
> test-43:
>  EXT: FILE-OFFSET         BLOCK-RANGE              AG AG-OFFSET             TOTAL FLAGS
>    0: [0..1535]:          92341936000..92341937535 43 (144640..146175)       1536 00011
>    1: [1536..3071]:       92342003584..92342005119 43 (212224..213759)       1536 00011
...
>   69: [105984..107519]:   4303912064..4303913599    2 (8945024..8946559)     1536 00011
>   70: [107520..109055]:   4303922816..4303924351    2 (8955776..8957311)     1536 00011
...
...
>  180: [276480..278015]:   8598943744..8598945279    4 (9009664..9011199)     1536 00011
...
>  181: [278016..279551]:   10744961920..10744963455  5 (7544320..7545855)     1536 00011
>  182: [279552..281087]:   10744968064..10744969599  5 (7550464..7551999)     1536 00011
...
...

Files being created are 1.6 GB.  Filesystem is 44 TB.  AGs are 1 TB.
AGs are 0-43.  Directories, /mnt/VOL1/0 - /mnt/VOL1/43.  Device is a
single RAID5 LUN.

How can I disable or change the filestreams behavior so all files go
into the one AG for the single directory test?

Thanks,
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
