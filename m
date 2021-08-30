Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A145C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 07:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147FA60FD9
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 07:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhH3HiW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 03:38:22 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:39929 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhH3HiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 03:38:19 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 7FD2961C3D;
        Mon, 30 Aug 2021 17:37:22 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id r2GWWSbZob2P; Mon, 30 Aug 2021 17:37:22 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id D1B9461C38;
        Mon, 30 Aug 2021 17:37:20 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id B46C1680468; Mon, 30 Aug 2021 17:37:20 +1000 (AEST)
Date:   Mon, 30 Aug 2021 17:37:20 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Mysterious ENOSPC
Message-ID: <20210830073720.GA3763165@onthe.net.au>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
 <20210828002137.GA3642069@onthe.net.au>
 <20210828035824.GA3654894@onthe.net.au>
 <20210829220457.GR3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20210829220457.GR3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Mon, Aug 30, 2021 at 08:04:57AM +1000, Dave Chinner wrote:
> On Sat, Aug 28, 2021 at 01:58:24PM +1000, Chris Dunlop wrote:
>> On Sat, Aug 28, 2021 at 10:21:37AM +1000, Chris Dunlop wrote:
>>> On Sat, Aug 28, 2021 at 08:03:43AM +1000, Dave Chinner wrote:
>>>> commit fd43cf600cf61c66ae0a1021aca2f636115c7fcb
>>>> Author: Brian Foster <bfoster@redhat.com>
>>>> Date:   Wed Apr 28 15:06:05 2021 -0700
>>>>
>>>>   xfs: set aside allocation btree blocks from block reservation
>>>
>>> Oh wow. Yes, sounds like a candidate. Is there same easy(-ish?) way of
>>> seeing if this fs is likely to be suffering from this particular issue
>>> or is it a matter of installing an appropriate kernel and seeing if the
>>> problem goes away?
>>
>> Is this sufficient to tell us that this filesystem probably isn't suffering
>> from that issue?
>
> IIRC, it's the per-ag histograms that are more important here
> because we are running out of space in an AG because of
> overcommitting the per-ag space. If there is an AG that is much more
> fragmented than others, then it will be consuming much more in way
> of freespace btree blocks than others...

Per-ag histograms attached.

Do the blocks used by the allocation btrees show up in the AG 
histograms? E.g. with an AG like this:

AG 18
    from      to extents  blocks    pct
       1       1    1961    1961   0.01
       2       3   17129   42602   0.11
       4       7   33374  183312   0.48
       8      15   68076  783020   2.06
      16      31  146868 3469398   9.14
      32      63  248690 10614558  27.96
      64     127   32088 2798748   7.37
     128     255    8654 1492521   3.93
     256     511    4227 1431586   3.77
     512    1023    2531 1824377   4.81
    1024    2047    2125 3076304   8.10
    2048    4095    1615 4691302  12.36
    4096    8191    1070 6062351  15.97
    8192   16383     139 1454627   3.83
   16384   32767       2   41359   0.11
total free extents 568549
total free blocks 37968026
average free extent size 66.7806

...it looks like it's significantly fragmented, but, if the allocation 
btrees aren't part of this, it seems there's still sufficient free 
space that it shouldn't be getting to ENOSPC?

> FWIW, if you are using reflink heavily and you have rmap enabled (as
> you have), there's every chance that an AG has completely run out of
> space and so new rmap records for shared extents can't be allocated
> - that can give you spurious ENOSPC errors before the filesystem is
> 100% full, too.

This doesn't seem to be the case for this fs as we seem to have "free" 
space in all the AGs, IFF the allocation btrees aren't included in the 
per-AG reported free space.

> i.e. every shared extent in the filesystem has a rmap record
> pointing back to each owner of the shared extent. That means for an
> extent shared 1000 times, there are 1000 rmap records for that
> shared extent. If you share it again, a new rmap record needs to be
> inserted into the rmapbt, and if the AG is completely out of space
> this can fail w/ ENOSPC. Hence you can get ENOSPC errors attempting
> to shared or unshare extents because there isn't space in the AG for
> the tracking metadata for the new extent record....

