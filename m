Return-Path: <SRS0=3UjW=7T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6973BC433DF
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9C0207D0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gl6V3lVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgFFI3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Jun 2020 04:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgFFI3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:29:44 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E458C08C5C2
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:29:44 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e9so6278588pgo.9
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c1Yew8Js0J/UQ9FGA7iBn8K5qCXfyY1wn08iBsl2XiA=;
        b=Gl6V3lVFX5gKaqsrRfDPqSRpsmv53V82Z3J8Q4vSymTImM1NQST+DJ4nl3AoWhdUUJ
         hLblFLgNdZPggl5BlqNqTi5aDBiRcq/XnT5qPcVRyuS8VpP1c+LkReJBv9u5K2zksKy2
         8TtMYXR3pQ7TUgIIJ2/gWRI7RiIpZnv6D2dhdIOUIEbrkHFfBPExMy9dTB8yKjxTVG5b
         Ghg7ZPB4ZqDTUcblD8tH/f8EVNxvRNanhk4JEL7A6bPuuHhRLXWV5B9zi/Q4LdkI/2Nl
         jfpkIaAI59e82F1zokdQMdfYU7L1gjAiNb+TDtwTA9ql1fT39dnp5Kf8eCgnIXtFmDmQ
         ImIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c1Yew8Js0J/UQ9FGA7iBn8K5qCXfyY1wn08iBsl2XiA=;
        b=Psetk+Y+7HxbjtT2Lz28MPv5GcAB+BoEfcDTMhTwi3uKc6jc9C+Fvz/k4BNNgzQ7ZM
         JRKaOVfcFml/34C5GFKzI9miYzxrILgnn6GQ/EyylGo1t8VovOPj6zr/BxEt9oYmZXB3
         z07jUQ/PmCtpPrinZ14Oao9Q6XAmAsXj+nevPAAgh7m+0prGWs1lGgW5GqZhuek70fuA
         wFSW5xagGVYx8vIqBI2PfXDv+E2r3WMf2TtqA34V13MWjwxZ7WSeWXswhVD5k5xty+jK
         ITA3+OrIBsjZVwV5NplG8SR4BPLbfC1CrS36jIkDyOTgkVCowHk1UimCWxUAbLST1kA9
         L5Kg==
X-Gm-Message-State: AOAM531hbXdsIe4ppie67Tec7PkwXau93SpciE/vTH6PUH+bMHN4CmuF
        B0S7XX3s7iyhk998TZQppaCuZ7Mo
X-Google-Smtp-Source: ABdhPJz7YxtbUzq0+4newPo6vzTFSmvp8z2p5dH4ExZnx1DYaYgyoRhjNGDYc27pw6K8et4lp8iHGQ==
X-Received: by 2002:a63:1a42:: with SMTP id a2mr12929796pgm.269.1591432183446;
        Sat, 06 Jun 2020 01:29:43 -0700 (PDT)
Received: from garuda.localnet ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id p30sm1412786pgn.58.2020.06.06.01.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:29:42 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, darrick.wong@oracle.com
Subject: Performance benchmarking of dabtree for working with large number of xattrs
Date:   Sat, 06 Jun 2020 13:59:37 +0530
Message-ID: <3886825.uFHOZ31LPH@garuda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Parent pointers feature allows us to locate all the hard links associated with
an inode.

A parent pointer consists of,
- Parent inode number.
- Generation id.
- Directory offset.
- File name

This information is stored in xattrs of the corresponding inode. The first
three components listed above are stored as part of the "Name" field of
an xattr while the last component i.e. "File name" is stored in the "Value"
field of the xattr.

Dave had informed me that there are instances where an inode can have upto 100
million hard links. On such systems, it translates to having equal number of
xattrs in an inode.

The purpose of this benchmarking is to evaluate if the Dabtree data structure
which is used to store xattrs of an inode can work with large numbers (in the
range of a million or more) of xattrs efficiently.

Scripts/source files that have been used for benchmarking can be found at
https://github.com/chandanr/xfs-xattr-benchmark. This repository also contains
the graphs that plot Leaf space usage, Hash distribution and xattrs per hash.

