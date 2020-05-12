Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D8CC54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E3C206A3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgELJer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:34:47 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:60866 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbgELJer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:34:47 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 05716D58CD0;
        Tue, 12 May 2020 19:06:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYQrU-000479-5b; Tue, 12 May 2020 19:06:04 +1000
Date:   Tue, 12 May 2020 19:06:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200512090604.GQ2040@dread.disaster.area>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-3-david@fromorbit.com>
 <20200512081608.GB7689@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512081608.GB7689@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=eWj1D-kZTL58mN7iq7kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 01:16:08AM -0700, Christoph Hellwig wrote:
> On Tue, May 12, 2020 at 12:59:49PM +1000, Dave Chinner wrote:
> > Concurrent rm of same 50 million inodes:
> > 
> > 		unpatched	patched
> > machine A:	8m30s		3m09s
> > machine B:	4m02s		4m51s
> 
> This actually is a significant slow down on machine B, which

Oops, that's supposed to read "5m02s", not "4m02s". It was
marginally faster on machine B, as the commentary indicated. See the
log below for raw numbers. First set is unpatched, second set is the
patched kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


$ ~/tests/fsmark-50-test-xfs.sh
QUOTA=
MKFSOPTS=
DEV=/dev/vdc
THREADS=16
meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=134217727500, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
4722

#  ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d  /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11  -d  /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14  -d  /mnt/scratch/15  -d  /mnt/scratch/16 
#       Version 3.3, 16 thread(s) starting at Tue May 12 11:48:45 2020
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 1800 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0     262602.4         11654020
     0      3200000            0     259664.3         11996380
     0      4800000            0     257304.3         11735862
     0      6400000            0     184439.9         12639349
     0      8000000            0     248908.7         12534005
     0      9600000            0     242772.1         12594078
     0     11200000            0     219974.6         13209264
     0     12800000            0     226903.2         13578529
     0     14400000            0     221077.0         13711077
     0     16000000            0     228973.0         13422679
     0     17600000            0     228344.3         13520123
     0     19200000            0     223846.4         13032929
     0     20800000            0     222562.0         13473815
     0     22400000            0     222068.3         13147580
     0     24000000            0     227009.1         13993071
     0     25600000            0     222685.8         13279342
     0     27200000            0     222493.4         13427861
     0     28800000            0     225331.6         13368843
     0     30400000            0     223663.7         13485135
     0     32000000            0     227392.7         13616403
     0     33600000            0     223416.0         14259976
     0     35200000            0     223949.8         13770566
     0     36800000            0     223848.5         14109223
     0     38400000            0     226992.1         13699116
     0     40000000            0     224701.9         13912164
     0     41600000            0     226491.7         14211451
     0     43200000            0     226421.6         13734525
     0     44800000            0     192666.9         14355559
     0     46400000            0     215824.1         16048153
     0     48000000            0     219833.9         13915186
     0     49600000            0     200815.3         13911419
     0     51200000            0     208422.5         13289185
     0 1600000-51200000(2.64e+07+/-1.4e+07)            0 184439.900000-262602.400000(225479+/-1.3e+04) 11654020-16048153(1.34312e+07+/-6.2e+05)

real    4m13.728s
user    4m54.879s
sys     45m35.908s
6287952 6287828  99%    0.20K 161508       39   1292064K xfs_ili                
6287545 6287545 100%    1.19K 273980       26   8767360K xfs_inode              
385038 369135  95%    0.44K  10697       36    171152K xfs_buf                
 35464  15741  44%    0.26K   1144       31      9152K xfs_buf_item           
  1840   1104  60%    0.17K     40       46       320K xfs_icr                
   704    704 100%    0.18K     16       44       128K xfs_log_ticket         
   576    576 100%    0.22K     16       36       128K xfs_btree_cur          
   544    544 100%    0.47K     16       34       256K xfs_da_state           
     0      0   0%    0.06K      0       64         0K xfs_bmap_free_item     
     0      0   0%    0.04K      0      102         0K xfs_ifork              
     0      0   0%    0.42K      0       37         0K xfs_efd_item           
     0      0   0%    0.42K      0       37         0K xfs_efi_item           
     0      0   0%    0.16K      0       24         0K xfs_rud_item           
     0      0   0%    0.67K      0       47         0K xfs_rui_item           
     0      0   0%    0.16K      0       24         0K xfs_cud_item           
     0      0   0%    0.42K      0       37         0K xfs_cui_item           
     0      0   0%    0.16K      0       24         0K xfs_bud_item           
     0      0   0%    0.20K      0       39         0K xfs_bui_item           
     0      0   0%    0.54K      0       29         0K xfs_dquot              
     0      0   0%    0.52K      0       31         0K xfs_dqtrx              
Repair

real    0m0.337s
user    0m0.004s
sys     0m0.059s
removing files

real    4m30.062s
user    0m4.154s
sys     3m14.984s

real    4m30.818s
user    0m3.912s
sys     3m16.197s

real    4m31.320s
user    0m4.047s
sys     3m15.194s

real    4m32.028s
user    0m4.028s
sys     3m16.690s

real    4m32.973s
user    0m3.974s
sys     3m16.360s

real    4m33.592s
user    0m3.943s
sys     3m13.878s

real    4m34.329s
user    0m4.017s
sys     3m16.072s

real    4m34.703s
user    0m4.000s
sys     3m15.959s