FYI, in this particular fs the reflinks have low owner counts: I think 
most of the extents are single owner, and the vast majority (and 
perhaps all of) of the multi-owner extents have only 2 owners. I don't 
think there would be any with more than, say, 3 owners.

Out of interest: if an multi-reflinked extent is reduced down to one 
owner is that extent then removed from the reflink btree?

>> $ sudo xfs_db -r -c 'freesp -s' /dev/mapper/vg00-chroot
>>    from      to extents  blocks    pct
>>       1       1   74943   74943   0.00
>>       2       3   71266  179032   0.01
>>       4       7  155670  855072   0.04
>>       8      15  304838 3512336   0.17
>>      16      31  613606 14459417   0.72
>>      32      63 1043230 47413004   2.35
>>      64     127 1130921 106646418   5.29
>>     128     255 1043683 188291054   9.34
>>     256     511  576818 200011819   9.93
>>     512    1023  328790 230908212  11.46
>>    1024    2047  194784 276975084  13.75
>>    2048    4095  119242 341977975  16.97
>>    4096    8191   72903 406955899  20.20
>>    8192   16383    5991 67763286   3.36
>>   16384   32767    1431 31354803   1.56
>>   32768   65535     310 14366959   0.71
>>   65536  131071     122 10838153   0.54
>>  131072  262143      87 15901152   0.79
>>  262144  524287      44 17822179   0.88
>>  524288 1048575      16 12482310   0.62
>> 1048576 2097151      14 20897049   1.04
>> 4194304 8388607       1 5213142   0.26
>> total free extents 5738710
>> total free blocks 2014899298
>> average free extent size 351.107
>
> So 5.7M freespace records. Assume perfect packing an thats roughly
> 500 records to a btree block so at least 10,000 freespace btree
> blocks in the filesytem. But we really need to see the per-ag
> histograms to be able to make any meaningful analysis of the free
> space layout in the filesystem....

See attached for per-ag histograms.

> Context is very important when trying to determine if free space
> fragmentation is an issue or not. Most of the time, it isn't an
> issue at all but people have generally been trained to think "all
> fragmentation is bad" rather than "only worry about fragmentation if
> there is a problem that is directly related to physical allocation
> patterns"...

In this case it's a typical backup application: it uploads regular 
incremental files and those are later merged into a full backup file, 
either by extending or overwriting or reflinking depending on whether the 
app decides to use reflinks or not. The uploads are sequential and mostly 
large-ish writes (132K+), then the merge is small to medium size randomish 
writes or reflinks (4K-???). So the smaller writes/reflinks are going to 
create a significant amount of fragmentation. The incremental files are 
removed entirely at some later time (no discard involved).

I guess if it's determined this pattern is critically suboptimal and 
causing this errant ENOSPC issue, and the changes in 5.13 don't help, 
there's nothing to stop me from occasionally doing a full (non-reflink) 
copy of the large full backup files into another file to get them nicely 
sequential. I'd lose any reflinks along the way of course, but they don't 
last a long time anyway (days to a few weeks) depending on how long the 
smaller incremental files are kept.


Cheers,

Chris

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="freesp-per-ag.txt"


AG 0
   from      to extents  blocks    pct
      1       1    5215    5215   0.00
      2       3    2095    4778   0.00
      4       7    1870   10786   0.01
      8      15    4696   53963   0.05
     16      31    8157  192210   0.18
     32      63   14912  707014   0.65
     64     127   31799 3052928   2.79
    128     255   62759 11177040  10.22
    256     511   51477 17851082  16.33
    512    1023   31651 22157880  20.26
   1024    2047   15353 21439837  19.61
   2048    4095    6229 17536785  16.04
   4096    8191    2416 13086492  11.97
   8192   16383     144 1500294   1.37
  16384   32767      21  461837   0.42
  32768   65535       3  108715   0.10