The repository has the following structure,
- src
  - benchmark-xattrs.c
    Program which actually works (i.e. insert, overwrite and delete) with
    xattrs on disk.
  - benchmark-xattrs.h
  - read-xattrs.c
    Helper program to verify if the required number of xattrs have indeed by
    inserted. This is not required for running the benchmarking tests.
  - rm-one-xattr.c
    Helper program to delete a single xattr. This is not required for running
    the benchmarking tests.
- scripts
  - python
    - xattr-leaf-space-used.py
      Traverses the xattr dabtree, collects statistical information from each
      leaf and dumps that information into a json file. The information
      collected includes,
      - Space used for each leaf node.
      - Hash distribution.
      - Xattrs per hash.
    - insert-xattr-clean-fs.py
      Driver program which uses benchmark-xattrs executable to perform
      benchmarking on a newly created filesystem. It later executes
      xattr-leaf-space-used.py to collect space usage information.
    - insert-xattr-partial-fs.py
      Driver program which uses benchmark-xattrs executable to perform
      benchmarking involving 
      1. Inserting a bunch of xattrs.
      2. Delete 50% of the xattrs.
      3. Either insert new xattrs or delete existing xattrs.
      It later executes xattr-leaf-space-used.py to collect space usage
      information.
    - json-to-graph.py
      Converts json files generated by insert-xattr-clean-fs.py and
      insert-xattr-partial-fs.py into Gnuplot graphs.
  - shell
    - create-remove-leaf-attr.sh
      Obtains CPU usage information for xattr insert and delete workloads. It
      uses benchmark-xattrs for inserting/deleting xattrs.
- graphs
  Contains gnuplot graphs depicting the results of executing benchmarking
  scripts.

Performance benchmarking details
--------------------------------
Benchmarking was performed on an x86_64 machine having,
- Intel Xeon processors, dual socket, 4 cores per socket and 2 threads per
  core.
- 64GiB of main memory.
- 100GiB sized spinning disk partition.

- CPU usage
  - Xattr insert operation
    -------------------------------------
    Nr xattrs  Sys CPU usage(%)  Overhead 
    -------------------------------------
      1000000             96.40         0 
      2000000            199.95    103.55 
      3000000            297.34     97.39 
      4000000            395.64      98.3 
      5000000            500.88    105.24 
      6000000            609.92    109.04 
      7000000            706.61     96.69 
      8000000            825.23    118.62 
      9000000            943.66    118.43 
     10000000           1070.73    127.07 
   --------------------------------------

  - Xattr delete operation
    --------------------------------------
     Nr xattrs  Sys CPU usage(%)  Overhead 
    --------------------------------------
       1000000             75.39         0 
       2000000            162.51     87.12 
       3000000            240.63     78.12 
       4000000            324.40     83.77 
       5000000            402.35     77.95 
       6000000            495.00     92.65 
       7000000            572.34     77.34 
       8000000            739.55    167.21 
       9000000            826.72     87.17 
      10000000            923.95     97.23 
    --------------------------------------

    As can be seen from the above tables, the overhead of inserting/deleting
    xattrs is constant (except for a spike when deleting 8 million xattrs).

    The above data was extracted by executing,
    $ ./create-remove-leaf-attr.sh ../../src/benchmark-xattrs

    NOTE: The above CPU usage benchmarks were obtained on a machine with
    - Intel	i7 processor, Single socket, 4 cores per socket and 2 threads per core.
    - 12 GiB of main memory and
    - 225 GiB of SSD disk.

