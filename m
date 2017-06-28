Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34608 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751610AbdF1Wp4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 18:45:56 -0400
Subject: Re: [PATCH] xfs_db: properly set inode type
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <20170628004252.GB4492@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ffd4ffc4-c4f0-4935-a785-c6af95c4d4b9@sandeen.net>
Date: Wed, 28 Jun 2017 17:45:55 -0500
MIME-Version: 1.0
In-Reply-To: <20170628004252.GB4492@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/27/17 7:42 PM, Darrick J. Wong wrote:
>> +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
>> +			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
>> +			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));

> XFS_OFFBNO_TO_AGINO(mp, xfs_daddr_to_agbno(mp, b), 0) instead of that
> long third argument?

Hm, nope:

xfs_db> inode 99
xfs_db> daddr
current daddr is 99

xfs_db> daddr 99
xfs_db> type inode
xfs_db> inode
current inode number is 96


That ends up taking the first inode in the fsblock (12), not the sector
(99) I guess.

The macro needs a non-zero offset into the fsblock... found by, um...
I'm not sure that's going to be much prettier.

How much do you hate how I wrote it first? ;)  (I kind of hate it a
lot but dunno what else we have?)

-Eric
