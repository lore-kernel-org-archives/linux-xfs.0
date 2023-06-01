Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB6BC77B7E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 15:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjFAPJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 11:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbjFAPJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 11:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B46DE78
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 08:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECEC5639FB
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 15:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C79BC433D2;
        Thu,  1 Jun 2023 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685632019;
        bh=eFzTM7VcHjrBoscuofwc9tuocvQvB8DdVLSBYPfgszk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vm5B9vSz3AXdkHZu22LcIlqSU6/NPBNVK6kRx6ohCqx+wiNOxd7fWgsie/7hzEeXW
         neovAERFpRNIIjAzRj0OtGO8tnvn7BjSzCVb63wZG+D/sp6n8CSdvEpHyq22+PLdll
         w6rM+/Fo2MKGXU1B7o1Wbm//wxc1fpcpIRyS9UraYLF10CQKnu/v9fiKklxqnmOSmi
         3YkCBXOs1/Gj+aJUAUhmup2oyfxhx6E+whADzUvo9ZL0snO/qLJmM2ZPnKtqCTmi9V
         +ufzaD7/jjy4UjaDTj5CRd3MwnrsO1AhfsudL3bACVpF6I8VdxbVkGKz+0q50L6cx6
         jLMd1hAuah9Fg==
Date:   Thu, 1 Jun 2023 08:06:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jianan Wang <wangjianan.zju@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Question on the xfs inode slab memory
Message-ID: <20230601150658.GG16865@frogsfrogsfrogs>
References: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
 <ZHfhYsqln68N1HyO@dread.disaster.area>
 <CAMj1M403Tqg+UKT82kt2=-adHagk1MfSNDN+vzt7_GXRJKf_-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1M403Tqg+UKT82kt2=-adHagk1MfSNDN+vzt7_GXRJKf_-w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 31, 2023 at 10:25:12PM -0700, Jianan Wang wrote:
