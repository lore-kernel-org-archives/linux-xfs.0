Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 16:59:31 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m96NxSpQ007655
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 16:59:29 -0700
Date: Tue, 07 Oct 2008 11:04:32 +1100
Subject: Adding attr, inode reference query
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

I'm doing a bit of debugging with attr creation in xfs_repair which uses
libxfs which has it's own simple cache/ref counting/transaction mechanism
for inodes and buffers.

I came across a refcounting issue when adding an extended attribute to an
inode, calling xfs_attr_set_int (indirectly in Phase 6):
   - if there are no extended attributes, a attr fork area is created within
     the inode (calling xfs_bmap_add_attrfork). After this call in libxfs,
     the inode is derefenced.
   - if extended attributes already exist, the inode isn't dereferenced
     after calling xfs_attr_set_int.

I seem to have traced this down to xfs_bmap_add_attrfork not calling
xfs_trans_ihold after calling xfs_trans_ijoin like other similar functions.
BUT, it does call IHOLD(ip).

It seems most other routines do call xfs_trans_ihold, esp in the attr code.

Also, it seems IHOLD isn't normally called in these routine in the
core XFS code.

Is this a bug in xfs_bmap_add_attrfork?
