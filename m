Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Dec 2007 21:47:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB55kqRF015590
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 21:46:55 -0800
Message-ID: <47563B73.2030403@sgi.com>
Date: Wed, 05 Dec 2007 16:47:31 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: 2.6.24-rc3 oopses while mounting fs
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com> <20071203220200.GC13667@luba> <47549B1A.4070508@sgi.com> <4754FCEC.30906@sgi.com>
In-Reply-To: <4754FCEC.30906@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

> ============================================================================ 
> 
> cycle: 154    version: 2        lsn: 154,5248    tail_lsn: 153,253056
> length of Log Record: 61440    prev offset: 5120        num ops: 303
> uuid: b02fc6bd-662f-40a5-8f0c-e260a881a3e7   format: little endian linux
> h_size: 262144
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
> 
> extended-header: cycle: 154
> ---------------------------------------------------------------------------- 
> 
> Oper (0): tid: 5769cd60  len: 0  clientid: TRANS  flags: START
> ---------------------------------------------------------------------------- 
> 
> Oper (1): tid: 5769cd60  len: 16  clientid: TRANS  flags: none
> TRAN:    type: STRAT_WRITE       tid: 0       num_items: 5
> ---------------------------------------------------------------------------- 
> 
> Oper (2): tid: 5769cd60  len: 56  clientid: TRANS  flags: none
> INODE: #regs: 3   ino: 0x1400005c  flags: 0x5   dsize: 16
>         blkno: 610338736  len: 16  boff: 4096
> Oper (3): tid: 5769cd60  len: 96  clientid: TRANS  flags: none
> INODE CORE
> magic 0x494e mode 0100600 version 1 format 2
> nlink 1 uid 14029 gid 1474
> atime 0x4716b870 mtime 0x4716bade ctime 0x4716bade
> size 0x1ce00000 nblocks 0x1c840 extsize 0x0 nextents 0x1
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen 0x4
> Oper (4): tid: 5769cd60  len: 16  clientid: TRANS  flags: none
> EXTENTS inode data
> ---------------------------------------------------------------------------- 

Another interesting point is that the transaction id has changed between
these operations from 5769cd60 to 5769cf18.  It should stay the same.
We may be reading old log data.

> 
> Oper (5): tid: 5769cf18  len: 24  clientid: TRANS  flags: none
> BUF:  #regs: 2   start blkno: 610338561 (0x24610701)  len: 1  bmap size: 
> 1  flags: 0x0
> Oper (6): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
> AGF Buffer: XAGF
> ver: 1  seq#: 5  len: 15258464
> root BNO: 1  CNT: 2
> level BNO: 1  CNT: 1
> 1st: 0  last: 3  cnt: 4  freeblks: 2491090  longest: 581471
> ---------------------------------------------------------------------------- 
> 
> Oper (7): tid: 5769cf18  len: 28  clientid: TRANS  flags: none
> BUF:  #regs: 2   start blkno: 610338568 (0x24610708)  len: 8  bmap size: 
> 2  flags: 0x0
> Oper (8): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
> BUF DATA
> ---------------------------------------------------------------------------- 
> 