- Space usage
  - Clean fs
    Each test shown below was executed on a newly created filesystem.
    -------------------------------------------------------------------------------------------------------------------------------------
    Test                                              Nr leaves  Below 2700 bytes  Percentage  Total leaf space  Space wasted  Percentage
											       (bytes)           (bytes)
    -------------------------------------------------------------------------------------------------------------------------------------
    n1000000-120-150-200-220-255-d25                   69,976     54,618                   78  290e6            100e6          36.12
    n1000000-120-150-200-220-255                       81,569     51,571                   63  330e6            91e6           27.13
    n1000000-120-150-200-220-255-o25                   91,423     80,256                   87  370e6            140e6          38.29
    n1000000-20-255-40-220-60-200-80-150-100-120-d25   52,302     35,637                   68  210e6            63e6           29.59
    n1000000-20-255-40-220-60-200-80-150-100-120       60,087     40,117                   66  250e6            74e6           30.17
    n1000000-20-255-40-220-60-200-80-150-100-120-o25   67,755     50,914                   75  280e6            92e6           33.16
    n1000000-20-40-60-80-100-120-150-200-220-255-d25   50,726     45,259                   89  210e6            80e6           38.26
    n1000000-20-40-60-80-100-120-150-200-220-255       59,569     36,207                   60  240e6            66e6           27.02
    n1000000-20-40-60-80-100-120-150-200-220-255-o25   61,984     40,703                   65  250e6            74e6           29.05
    n1000000-20-40-60-80-100-d25                       23,528     9,259                    39  96e6             18e6           18.22
    n1000000-20-40-60-80-100                           31,934     17,140                   53  130e6            33e6           25.11
    n1000000-20-40-60-80-100-o25                       33,829     21,750                   64  140e6            41e6           29.67
    n1000000-255-220-200-150-120-100-80-60-40-20-d25   50,031     45,683                   91  200e6            87e6           42.45
    n1000000-255-220-200-150-120-100-80-60-40-20       58,432     36,864                   63  240e6            68e6           28.54
    n1000000-255-220-200-150-120-100-80-60-40-20-o25   62,105     46,118                   74  250e6            87e6           34.03
    n1000000-255-d25                                   100,674    95,024                   94  410e6            180e6          44.82
    n1000000-255                                       106,567    61,837                   58  440e6            110e6          24.19
    n1000000-255-o25                                   108,567    65,837                   60  440e6            110e6          25.57
    n1000000-40-d25                                    20,082     10,468                   52  82e6             20e6           24.36
    n1000000-40                                        24,445     9,051                    37  100e6            18e6           17.82
    n1000000-40-o25                                    24,445     9,051                    37  100e6            18e6           17.82
    n1000000-60-d25                                    23,520     8,975                    38  96e6             17e6           17.89
    n1000000-60                                        32,091     17,444                   54  130e6            33e6           25.31
    n1000000-60-o25                                    33,473     20,210                   60  140e6            39e6           28.36
    -------------------------------------------------------------------------------------------------------------------------------------

    The data in the table above was obtained by executing,
    $ ./insert-xattr-clean-fs.py ../../src/benchmark-xattrs ./xattr-leaf-space-used.py  ./logs/ ./json/
    Corresponding graphs can be plotted using,
    $ for f in json/*.json; do echo -n "Processing $f ..."; ./json-to-graph.py $f graphs/; echo ' Done'

    Tests have been named using the following convention,
    n{nr xattrs inserted}-{Sequence of possible xattr value
    sizes}-[d{Percentage of xattrs to delete} | o{Percentage of xattrs to
    overwrite}]. 
    For example, n1000000-255-220-200-150-120-100-80-60-40-20-o25 indicates,
    1. Insert 1000000 xattrs.
    2. The value part of the xattrs can have a length of
       255,220,200,150,120,100,80,60,40 or 20 bytes.
    3. o25 indicates that 25% of the xattrs (i.e. 250,000) should be
       overwritten.

    This naming follows from the each of the individual benchmarking cases
    mentioned in insert-xattr-clean-fs.py source file.

    For test cases which involve only insertion of xattrs (as opposed to
    deleting or overwriting them), the maximum space wasted is 30% of the
    total leaf space.

    For test cases which involve overwriting 25% of xattrs with new values,
    the maximum space wasted is 38% of the total leaf space.

    For test cases which involve deleting 25% of xattrs, the maximum space
    wasted is 44% of the total leaf space. This includes the space freed due
    to deletion of xattrs.

    Dave, the percentage of space wasted has increased slightly when compared
    to the numbers I had sent to you late last year. This is because of an
    arithmetic mistake I had made in the json-to-graph.py program.

  - Partial fs
    This benchmark involved inserting xattrs, deleting a certain percentage of
    them and then either inserting new xattrs or further deleting existing
    xattrs.
    -------------------------------------------------------------------------------------------------------------------------------------------------
    Test                                                          Nr leaves  Below 2700 bytes  Percentage  Total leaf space  Space wasted  Percentage
													   (bytes)           (bytes)
    -------------------------------------------------------------------------------------------------------------------------------------------------
    n1000000--s-50-120-150-200-220-255--D-400000                  10,000     10,000                   100  41e6              18e6          45.11     
    n1000000--s-50-120-150-200-220-255--N-400000                  88,432     83,729                    94  360e6             150e6         42.65     
    n1000000--s-50-20-40-60-80-100-120-150-200-220-255--D-400000  8,434      6,369                     75  35e6              15e6          42.42     
    n1000000--s-50-20-40-60-80-100-120-150-200-220-255--N-400000  51,568     21,136                    40  210e6             40e6          18.99     
    n1000000--s-50-20-40-60-80-100--D-400000                      4,245      2,686                     63  17e6              6.1e6         35.21     
    n1000000--s-50-20-40-60-80-100--N-400000                      30,029     14,263                    47  120e6             28e6          22.90     
    n1000000--s-50-255--D-400000                                  12,567     7,701                     61  51e6              16e6          31.75     
    n1000000--s-50-255--N-400000                                  102,433    73,730                    71  420e6             130e6         31.97     
    n1000000--s-50-40--D-400000                                   3,310      2,478                     74  14e6              5.4e6         39.93     
    n1000000--s-50-40--N-400000                                   24,445     10,626                    43  100e6             21e6          20.97     
    n1000000--s-50-60--D-400000                                   4,464      3,230                     72  18e6              7.4e6         40.66     
    n1000000--s-50-60--N-400000                                   30,460     15,448                    50  120e6             30e6          24.28     
    -------------------------------------------------------------------------------------------------------------------------------------------------

    Tests have been named using the following convention,
    n{nr xattrs inserted}-s{Percentage of xattrs to be deleted}-{Sequence of
    possible xattr value sizes}-[D{Percentage of xattrs to delete further} |
    N{Percentage of xattrs to insert}].
    For example, n1000000--s-50-20-40-60-80-100-120-150-200-220-255--N-400000
    indicates,
    1. Insert 1000000 xattrs.
    2. The value part of the xattrs can have a length of
       20,40,60,80,100,120,150,200,220 or 255 bytes.
    3. s-50 indicates that 50% of the xattrs have to deleted.
    4. N-400000 indicates that 400,000 new xattrs have to be inserted.

    This naming follows from the each of the individual benchmarking cases
    mentioned in insert-xattr-partial-fs.py source file.

    For tests which insert 400,000 xattrs after deleting 50% of the initial
    1,000,000 xattrs, the space wasted was mostly less than ~32% (apart from
    the n1000000--s-50-120-150-200-220-255--N-400000 benmarking case).

  - The collection of graphs available from the github repository also
    contain,
    - Hash distribution
      Plots number of unique hash values in each leaf. 
      For all benchmarking scenarios, it is found that hash distribution is
      uniformly spread across the leaves.
    - Xattrs per hash
      Plots number of xattrs associated with each hash value.
      For all benchmarking scenarios, it is found that there is a maximum of
      two xattrs associated with a hash value.

One bug was discovered during benchmarking i.e. the per-inode xattr
extent counter overflowed when,
1. 1,000,000 255-byte sized xattrs are inserted.
2. 50% of these xattrs are deleted in an alternating manner.
3. 400,000 new 255-byte sized xattrs are inserted.

PS: I could not collect space usage benchmarking details for 10 million xattrs
since the corresponding programs required more than 6 hrs for each of the
benchmarking use case.

-- 
chandan