total free extents 238797
total free blocks 109346856
average free extent size 457.907

AG 1
   from      to extents  blocks    pct
      1       1    2395    2395   0.00
      2       3     988    2299   0.00
      4       7    2101   12169   0.01
      8      15    4150   46624   0.04
     16      31    9433  228624   0.19
     32      63   16784  784775   0.67
     64     127   28022 2665137   2.26
    128     255   47302 8960792   7.60
    256     511   36831 13355167  11.33
    512    1023   29405 21185337  17.98
   1024    2047   18508 26248652  22.27
   2048    4095    8667 24290355  20.61
   4096    8191    3239 17611659  14.95
   8192   16383     187 1969888   1.67
  16384   32767      16  314583   0.27
  32768   65535       4  161187   0.14
total free extents 208032
total free blocks 117839643
average free extent size 566.45

AG 2
   from      to extents  blocks    pct
      1       1     792     792   0.00
      2       3    1391    3490   0.01
      4       7   10670   57044   0.09
      8      15   13407  156686   0.24
     16      31   20931  491161   0.74
     32      63   37588 1774854   2.69
     64     127   75778 7268636  11.01
    128     255   79386 13883934  21.04
    256     511   44863 15288638  23.17
    512    1023   17691 12086170  18.31
   1024    2047    5478 7497222  11.36
   2048    4095    1470 4030441   6.11
   4096    8191     400 2179114   3.30
   8192   16383      80  907597   1.38
  16384   32767      15  309075   0.47
  32768   65535       1   61508   0.09
total free extents 309941
total free blocks 65996362
average free extent size 212.932

AG 3
   from      to extents  blocks    pct
      1       1      29      29   0.00
      2       3     546    1392   0.00
      4       7    3695   19778   0.04
      8      15    5115   59644   0.11
     16      31    8650  203188   0.39
     32      63   19446  931805   1.78
     64     127   33918 3206707   6.12
    128     255   41472 7109466  13.56
    256     511   17943 6233330  11.89
    512    1023    9813 6800951  12.97
   1024    2047    5172 7319826  13.96
   2048    4095    3156 8975995  17.12
   4096    8191    1841 10198723  19.46
   8192   16383      94 1092849   2.08
  16384   32767      13  267832   0.51
total free extents 150903
total free blocks 52421515
average free extent size 347.386

AG 4
   from      to extents  blocks    pct
      1       1    3456    3456   0.00
      2       3     500    1139   0.00
      4       7     569    3705   0.00
      8      15    4786   55972   0.07
     16      31    9612  224801   0.28
     32      63   19371  919993   1.14
     64     127   34259 3236421   3.99
    128     255   62935 10890988  13.44
    256     511   41997 14096666  17.39
    512    1023   21973 14775110  18.23
   1024    2047    6946 9350039  11.54
   2048    4095    2680 8009016   9.88
   4096    8191    3185 17772132  21.93
   8192   16383     119 1383976   1.71
  16384   32767      14  283682   0.35
  32768   65535       1   37998   0.05
total free extents 212403
total free blocks 81045094
average free extent size 381.563

AG 5
   from      to extents  blocks    pct
      1       1    3724    3724   0.00
      2       3     700    1556   0.00
      4       7     117     604   0.00
      8      15    2299   27842   0.03
     16      31    5116  118536   0.14
     32      63   10153  479910   0.55
     64     127   17573 1659991   1.91
    128     255   48504 8454216   9.74
    256     511   33549 11365292  13.10
    512    1023   16890 11524528  13.28
   1024    2047    8227 11463511  13.21
   2048    4095    4975 14744962  16.99
   4096    8191    4363 24030370  27.69
   8192   16383     235 2623084   3.02
  16384   32767      14  281041   0.32
total free extents 156439
total free blocks 86779167
average free extent size 554.716

