Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA5EC7EE37
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 23:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbjFFXBF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 19:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbjFFXBD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 19:01:03 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADD610F2
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 16:00:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b0201d9a9eso262045ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Jun 2023 16:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686092459; x=1688684459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eyjTyqNe4cCvwvlzSuK/9OtHh3PU+MWyLm4VHp0YqiA=;
        b=bRIJU+Wz/nD3xgthr41mtAfYRtZlzXzb+M4XYipksDpyBWDyW8L+dwGJVIaKMbvCjK
         ah6L27ZIaIsSOhVqSSI1TH5L9ifa/BXwXKBUhzEw2K9gg5eO3nxgbz7Hehpz7uKuYhPM
         D54yB4a4t0rgQ5LmvHgbWaElWdB4/34Gwr5hurOsuBuFi5vsp8uFwsQAhw/GsVHUdRpK
         YgG399SLyJl97yJx8zNssodYouMttP+FVb/SQEWwZL3/PmSGtL2EhYPrN7NpWqGMS4AH
         r5gc4f7WjSLpLqatzRnMyXQsh7jZFeI/z5xk2ukqSKiNEUKKmdxuLni3U72R+hpSONq6
         XqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686092459; x=1688684459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eyjTyqNe4cCvwvlzSuK/9OtHh3PU+MWyLm4VHp0YqiA=;
        b=NGPz/7uzpvx9MNbnGihoa4+pHw8YgwZDoscczQtpei7lVN2duSlbrh77KKlQP2o97W
         /GnKpLRheh/cl9NF9oaVCMLUPEeG9hpRNb2g7PY8IKNwNb7R4Q1ti10V4cpTtg74xV/W
         EZfjd8XnuQA2qZcIKhIkKlMk+o9cqOMsLJC+5b+jiLT3yA80hrHMwmmclwUoVvHNSBpH
         5Um4dO3Xns0QpBtrS6WLpUYZUmxb0hkA4xYpW4gOJvXyaZOcjKLPQndrPKLW0ZU4wYMH
         leqDD1KL4cfk/n+Wl5Y0tMPOIrYUUYhFnTCpe8YJu+sGi9wBB0O6KLXS1XZlLZf4acwa
         QD2g==
X-Gm-Message-State: AC+VfDw+wqA7sIUiDw6/iVqSAxIIGpjBM5qeGaf/HL0fYD7byY/hYhsi
        pfE8GlOsZ2hxTas83b9pkvnFS0f4ARXqpA==
X-Google-Smtp-Source: ACHHUZ6DnqpIy8AnhPq7fJ29/ECLUKlkOuzHUo20Xp8NQc7PMa0c0FuSTdYQ1uaomapRN6wUil28Pw==
X-Received: by 2002:a17:903:11d0:b0:1b0:4a2:5928 with SMTP id q16-20020a17090311d000b001b004a25928mr14479589plh.8.1686092458696;
        Tue, 06 Jun 2023 16:00:58 -0700 (PDT)
Received: from ?IPV6:2606:4700:110:8939:3cc4:589f:70ed:f5b0? ([2a09:bac0:1000:a2::4:23d])
        by smtp.gmail.com with ESMTPSA id je12-20020a170903264c00b001addf547a6esm9031366plb.17.2023.06.06.16.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 16:00:57 -0700 (PDT)
Message-ID: <b9c528fd-9556-12c5-4628-4163c070e45d@gmail.com>
Date:   Tue, 6 Jun 2023 16:00:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Question on the xfs inode slab memory
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
 <ZHfhYsqln68N1HyO@dread.disaster.area>
 <7572072d-8132-d918-285c-3391cb041cff@gmail.com>
 <ZHkRHW9Fd19du0Zv@dread.disaster.area>
From:   Jianan Wang <wangjianan.zju@gmail.com>
In-Reply-To: <ZHkRHW9Fd19du0Zv@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Just to follow up on this. We have performed the testing using the Ubuntu 20.04 with 5.15 kernel as well as our custom built xfs 5.9, but we still see significant slab memory build-up during the process. Below are the information for your reference:

