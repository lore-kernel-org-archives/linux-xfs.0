Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:07:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B47DPw011856
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:07:15 -0700
Message-ID: <4876DCAC.5040903@sgi.com>
Date: Fri, 11 Jul 2008 14:08:12 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <20080711032258.GB11558@disturbed> <4876D872.2060408@sgi.com>
In-Reply-To: <4876D872.2060408@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: markgw@sgi.com, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:
> 
> 
> Dave Chinner wrote:
>> On Fri, Jul 11, 2008 at 12:48:11PM +1000, Mark Goodwin wrote:
>>> Thanks for the report Eric. This looks very similar to a
>>> deadlock Lachlan recently hit in the patch for
>>> "Use atomics for iclog reference counting"
>>> http://oss.sgi.com/archives/xfs/2008-02/msg00130.html
>>>
>>> It seems this patch can cause deadlocks under heavy log traffic.
>>> I don't think anyone has a fix yet ... Lachlan is out this week,
>>> but Tim can follow-up here ...
>>
>> Nice to know - why didn't anyone email me or report this to the
>> list when the bug was first found? I mean, I wrote that code, I know
>> what it is supposed to be doing and as a result should be able
> 
> Only recently found and didn't think it was this easy to hit.
> But no excuses ...
> 
>> help find and fix the bug. Can you please post what details you have
>> about the problem (test case, stack traces, debugging info, etc)
>> so I can try to find the problem.
> 
> See Tim's follow-up.
> 

Remaining info from bug....