AG 6
   from      to extents  blocks    pct
      1       1    1674    1674   0.00
      2       3     355     813   0.00
      4       7    2715   16326   0.03
      8      15    7931   88289   0.19
     16      31   13045  305893   0.65
     32      63   24945 1181407   2.52
     64     127   41067 3842176   8.21
    128     255   32329 6311725  13.49
    256     511   18891 6828744  14.59
    512    1023    9908 6967594  14.89
   1024    2047    4350 6045470  12.92
   2048    4095    2193 6439871  13.76
   4096    8191    1461 7911939  16.90
   8192   16383      68  771093   1.65
  16384   32767       4   92454   0.20
total free extents 160936
total free blocks 46805468
average free extent size 290.833

AG 7
   from      to extents  blocks    pct
      1       1    2619    2619   0.01
      2       3    8411   22859   0.05
      4       7   24615  135628   0.29
      8      15   52117  602928   1.27
     16      31  113925 2689338   5.68
     32      63  130210 5632031  11.89
     64     127   70649 6543643  13.81
    128     255   34479 6648866  14.03
    256     511   12599 4479515   9.45
    512    1023    4811 3368174   7.11
   1024    2047    2103 3005162   6.34
   2048    4095    1634 5032217  10.62
   4096    8191    1350 7678961  16.21
   8192   16383     122 1317350   2.78
  16384   32767      10  221553   0.47
total free extents 459654
total free blocks 47380844
average free extent size 103.079

AG 8
   from      to extents  blocks    pct
      1       1    3356    3356   0.00
      2       3    1201    2823   0.00
      4       7    3239   17470   0.02
      8      15    5367   61388   0.08
     16      31   10163  239796   0.31
     32      63   16501  762075   0.97
     64     127   23574 2217722   2.84
    128     255   25811 4591149   5.87
    256     511   17518 6205779   7.94
    512    1023   11425 8119641  10.38
   1024    2047    8511 12248970  15.67
   2048    4095    6239 17951935  22.96
   4096    8191    3798 21258331  27.19
   8192   16383     298 3316518   4.24
  16384   32767      47 1032837   1.32
  32768   65535       4  159307   0.20
total free extents 137052
total free blocks 78189097
average free extent size 570.507

AG 9
   from      to extents  blocks    pct
      1       1    1658    1658   0.00
      2       3     671    1583   0.00
      4       7    3038   17804   0.02
      8      15    7393   84680   0.08
     16      31   14733  346835   0.34
     32      63   26665 1247101   1.23
     64     127   42681 4044159   3.99
    128     255   27529 5020861   4.95
    256     511   17799 6408209   6.32
    512    1023   13490 9703531   9.57
   1024    2047   10811 15690391  15.48
   2048    4095    8127 23294001  22.98
   4096    8191    4988 27939154  27.56
   8192   16383     408 4660404   4.60
  16384   32767      96 2050928   2.02
  32768   65535      18  852224   0.84
total free extents 180105
total free blocks 101363523
average free extent size 562.802

AG 10
   from      to extents  blocks    pct
      1       1     966     966   0.00
      2       3     746    2040   0.00
      4       7    6188   34186   0.04
      8      15   13586  157397   0.18
     16      31   33591  800147   0.93
     32      63   47124 2046100   2.38
     64     127   17498 1627896   1.90
    128     255   22847 4329426   5.04
    256     511   17337 6308302   7.35
    512    1023   12951 9341029  10.88
   1024    2047    9293 13400500  15.61
   2048    4095    6398 18424400  21.47
   4096    8191    3745 20831876  24.27
   8192   16383     316 3677143   4.28
  16384   32767     120 2682190   3.13
  32768   65535      25 1167323   1.36
  65536  131071      11  992269   1.16
total free extents 192742
total free blocks 85823190
average free extent size 445.275

