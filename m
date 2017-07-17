Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42987 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdGQVHn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2017 17:07:43 -0400
Date: Mon, 17 Jul 2017 14:07:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: properly set inode type
Message-ID: <20170717210736.GF4224@magnolia>
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <20170628004252.GB4492@birch.djwong.org>
 <ffd4ffc4-c4f0-4935-a785-c6af95c4d4b9@sandeen.net>
 <20170628235411.GA5874@birch.djwong.org>
 <f7050d91-0bc5-ec0a-fc3f-59a25f8855ef@sandeen.net>
 <67d06f4f-73fc-577c-a12f-132821386597@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67d06f4f-73fc-577c-a12f-132821386597@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 17, 2017 at 03:51:50PM -0500, Eric Sandeen wrote:
> 
> 
> On 06/28/2017 11:01 PM, Eric Sandeen wrote:
> >> I guess there's also the problem that if inodesize != 512 then what are
> >> we targeting, anyway?  If inodesize = 256 then we can only hit
> >> even-numbered inodes (not so bad) but if inodesize > 512 then do we jump
> >> back to wherever the inode starts?  Or just give the user what they
> >> asked for, even if it's garbage? 
> > Oh, hum. Right, big inodes.... 
> > 
> > So I'm trying to go from disk location to inode number, but the current
> > disk location may not even be the start of an inode.  Hell.  Well, I'm
> > sure I could craft a test to disallow "type inode" if the current location
> > cannot be on an inode boundary.  But is that too clever?  Should the
> > debug tool just do what the user asks?
> > 
> >> (FWIW I was fine with xfs_db being dumb and giving you exactly what you
> >> point it at, even if that makes no sense. :P)
> > yeah, if you do "daddr 0" "type agf" it'll squawk, too, so it's fine to
> > do the dumb user's bidding...
> 
> So as I have it today, issuing "type inode" will actually re-align you
> to an inode offset even if you're not on one:
> 
> xfs_db> sb 0
> xfs_db> addr rootino
> xfs_db> daddr
> current daddr is 128
> xfs_db> daddr 129
> xfs_db> type inode
> xfs_db> daddr
> current daddr is 128
> xfs_db> 
> 
> good? bad? indifferent? I'm thinking "bad" but we have no mechanism to
> read a batch of inodes in xfs_db other than by passing in a legit inode number.

I suppose there's the argument that if the user feeds us garbage then
they'll find out pretty quickly when the CRC checks blow up in print...
...or that it's a debugging tool so if they want to do weird things then
let them.

> And we have no mechanism to read only a /single/ inode...
> 
> Maybe print a warning about the re-alignment and carry on?

Sure.

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