> Hi Dave,
> 
> Thanks for the prompt response!
> 
> On Wed, May 31, 2023 at 5:08 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, May 31, 2023 at 02:29:52PM -0700, Jianan Wang wrote:
> > > Hi all,
> > >
> > > I have a question regarding the xfs slab memory usage when operating a
> > > filesystem with 1-2 billion inodes (raid 0 with 6 disks, totally
> > > 18TB). On this partition, whenever there is a high disk io operation,
> > > like removing millions of small files, the slab kernel memory usage
> > > will increase a lot, leading to many OOM issues happening for the
> > > services running on this node. You could check some of the stats as
> > > the following (only includes the xfs related):
> >
> > You didn't include all the XFS related slabs. At minimum, the inode
> > log item slab needs to be shown (xfs_ili) because that tells us how
> > many of the inodes in the cache have been dirtied.
> >
> > As it is, I'm betting the problem is the disk subsystem can't write
> > back dirty inodes fast enough to keep up with memory demand and so
> > reclaim is declaring OOM faster than your disks can clean inodes to
> > enable them to be reclaimed.
> 
> We have similar feelings about this. Do you think 1-2 billion inodes
> and fast walk of millions of files could be an issue overtime on the
> current xfs implementation. In a production environment, do you have
> any suggestion on tuning the xfs performance to fit this kind of large
> number of small files workload or we shall consider reducing the data
> volume and io workload to more nodes?
> 
> >
> > > #########################################################################
> > > Active / Total Objects (% used):  281803052 / 317485764 (88.8%)
> > > Active / Total Slabs (% used): 13033144 / 13033144 (100.0%)
> > > Active / Total Caches (% used): 126 / 180 (70.0%)
> > > Active / Total Size (% used): 114671057.99K / 127265108.19K (90.1%)
> > > Minium / Average / Maximum Object : 0.01K / 0.40K / 16.75K
> > >
> > > OBJS               ACTIVE      USE     OBJ SIZE     SLABS
> > > OBJ/SLAB    CACHE SIZE    NAME
> > > 78207920      70947541      0%       1.00K           7731010
> > >  32            247392320K     xfs_inode
> > > 59945928      46548798      0%       0.19K           1433102
> > >  42              11464816K     dentry
> > > 25051296      25051282      0%       0.38K           599680
> > >   42            9594880K         xfs_buf
> >
> > Ok, that's from slabtop. Please don't autowrap stuff you've pasted
> > in - it makes it really hard to read. (reformatted so I can read
> > it).
> 
> Got it, will pay more attention to this.
> 
> >
> > OBJS           ACTIVE      USE     OBJ SIZE     SLABS OBJ/SLAB    CACHE SIZE    NAME
> > 78207920      70947541      0%       1.00K     7731010   32       247392320K     xfs_inode
> > 59945928      46548798      0%       0.19K     1433102   42        11464816K     dentry
> > 25051296      25051282      0%       0.38K      599680   42         9594880K         xfs_buf
> >
> > So, 70 million cached inodes, with a cache size of 240GB. There are
> > 7.7 million slabs, 32 objects per slab, and that's roughly 240GB.
> >
> > But why does the slab report only 78 million objects in the slab
> > when at 240GB there should be 240 million objects in the slab?
> >
> > It looks like theres some kind of accounting problem here, likely in
> > the slabtop program. I have always found slabtop to be unreliable
> > like this....
> >
> > Can you attach the output of 'cat /proc/slabinfo' and 'cat
> > /proc/meminfo' when you have a large slab cache in memory?
> 
> I do not have those output you requested for the exact situation I
> pasted originally, but this is another node where xfs consumes a lot
> of slab memory using the same xfs version:
> 
> Linux # cat /proc/slabinfo
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab>
> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> :
> slabdata <active_slabs> <num_slabs> <sharedavail>
> nf_conntrack       15716  20349    320   51    4 : tunables    0    0
>   0 : slabdata    399    399      0
> au_finfo               0      0    192   42    2 : tunables    0    0
>   0 : slabdata      0      0      0
> au_icntnr              0      0    832   39    8 : tunables    0    0
>   0 : slabdata      0      0      0
> au_dinfo               0      0    192   42    2 : tunables    0    0
>   0 : slabdata      0      0      0
> ovl_inode          41792  42757    688   47    8 : tunables    0    0
>   0 : slabdata    941    941      0
> ufs_inode_cache        0      0    808   40    8 : tunables    0    0
>   0 : slabdata      0      0      0
> qnx4_inode_cache       0      0    680   48    8 : tunables    0    0
>   0 : slabdata      0      0      0
> hfsplus_attr_cache      0      0   3840    8    8 : tunables    0    0
>    0 : slabdata      0      0      0
> hfsplus_icache         0      0    896   36    8 : tunables    0    0
>   0 : slabdata      0      0      0
> hfs_inode_cache        0      0    832   39    8 : tunables    0    0
>   0 : slabdata      0      0      0
> minix_inode_cache      0      0    672   48    8 : tunables    0    0
>   0 : slabdata      0      0      0
> ntfs_big_inode_cache      0      0    960   34    8 : tunables    0
> 0    0 : slabdata      0      0      0
> ntfs_inode_cache       0      0    296   55    4 : tunables    0    0
>   0 : slabdata      0      0      0
> jfs_ip                 0      0   1280   25    8 : tunables    0    0
>   0 : slabdata      0      0      0
> xfs_dqtrx              0      0    528   31    4 : tunables    0    0
>   0 : slabdata      0      0      0
> xfs_dquot              0      0    496   33    4 : tunables    0    0
>   0 : slabdata      0      0      0
> xfs_buf           2545661 3291582    384   42    4 : tunables    0
> 0    0 : slabdata  78371  78371      0
> xfs_rui_item           0      0    696   47    8 : tunables    0    0
>   0 : slabdata      0      0      0
> xfs_rud_item           0      0    176   46    2 : tunables    0    0
>   0 : slabdata      0      0      0
> xfs_inode         23063278 77479540   1024   32    8 : tunables    0
>  0    0 : slabdata 2425069 2425069      0
> xfs_efd_item        4662   4847    440   37    4 : tunables    0    0
>   0 : slabdata    131    131      0
> xfs_buf_item        8610   8760    272   30    2 : tunables    0    0
>   0 : slabdata    292    292      0
> xfs_trans           1925   1925    232   35    2 : tunables    0    0
>   0 : slabdata     55     55      0
> xfs_da_state        1632   1632    480   34    4 : tunables    0    0
>   0 : slabdata     48     48      0
> xfs_btree_cur       1728   1728    224   36    2 : tunables    0    0
>   0 : slabdata     48     48      0
> kvm_async_pf           0      0    136   30    1 : tunables    0    0
>   0 : slabdata      0      0      0
> kvm_vcpu               0      0  17152    1    8 : tunables    0    0
>   0 : slabdata      0      0      0
> kvm_mmu_page_header      0      0    168   48    2 : tunables    0
> 0    0 : slabdata      0      0      0
> x86_fpu                0      0   4160    7    8 : tunables    0    0
>   0 : slabdata      0      0      0
> ext4_groupinfo_4k   7196   7196    144   28    1 : tunables    0    0
>   0 : slabdata    257    257      0
> btrfs_delayed_node      0      0    312   52    4 : tunables    0    0
>    0 : slabdata      0      0      0
> btrfs_ordered_extent      0      0    416   39    4 : tunables    0
> 0    0 : slabdata      0      0      0
> btrfs_inode            0      0   1168   28    8 : tunables    0    0
>   0 : slabdata      0      0      0
> mlx5_fs_ftes         560    560    584   28    4 : tunables    0    0
>   0 : slabdata     20     20      0
> mlx5_fs_fgs          100    100    648   50    8 : tunables    0    0
>   0 : slabdata      2      2      0
> scsi_sense_cache   16896  16896    128   32    1 : tunables    0    0
>   0 : slabdata    528    528      0
> fsverity_info          0      0    248   33    2 : tunables    0    0
>   0 : slabdata      0      0      0
> ip6-frags          21560  21736    184   44    2 : tunables    0    0
>   0 : slabdata    494    494      0
> PINGv6                26     26   1216   26    8 : tunables    0    0
>   0 : slabdata      1      1      0
> RAWv6                390    390   1216   26    8 : tunables    0    0
>   0 : slabdata     15     15      0
> UDPv6               4032   4032   1344   24    8 : tunables    0    0
>   0 : slabdata    168    168      0
> tw_sock_TCPv6       4785   4785    248   33    2 : tunables    0    0
>   0 : slabdata    145    145      0
> request_sock_TCPv6      0      0    304   53    4 : tunables    0    0
>    0 : slabdata      0      0      0
> TCPv6               3809   3874   2432   13    8 : tunables    0    0
>   0 : slabdata    298    298      0
> kcopyd_job             0      0   3312    9    8 : tunables    0    0
>   0 : slabdata      0      0      0
> dm_uevent              0      0   2632   12    8 : tunables    0    0
>   0 : slabdata      0      0      0
> mqueue_inode_cache   1632   1632    960   34    8 : tunables    0    0
>    0 : slabdata     48     48      0
> fuse_request        1344   1344    144   28    1 : tunables    0    0
>   0 : slabdata     48     48      0
> fuse_inode         13428  13830    832   39    8 : tunables    0    0
>   0 : slabdata    360    360      0
> ecryptfs_key_record_cache      0      0    576   28    4 : tunables
> 0    0    0 : slabdata      0      0      0
> ecryptfs_inode_cache      0      0   1024   32    8 : tunables    0
> 0    0 : slabdata      0      0      0
> ecryptfs_file_cache      0      0     16  256    1 : tunables    0
> 0    0 : slabdata      0      0      0
> ecryptfs_auth_tok_list_item      0      0    832   39    8 : tunables
>   0    0    0 : slabdata      0      0      0
> fat_inode_cache      176    176    744   44    8 : tunables    0    0
>   0 : slabdata      4      4      0
> fat_cache              0      0     40  102    1 : tunables    0    0
>   0 : slabdata      0      0      0
> squashfs_inode_cache     46     46    704   46    8 : tunables    0
> 0    0 : slabdata      1      1      0
> jbd2_journal_handle   4080   4080     48   85    1 : tunables    0
> 0    0 : slabdata     48     48      0
> jbd2_journal_head  10438  10608    120   34    1 : tunables    0    0
>   0 : slabdata    312    312      0
> jbd2_revoke_table_s   1024   1024     16  256    1 : tunables    0
> 0    0 : slabdata      4      4      0
> ext4_inode_cache   56239  67562   1096   29    8 : tunables    0    0
>   0 : slabdata   2700   2700      0
> ext4_allocation_context   1536   1536    128   32    1 : tunables    0
>    0    0 : slabdata     48     48      0
> ext4_system_zone     816    816     40  102    1 : tunables    0    0
>   0 : slabdata      8      8      0
> ext4_io_end        24832  24896     64   64    1 : tunables    0    0
>   0 : slabdata    389    389      0
> ext4_pending_reservation  67072  67456     32  128    1 : tunables
> 0    0    0 : slabdata    527    527      0
> ext4_extent_status  44359  55386     40  102    1 : tunables    0    0
>    0 : slabdata    543    543      0
> mbcache            50005  50005     56   73    1 : tunables    0    0
>   0 : slabdata    685    685      0
> userfaultfd_ctx_cache      0      0    192   42    2 : tunables    0
>  0    0 : slabdata      0      0      0
> dnotify_struct         0      0     32  128    1 : tunables    0    0
>   0 : slabdata      0      0      0
> pid_namespace       1872   1872    208   39    2 : tunables    0    0
>   0 : slabdata     48     48      0
> ip4-frags              0      0    200   40    2 : tunables    0    0
>   0 : slabdata      0      0      0
> xfrm_state             0      0    704   46    8 : tunables    0    0
>   0 : slabdata      0      0      0
> PING               25440  25440   1024   32    8 : tunables    0    0
>   0 : slabdata    795    795      0
> RAW                  832    832   1024   32    8 : tunables    0    0
>   0 : slabdata     26     26      0
> tw_sock_TCP        21153  21153    248   33    2 : tunables    0    0
>   0 : slabdata    641    641      0
> request_sock_TCP   13674  13780    304   53    4 : tunables    0    0
>   0 : slabdata    260    260      0
> TCP                 8470   8666   2240   14    8 : tunables    0    0
>   0 : slabdata    619    619      0
> hugetlbfs_inode_cache    102    102    632   51    8 : tunables    0
>  0    0 : slabdata      2      2      0
> dquot               1536   1536    256   32    2 : tunables    0    0
>   0 : slabdata     48     48      0
> eventpoll_pwq      81872  81928     72   56    1 : tunables    0    0
>   0 : slabdata   1463   1463      0
> dax_cache             42     42    768   42    8 : tunables    0    0
>   0 : slabdata      1      1      0
> request_queue        180    255   2104   15    8 : tunables    0    0
>   0 : slabdata     17     17      0
> biovec-max          1120   1192   4096    8    8 : tunables    0    0
>   0 : slabdata    149    149      0
> biovec-128          2546   2642   2048   16    8 : tunables    0    0
>   0 : slabdata    166    166      0
> biovec-64           5492   5656   1024   32    8 : tunables    0    0
>   0 : slabdata    182    182      0
> khugepaged_mm_slot   1440   1440    112   36    1 : tunables    0    0
>    0 : slabdata     40     40      0
> user_namespace         0      0    536   30    4 : tunables    0    0
>   0 : slabdata      0      0      0
> uid_cache          16514  16640    128   32    1 : tunables    0    0
>   0 : slabdata    520    520      0
> dmaengine-unmap-256     15     15   2112   15    8 : tunables    0
> 0    0 : slabdata      1      1      0
> dmaengine-unmap-128     30     30   1088   30    8 : tunables    0
> 0    0 : slabdata      1      1      0
> sock_inode_cache   62080  62433    832   39    8 : tunables    0    0
>   0 : slabdata   1617   1617      0
> skbuff_ext_cache  16454495 32746392    192   42    2 : tunables    0
>  0    0 : slabdata 779676 779676      0
> skbuff_fclone_cache   6752   7008    512   32    4 : tunables    0
> 0    0 : slabdata    219    219      0
> skbuff_head_cache  48769  49184    256   32    2 : tunables    0    0
>   0 : slabdata   1537   1537      0
> file_lock_cache     1776   1776    216   37    2 : tunables    0    0
>   0 : slabdata     48     48      0
> fsnotify_mark_connector   6144   6144     32  128    1 : tunables    0
>    0    0 : slabdata     48     48      0
> net_namespace         18     18   4928    6    8 : tunables    0    0
>   0 : slabdata      3      3      0
> task_delay_info    79305  79407     80   51    1 : tunables    0    0
>   0 : slabdata   1557   1557      0
> taskstats           2256   2256    344   47    4 : tunables    0    0
>   0 : slabdata     48     48      0
> proc_dir_entry      4578   4578    192   42    2 : tunables    0    0
>   0 : slabdata    109    109      0
> pde_opener         79050  79050     40  102    1 : tunables    0    0
>   0 : slabdata    775    775      0
> proc_inode_cache  153717 156498    680   48    8 : tunables    0    0
>   0 : slabdata   3263   3263      0
> bdev_cache          1092   1092    832   39    8 : tunables    0    0
>   0 : slabdata     28     28      0
> shmem_inode_cache  28213  28800    720   45    8 : tunables    0    0
>   0 : slabdata    640    640      0
> kernfs_node_cache 195825 200730    136   30    1 : tunables    0    0
>   0 : slabdata   6691   6691      0
> mnt_cache          13984  14076    320   51    4 : tunables    0    0
>   0 : slabdata    276    276      0
> filp              250898 253328    256   32    2 : tunables    0    0
>   0 : slabdata   7917   7917      0
> inode_cache       140359 142937    608   53    8 : tunables    0    0
>   0 : slabdata   2712   2712      0
> dentry            27263153 58131675    192   42    2 : tunables    0
>  0    0 : slabdata 1384093 1384093      0
> names_cache          617    633   4096    8    8 : tunables    0    0
>   0 : slabdata     80     80      0
> iint_cache             0      0    120   34    1 : tunables    0    0
>   0 : slabdata      0      0      0
> lsm_file_cache     87405  87890     24  170    1 : tunables    0    0
>   0 : slabdata    517    517      0
> buffer_head       3298954 3785808    104   39    1 : tunables    0
> 0    0 : slabdata  97072  97072      0
> uts_namespace       1776   1776    440   37    4 : tunables    0    0
>   0 : slabdata     48     48      0
> nsproxy             3504   3504     56   73    1 : tunables    0    0
>   0 : slabdata     48     48      0
> vm_area_struct    265005 265785    208   39    2 : tunables    0    0
>   0 : slabdata   6815   6815      0
> mm_struct          19926  19926   1088   30    8 : tunables    0    0
>   0 : slabdata    666    666      0
> files_cache        28029  28029    704   46    8 : tunables    0    0
>   0 : slabdata    612    612      0
> signal_cache       28910  29154   1152   28    8 : tunables    0    0
>   0 : slabdata   1043   1043      0
> sighand_cache      11738  11795   2112   15    8 : tunables    0    0
>   0 : slabdata    791    791      0
> task_struct         7323   7693   7616    4    8 : tunables    0    0
>   0 : slabdata   1924   1924      0
> cred_jar           81837  81837    192   42    2 : tunables    0    0
>   0 : slabdata   1949   1949      0
> anon_vma_chain    350482 351552     64   64    1 : tunables    0    0
>   0 : slabdata   5493   5493      0
> anon_vma          231854 233220     88   46    1 : tunables    0    0
>   0 : slabdata   5070   5070      0
> pid               113960 114336    128   32    1 : tunables    0    0
>   0 : slabdata   3573   3573      0
> Acpi-Operand      189280 189280     72   56    1 : tunables    0    0
>   0 : slabdata   3380   3380      0
> Acpi-ParseExt      18174  18174    104   39    1 : tunables    0    0
>   0 : slabdata    466    466      0
> Acpi-State         10098  10098     80   51    1 : tunables    0    0
>   0 : slabdata    198    198      0
> numa_policy           62     62    264   31    2 : tunables    0    0
>   0 : slabdata      2      2      0
> trace_event_file    2622   2622     88   46    1 : tunables    0    0
>   0 : slabdata     57     57      0
> ftrace_event_field  28220  28220     48   85    1 : tunables    0    0
>    0 : slabdata    332    332      0
> pool_workqueue      8513   8544    256   32    2 : tunables    0    0
>   0 : slabdata    267    267      0
> radix_tree_node   6248549 8844010    584   28    4 : tunables    0
> 0    0 : slabdata 315865 315865      0
> task_group          2448   2448    640   51    8 : tunables    0    0
>   0 : slabdata     48     48      0
> vmap_area          24174  64640     64   64    1 : tunables    0    0
>   0 : slabdata   1010   1010      0
> dma-kmalloc-8k         0      0   8192    4    8 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-4k         0      0   4096    8    8 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-2k         0      0   2048   16    8 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-1k         0      0   1024   32    8 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-512        0      0    512   32    4 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-256        0      0    256   32    2 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-128        0      0    128   32    1 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-64         0      0     64   64    1 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-32         0      0     32  128    1 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-16         0      0     16  256    1 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-8          0      0      8  512    1 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-192        0      0    192   42    2 : tunables    0    0
>   0 : slabdata      0      0      0
> dma-kmalloc-96         0      0     96   42    1 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-8k         0      0   8192    4    8 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-4k         0      0   4096    8    8 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-2k         0      0   2048   16    8 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-1k         0      0   1024   32    8 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-512        0      0    512   32    4 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-256        0      0    256   32    2 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-192    64441  82992    192   42    2 : tunables    0    0
>   0 : slabdata   1976   1976      0
> kmalloc-rcl-128   723176 936960    128   32    1 : tunables    0    0
>   0 : slabdata  29280  29280      0
> kmalloc-rcl-96    10652323 18961866     96   42    1 : tunables    0
>  0    0 : slabdata 451473 451473      0
> kmalloc-rcl-64    6044167 11369536     64   64    1 : tunables    0
> 0    0 : slabdata 177649 177649      0
> kmalloc-rcl-32         0      0     32  128    1 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-16         0      0     16  256    1 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-rcl-8          0      0      8  512    1 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-8k          3114   3172   8192    4    8 : tunables    0    0
>   0 : slabdata    793    793      0
> kmalloc-4k          9499   9632   4096    8    8 : tunables    0    0
>   0 : slabdata   1204   1204      0
> kmalloc-2k         12732  13312   2048   16    8 : tunables    0    0
>   0 : slabdata    832    832      0
> kmalloc-1k        183625 539936   1024   32    8 : tunables    0    0
>   0 : slabdata  16873  16873      0
> kmalloc-512       655588 1568608    512   32    4 : tunables    0    0
>    0 : slabdata  49022  49022      0
> kmalloc-256        98952 342912    256   32    2 : tunables    0    0
>   0 : slabdata  10716  10716      0
> kmalloc-192       204049 482370    192   42    2 : tunables    0    0
>   0 : slabdata  11485  11485      0
> kmalloc-128       311838 730848    128   32    1 : tunables    0    0
>   0 : slabdata  22839  22839      0
> kmalloc-96        1930979 3409056     96   42    1 : tunables    0
> 0    0 : slabdata  81168  81168      0
> kmalloc-64        8181387 8266624     64   64    1 : tunables    0
> 0    0 : slabdata 129166 129166      0
> kmalloc-32        8544206 16602368     32  128    1 : tunables    0
> 0    0 : slabdata 129706 129706      0
> kmalloc-16        6563402 21336064     16  256    1 : tunables    0
> 0    0 : slabdata  83344  83344      0
> kmalloc-8         119808 119808      8  512    1 : tunables    0    0
>   0 : slabdata    234    234      0
> kmem_cache_node     8235   9920     64   64    1 : tunables    0    0
>   0 : slabdata    155    155      0
> kmem_cache         10216  10332    448   36    4 : tunables    0    0
>   0 : slabdata    287    287      0
> 
> Linux# cat /proc/meminfo
> MemTotal:       263782936 kB
> MemFree:         5950596 kB
> MemAvailable:   187604140 kB
> Buffers:          590176 kB
> Cached:         88517408 kB
> SwapCached:            0 kB
> Active:         33425084 kB
> Inactive:       78773572 kB
> Active(anon):   22977948 kB
> Inactive(anon):     1768 kB
> Active(file):   10447136 kB
> Inactive(file): 78771804 kB
> Unevictable:          28 kB
> Mlocked:              28 kB
> SwapTotal:             0 kB
> SwapFree:              0 kB
> Dirty:              1944 kB
> Writeback:             0 kB
> AnonPages:      23028212 kB
> Mapped:           370632 kB
> Shmem:              3352 kB
> KReclaimable:   97013384 kB
> Slab:           108591792 kB
> SReclaimable:   97013384 kB
> SUnreclaim:     11578408 kB
> KernelStack:       29600 kB
> PageTables:        69120 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    131891468 kB
> Committed_AS:   33922344 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      288528 kB
> VmallocChunk:          0 kB
> Percpu:            79680 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:     53248 kB
> ShmemHugePages:        0 kB
> ShmemPmdMapped:        0 kB
> FileHugePages:         0 kB
> FilePmdMapped:         0 kB
> CmaTotal:              0 kB
> CmaFree:               0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> Hugetlb:               0 kB
> DirectMap4k:    31415244 kB
> DirectMap2M:    231421952 kB
> DirectMap1G:     7340032 kB
> 
> >
> > > #########################################################################
> > >
> > > The peak slab memory usage could spike all the way to 100GB+.
> >
> > Is that all? :)
> >
> > > We are using Ubuntu 18.04 and the xfs version is 4.9, kernel version is 5.4

Your vendor EOL'd this release yesterday.  Please contact your extended
support contact for assistance.  That is, assuming they ever fixed the
severe memory reclaim problems in their 5.4 kernel...

--D

> >
> > Ah, I don't think there's anything upstream can do for you. We
> > rewrote large portions of the XFS inode reclaim in 5.9 (3 years ago)
> > to address the issues with memory reclaim getting stuck on dirty XFS
> > inodes, so inode reclaim behaviour in modern kernels is completely
> > different to old kernels.
> >
> > I'd suggest that you need to upgrade your systems to run a more
> > modern kernel and see if that fixes the issues you are seeing...
> 
> Will try it out, thanks for the suggestion.
> 
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> 
> 
> 
> --
> Jianan Wang
