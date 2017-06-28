Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25762 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdF1XyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2017 19:54:20 -0400
Date: Wed, 28 Jun 2017 16:54:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: properly set inode type
Message-ID: <20170628235411.GA5874@birch.djwong.org>
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <20170628004252.GB4492@birch.djwong.org>
 <ffd4ffc4-c4f0-4935-a785-c6af95c4d4b9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffd4ffc4-c4f0-4935-a785-c6af95c4d4b9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jun 28, 2017 at 05:45:55PM -0500, Eric Sandeen wrote:
> On 6/27/17 7:42 PM, Darrick J. Wong wrote:
> >> +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> >> +			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> >> +			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
> 
> > XFS_OFFBNO_TO_AGINO(mp, xfs_daddr_to_agbno(mp, b), 0) instead of that
> > long third argument?
> 
> Hm, nope:
> 
> xfs_db> inode 99
> xfs_db> daddr
> current daddr is 99
> 
> xfs_db> daddr 99
> xfs_db> type inode
> xfs_db> inode
> current inode number is 96
> 
> 
> That ends up taking the first inode in the fsblock (12), not the sector
> (99) I guess.
> 
> The macro needs a non-zero offset into the fsblock... found by, um...
> I'm not sure that's going to be much prettier.
> 
> How much do you hate how I wrote it first? ;)  (I kind of hate it a
> lot but dunno what else we have?)

I guess there's also the problem that if inodesize != 512 then what are
we targeting, anyway?  If inodesize = 256 then we can only hit
even-numbered inodes (not so bad) but if inodesize > 512 then do we jump
back to wherever the inode starts?  Or just give the user what they
asked for, even if it's garbage? 

(FWIW I was fine with xfs_db being dumb and giving you exactly what you
point it at, even if that makes no sense. :P)

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