AG 11
   from      to extents  blocks    pct
      1       1    1299    1299   0.00
      2       3     323     708   0.00
      4       7    3575   19776   0.03
      8      15    7735   89139   0.13
     16      31   17713  420384   0.62
     32      63   26712 1166375   1.73
     64     127   14584 1334644   1.97
    128     255   16415 3058179   4.52
    256     511   13009 4603114   6.81
    512    1023    9239 6592614   9.75
   1024    2047    7659 11116956  16.45
   2048    4095    5350 15410257  22.80
   4096    8191    3331 18748075  27.74
   8192   16383     208 2429051   3.59
  16384   32767      55 1244321   1.84
  32768   65535      12  505639   0.75
  65536  131071      10  855948   1.27
total free extents 127229
total free blocks 67596479
average free extent size 531.298

AG 12
   from      to extents  blocks    pct
      1       1    3005    3005   0.00
      2       3     714    1597   0.00
      4       7     187     945   0.00
      8      15    1305   16178   0.02
     16      31    2951   69749   0.08
     32      63    7235  345651   0.38
     64     127   12451 1169316   1.29
    128     255   17704 3131500   3.47
    256     511   17974 6108480   6.76
    512    1023   12145 8411406   9.31
   1024    2047   10674 15329545  16.97
   2048    4095    8003 22792418  25.23
   4096    8191    4873 27235851  30.14
   8192   16383     362 4212767   4.66
  16384   32767      64 1314405   1.45
  32768   65535       5  212528   0.24
total free extents 99652
total free blocks 90355341
average free extent size 906.709

AG 13
   from      to extents  blocks    pct
      1       1    2160    2160   0.00
      2       3     519    1163   0.00
      4       7     484    3058   0.00
      8      15    2409   27772   0.03
     16      31    4278  100415   0.11
     32      63    9579  457724   0.51
     64     127   16929 1587860   1.76
    128     255   17847 3225558   3.57
    256     511   16287 5626056   6.23
    512    1023   11821 8380892   9.28
   1024    2047   10335 14995088  16.60
   2048    4095    7862 22594531  25.01
   4096    8191    4758 26754739  29.61
   8192   16383     420 4805199   5.32
  16384   32767      71 1495249   1.65
  32768   65535       7  291647   0.32
total free extents 105766
total free blocks 90349111
average free extent size 854.236

AG 14
   from      to extents  blocks    pct
      1       1    1381    1381   0.00
      2       3     245     547   0.00
      4       7     283    1808   0.00
      8      15    2387   27720   0.03
     16      31    4178   97402   0.10
     32      63    8758  415855   0.42
     64     127   15409 1452075   1.46
    128     255   21170 4098561   4.12
    256     511   17815 6425768   6.46
    512    1023   12923 9287495   9.34
   1024    2047   11645 16908465  17.00
   2048    4095    8668 25031077  25.16
   4096    8191    5335 29855758  30.01
   8192   16383     380 4260079   4.28
  16384   32767      72 1495166   1.50
  32768   65535       3  112759   0.11
total free extents 110652
total free blocks 99471916
average free extent size 898.962

AG 15
   from      to extents  blocks    pct
      1       1     207     207   0.00
      2       3     519    1471   0.02
      4       7    1978   10867   0.13
      8      15    3736   42434   0.50
     16      31    6604  154719   1.83
     32      63   13689  653865   7.73
     64     127   24824 2356818  27.86
    128     255   21639 3771966  44.59
    256     511    1990  611208   7.23
    512    1023     157  105129   1.24
   1024    2047      74  107559   1.27
   2048    4095     153  377991   4.47
   4096    8191      27  163987   1.94
   8192   16383       9  101213   1.20
total free extents 75606
total free blocks 8459434
average free extent size 111.888

AG 16
   from      to extents  blocks    pct
      1       1    1140    1140   0.00
      2       3     758    1750   0.00
      4       7    1018    5639   0.01
      8      15    1759   19882   0.02
     16      31    3172   75580   0.08
     32      63    8026  384525   0.40
     64     127   13894 1294275   1.36
    128     255   16508 3126070   3.27
    256     511   13907 5090005   5.33
    512    1023   11460 8377061   8.77
   1024    2047    9811 14258785  14.93
   2048    4095    7805 22582010  23.65
   4096    8191    5407 30571003  32.02
   8192   16383     551 6374167   6.68
  16384   32767     156 3255515   3.41
  32768   65535       2   69263   0.07
