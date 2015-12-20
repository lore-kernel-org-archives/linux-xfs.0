Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 355607F73
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 06:36:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBC84AC001
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 04:36:36 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 3fzhj8CwRFkhVakU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Dec 2015 04:36:30 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 8371F20A17
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 13:36:28 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pNk2374C9z5vNB
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 13:36:27 +0100 (CET)
From: Kristian <kbx@posteo.de>
Subject: Integer truncation in fs/xfs/libxfs/xfs_da_btree.c
Message-ID: <5676A0C6.9000407@posteo.de>
Date: Sun, 20 Dec 2015 13:36:22 +0100
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

there is an integer truncation in

fs/xfs/libxfs/xfs_da_btree.c +2081

/* account for newly allocated blocks in reserved blocks total */
args->total -= dp->i_d.di_nblocks - nblks;

with the types: uint32 -= uint64 - uint64

On a hardened kernel with grsecurity enabled, this leads to a fault.

https://forums.grsecurity.net/viewtopic.php?f=3&t=4346&sid=3200600c0faaab4bf8779a95c549a737

Is this intentional and safe?

Regards

Kristian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
