Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7TEUpxE020808 for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 09:30:51 -0500
Received: from [128.162.232.196] (eagdhcp-232-196.americas.sgi.com
	[128.162.232.196])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E81568F8073
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 07:31:40 -0700 (PDT)
Message-ID: <503E27CA.4000705@sgi.com>
Date: Wed, 29 Aug 2012 09:31:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: flush workers before stopping log
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com>
In-Reply-To: <20120829134628.835024558@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Sorry the log print was trucated.

The superblock/UNMOUNT/superblock log is here:

cycle: 10       version: 2              lsn: 10,4858    tail_lsn: 10,4856
length of Log Record: 512       prev offset: 4856               num ops: 5
uuid: aa1f1bfe-c226-42ae-a3db-ae0d4fc62938   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2ce1d11b  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (1): tid: 2ce1d11b  len: 16  clientid: TRANS  flags: none
TRAN:    type: CHECKPOINT       tid: 2ce1d11b       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: 2ce1d11b  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x0
Oper (3): tid: 2ce1d11b  len: 128  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 85952  ifree: 150  fdblks: 344729  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: 2ce1d11b  len: 0  clientid: TRANS  flags: COMMIT

============================================================================
cycle: 10       version: 2              lsn: 10,4860    tail_lsn: 10,4858
length of Log Record: 512       prev offset: 4858               num ops: 1
uuid: aa1f1bfe-c226-42ae-a3db-ae0d4fc62938   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 9328d157  len: 8  clientid: LOG  flags: UNMOUNT
Unmount filesystem

============================================================================
cycle: 10       version: 2              lsn: 10,4862    tail_lsn: 10,4860
length of Log Record: 512       prev offset: 4860               num ops: 5
uuid: aa1f1bfe-c226-42ae-a3db-ae0d4fc62938   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: b6b71c0c  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (1): tid: b6b71c0c  len: 16  clientid: TRANS  flags: none
TRAN:    type: CHECKPOINT       tid: b6b71c0c       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: b6b71c0c  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x0
Oper (3): tid: b6b71c0c  len: 128  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 6360863066640355328  ifree: 524288  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: b6b71c0c  len: 0  clientid: TRANS  flags: COMMIT

============================================================================
xfs_logprint: logical end of log
============================================================================ 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