total free extents 95374
total free blocks 95486670
average free extent size 1001.18

AG 17
   from      to extents  blocks    pct
      1       1    3555    3555   0.02
      2       3    3384    8530   0.04
      4       7    6883   37356   0.20
      8      15   11694  133428   0.70
     16      31   33349  776859   4.10
     32      63   69828 3159981  16.67
     64     127   78168 7397203  39.01
    128     255   24793 4100867  21.63
    256     511    3287 1064507   5.61
    512    1023     816  550030   2.90
   1024    2047     321  453787   2.39
   2048    4095     167  457272   2.41
   4096    8191      77  412315   2.17
   8192   16383      28  309618   1.63
  16384   32767       4   95252   0.50
total free extents 236354
total free blocks 18960560
average free extent size 80.221

AG 18
   from      to extents  blocks    pct
      1       1    1961    1961   0.01
      2       3   17129   42602   0.11
      4       7   33374  183312   0.48
      8      15   68076  783020   2.06
     16      31  146868 3469398   9.14
     32      63  248690 10614558  27.96
     64     127   32088 2798748   7.37
    128     255    8654 1492521   3.93
    256     511    4227 1431586   3.77
    512    1023    2531 1824377   4.81
   1024    2047    2125 3076304   8.10
   2048    4095    1615 4691302  12.36
   4096    8191    1070 6062351  15.97
   8192   16383     139 1454627   3.83
  16384   32767       2   41359   0.11
total free extents 568549
total free blocks 37968026
average free extent size 66.7806

AG 19
   from      to extents  blocks    pct
      1       1     107     107   0.00
      2       3    1571    4670   0.01
      4       7    4283   22880   0.06
      8      15    6402   73460   0.19
     16      31   13908  333208   0.88
     32      63   30597 1431708   3.78
     64     127   55680 5363294  14.16
    128     255   47437 8647119  22.83
    256     511   17362 5680534  15.00
    512    1023    5096 3578314   9.45
   1024    2047    2397 3364622   8.89
   2048    4095    1309 3712093   9.80
   4096    8191     715 3963154  10.47
   8192   16383     143 1501527   3.97
  16384   32767       9  191537   0.51
total free extents 187016
total free blocks 37868227
average free extent size 202.487

AG 20
   from      to extents  blocks    pct
      1       1     598     598   0.00
      2       3     827    2187   0.01
      4       7    3608   19728   0.05
      8      15    6881   79046   0.21
     16      31   13022  305537   0.80
     32      63   25486 1210959   3.17
     64     127   49017 4712712  12.34
    128     255   30156 5748421  15.05
    256     511   10155 3495836   9.15
    512    1023    5674 4149553  10.86
   1024    2047    3253 4652429  12.18
   2048    4095    1900 5476465  14.34
   4096    8191    1208 6732503  17.63
   8192   16383     105 1198304   3.14
  16384   32767      16  338049   0.89
  32768   65535       2   74999   0.20
total free extents 151908
total free blocks 38197326
average free extent size 251.45

AG 21
   from      to extents  blocks    pct
      1       1      20      20   0.00
      2       3      28      63   0.00
      4       7     115     649   0.01
      8      15     244    2809   0.03
     16      31     453   10626   0.11
     32      63    1265   61288   0.63
     64     127    2405  228896   2.35
    128     255    3165  577983   5.93
    256     511    1913  647654   6.64
    512    1023    1038  714076   7.32
   1024    2047     700 1028270  10.55
   2048    4095     698 2035971  20.88
   4096    8191     514 2981234  30.58
   8192   16383      74  834862   8.56
  16384   32767      15  325690   3.34
  32768   65535       7  299123   3.07
total free extents 12654
total free blocks 9749214
average free extent size 770.445