real    4m35.050s
user    0m3.977s
sys     3m16.347s

real    4m35.608s
user    0m3.938s
sys     3m16.133s

real    4m38.287s
user    0m4.049s
sys     3m16.415s

real    4m52.474s
user    0m4.036s
sys     3m16.174s

real    4m57.587s
user    0m4.131s
sys     3m17.122s

real    5m1.172s
user    0m4.074s
sys     3m17.258s

real    5m1.418s
user    0m3.930s
sys     3m17.229s

real    5m2.636s
user    0m4.153s
sys     3m18.217s

-----

$ ~/tests/fsmark-50-test-xfs.sh
QUOTA=
MKFSOPTS=
DEV=/dev/vdc
THREADS=16
meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=134217727500, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
4735

#  ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d  /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11  -d  /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14  -d  /mnt/scratch/15  -d  /mnt/scratch/16 
#       Version 3.3, 16 thread(s) starting at Tue May 12 12:14:32 2020
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 1800 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0     261219.3         12276821
     0      3200000            0     258794.5         12649641
     0      4800000            0     239854.1         13457093
     0      6400000            0     224239.7         15311092
     0      8000000            0     247496.4         13289793
     0      9600000            0     237615.3         13263139
     0     11200000            0     223894.5         14654331
     0     12800000            0     224140.0         14361572
     0     14400000            0     215027.4         14415680
     0     16000000            0     223168.6         14288061
     0     17600000            0     224865.4         13978708
     0     19200000            0     220644.3         14040732
     0     20800000            0     219239.1         14174390
     0     22400000            0     228602.0         13519203
     0     24000000            0     224225.2         14069045
     0     25600000            0     221120.1         14516810
     0     27200000            0     221523.0         14665428
     0     28800000            0     217718.8         14485142
     0     30400000            0     220233.9         14628782
     0     32000000            0     220244.3         13882637
     0     33600000            0     223942.6         14548384
     0     35200000            0     222644.3         14862085
     0     36800000            0     219387.9         14354504
     0     38400000            0     222048.7         14658001
     0     40000000            0     221213.9         14664261
     0     41600000            0     220770.8         14583222
     0     43200000            0     220374.6         15453719
     0     44800000            0     205423.2         14096683
     0     46400000            0     208618.2         16111760
     0     48000000            0     200860.0         16714313
     0     49600000            0     207497.0         15617340
     0     51200000            0     206502.8         15035764

real    4m14.483s
user    5m8.450s
sys     46m5.712s
     0 1600000-51200000(2.64e+07+/-1.4e+07)            0 200860.000000-261219.300000(223036+/-1.1e+04) 12276821-16714313(1.43879e+07+/-7.2e+05)
6009008 5941393  98%    0.20K 154292       39   1234336K xfs_ili                
5962213 5941503  99%    1.19K 299994       26   9599808K xfs_inode              
382752 337541  88%    0.44K  10632       36    170112K xfs_buf                
 32085  14207  44%    0.26K   1035       31      8280K xfs_buf_item           
  2990   2089  69%    0.17K     65       46       520K xfs_icr                
   704    704 100%    0.18K     16       44       128K xfs_log_ticket         
   576    576 100%    0.22K     16       36       128K xfs_btree_cur          
   544    544 100%    0.47K     16       34       256K xfs_da_state           
     0      0   0%    0.06K      0       64         0K xfs_bmap_free_item     
     0      0   0%    0.04K      0      102         0K xfs_ifork              
     0      0   0%    0.42K      0       37         0K xfs_efd_item           
     0      0   0%    0.42K      0       37         0K xfs_efi_item           
     0      0   0%    0.16K      0       24         0K xfs_rud_item           
     0      0   0%    0.67K      0       47         0K xfs_rui_item           
     0      0   0%    0.16K      0       24         0K xfs_cud_item           
     0      0   0%    0.42K      0       37         0K xfs_cui_item           
     0      0   0%    0.16K      0       24         0K xfs_bud_item           
     0      0   0%    0.20K      0       39         0K xfs_bui_item           
     0      0   0%    0.54K      0       29         0K xfs_dquot              
     0      0   0%    0.52K      0       31         0K xfs_dqtrx              
Repair

real    0m0.579s
user    0m0.007s
sys     0m0.076s
removing files

real    4m26.929s
user    0m4.010s
sys     3m9.884s

real    4m27.298s
user    0m4.113s
sys     3m9.052s

real    4m29.477s
user    0m4.007s
sys     3m10.205s

real    4m29.562s
user    0m4.004s
sys     3m9.534s

real    4m29.582s
user    0m4.001s
sys     3m8.189s

real    4m31.160s
user    0m4.038s
sys     3m10.027s

real    4m31.646s
user    0m4.232s
sys     3m8.585s

real    4m31.671s
user    0m4.246s
sys     3m9.954s

real    4m31.824s
user    0m3.966s
sys     3m9.712s

real    4m33.730s
user    0m4.189s
sys     3m8.743s

real    4m34.045s
user    0m4.007s
sys     3m10.145s

real    4m36.011s
user    0m4.006s
sys     3m10.385s

real    4m36.110s
user    0m3.929s
sys     3m11.254s

real    4m43.693s
user    0m4.149s
sys     3m9.350s

real    4m50.344s
user    0m4.159s
sys     3m9.867s

real    4m51.145s
user    0m4.165s
sys     3m10.713s