> While stress testing I'm frequently hitting a deadlock in the log code where
> many threads are stuck in xlog_state_get_iclog_space().
> 
> Stack traceback for pid 16570
> 0xffff8100421fa4c0    16570     4620  0    2   D  0xffff8100421fa810  rm
> rsp                rip                Function (args)
> 0xffff81003c41d908 0xffffffff8062be32 thread_return
> 0xffff81003c41d9a0 0xffffffff8062c205 schedule_timeout+0x1e (0x7fffffffffffffff)
> 0xffff81003c41da10 0xffffffff803954f0 xlog_state_get_iclog_space+0xed (0xffff81007d33d650, invalid, 0xffff81003c41db00, 0xffff81007c1d39c0, 0xffff81003c41db08, 0xffff81003c41db0c)
> 0xffff81003c41daa0 0xffffffff8039578d xlog_write+0x118 (0xffff81007c97d338, 0xffff81003c41db58, invalid, 0xffff81007c1d39c0, 0xffff81003c41dba0, 0xffff81003c41dce0, 0xffff810000000002)
> 0xffff81003c41db40 0xffffffff80395cb4 xlog_commit_record+0x6e (0xffff81007c97d338, 0xffff81007c1d39c0, 0xffff81003c41dce0, 0xffff81003c41dba0)
> 0xffff81003c41db90 0xffffffff80396c31 xfs_log_done+0x34 (invalid, 0xffff81007c1d39c0, invalid, invalid)
> 0xffff81003c41dbc0 0xffffffff803a1271 _xfs_trans_commit+0x24a (0xffff81007a99c780, invalid, 0x0)
> 0xffff81003c41dd20 0xffffffff8035eb2e xfs_bmap_finish+0xaa (0xffff81003c41de38, 0xffff81003c41ddc8, 0xffff81003c41dde0)
> 0xffff81003c41dd80 0xffffffff8038ae2b xfs_itruncate_finish+0x376 (0xffff81003c41de38, 0xffff81007b9c5670, invalid, invalid, 0x1)
> 0xffff81003c41de20 0xffffffff803ab720 xfs_inactive+0x27d (0xffff81007b9c5670)
> 0xffff81003c41de70 0xffffffff803b663e xfs_fs_clear_inode+0xbd (0xffff810073cf0438)
> 0xffff81003c41de90 0xffffffff802964af clear_inode+0x9c (0xffff810073cf0438)
> 0xffff81003c41dea0 0xffffffff80296598 generic_delete_inode+0x92 (0xffff810073cf0438)
> 0xffff81003c41dec0 0xffffffff8028d953 do_unlinkat+0xdd (invalid, invalid)
> 0xffff81003c41df80 0xffffffff8020ae4b system_call_after_swapgs+0x7b (invalid, invalid, invalid, invalid, invalid, invalid)
> Enter <q> to end, <cr> to continue:
> Stack traceback for pid 24088
> 0xffff81003b804a00    24088     4649  0    6   D  0xffff81003b804d50  xfs_io
> rsp                rip                Function (args)
> 0xffff81003e403288 0xffffffff8062be32 thread_return
> 0xffff81003e403320 0xffffffff8062c205 schedule_timeout+0x1e (0x7fffffffffffffff)
> 0xffff81003e403390 0xffffffff803954f0 xlog_state_get_iclog_space+0xed (0xffff81007d33d650, invalid, 0xffff81003e403480, 0xffff8100741499c0, 0xffff81003e403488, 0xffff81003e40348c)
> 0xffff81003e403420 0xffffffff8039578d xlog_write+0x118 (0xffff81007c97d338, 0xffff81003e4034f8, invalid, 0xffff8100741499c0, 0xffff81003e5b9858, 0x0, 0x0)
> 0xffff81003e4034c0 0xffffffff80395d13 xfs_log_write+0x33 (0xffff81007c97d338)
> 0xffff81003e4034e0 0xffffffff803a1256 _xfs_trans_commit+0x22f (0xffff81003e5b9810, invalid, 0x0)
> 0xffff81003e403640 0xffffffff8038fdba xfs_iomap_write_allocate+0x2eb (0xffff81007b9e7c90, invalid, invalid, 0xffff81003e403788, 0xffff81003e4037b4)
> 0xffff81003e403730 0xffffffff80390dd6 xfs_iomap+0x35a (0xffff81007b9e7c90, 0x19edd000, invalid, invalid, 0xffff81003e403898, 0xffff81003e403804)
> 0xffff81003e4037f0 0xffffffff803acf45 xfs_map_blocks+0x2c (invalid, invalid, invalid, invalid, invalid)
> 0xffff81003e403820 0xffffffff803ae04e xfs_page_state_convert+0x28b (0xffff81007b9e6c18, 0xffffe200028ac0f0, 0xffff81003e403b58, invalid, 0x100000000)
> 0xffff81003e403910 0xffffffff803ae61e xfs_vm_writepage+0xca (0xffffe200028ac0f0, 0xffff81003e403b58)
> 0xffff81003e403940 0xffffffff80260c16 __writepage+0xd (invalid, invalid, 0xffff81007b9e6e00)
> 0xffff81003e403950 0xffffffff8026112c write_cache_pages+0x19e (0xffff81007b9e6e00, 0xffff81003e403b58, 0xffffffff80260c09, 0xffff81007b9e6e00)
> 0xffff81003e403a50 0xffffffff802612a0 do_writepages+0x23 (invalid, 0xffff81003e403b58)
> 0xffff81003e403a60 0xffffffff8029ebca __writeback_single_inode+0x150 (0xffff81007b9e6c18, 0xffff81003e403b58)
> 0xffff81003e403ae0 0xffffffff8029f124 sync_sb_inodes+0x1b4 (0xffff81007c15d3f8, 0xffff81003e403b58)
> 0xffff81003e403b20 0xffffffff8029f406 writeback_inodes+0x81 (0xffff81003e403b58)
> 0xffff81003e403b40 0xffffffff802616f9 balance_dirty_pages_ratelimited_nr+0x15e (invalid, invalid)
> 0xffff81003e403bf0 0xffffffff8025bcb6 generic_file_buffered_write+0x20c (0xffff81003e403df8, 0xffff81003e403ee8, 0x1, 0x3c7c8000, 0xffff81003e403e78, invalid, 0x0)
> 0xffff81003e403cf0 0xffffffff803b56b4 xfs_write+0x68a (0xffff81007b58d360, 0xffff81003e403df8, 0xffff81003e403ee8, 0x1, 0xffff81003e403e78, invalid)
> 0xffff81003e403df0 0xffffffff8028411f do_sync_write+0xc9 (0xffff810079de9530, 0x51d000, 0x1000, 0xffff81003e403f48)
> 0xffff81003e403f10 0xffffffff8028485f vfs_write+0xad (0xffff810079de9530, 0x51d000, invalid, 0xffff81003e403f48)
> 0xffff81003e403f40 0xffffffff80284e87 sys_pwrite64+0x50 (invalid, 0x51d000, 0x1000, 0x3c7c8000)
> 0xffff81003e403f80 0xffffffff8020ae4b system_call_after_swapgs+0x7b (invalid, invalid, invalid, invalid, invalid, invalid)
> 
> Taking a look at the log and iclog structures...
> 
> [2]kdb> xlog 0xffff81007d33d650
> xlog at 0xffff81007d33d650
> &flush_wait: 0xffff81007d33d6d0  ICLOG: 0xffff81007c193710  
> &icloglock: 0xffff81007d33d720  tail_lsn: [58:173319]  last_sync_lsn: [58:173319] 
> mp: 0xffff81007c97d338  xbuf: 0xffff81007c8e9e08  l_covered_state: need 
> flags: log 0x0 <>   logBBstart: 0 logsize: 134217728 logBBsize: 262144
> curr_cycle: 58  prev_cycle: 58  curr_block: 213344  prev_block: 213280
> iclog_bak: 0xffff81007d33d830  iclog_size: 0x8000 (32768)  num iclogs: 8
> l_iclog_hsize 512 l_iclog_heads 1
> l_sectbb_log 0 l_sectbb_mask 0
> &grant_lock: 0xffff81007d33d7d0  resHeadQ: 0x0000000000000000  wrHeadQ: 0x0000000000000000
> GResCycle: 58  GResBytes: 110263292  GWrCycle: 58  GWrBytes: 110263292
> GResBlocks: 215357 GResRemain: 508  GWrBlocks: 215357 GWrRemain: 508
> trace: 0x0000000000000000  grant_trace: use xlog value
> [2]kdb> 
> [2]kdb> xicall 0xffff81007c193710
> xlog_in_core/header at 0xffff81007c193710/0xffffc2001110d000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a00033f60
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 212768  num_ops: 92
> cycle_data: 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc2001110d200  &forcesema: 0xffff81007c193710  next: 0xffff81007c1932f8 bp: 0xffff81007d102608
> log: 0xffff81007d33d650  callb: 0xffff810077915898  callb_tail: 0xffff81003e43cad8
> size: 32256 (OFFSET: 32240) trace: 0xffff81007aa78560 refcnt: 0 bwritecnt: 0 state: 0x2 <WANT_SYNC > 
> =================================================
> xlog_in_core/header at 0xffff81007c1932f8/0xffffc20011116000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a00033fa0
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 212832  num_ops: 99
> cycle_data: 7c1d39c0  127c8  121  121  121  121  122  122  123  123  36120100  3412  0  0  0  0  0  0  0  0  69020000  5  41425443  1c84  4  16  155  60  0  1cd9400  1d05600  1d24600  1d52a00  1e3 
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc20011116200  &forcesema: 0xffff81007c1932f8  next: 0xffff81007d297610 bp: 0xffff81007d102408
> log: 0xffff81007d33d650  callb: 0xffff81007206b898  callb_tail: 0xffff8100715010f8
> size: 32256 (OFFSET: 32256) trace: 0xffff81007aa781d0 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
> xlog_in_core/header at 0xffff81007d297610/0xffffc2001111f000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a00033fe0
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 212896  num_ops: 102
> cycle_data: 7c1d39c0  2dd  3d  547a  1f7d  0  24  2000000  2f6  1  11  1  4a  6730  72d9  631a  6d46  db00  0  6240000d  8400000b  9fa00025  d2e00010  c2c00001  3400001  3da00001  85600001  100000 
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc2001111f200  &forcesema: 0xffff81007d297610  next: 0xffff81007d296198 bp: 0xffff81007d102208
> log: 0xffff81007d33d650  callb: 0xffff81007aac3548  callb_tail: 0xffff81006cdf2788
> size: 32256 (OFFSET: 32256) trace: 0xffff81007a9ef860 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
> xlog_in_core/header at 0xffff81007d296198/0xffffc20011128000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a00034020
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 212960  num_ops: 105
> cycle_data: 7aa7bcd8  0  7e00001  4de00001  4d000001  56600001  49400001  5ae00001  9f600001  4f800001  1f03000  0  1  3  5  a  1f  4347  55b4  5e62  644a  716a  df1400  e59800  ea0600  efc000  f9 
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc20011128200  &forcesema: 0xffff81007d296198  next: 0xffff81007e59cd20 bp: 0xffff81007d102008
> log: 0xffff81007d33d650  callb: 0xffff81006cd5b798  callb_tail: 0xffff81006c4d10f8
> size: 32256 (OFFSET: 32256) trace: 0xffff81007aa78680 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
> xlog_in_core/header at 0xffff81007e59cd20/0xffffc20000354000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a00034060
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 213024  num_ops: 93
> cycle_data: 7aa7bcd8  0  91400001  46600001  67200001  8800001  49400001  5ae00001  9f600001  4f800001  0  4fe00001  79c00001  99600001  c9c00001  b4e0000d  ede0000d  31000017  7580003a  0  5f60   
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc20000354200  &forcesema: 0xffff81007e59cd20  next: 0xffff81007e59c4f0 bp: 0xffff81007d102e08
> log: 0xffff81007d33d650  callb: 0xffff81003fd86068  callb_tail: 0xffff81003e4fca58
> size: 32256 (OFFSET: 32256) trace: 0xffff81007a9efef0 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
> xlog_in_core/header at 0xffff81007e59c4f0/0xffffc2000035d000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a000340a0
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 213088  num_ops: 88
> cycle_data: 7c1d39c0  127c8  121  121  121  121  122  122  123  123  36120100  5d10  6a72  1  3  2030000  ba00001  35600001  3a800001  d6800001  dd200001  e0800001  83000800  6127  6164  58b7  72d 
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc2000035d200  &forcesema: 0xffff81007e59c4f0  next: 0xffff81007d5084f0 bp: 0xffff81007d102c08
> log: 0xffff81007d33d650  callb: 0xffff81006a091818  callb_tail: 0xffff81007206b548
> size: 32256 (OFFSET: 32256) trace: 0xffff81007aa786e0 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
> xlog_in_core/header at 0xffff81007d5084f0/0xffffc20000366000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a000340e0
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 213152  num_ops: 101
> cycle_data: 7aa7bcd8  5f75  6af1  1  3  e359cb09  4  7  11  143  1c  0  1ceba00  1d10800  1d29800  1d5f800  1e53000  1e97000  1ed1800  1f16400  7936448  35  de7a00  e4c800  e9dc00  ee3c00  f7a800  
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc20000366200  &forcesema: 0xffff81007d5084f0  next: 0xffff81007e59c908 bp: 0xffff81007d102a08
> log: 0xffff81007d33d650  callb: 0xffff8100778a6da8  callb_tail: 0xffff8100779144b8
> size: 32256 (OFFSET: 32256) trace: 0xffff81007a981b60 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
> xlog_in_core/header at 0xffff81007e59c908/0xffffc2000036f000
> magicno: feedbabe  cycle: 58  version: 2  lsn: 0x3a00034120
> tail_lsn: 0x3a0000d587  len: 32256  prev_block: 213216  num_ops: 118
> cycle_data: 7aa7bcd8  5f75  6af1  1  3  0  1f01  7b  79  c42c00  0  0  0  0  0  0  0  0  0  4ce00001  b174  80000000  80000000  80000000  80000000  0  0  0  0  68800010  72e6  2000000  31c  1  8c  
> size: 32768
> 
> --------------------------------------------------
> data: 0xffffc2000036f200  &forcesema: 0xffff81007e59c908  next: 0xffff81007c193710 bp: 0xffff81007d102808
> log: 0xffff81007d33d650  callb: 0xffff81006a1c8168  callb_tail: 0xffff81004714d0f8
> size: 32256 (OFFSET: 32256) trace: 0xffff81007aa78f80 refcnt: 0 bwritecnt: 0 state: 0x10 <DO_CALLBACK > 
> =================================================