AG 22
   from      to extents  blocks    pct
      1       1     181     181   0.00
      2       3     181     485   0.00
      4       7     471    2569   0.00
      8      15    1133   12622   0.02
     16      31    1660   38976   0.06
     32      63    2968  138446   0.23
     64     127    5624  534816   0.88
    128     255    6238 1013851   1.67
    256     511    4898 1598605   2.63
    512    1023    3271 2265332   3.73
   1024    2047    2349 3367324   5.54
   2048    4095    1707 4927265   8.10
   4096    8191    1258 7233661  11.90
   8192   16383     416 4681490   7.70
  16384   32767     240 5417597   8.91
  32768   65535     142 6879800  11.31
  65536  131071      73 6599297  10.85
 131072  262143      55 9907812  16.30
 262144  524287      15 6182398  10.17
total free extents 32880
total free blocks 60802527
average free extent size 1849.23

AG 23
   from      to extents  blocks    pct
      1       1      90      90   0.00
      2       3      73     174   0.00
      4       7     260    1427   0.00
      8      15     639    7159   0.01
     16      31    1103   26041   0.03
     32      63    2083   99039   0.12
     64     127    4417  423805   0.52
    128     255    6331 1033005   1.28
    256     511    5124 1670066   2.07
    512    1023    3618 2499924   3.09
   1024    2047    2480 3492362   4.32
   2048    4095    1509 4278094   5.30
   4096    8191     996 5688231   7.04
   8192   16383     124 1403821   1.74
  16384   32767      35  805104   1.00
  32768   65535      29 1301420   1.61
  65536  131071      26 2259171   2.80
 131072  262143      31 5862140   7.26
 262144  524287      30 11971903  14.82
 524288 1048575      15 11844396  14.66
1048576 2097151      14 20897049  25.87
4194304 8388607       1 5213142   6.45
total free extents 29028
total free blocks 80777563
average free extent size 2782.75

AG 24
   from      to extents  blocks    pct
      1       1     670     670   0.00
      2       3    1385    3465   0.01
      4       7    4049   22284   0.04
      8      15    7957   91548   0.15
     16      31   18216  435852   0.72
     32      63   50655 2550157   4.20
     64     127   82684 7564495  12.46
    128     255   48304 8493950  14.00
    256     511   21102 7373519  12.15
    512    1023   10541 7401799  12.20
   1024    2047    5096 7179159  11.83
   2048    4095    2525 7157989  11.79
   4096    8191    1378 7677669  12.65
   8192   16383     119 1376478   2.27
  16384   32767     103 2424330   3.99
  32768   65535      15  672757   1.11
  65536  131071       2  131468   0.22
 131072  262143       1  131200   0.22
total free extents 254802
total free blocks 60688789
average free extent size 238.18

AG 25
   from      to extents  blocks    pct
      1       1     405     405   0.00
      2       3     165     378   0.00
      4       7     743    4356   0.01
      8      15    1868   21572   0.03
     16      31    3909   93678   0.12
     32      63    8919  425029   0.55
     64     127   15412 1455339   1.90
    128     255   24492 4427828   5.77
    256     511   19279 6661076   8.68
    512    1023   13237 9346109  12.17
   1024    2047    9003 12812201  16.69
   2048    4095    5778 16383579  21.34
   4096    8191    3442 19072421  24.84
   8192   16383     248 2911859   3.79
  16384   32767      99 2365870   3.08
  32768   65535      18  795680   1.04
total free extents 107017
total free blocks 76777380
average free extent size 717.432

AG 26
   from      to extents  blocks    pct
      1       1      99      99   0.00
      2       3     298     817   0.00
      4       7    1677    8992   0.01
      8      15    2826   32643   0.04
     16      31    5761  136023   0.15
     32      63   12636  615792   0.66
     64     127   18809 1774258   1.91
    128     255   28196 4707461   5.06
    256     511   24529 8159340   8.77
    512    1023   16408 11363082  12.21
   1024    2047   10999 15601527  16.76
   2048    4095    7504 21234282  22.81
   4096    8191    4545 25548241  27.45
   8192   16383     254 2849284   3.06
  16384   32767      34  733619   0.79
  32768   65535       6  307024   0.33
