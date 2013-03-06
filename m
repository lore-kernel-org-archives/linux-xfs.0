Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 228907F77
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 16:01:59 -0600 (CST)
Date: Wed, 6 Mar 2013 16:01:55 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Pathological allocation pattern with direct IO
Message-ID: <20130306220155.GM22182@sgi.com>
References: <20130306202210.GA1318@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130306202210.GA1318@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

Hi Jan,

On Wed, Mar 06, 2013 at 09:22:10PM +0100, Jan Kara wrote:
>   one of our customers has application that write large (tens of GB) files
> using direct IO done in 16 MB chunks. They keep the fs around 80% full
> deleting oldest files when they need to store new ones. Usually the file
> can be stored in under 10 extents but from time to time a pathological case
> is triggered and the file has few thousands extents (which naturally has
> impact on performance). The customer actually uses 2.6.32-based kernel but
> I reproduced the issue with 3.8.2 kernel as well.
> 
> I was analyzing why this happens and the filefrag for the file looks like:
> Filesystem type is: 58465342
> File size of /raw_data/ex.20130302T121135/ov.s1a1.wb is 186294206464
> (45481984 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0       13          4550656
>    1 4550656 188136807  4550668 12562432
>    2 17113088 200699240 200699238 622592
>    3 17735680 182046055 201321831   4096
>    4 17739776 182041959 182050150   4096
>    5 17743872 182037863 182046054   4096
>    6 17747968 182033767 182041958   4096
>    7 17752064 182029671 182037862   4096
> ...
> 6757 45400064 154381644 154389835   4096
> 6758 45404160 154377548 154385739   4096
> 6759 45408256 252951571 154381643  73728 eof
> /raw_data/ex.20130302T121135/ov.s1a1.wb: 6760 extents found
> 
> So we see that at one moment, the allocator starts giving us 16 MB chunks
> backwards. This seems to be caused by XFS_ALLOCTYPE_NEAR_BNO allocation. For
> two cases I was able to track down the logic:
> 
> 1) We start allocating blocks for file. We want to allocate in the same AG
> as the inode is. First we try exact allocation which fails so we try
> XFS_ALLOCTYPE_NEAR_BNO allocation which finds large enough free extent
> before the inode. So we start allocating 16 MB chunks from the end of that
> free extent. From this moment on we are basically bound to continue
> allocating backwards using XFS_ALLOCTYPE_NEAR_BNO allocation until we
> exhaust the whole free extent.
> 
> 2) Similar situation happens when we cannot further grow current extent but
> there is large free space somewhere before this extent in the AG.
> 
> So I was wondering is this known? Is XFS_ALLOCTYPE_NEAR_BNO so beneficial
> it outweights pathological cases like the above? Or shouldn't it maybe be
> disabled for larger files or for direct IO?

I believe we've seen something similar to #2 before:

# xfs_bmap -v /data/dbench.dat
/data/dbench.dat:
  EXT: FILE-OFFSET               BLOCK-RANGE              AG AG-OFFSET                  TOTAL FLAGS
    0: [0..150994943]:           2343559168..2494554111    5 (2048..150996991)      150994944 00011
    1: [150994944..468582399]:   2494556160..2812143615    5 (150999040..468586495) 317587456 00011
    2: [468582400..670957567]:   3078479872..3280855039    6 (266211328..468586495) 202375168 00011
    3: [670957568..671088639]:   3078346752..3078477823    6 (266078208..266209279)    131072 00011
    4: [671088640..671219711]:   3078215680..3078346751    6 (265947136..266078207)    131072 00011
    5: [671219712..671350783]:   3078084608..3078215679    6 (265816064..265947135)    131072 00011
    6: [671350784..671481855]:   3077953536..3078084607    6 (265684992..265816063)    131072 00011
    7: [671481856..671612927]:   3077822464..3077953535    6 (265553920..265684991)    131072 00011
    8: [671612928..671743999]:   3077691392..3077822463    6 (265422848..265553919)    131072 00011
    9: [671744000..671875071]:   3077560320..3077691391    6 (265291776..265422847)    131072 00011
...
2040: [4216979456..4502192127]: 6562093056..6847305727   14 (133120..285345791)    285212672 00011
2041: [4502192128..4685430783]: 6847307776..7030546431   14 (285347840..468586495) 183238656 00011
2042: [4685430784..4876402687]: 9183129600..9374101503   19 (277612544..468584447) 190971904 00011
2043: [4876402688..5344985087]: 9374230528..9842812927   20 (2048..468584447)      468582400 00011
2044: [5344985088..5813567487]: 9842941952..10311524351  21 (2048..468584447)      468582400 00011
2045: [5813567488..6282149887]: 10311653376..10780235775 22 (2048..468584447)      468582400 00011
2046: [6282149888..6750732287]: 10780364800..11248947199 23 (2048..468584447)      468582400 00011
2047: [6750732288..6767501311]: 11249076224..11265845247 24 (2048..16771071)        16769024 00011
2048: [6767501312..7219314687]: 11265845248..11717658623 24 (16771072..468584447)  451813376 00011
2049: [7219314688..7687766015]: 11717918720..12186370047 25 (133120..468584447)    468451328
2050: [7687766016..8156348415]: 12186499072..12655081471 26 (2048..468584447)      468582400 00011
2051: [8156348416..8449425407]: 12655210496..12948287487 27 (2048..293079039)      293076992 00011

In this case, the allocation in AG 6 starts near the middle of the AG and runs
through the end.  At that point we began to march backward through the AG until
it was exhausted.  Not ideal.  Maybe it would be better if
XFS_ALLOCTYPE_NEAR_BNO would move on to the next AG if it reached the end of
the current one.  We need to be careful though.  What is good for this workload
may have unintended consequences for another.

Could you post geometry information for the filesystem in question?
xfs_growfs -n /dev/sda

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
