Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41963 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfAXIxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 03:53:36 -0500
Message-ID: <1548320014.28802.11.camel@pengutronix.de>
Subject: Re: Regular FS shutdown while rsync is running
From: Lucas Stach <l.stach@pengutronix.de>
Date: Thu, 24 Jan 2019 09:53:34 +0100
In-Reply-To: <20190123185835.GC27886@bfoster>
References: <20181126153249.GC14585@bfoster>
         <1548067317.2465.7.camel@pengutronix.de> <20190121130121.GA4537@bfoster>
         <1548087824.2465.9.camel@pengutronix.de> <20190121181151.GD14281@bfoster>
         <1548153593.2465.18.camel@pengutronix.de> <20190122130254.GA22901@bfoster>
         <1548242057.28802.1.camel@pengutronix.de> <20190123121153.GA27284@bfoster>
         <20190123130306.GB27284@bfoster> <20190123185835.GC27886@bfoster>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

Am Mittwoch, den 23.01.2019, 13:58 -0500 schrieb Brian Foster:
> On Wed, Jan 23, 2019 at 08:03:07AM -0500, Brian Foster wrote:
> > On Wed, Jan 23, 2019 at 07:11:53AM -0500, Brian Foster wrote:
> > > On Wed, Jan 23, 2019 at 12:14:17PM +0100, Lucas Stach wrote:
> > > > Am Dienstag, den 22.01.2019, 08:02 -0500 schrieb Brian Foster:
> > > > > On Tue, Jan 22, 2019 at 11:39:53AM +0100, Lucas Stach wrote:
> > > > > > Hi Brian,
> > > > > > 
> > > > > > Am Montag, den 21.01.2019, 13:11 -0500 schrieb Brian Foster:
> > > > > > [...]
> > > > > > > > So for the moment, here's the output of the above sequence.
> > > > > > > > 
> > > > > > > > xfs_db> convert agno 5 agbno 7831662 fsb
> > > > > > > > 0x5077806e (1350008942)
> > > > > > > > xfs_db> fsb 0x5077806e
> > > > > > > > xfs_db> type finobt
> > > > > > > > xfs_db> print
> > > > > > > > magic = 0x49414233
> > > > > > > > level = 1
> > > > > > > > numrecs = 335
> > > > > > > > leftsib = 7810856
> > > > > > > > rightsib = null
> > > > > > > > bno = 7387612016
> > > > > > > > lsn = 0x6671003d9700
> > > > > > > > uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
> > > > > > > > owner = 5
> > > > > > > > crc = 0xe12b19b2 (correct)
> > > > > > > 
> > > > > > > As expected, we have the inobt magic. Interesting that this is a fairly
> > > > > > > full intermediate (level > 0) node. There is no right sibling, which
> > > > > > > means we're at the far right end of the tree. I wouldn't mind poking
> > > > > > > around a bit more at the tree, but that might be easier with access to
> > > > > > > the metadump. I also think that xfs_repair would have complained were
> > > > > > > something more significant wrong with the tree.
> > > > > > > 
> > > > > > > Hmm, I wonder if the (lightly tested) diff below would help us catch
> > > > > > > anything. It basically just splits up the currently combined inobt and
> > > > > > > finobt I/O verifiers to expect the appropriate magic number (rather than
> > > > > > > accepting either magic for both trees). Could you give that a try?
> > > > > > > Unless we're doing something like using the wrong type of cursor for a
> > > > > > > particular tree, I'd think this would catch wherever we happen to put a
> > > > > > > bad magic on disk. Note that this assumes the underlying filesystem has
> > > > > > > been repaired so as to try and detect the next time an on-disk
> > > > > > > corruption is introduced.
> > > > > > > 
> > > > > > > You'll also need to turn up the XFS error level to make sure this prints
> > > > > > > out a stack trace if/when a verifier failure triggers:
> > > > > > > 
> > > > > > > echo 5 > /proc/sys/fs/xfs/error_level
> > > > > > > 
> > > > > > > I guess we also shouldn't rule out hardware issues or whatnot. I did
> > > > > > > notice you have a strange kernel version: 4.19.4-holodeck10. Is that a
> > > > > > > distro kernel? Has it been modified from upstream in any way? If so, I'd
> > > > > > > strongly suggest to try and confirm whether this is reproducible with an
> > > > > > > upstream kernel.
> > > > > > 
> > > > > > With the finobt verifier changes applied we are unable to mount the FS,
> > > > > > even after running xfs_repair.
> > > > > > 
> > > > > > xfs_repair had found "bad magic # 0x49414233 in inobt block 5/2631703",
> > > > > > which would be daddr 0x1b5db40b8 according to xfs_db. The mount trips
> > > > > > over a buffer at a different daddr though:
> > > > > > 
> > > > > 
> > > > > So the mount failed, you ran repair and discovered the bad magic..? That
> > > > > suggests there was still an issue with the fs on-disk. Could you run
> > > > > 'xfs_repair -n' after the actual xfs_repair to confirm the fs is free of
> > > > > errors before it is mounted? Note that xfs_repair unconditionally
> > > > > regenerates certain metadata structures (like the finobt) from scratch
> > > > > so there is always the possibility that xfs_repair itself is introducing
> > > > > some problem in the fs.
> > > > 
> > > > The sequence was:
> > > > 1. Trying to mount with the debug kernel, which didn't work due to the
> > > > finobt verifier rejecting a bad btree node.
> > > > 2. Full run of mutating xfs_repair (which did find a finobt node with
> > > > bad magic)
> > > > 3. Try to mount again, still fails due to finobt verifier rejecting a
> > > > bad btree node, but at a different daddr than what was flagged by
> > > > xfs_repair.
> > > > 4. xfs_repair -n finds a bad magic finobt node at the same position as
> > > > the mount splat.
> > > > 
> > > > This leads me to wonder if xfs_repair was the poison rather than the
> > > > cure in this case. After digging into the xfs_repair code I found the
> > > > following, which looks suspicious, but I don't know enough about XFS
> > > > internals to tell if this can actually happen:
> > > > 
> > > 
> > > That does imply xfs_repair is the culprit. If you haven't, could you try
> > > the xfs_repair -> xfs_repair -n sequence without a mount attempt in the
> > > picture just to be sure? That may also explain why the block seems to
> > > shift around. It wouldn't surprise me if it's the same relative block in
> > > the tree, but IIRC the tree itself can be shifted around run to run.
> > > 
> > > > build_ino_tree(), which is shared between XFS_BTNUM_INO and
> > > > XFS_BTNUM_FINO btree rebuilds contains the following in one of the
> > > > loops:
> > > > 
> > > > if (lptr->num_recs_pb > 0)
> > > > > > > > 		prop_ino_cursor(mp, agno, btree_curs,
> > > > > > > > 				ino_rec->ino_startnum, 0);
> > > > 
> > > > prop_ino_cursor() calls libxfs_btree_init_block() with the btnum
> > > > parameter being a fixed XFS_BTNUM_INO.
> > > > 
> > > 
> > > It's been a while since I've looked at the guts of this code but that
> > > definitely does not look right. build_ino_tree() is where we abstract
> > > construction of the different tree types. Nice catch!
> > > 
> > > If this is the problem, I'll have to take a closer look to figure out
> > > why this problem isn't more prevalent..
> > > 
> > 
> > Hmm... so it looks like this is the code responsible for _growing_ the
> > interior nodes of the tree (i.e., level > 0). If I'm following the code
> > correctly, the high level algorithm is to first set up a block for each
> > level of the tree. This occurs early in build_ino_tree() and uses the
> > correct btnum. We then start populating the leaf nodes with the finobt
> > records that have previously been built up in-core. For each leaf block,
> > we populate the higher level block with the key based on the first
> > record in the leaf then fill in the remaining records in the leaf. This
> > repeats until the block at the next level up is full, at which point we
> > grab a new level > 0 block and initialize it with the inobt magic.
> > 
> > I haven't confirmed, but I think this basically means that we'd
> > initialize every intermediate block after the left-most block at each
> > level in the tree with the inobt magic. I think Dave already recognized
> > in the other subthread that you have a 2 block level 1 tree. I suspect
> > the only reasons we haven't run into this until now are that the finobt
> > is intended to remain fairly small by only tracking free inode records
> > and thus prioritizing allocation from those records (removing them from
> > the tree) and this is limited to users who repair a filesystem in such a
> > state.
> > 
> 
> I created a large finobt filesystem, confirmed that xfs_repair stamps
> every node as noted above with the inobt magic, and verified that the
> patch below fixes the problem. I'll post it to the list shortly. Thanks
> again.

I can confirm that with the patch applied xfs_repair is able to fix the
corruption. A second xfs_repair run didn't find any corrupt btree nodes
anymore.

I can also confirm that manually stamping the right magic in the
corrupt finobt block via xfs_db brought our FS back to life without a
xfs_repair run.

Regards,
Lucas