Linux# xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=32, agsize=146492160 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=4687748608, imaxpct=5
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Linux# xfs_db -r /dev/sdb1
xfs_db> version
versionnum [0xb5b5+0x18a] = V5,NLINK,DIRV2,ATTR,ALIGN,DALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK

Linux# xfs_info -V
xfs_info version 5.9.0

Linux# cat /proc/meminfo
MemTotal:       526966076 kB
MemFree:        128253892 kB
MemAvailable:   422280036 kB
Buffers:          309532 kB
Cached:         265523976 kB
SwapCached:            0 kB
Active:         101563884 kB
Inactive:       165695060 kB
Active(anon):      17320 kB
Inactive(anon):  1374072 kB
Active(file):   101546564 kB
Inactive(file): 164320988 kB
Unevictable:       18472 kB
Mlocked:           18472 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:       1281636 kB
Mapped:           320712 kB
Shmem:             14156 kB
KReclaimable:   33278880 kB
Slab:           56547064 kB
SReclaimable:   33278880 kB
SUnreclaim:     23268184 kB
KernelStack:       41488 kB
PageTables:        19824 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    263483036 kB
Committed_AS:   12538508 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      440260 kB
VmallocChunk:          0 kB
Percpu:           141760 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:    113564068 kB
DirectMap2M:    268806144 kB
DirectMap1G:    155189248 kB

