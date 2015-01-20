Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C202D7F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 16:27:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B12D58F8033
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 14:27:01 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ruUzXw0B5wW8BNWS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 14:26:59 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9FE5BADF9
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 22:26:58 +0000 (UTC)
Date: Tue, 20 Jan 2015 23:26:58 +0100
From: Jan Kara <jack@suse.cz>
Subject: Bug in AGI buffer logging?
Message-ID: <20150120222658.GA6521@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

  Hello,

  so I was trying to track down occasional reports like:
[  +0.007156] XFS (md0): Mounting V5 Filesystem
[  +0.200782] XFS (md0): Starting recovery (logdev: internal)
[  +0.125313] XFS (md0): Unknown buffer type 0!
[  +0.042793] XFS (md0): _xfs_buf_ioapply: no ops on block 0xaea8802/0x1
[  +0.000145] ffff8800ffc53800: 58 41 47 49 00 00 00 01 00 00 00 02 00 ae
a8 80  XAGI............
[  +0.000179] ffff8800ffc53810: 00 00 13 00 00 00 00 76 00 00 00 01 00 00
00 0e  .......v........
[  +0.000179] ffff8800ffc53820: 00 01 f4 00 ff ff ff ff ff ff ff ff ff ff
ff ff  ................
[  +0.000178] ffff8800ffc53830: ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff  ................
...

from our users with current kernels. What happens is that log contains AGI
buffer but blf_flags is 0 so we don't know how to set the buffer operations
during log recovery. After some experiments I've noticed that when we log
agi_unlinked buckets e.g. in xfs_iunlink_remove(), we don't set buffer
type. We just call
		xfs_trans_log_buf(tp, agibp, offset,
                                  (offset + sizeof(xfs_agino_t) - 1));

and thus buffer may be logged without blf_flags set appropriately. Am I
missing something or is that code really buggy? If it's really a bug I can
try to fix that but I'd think that it would require somewhat larger changes
so that similar bugs are avoided in future so I'm asking first before
investing significant amount of time into it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
