Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:34310 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbfAVVlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 16:41:47 -0500
Date: Wed, 23 Jan 2019 08:41:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190122214143.GL6173@dastard>
References: <1543238989.2507.33.camel@pengutronix.de>
 <20181126153249.GC14585@bfoster>
 <1548067317.2465.7.camel@pengutronix.de>
 <20190121211846.GB4205@dastard>
 <1548148553.2465.16.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548148553.2465.16.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jan 22, 2019 at 10:15:53AM +0100, Lucas Stach wrote:
> 
> Am Dienstag, den 22.01.2019, 08:18 +1100 schrieb Dave Chinner:
> > That doesn't match the agbno that xfs repair reported.
> > 
> > xfs_db> convert agno 5 agbno 7831662 daddr
> > 0x1b8560370 (7387612016)
> > xfs_db> convert daddr 0x1b8560370 agbno
> > 0x77806e (7831662)
> > xfs_db> 
> > 
> > The agbno isn't even close to being correct. We may have a
> > misdirected write here.
> 
> Sorry for causing confusion here. The kernel splat is not from the same
> crash where we were able to capture the metadump from and which the
> xfs_repair output references. It is from a later run, where we didn't
> store a complete metadump. All it does is prove that the bug is still
> present in a later 4.19 stable release.

Well, all it proves is that there is still a problem on disk :/

> Just to rule out the misdirected write theory, I did the following:
> 
> xfs_db> convert agno 5 agbno 7831662 fsb
> 0x5077806e (1350008942)
> xfs_db> fsb 0x5077806e
> xfs_db> type data
> xfs_db> p
> 000: 49414233 0001014f 00772f28 ffffffff 00000001 b8560370 00006671 003d9700
> 020: 026711cc 25c744b9 89aa0aac 496edfec 00000005 e12b19b2 39259c80 393b8c80
> [... snip ...]
> xfs_db> convert	daddr 0x1b8560370 agno
> 0x5 (5)
> xfs_db> convert daddr 0x1b8560370 agbno       
> 0x77806e (7831662)
> 
> So it seems we are looking at a finobt node that is exactly where it is
> supposed to be, but carries the wrong magic. We are still waiting to
> get back results from a run with Brians verifier changes applied.

Well, we don't know yet if it's inobt block incorrectly linked to
the finobt or whether its a finobt block with the wrong magic....

> > So, we really need to start to walk the tree
> > structure to determine if this really is in the correct place.  So
> > what we really need is to look at is the left sibling block of the
> > bad block (agbno 0x758ab) and determine what agbno it points to
> > (i.e. if it points to the agbno that repair told us about or the
> > agbno the kernel thinks it has read).
> > 
> > i.e. run these commands and paste the output:
> > 
> > xfs_db> convert agno 5 agbno 0x758ab fsb
> > 0x500758ab (1342658731)
> > xfs_db> fsb 0x500758ab
> > xfs_db> type data
> > xfs_db> p
> > [hexdump output we need]
> > xfs_db> type finobt
> > xfs_db> p
> > [same info but decoded as finobt structure]
> > xfs_db> type inobt
> > xfs_db> p
> > [same info but decoded as inobt structure]
> 
> Just for completeness I did a bit of the tree walk to look at the left
> sibling:
> 
> xfs_db> convert agno 5 agbno 7810856 fsb
> 0x50772f28 (1349988136)
> xfs_db> fsb 0x50772f28
> xfs_db> type finobt 
> xfs_db> p
> magic = 0x46494233
> level = 1
> numrecs = 252
> leftsib = null
> rightsib = 7831662
> bno = 7387445568
> lsn = 0x66bc003f28a8
> uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
> owner = 5
> crc = 0xe5e78504 (correct)
> [... snip ...]
> 
> It seems interesting that this node doesn't have a left sibling. Does
> this mean the finobt is just those 2 nodes at that point?

No, it means level 1 of the tree only has two blocks. That means
there should be a single level 2 block (the tree root) and up to
several hundred level zero leaf blocks with free inode records in
them.

Can you dump the AGI and the tree roots, walking down the finobt to
the level 1 blocks dumping the tree blocks as you go? i.e.

xfs_db> agi 5
xfs_db> a root
xfs_db> p
[inobt root block info]
xfs_db> ring
type    bblock  bblen    fsbno     inode
* 2: inobt         24     8        3        -1
  1: agi            2     1        0        -1
....
xfs_db> ring 1
xfs_db> a free_root
xfs_db> p
[finobt root block info]
xfs_db> a ptrs[1]
xfs_db> p
[finobt level one left block]
type    bblock  bblen    fsbno     inode
* 3: finobt         .....
  2: finobt         .....
  1: agi             2     1        0        -1
....
xfs_db> ring 2
xfs_db> a ptrs[2]
xfs_db> p
[finobt level one right block]
xfs_db>

basically, this is a walk of the finobt from the top down to
determine if the finobt points to the level 1 block with the bad
magic number.

It may also be owrth while doing a similar walk on the inobt to see
what block is at the right edge of level 1. Essentially that is
walking the last pointer in each block from the root (the right
edge) until you are at the level 1 block....

Cheers,

Dave.


> 
> Regards,
> Lucas
> 

-- 
Dave Chinner
david@fromorbit.com