root@sjc1-training-prod-104:~# cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
wg_peer                0      0   1552   21    8 : tunables    0    0    0 : slabdata      0      0      0
ufs_inode_cache        0      0    840   39    8 : tunables    0    0    0 : slabdata      0      0      0
qnx4_inode_cache       0      0    712   46    8 : tunables    0    0    0 : slabdata      0      0      0
hfsplus_attr_cache      0      0   3840    8    8 : tunables    0    0    0 : slabdata      0      0      0
hfsplus_icache         0      0    960   34    8 : tunables    0    0    0 : slabdata      0      0      0
hfs_inode_cache        0      0    832   39    8 : tunables    0    0    0 : slabdata      0      0      0
minix_inode_cache      0      0    704   46    8 : tunables    0    0    0 : slabdata      0      0      0
ntfs_big_inode_cache      0      0    960   34    8 : tunables    0    0    0 : slabdata      0      0      0
ntfs_inode_cache       0      0    296   55    4 : tunables    0    0    0 : slabdata      0      0      0
jfs_ip                 0      0   1312   24    8 : tunables    0    0    0 : slabdata      0      0      0
au_vdir                0      0    128   32    1 : tunables    0    0    0 : slabdata      0      0      0
au_finfo               0      0    192   42    2 : tunables    0    0    0 : slabdata      0      0      0
au_icntnr              0      0    832   39    8 : tunables    0    0    0 : slabdata      0      0      0
au_dinfo               0      0    192   42    2 : tunables    0    0    0 : slabdata      0      0      0
xfs_dqtrx              0      0    528   62    8 : tunables    0    0    0 : slabdata      0      0      0
xfs_dquot              0      0    496   33    4 : tunables    0    0    0 : slabdata      0      0      0
xfs_buf           6161830 6162282    384   42    4 : tunables    0    0    0 : slabdata 146721 146721      0
xfs_rui_item           0      0    680   48    8 : tunables    0    0    0 : slabdata      0      0      0
xfs_rud_item        8784   8784    168   48    2 : tunables    0    0    0 : slabdata    183    183      0
xfs_icr            33396  33810    176   46    2 : tunables    0    0    0 : slabdata    735    735      0
xfs_inode         20062909 24750334    960   34    8 : tunables    0    0    0 : slabdata 727951 727951      0
xfs_efd_item       10360  10656    432   37    4 : tunables    0    0    0 : slabdata    288    288      0
xfs_trans           4550   4550    232   35    2 : tunables    0    0    0 : slabdata    130    130      0
xfs_da_state        2720   2720    480   34    4 : tunables    0    0    0 : slabdata     80     80      0
xfs_btree_cur       2880   2880    224   36    2 : tunables    0    0    0 : slabdata     80     80      0
kvm_async_pf        4800   4800    136   60    2 : tunables    0    0    0 : slabdata     80     80      0
kvm_vcpu               0      0  10880    3    8 : tunables    0    0    0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    184   44    2 : tunables    0    0    0 : slabdata      0      0      0
x86_emulator           0      0   2672   12    8 : tunables    0    0    0 : slabdata      0      0      0
rbd_img_request        0      0    160   51    2 : tunables    0    0    0 : slabdata      0      0      0
uvm_tools_event_tracker_t      0      0   1128   29    8 : tunables    0    0    0 : slabdata      0      0      0
migrate_vma_state_t      0      0 302152    1  128 : tunables    0    0    0 : slabdata      0      0      0
uvm_range_group_range_t      0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
uvm_va_block_context_t      0      0   1472   22    8 : tunables    0    0    0 : slabdata      0      0      0
uvm_va_block_t       608    608    848   38    8 : tunables    0    0    0 : slabdata     16     16      0
uvm_va_range_t      4743   4811   1896   17    8 : tunables    0    0    0 : slabdata    283    283      0
ceph_osd_request       0      0   1200   27    8 : tunables    0    0    0 : slabdata      0      0      0
ceph_msg               0      0    240   34    2 : tunables    0    0    0 : slabdata      0      0      0
ovl_inode          41832  43110    720   45    8 : tunables    0    0    0 : slabdata    958    958      0
nf_conntrack        4437   4437    320   51    4 : tunables    0    0    0 : slabdata     87     87      0
ext4_groupinfo_4k 19658572 25481736    192   42    2 : tunables    0    0    0 : slabdata 606708 606708      0
btrfs_delayed_node      0      0    312   52    4 : tunables    0    0    0 : slabdata      0      0      0
btrfs_ordered_extent   9576   9880    424   38    4 : tunables    0    0    0 : slabdata    260    260      0
btrfs_extent_map       0      0    144   56    2 : tunables    0    0    0 : slabdata      0      0      0
btrfs_trans_handle      0      0    112   36    1 : tunables    0    0    0 : slabdata      0      0      0
btrfs_inode            0      0   1208   27    8 : tunables    0    0    0 : slabdata      0      0      0
nvidia_stack_cache    844    866  12288    2    8 : tunables    0    0    0 : slabdata    433    433      0
scsi_sense_cache  114832 114848    128   32    1 : tunables    0    0    0 : slabdata   3589   3589      0
fsverity_info          0      0    256   32    2 : tunables    0    0    0 : slabdata      0      0      0
fscrypt_info           0      0    136   60    2 : tunables    0    0    0 : slabdata      0      0      0
MPTCPv6                0      0   2048   16    8 : tunables    0    0    0 : slabdata      0      0      0
ip6-frags           5148   5148    184   44    2 : tunables    0    0    0 : slabdata    117    117      0
PINGv6                 0      0   1216   26    8 : tunables    0    0    0 : slabdata      0      0      0
RAWv6               4264   4446   1216   26    8 : tunables    0    0    0 : slabdata    171    171      0
UDPv6               2952   2952   1344   24    8 : tunables    0    0    0 : slabdata    123    123      0
tw_sock_TCPv6       1320   1320    248   33    2 : tunables    0    0    0 : slabdata     40     40      0
request_sock_TCPv6      0      0    304   53    4 : tunables    0    0    0 : slabdata      0      0      0
TCPv6               1040   1040   2432   13    8 : tunables    0    0    0 : slabdata     80     80      0
kcopyd_job             0      0   3240   10    8 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent              0      0   2888   11    8 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache   1802   1802    960   34    8 : tunables    0    0    0 : slabdata     53     53      0
fuse_request           0      0    152   53    2 : tunables    0    0    0 : slabdata      0      0      0
fuse_inode             0      0    832   39    8 : tunables    0    0    0 : slabdata      0      0      0
ecryptfs_inode_cache      0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
ecryptfs_file_cache  17664  17664     16  256    1 : tunables    0    0    0 : slabdata     69     69      0
ecryptfs_auth_tok_list_item      0      0    832   39    8 : tunables    0    0    0 : slabdata      0      0      0
fat_inode_cache        0      0    776   42    8 : tunables    0    0    0 : slabdata      0      0      0
fat_cache              0      0     40  102    1 : tunables    0    0    0 : slabdata      0      0      0
squashfs_inode_cache    920    920    704   46    8 : tunables    0    0    0 : slabdata     20     20      0
jbd2_journal_head   3978   3978    120   34    1 : tunables    0    0    0 : slabdata    117    117      0
jbd2_revoke_table_s    512    512     16  256    1 : tunables    0    0    0 : slabdata      2      2      0
ext4_fc_dentry_update      0      0     80   51    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_inode_cache   15687  15687   1176   27    8 : tunables    0    0    0 : slabdata    581    581      0
ext4_allocation_context   4480   4480    144   56    2 : tunables    0    0    0 : slabdata     80     80      0
ext4_io_end         5120   5120     64   64    1 : tunables    0    0    0 : slabdata     80     80      0
ext4_pending_reservation  10240  10240     32  128    1 : tunables    0    0    0 : slabdata     80     80      0
ext4_extent_status  14484  14484     40  102    1 : tunables    0    0    0 : slabdata    142    142      0
mbcache             5840   5840     56   73    1 : tunables    0    0    0 : slabdata     80     80      0
kioctx               224    224    576   56    8 : tunables    0    0    0 : slabdata      4      4      0
userfaultfd_ctx_cache      0      0    192   42    2 : tunables    0    0    0 : slabdata      0      0      0
dnotify_struct         0      0     32  128    1 : tunables    0    0    0 : slabdata      0      0      0
pid_namespace       3600   3600    136   60    2 : tunables    0    0    0 : slabdata     60     60      0
UNIX                2400   2400   1088   30    8 : tunables    0    0    0 : slabdata     80     80      0
ip4-frags           5040   5080    200   40    2 : tunables    0    0    0 : slabdata    127    127      0
MPTCP                  0      0   1920   17    8 : tunables    0    0    0 : slabdata      0      0      0
request_sock_subflow      0      0    376   43    4 : tunables    0    0    0 : slabdata      0      0      0
xfrm_dst_cache        51     51    320   51    4 : tunables    0    0    0 : slabdata      1      1      0
xfrm_state             0      0    768   42    8 : tunables    0    0    0 : slabdata      0      0      0
ip_fib_trie         5865   5865     48   85    1 : tunables    0    0    0 : slabdata     69     69      0
ip_fib_alias        5037   5037     56   73    1 : tunables    0    0    0 : slabdata     69     69      0
PING                   0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
RAW                 6528   6528   1024   32    8 : tunables    0    0    0 : slabdata    204    204      0
tw_sock_TCP         2673   2673    248   33    2 : tunables    0    0    0 : slabdata     81     81      0
request_sock_TCP    4240   4240    304   53    4 : tunables    0    0    0 : slabdata     80     80      0
TCP                 1610   1610   2240   14    8 : tunables    0    0    0 : slabdata    115    115      0
hugetlbfs_inode_cache     98     98    664   49    8 : tunables    0    0    0 : slabdata      2      2      0
dquot               2560   2560    256   32    2 : tunables    0    0    0 : slabdata     80     80      0
ep_head            20480  20480     16  256    1 : tunables    0    0    0 : slabdata     80     80      0
dax_cache             39     39    832   39    8 : tunables    0    0    0 : slabdata      1      1      0
bio_crypt_ctx     5575008 12859548     40  102    1 : tunables    0    0    0 : slabdata 126074 126074      0
request_queue        167    225   2128   15    8 : tunables    0    0    0 : slabdata     15     15      0
biovec-max          1872   1928   4096    8    8 : tunables    0    0    0 : slabdata    241    241      0
biovec-128          5938   6016   2048   16    8 : tunables    0    0    0 : slabdata    376    376      0
biovec-64           5952   5952   1024   32    8 : tunables    0    0    0 : slabdata    186    186      0
khugepaged_mm_slot   1620   1620    112   36    1 : tunables    0    0    0 : slabdata     45     45      0
user_namespace       260    260    624   52    8 : tunables    0    0    0 : slabdata      5      5      0
dmaengine-unmap-256     15     15   2112   15    8 : tunables    0    0    0 : slabdata      1      1      0
dmaengine-unmap-128     30     30   1088   30    8 : tunables    0    0    0 : slabdata      1      1      0
sock_inode_cache   20562  20943    832   39    8 : tunables    0    0    0 : slabdata    537    537      0
skbuff_ext_cache    9828   9828    192   42    2 : tunables    0    0    0 : slabdata    234    234      0
skbuff_fclone_cache   9440   9440    512   32    4 : tunables    0    0    0 : slabdata    295    295      0
skbuff_head_cache  14485  14592    256   32    2 : tunables    0    0    0 : slabdata    456    456      0
file_lock_cache     2960   2960    216   37    2 : tunables    0    0    0 : slabdata     80     80      0
file_lock_ctx      72197  72197     56   73    1 : tunables    0    0    0 : slabdata    989    989      0
fsnotify_mark_connector  81895  88192     32  128    1 : tunables    0    0    0 : slabdata    689    689      0
buffer_head       163644 272571    104   39    1 : tunables    0    0    0 : slabdata   6989   6989      0
x86_lbr                0      0    800   40    8 : tunables    0    0    0 : slabdata      0      0      0
taskstats           3680   3680    352   46    4 : tunables    0    0    0 : slabdata     80     80      0
proc_dir_entry     11046  11046    192   42    2 : tunables    0    0    0 : slabdata    263    263      0
pde_opener          8160   8160     40  102    1 : tunables    0    0    0 : slabdata     80     80      0
proc_inode_cache   26161  29118    712   46    8 : tunables    0    0    0 : slabdata    633    633      0
seq_file            3264   3264    120   34    1 : tunables    0    0    0 : slabdata     96     96      0
sigqueue           16677  16677     80   51    1 : tunables    0    0    0 : slabdata    327    327      0
bdev_cache           100    100   1600   20    8 : tunables    0    0    0 : slabdata      5      5      0
shmem_inode_cache  39065  42054    760   43    8 : tunables    0    0    0 : slabdata    978    978      0
kernfs_node_cache 303712 303712    128   32    1 : tunables    0    0    0 : slabdata   9491   9491      0
mnt_cache          23154  23154    320   51    4 : tunables    0    0    0 : slabdata    454    454      0
filp               24710  25536    256   32    2 : tunables    0    0    0 : slabdata    798    798      0
inode_cache        65841  72726    640   51    8 : tunables    0    0    0 : slabdata   1426   1426      0
dentry            2281389 3225894    192   42    2 : tunables    0    0    0 : slabdata  76807  76807      0
names_cache         1640   1664   4096    8    8 : tunables    0    0    0 : slabdata    208    208      0
net_namespace        329    329   4352    7    8 : tunables    0    0    0 : slabdata     47     47      0
iint_cache             0      0    120   34    1 : tunables    0    0    0 : slabdata      0      0      0
lsm_file_cache    20349776 51397800     24  170    1 : tunables    0    0    0 : slabdata 302340 302340      0
uts_namespace       2220   2220    432   37    4 : tunables    0    0    0 : slabdata     60     60      0
nsproxy             4480   4480     72   56    1 : tunables    0    0    0 : slabdata     80     80      0
vm_area_struct     47648  47814    208   39    2 : tunables    0    0    0 : slabdata   1226   1226      0
mm_struct           2760   2760   1088   30    8 : tunables    0    0    0 : slabdata     92     92      0
files_cache         4094   4094    704   46    8 : tunables    0    0    0 : slabdata     89     89      0
signal_cache        8704   8904   1152   28    8 : tunables    0    0    0 : slabdata    318    318      0
sighand_cache       4921   4965   2112   15    8 : tunables    0    0    0 : slabdata    331    331      0
task_struct         2981   3192   8192    4    8 : tunables    0    0    0 : slabdata    798    798      0
cred_jar           48258  48258    192   42    2 : tunables    0    0    0 : slabdata   1149   1149      0
anon_vma_chain     70629  72320     64   64    1 : tunables    0    0    0 : slabdata   1130   1130      0
anon_vma           47399  47840     88   46    1 : tunables    0    0    0 : slabdata   1040   1040      0
pid                43666  44352    128   32    1 : tunables    0    0    0 : slabdata   1386   1386      0
Acpi-Operand      103376 103376     72   56    1 : tunables    0    0    0 : slabdata   1846   1846      0
Acpi-ParseExt        234    234    104   39    1 : tunables    0    0    0 : slabdata      6      6      0
Acpi-State           459    459     80   51    1 : tunables    0    0    0 : slabdata      9      9      0
numa_policy        22071  22506    264   62    4 : tunables    0    0    0 : slabdata    363    363      0
perf_event          2160   2160   1192   27    8 : tunables    0    0    0 : slabdata     80     80      0
trace_event_file    6210   6210     88   46    1 : tunables    0    0    0 : slabdata    135    135      0
ftrace_event_field  29750  29750     48   85    1 : tunables    0    0    0 : slabdata    350    350      0
pool_workqueue     31616  31776    256   32    2 : tunables    0    0    0 : slabdata    993    993      0
radix_tree_node   2745972 3417008    584   56    8 : tunables    0    0    0 : slabdata  61018  61018      0
task_group          5202   5202    640   51    8 : tunables    0    0    0 : slabdata    102    102      0
vmap_area          50712  52160     64   64    1 : tunables    0    0    0 : slabdata    815    815      0
dma-kmalloc-8k         0      0   8192    4    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-4k         0      0   4096    8    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-2k         0      0   2048   16    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-1k         0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-512        0      0    512   32    4 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-256        0      0    256   32    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   32    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   64    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-32         0      0     32  128    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-16         0      0     16  256    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-8          0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-192        0      0    192   42    2 : tunables    0    0    0 : slabdata      0      0      0
dma-kmalloc-96         0      0     96   42    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-8k         0      0   8192    4    8 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-4k       280    280   4096    8    8 : tunables    0    0    0 : slabdata     35     35      0
kmalloc-rcl-2k         0      0   2048   16    8 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-1k         0      0   1024   32    8 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-512        0      0    512   32    4 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-256        0      0    256   32    2 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-192    55331  55944    192   42    2 : tunables    0    0    0 : slabdata   1332   1332      0
kmalloc-rcl-128    52841  92480    128   32    1 : tunables    0    0    0 : slabdata   2890   2890      0
kmalloc-rcl-96     75188  81732     96   42    1 : tunables    0    0    0 : slabdata   1946   1946      0
kmalloc-rcl-64    223406 330624     64   64    1 : tunables    0    0    0 : slabdata   5166   5166      0
kmalloc-rcl-32         0      0     32  128    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-16         0      0     16  256    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-rcl-8          0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-cg-8k        320    320   8192    4    8 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-cg-4k       1696   1736   4096    8    8 : tunables    0    0    0 : slabdata    217    217      0
kmalloc-cg-2k       2416   2416   2048   16    8 : tunables    0    0    0 : slabdata    151    151      0
kmalloc-cg-1k       4640   4640   1024   32    8 : tunables    0    0    0 : slabdata    145    145      0
kmalloc-cg-512      2976   2976    512   32    4 : tunables    0    0    0 : slabdata     93     93      0
kmalloc-cg-256      2208   2208    256   32    2 : tunables    0    0    0 : slabdata     69     69      0
kmalloc-cg-192      3402   3402    192   42    2 : tunables    0    0    0 : slabdata     81     81      0
kmalloc-cg-128      2560   2560    128   32    1 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-cg-96       3360   3360     96   42    1 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-cg-64       5696   5696     64   64    1 : tunables    0    0    0 : slabdata     89     89      0
kmalloc-cg-32      10240  10240     32  128    1 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-cg-16      61952  61952     16  256    1 : tunables    0    0    0 : slabdata    242    242      0
kmalloc-cg-8       40960  40960      8  512    1 : tunables    0    0    0 : slabdata     80     80      0
kmalloc-8k          1870   1984   8192    4    8 : tunables    0    0    0 : slabdata    496    496      0
kmalloc-4k          4917   5408   4096    8    8 : tunables    0    0    0 : slabdata    676    676      0
kmalloc-2k         50935  52528   2048   16    8 : tunables    0    0    0 : slabdata   3283   3283      0
kmalloc-1k        1069096 2780992   1024   32    8 : tunables    0    0    0 : slabdata  86906  86906      0
kmalloc-512       11268929 22504704    512   32    4 : tunables    0    0    0 : slabdata 703272 703272      0
kmalloc-256       2255033 6208960    256   32    2 : tunables    0    0    0 : slabdata 194030 194030      0
kmalloc-192       10336133 19638192    192   42    2 : tunables    0    0    0 : slabdata 467576 467576      0
kmalloc-128       2112454 5171456    128   32    1 : tunables    0    0    0 : slabdata 161608 161608      0
kmalloc-96        1078742 2495976     96   42    1 : tunables    0    0    0 : slabdata  59428  59428      0
kmalloc-64        2065281 5393984     64   64    1 : tunables    0    0    0 : slabdata  84281  84281      0
kmalloc-32        4692190 6049792     32  128    1 : tunables    0    0    0 : slabdata  47264  47264      0
kmalloc-16        1449497 3389184     16  256    1 : tunables    0    0    0 : slabdata  13239  13239      0
kmalloc-8          53760  53760      8  512    1 : tunables    0    0    0 : slabdata    105    105      0
kmem_cache_node     1492   1536     64   64    1 : tunables    0    0    0 : slabdata     24     24      0
kmem_cache           704    704    256   32    2 : tunables    0    0    0 : slabdata     22     22      0