total free extents 134581
total free blocks 93072484
average free extent size 691.572

AG 27
   from      to extents  blocks    pct
      1       1   10879   10879   0.02
      2       3   11703   30182   0.06
      4       7   15365   82109   0.16
      8      15   21594  249932   0.50
     16      31   28409  655518   1.31
     32      63   43497 2049403   4.08
     64     127   72680 6904421  13.76
    128     255  102300 19405736  38.67
    256     511   26206 9273138  18.48
    512    1023    8191 5686275  11.33
   1024    2047    2047 2745613   5.47
   2048    4095     489 1365775   2.72
   4096    8191     180  993540   1.98
   8192   16383      30  320798   0.64
  16384   32767      16  368624   0.73
  32768   65535       1   34557   0.07
total free extents 343587
total free blocks 50176500
average free extent size 146.037

AG 28
   from      to extents  blocks    pct
      1       1    7552    7552   0.01
      2       3    3098    7292   0.01
      4       7    2771   15821   0.02
      8      15    7104   82312   0.10
     16      31   10221  237417   0.29
     32      63   20206  967751   1.16
     64     127   35069 3342138   4.02
    128     255   72234 13584381  16.35
    256     511   37385 13205348  15.89
    512    1023   19299 13455515  16.19
   1024    2047    8191 11466542  13.80
   2048    4095    3650 10478167  12.61
   4096    8191    2434 13579353  16.34
   8192   16383     162 1867524   2.25
  16384   32767      27  595097   0.72
  32768   65535       4  207899   0.25
total free extents 229407
total free blocks 83100109
average free extent size 362.239

AG 29
   from      to extents  blocks    pct
      1       1    7059    7059   0.04
      2       3    6270   15470   0.09
      4       7    9456   50893   0.30
      8      15   15264  175419   1.03
     16      31   26440  618832   3.64
     32      63   44154 2089707  12.28
     64     127   80897 7696115  45.23
    128     255   20391 3384375  19.89
    256     511    3974 1229352   7.22
    512    1023     626  410718   2.41
   1024    2047     141  193862   1.14
   2048    4095      59  170185   1.00
   4096    8191      85  473185   2.78
   8192   16383      21  239248   1.41
  16384   32767      10  208379   1.22
  32768   65535       1   53376   0.31
total free extents 214848
total free blocks 17016175
average free extent size 79.201

AG 30
   from      to extents  blocks    pct
      1       1    1672    1672   0.03
      2       3    1073    2577   0.05
      4       7    1202    6461   0.13
      8      15    1751   19741   0.39
     16      31    2830   65939   1.29
     32      63    4589  216879   4.25
     64     127    8443  801744  15.71
    128     255    5988 1023450  20.05
    256     511    2230  737877  14.46
    512    1023     714  495411   9.71
   1024    2047     377  536218  10.51
   2048    4095     212  611170  11.98
   4096    8191      85  478388   9.37
   8192   16383       7   86683   1.70
  16384   32767       1   19328   0.38
total free extents 31174
total free blocks 5103538
average free extent size 163.711

AG 31
   from      to extents  blocks    pct
      1       1    4225    4225   0.02
      2       3    3496    8376   0.05
      4       7    5808   32657   0.19
      8      15   12158  139830   0.80
     16      31   22809  534239   3.07
     32      63   42627 2017708  11.60
     64     127   79484 7548752  43.41
    128     255   22140 3540716  20.36
    256     511    4862 1476486   8.49
    512    1023     568  364917   2.10
   1024    2047     151  204945   1.18
   2048    4095      58  168429   0.97
   4096    8191      74  435946   2.51
   8192   16383      30  379043   2.18
  16384   32767      27  532823   3.06
total free extents 198517
total free blocks 17389092
average free extent size 87.595

--J/dobhs11T7y2rNN--
