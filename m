Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 299F27F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 11:49:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F397A304053
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 09:49:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id XYCN6LDbqgLTzJhw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 09:49:54 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1A2F5AC7E
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 16:49:41 +0000 (UTC)
Date: Wed, 25 Jun 2014 18:49:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: XFS CRC errors after a crash
Message-ID: <20140625164939.GA27620@quack.suse.cz>
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

  so I've been crash-testing XFS (just killing KVM with XFS filesystem
mounted) a bit with V5 superblock enabled in 3.16-rc1 and I can pretty
easily hit CRC mismatches after that. Kernel complains like:
[518184.794175] XFS (sdb3): Mounting V5 Filesystem
[518184.902898] XFS (sdb3): Starting recovery (logdev: internal)
[518187.118860] XFS (sdb3): Metadata CRC error detected at xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1
[518187.118870] XFS (sdb3): Unmount and run xfs_repair
[518187.118875] XFS (sdb3): First 64 bytes of corrupted metadata buffer:
[518187.118882] ffff880136ffd600: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f aa 40  XAGF...........@
[518187.118887] ffff880136ffd610: 00 02 6d 53 00 02 77 f8 00 00 00 00 00 00 00 01  ..mS..w.........
[518187.118891] ffff880136ffd620: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 03  ................
[518187.118895] ffff880136ffd630: 00 00 00 04 00 08 81 d0 00 08 81 a7 00 00 00 00  ................
[518187.118923] XFS (sdb3): metadata I/O error: block 0x1 ("xfs_trans_read_buf_map") error 74 numblks 1

So it seem like the checksum doesn't get updated properly in all the cases.
Looking into the logdump, there doesn't seem to be any modifications for
this AGF block in unrelayed part of the log but there are some modifications
in the older parts of the log - the latest LSN where block 1 was updated is
1,4639 (and the buffer contents in the log corresponds to the data I see in
block 1). However the lsn field in AGF structure in that block shows 1,3616
so that really seems stale (and I've checked and in that transaction the
block has been modified as well).

I'm looking into how the mismatch could happen but if anybody more
knowledgeable wants to have a look I have an unmodified fs image available
(however it has ~20G so if there's a way to make that smaller it would be
good).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