Linux# uname -a
Linux sjc1-training-prod-104 5.15.0-46-generic #49~20.04.1-Ubuntu SMP Thu Aug 4 19:15:44 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

Linux# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu-Server 20.04.6 2023.05.30 (Cubic 2023-05-30 13:13)"

Please let us know if you could share any suggestion or recommendation on this.

Best Regards.

Jianan.

On 6/1/23 14:43, Dave Chinner wrote:
> On Wed, May 31, 2023 at 11:21:41PM -0700, Jianan Wang wrote:
>> Seems the auto-wraping issue is on my gmail.... using thunderbird should be better...
> Thanks!
>
>> Resend the slabinfo and meminfo output here:
>>
>> Linux # cat /proc/slabinfo
>> slabinfo - version: 2.1
>> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
> .....
>> xfs_dqtrx              0      0    528   31    4 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_dquot              0      0    496   33    4 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_buf           2545661 3291582    384   42    4 : tunables    0    0    0 : slabdata  78371  78371      0
>> xfs_rui_item           0      0    696   47    8 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_rud_item           0      0    176   46    2 : tunables    0    0    0 : slabdata      0      0      0
>> xfs_inode         23063278 77479540   1024   32    8 : tunables    0    0    0 : slabdata 2425069 2425069      0
>> xfs_efd_item        4662   4847    440   37    4 : tunables    0    0    0 : slabdata    131    131      0
>> xfs_buf_item        8610   8760    272   30    2 : tunables    0    0    0 : slabdata    292    292      0
>> xfs_trans           1925   1925    232   35    2 : tunables    0    0    0 : slabdata     55     55      0
>> xfs_da_state        1632   1632    480   34    4 : tunables    0    0    0 : slabdata     48     48      0
>> xfs_btree_cur       1728   1728    224   36    2 : tunables    0    0    0 : slabdata     48     48      0
> There's no xfs_ili slab cache - this kernel must be using merged
> slabs, so I'm going to have to infer how many inodes are dirty from
> other slabs. The inode log item is ~190 bytes in size, so....
>
>> skbuff_ext_cache  16454495 32746392    192   42    2 : tunables    0    0    0 : slabdata 779676 779676      0
> Yup, there were - 192 byte slab, 16 million active objects. Not all
> of those inodes will be dirty right now, but ~65% of the inodes
> cached in memory have been dirty at some point. 
>
> So, yes, it is highly likely that your memory reclaim/OOM problems
> are caused by blocking on dirty inodes in memory reclaim, which you
> can only fix by upgrading to a newer kernel.
>
> -Dave.
