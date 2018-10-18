Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f49.google.com ([209.85.128.49]:53371 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbeJRPzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 11:55:11 -0400
Received: by mail-wm1-f49.google.com with SMTP id y11-v6so4410448wma.3
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 00:55:23 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
Date: Thu, 18 Oct 2018 10:55:18 +0300
MIME-Version: 1.0
In-Reply-To: <20181018013727.GE6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 18/10/2018 04.37, Dave Chinner wrote:
> On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
>> I have a user running a 1.7TB filesystem with ~10% usage (as shown
>> by df), getting sporadic ENOSPC errors. The disk is mounted with
>> inode64 and has a relatively small number of large files. The disk
>> is a single-member RAID0 array, with 1MB chunk size. There are 32
>> AGs. Running Linux 4.9.17.
> ENOSPC on what operation? write? open(O_CREAT)? something else?


Unknown.


> What's the filesystem config (xfs_info output)?


(restored from metadata dump)


meta-data=/dev/loop2             isize=512    agcount=32, 
agsize=14494720 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=0 spinodes=0 rmapbt=0
          =                       reflink=0
data     =                       bsize=4096   blocks=463831040, imaxpct=5
          =                       sunit=256    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=226480, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


>> The write load consists of AIO/DIO writes, followed by unlinks of
>> these files. The writes are non-size-changing (we truncate ahead)
>> and we use XFS_IOC_FSSETXATTR/XFS_FLAG_EXTSIZE with a hint size of
>> 32MB. The errors happen on commit logs, which have a target size of
>> 32MB (but may exceed it a little).
>>
>>
>> The errors are sporadic and after restarting the workload they go
>> away for a few hours to a few days, but then return. During one of
>> the crashes I used xfs_db to look at fragmentation and saw that most
>> AGs had free extents of size categories up to 128-255, but a few had
>> more. I tried xfs_fsr but it did not help.
> 32MB extents are 8192 blocks. The bucket 128-255 records extents
> between 512k and 1MB in size, so it sounds like free space has been
> fragmented to death. Has xfs_fsr been run on this filesystem
> regularly?


xfs_fsr has never been run, until we saw the problem (and then did not 
fix it). IIUC the workload should be self-defragmenting: it consists of 
writing large files, then erasing them. I estimate that around 100 files 
are written concurrently (from 14 threads), and they are written with 
large extent hints. With every large file, another smaller (but still 
large) file is written, and a few smallish metadata files.


I understood from xfs_fsr that it attempts to defragment files, not free 
space, although that may come as a side effect. In any case I ran xfs_db 
after xfs_fsr and did not see an improvement.


>
> If the ENOSPC errors are only from files with a 32MB extent size
> hints on them, then it may be that there isn't sufficient contiguous
> free space to allocate an entire 32MB extent. I'm not sure what the
> allocator behaviour here is (the code is a maze of twisty passages),
> so I'll have to look more into this.


There are other files with 32MB hints that do not show the error (but on 
the other hand, the error has been observed few enough times for that to 
be a fluke).


>
> In the mean time, can you post the output of the freespace command
> (both global and per-ag) so we can see just how much free space
> there is and how badly fragmented it has become? I might be able to
> reproduce the behaviour if I know the conditions under which it is
> occuring.


xfs_db> freesp
    from      to extents  blocks    pct
       1       1    5916    5916   0.00
       2       3   10235   22678   0.01
       4       7   12251   66829   0.02
       8      15    5521   59556   0.01
      16      31    5703  132031   0.03
      32      63    9754  463825   0.11
      64     127   16742 1590339   0.37
     128     255 1550511 390108625  89.87
     256     511   71516 29178504   6.72
     512    1023      19   15355   0.00
    1024    2047     287  461824   0.11
    2048    4095     528 1611413   0.37
    4096    8191    1537 10352304   2.38
    8192   16383       2   19015   0.00

Just 2 extents >= 32MB (and they may have been freed after the error).


Per-ag:


    from      to extents  blocks    pct
       1       1     390     390   0.00
       2       3     542    1215   0.01
       4       7     590    3211   0.02
       8      15     265    2735   0.02
      16      31     219    5000   0.04
      32      63     323   15530   0.11
      64     127     620   58217   0.43
     128     255   48677 12254686  90.27
     256     511    2981 1234365   9.09
    from      to extents  blocks    pct
       1       1     542     542   0.00
       2       3     646    1495   0.01
       4       7     592    3122   0.02
       8      15     525    5937   0.04
      16      31     539   12280   0.09
      32      63     691   33226   0.25
      64     127     851   78277   0.59
     128     255   46390 11658684  88.21
     256     511    3335 1422955  10.77
    from      to extents  blocks    pct
       1       1     560     560   0.00
       2       3     642    1454   0.01
       4       7     483    2552   0.02
       8      15     368    4020   0.03
      16      31     440    9947   0.08
      32      63     540   25347   0.21
      64     127     733   67944   0.56
     128     255   42337 10632366  87.06
     256     511    3386 1438609  11.78
     512    1023       5    4423   0.04
    1024    2047       5    8649   0.07
    2048    4095       3    9205   0.08
    4096    8191       1    8191   0.07
    from      to extents  blocks    pct
       1       1     662     662   0.01
       2       3     675    1545   0.02
       4       7     490    2483   0.03
       8      15     414    4485   0.05
      16      31     445    9915   0.11
      32      63     540   25279   0.29
      64     127     683   63014   0.72
     128     255   10061 2483774  28.34
     256     511    1498  574685   6.56
     512    1023       9    6715   0.08
    1024    2047       5    6967   0.08
    2048    4095     100  354101   4.04
    4096    8191     786 5229818  59.68
    from      to extents  blocks    pct
       1       1     642     642   0.01
       2       3     705    1599   0.02
       4       7     545    2801   0.04
       8      15     407    4320   0.05
      16      31     410    9396   0.12
      32      63     513   24294   0.31
      64     127     528   48217   0.61
     128     255    2723  644939   8.17
     256     511     875  326064   4.13
     512    1023       5    4217   0.05
    1024    2047     277  446208   5.65
    2048    4095     425 1248107  15.81
    4096    8191     750 5114295  64.79
    8192   16383       2   19015   0.24
    from      to extents  blocks    pct
       1       1     176     176   0.00
       2       3     484    1228   0.01
       4       7     825    4277   0.03
       8      15      73     870   0.01
      16      31     174    4155   0.03
      32      63     356   16746   0.12
      64     127     597   58761   0.42
     128     255   55401 13814803  99.38
    from      to extents  blocks    pct
       1       1     182     182   0.00
       2       3     212     444   0.00
       4       7      32     188   0.00
       8      15      58     692   0.00
      16      31     102    2369   0.02
      32      63     243   11756   0.08
      64     127     449   43271   0.30
     128     255   53882 13618288  95.22
     256     511    1550  625387   4.37
    from      to extents  blocks    pct
       1       1     147     147   0.00
       2       3     203     426   0.00
       4       7     287    1585   0.01
       8      15      84     958   0.01
      16      31     105    2370   0.02
      32      63     243   12073   0.09
      64     127     497   47704   0.34
     128     255   51847 13080484  94.15
     256     511    1897  747986   5.38
    from      to extents  blocks    pct
       1       1      81      81   0.00
       2       3     129     262   0.00
       4       7     186    1070   0.01
       8      15     148    1781   0.01
      16      31     225    5411   0.04
      32      63     257   12226   0.09
      64     127     492   46230   0.33
     128     255   53802 13533984  95.16
     256     511    1574  621876   4.37
    from      to extents  blocks    pct
       1       1     159     159   0.00
       2       3     191     398   0.00
       4       7     182    1009   0.01
       8      15      63     730   0.01
      16      31      88    2006   0.01
      32      63     191    9044   0.06
      64     127     494   46669   0.33
     128     255   53441 13451913  94.51
     256     511    1850  720941   5.07
    from      to extents  blocks    pct
       1       1     156     156   0.00
       2       3     192     397   0.00
       4       7     169     948   0.01
       8      15      67     780   0.01
      16      31     115    2948   0.02
      32      63     272   12564   0.09
      64     127     511   49124   0.35
     128     255   53339 13427444  94.42
     256     511    1866  726347   5.11
    from      to extents  blocks    pct
       1       1     157     157   0.00
       2       3     171     364   0.00
       4       7     221    1215   0.01
       8      15      45     504   0.00
      16      31     116    2628   0.02
      32      63     249   11827   0.08
      64     127     474   47158   0.33
     128     255   53261 13409025  94.35
     256     511    1886  738689   5.20
    from      to extents  blocks    pct
       1       1     142     142   0.00
       2       3     181     395   0.00
       4       7     323    1753   0.01
       8      15     108    1176   0.01
      16      31     134    3069   0.02
      32      63     260   12055   0.08
      64     127     411   39107   0.28
     128     255   53197 13389340  94.39
     256     511    1877  737582   5.20
    from      to extents  blocks    pct
       1       1     137     137   0.00
       2       3     174     386   0.00
       4       7     222    1232   0.01
       8      15      93    1012   0.01
      16      31      96    2192   0.02
      32      63     223   10763   0.08
      64     127     493   47665   0.34
     128     255   53125 13374075  94.17
     256     511    1949  764710   5.38
    from      to extents  blocks    pct
       1       1      59      59   0.00
       2       3     138     309   0.00
       4       7     224    1217   0.01
       8      15     104    1211   0.01
      16      31     138    3352   0.02
      32      63     337   16480   0.12
      64     127     585   55922   0.39
     128     255   53654 13487724  95.05
     256     511    1589  623688   4.40
    from      to extents  blocks    pct
       1       1     121     121   0.00
       2       3     264     597   0.00
       4       7     706    3907   0.03
       8      15     174    1802   0.01
      16      31      94    2243   0.02
      32      63     228   10806   0.08
      64     127     495   47228   0.34
     128     255   52078 13106646  93.94
     256     511    1953  779417   5.59
    from      to extents  blocks    pct
       1       1     107     107   0.00
       2       3     174     370   0.00
       4       7     248    1401   0.01
       8      15     115    1318   0.01
      16      31     111    2561   0.02
      32      63     218   10243   0.07
      64     127     443   42493   0.30
     128     255   52320 13168357  94.43
     256     511    1828  717948   5.15
    from      to extents  blocks    pct
       1       1     126     126   0.00
       2       3     353     793   0.01
       4       7     774    4297   0.03
       8      15     174    1767   0.01
      16      31     129    3135   0.02
      32      63     317   14569   0.11
      64     127     506   48326   0.35
     128     255   51507 12956078  93.58
     256     511    2055  815607   5.89
    from      to extents  blocks    pct
       1       1     118     118   0.00
       2       3     207     448   0.00
       4       7     299    1694   0.01
       8      15      91     960   0.01
      16      31     104    2394   0.02
      32      63     358   17378   0.12
      64     127     497   47351   0.34
     128     255   52540 13229046  93.84
     256     511    1971  798192   5.66
    from      to extents  blocks    pct
       1       1     105     105   0.00
       2       3     261     571   0.00
       4       7     333    1851   0.01
       8      15     100    1009   0.01
      16      31     137    3323   0.02
      32      63     261   12069   0.09
      64     127     482   45103   0.32
     128     255   51909 13060192  93.20
     256     511    2226  889345   6.35
    from      to extents  blocks    pct
       1       1     111     111   0.00
       2       3     221     471   0.00
       4       7     243    1341   0.01
       8      15     101    1002   0.01
      16      31      87    2145   0.02
      32      63     265   12987   0.09
      64     127     429   41335   0.29
     128     255   51818 13031610  92.85
     256     511    2312  944418   6.73
    from      to extents  blocks    pct
       1       1      89      89   0.00
       2       3     245     542   0.00
       4       7     383    2114   0.02
       8      15     107    1117   0.01
      16      31     153    3505   0.03
      32      63     237   11431   0.08
      64     127     489   46582   0.33
     128     255   51377 12929850  92.48
     256     511    2412  986093   7.05
    from      to extents  blocks    pct
       1       1      83      83   0.00
       2       3     253     536   0.00
       4       7     341    1902   0.01
       8      15     118    1269   0.01
      16      31     137    3201   0.02
      32      63     235   11096   0.08
      64     127     432   41041   0.30
     128     255   51165 12882960  92.73
     256     511    2348  951207   6.85
    from      to extents  blocks    pct
       1       1      63      63   0.00
       2       3     263     570   0.00
       4       7     427    2392   0.02
       8      15     143    1536   0.01
      16      31     117    2714   0.02
      32      63     217   10510   0.08
      64     127     402   38021   0.27
     128     255   50857 12803884  91.91
     256     511    2583 1071722   7.69
    from      to extents  blocks    pct
       1       1      69      69   0.00
       2       3     302     645   0.00
       4       7     343    1884   0.01
       8      15     120    1234   0.01
      16      31     133    3184   0.02
      32      63     215    9971   0.07
      64     127     506   49464   0.35
     128     255   49778 12542384  89.34
     256     511    3333 1429372  10.18
    from      to extents  blocks    pct
       1       1      62      62   0.00
       2       3     300     652   0.00
       4       7     432    2413   0.02
       8      15     173    1814   0.01
      16      31      92    2119   0.02
      32      63     253   12006   0.09
      64     127     439   43006   0.31
     128     255   49809 12539975  89.53
     256     511    3298 1403687  10.02
    from      to extents  blocks    pct
       1       1      52      52   0.00
       2       3     283     608   0.00
       4       7     253    1382   0.01
       8      15     126    1353   0.01
      16      31     117    2653   0.02
      32      63     226   10856   0.08
      64     127     462   43181   0.31
     128     255   50799 12805008  90.86
     256     511    2899 1228715   8.72
    from      to extents  blocks    pct
       1       1      53      53   0.00
       2       3     322     683   0.00
       4       7     473    2658   0.02
       8      15     206    2134   0.02
      16      31     149    3494   0.03
      32      63     251   12271   0.09
      64     127     548   52541   0.38
     128     255   50353 12685959  91.22
     256     511    2753 1146454   8.24
    from      to extents  blocks    pct
       1       1      46      46   0.00
       2       3     309     655   0.00
       4       7     373    2108   0.02
       8      15     181    1951   0.01
      16      31     161    3795   0.03
      32      63     270   12433   0.09
      64     127     434   41689   0.30
     128     255   50963 12821420  91.99
     256     511    2604 1054433   7.56
    from      to extents  blocks    pct
       1       1     121     121   0.00
       2       3     357     779   0.01
       4       7     337    1825   0.01
       8      15     220    2378   0.02
      16      31     181    4124   0.03
      32      63     297   13987   0.10
      64     127     571   53694   0.39
     128     255   49880 12560088  91.06
     256     511    2792 1155483   8.38
    from      to extents  blocks    pct
       1       1     235     235   0.00
       2       3     439     964   0.01
       4       7     448    2445   0.02
       8      15     275    2842   0.02
      16      31     221    4979   0.04
      32      63     332   15967   0.12
      64     127     596   56251   0.41
     128     255   48484 12208089  89.11
     256     511    3341 1408614  10.28
    from      to extents  blocks    pct
       1       1     163     163   0.00
       2       3     397     877   0.01
       4       7     467    2552   0.02
       8      15     275    2859   0.02
      16      31     234    5424   0.04
      32      63     336   16035   0.12
      64     127     593   55753   0.41
     128     255   49737 12515550  91.40
     256     511    2695 1093913   7.99

>> Is this a known issue? Would upgrading the kernel help?
> Not that I know of. If it's an extszhint vs free space fragmentation
> issue, then a kernel upgrade is unlikely to fix it.
>
> Cheers,
>
> Dave.
>
