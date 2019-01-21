Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35325 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbfAUSVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 13:21:13 -0500
Message-ID: <1548094872.2465.14.camel@pengutronix.de>
Subject: Re: Regular FS shutdown while rsync is running
From: Lucas Stach <l.stach@pengutronix.de>
Date: Mon, 21 Jan 2019 19:21:12 +0100
In-Reply-To: <20190121181151.GD14281@bfoster>
References: <1543238989.2507.33.camel@pengutronix.de>
         <20181126153249.GC14585@bfoster> <1548067317.2465.7.camel@pengutronix.de>
         <20190121130121.GA4537@bfoster> <1548087824.2465.9.camel@pengutronix.de>
         <20190121181151.GD14281@bfoster>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Am Montag, den 21.01.2019, 13:11 -0500 schrieb Brian Foster:
> On Mon, Jan 21, 2019 at 05:23:44PM +0100, Lucas Stach wrote:
> > Am Montag, den 21.01.2019, 08:01 -0500 schrieb Brian Foster:
> > [...]
> > > > root@XXX:/mnt/metadump# xfs_repair  /dev/XXX
> > > > Phase 1 - find and verify superblock...
> > > >         - reporting progress in intervals of 15 minutes
> > > > Phase 2 - using internal log
> > > >         - zero log...
> > > >         - scan filesystem freespace and inode maps...
> > > > bad magic # 0x49414233 in inobt block 5/7831662
> > > 
> > > Hmm, so this looks like a very isolated corruption. It's complaining
> > > about a magic number (internal filesystem value stamped to metadata
> > > blocks for verification/sanity purposes) being wrong on a finobt block
> > > and nothing else seems to be wrong in the fs. (I guess repair should
> > > probably print out 'finobt' here instead of 'inobt,' but that's a
> > > separate issue..).
> > > 
> > > The finobt uses a magic value of XFS_FIBT_CRC_MAGIC (0x46494233, 'FIB3')
> > > whereas this block has a magic value of 0x49414233. The latter is
> > > 'IAB3' (XFS_IBT_CRC_MAGIC), which is the magic value for regular inode
> > > btree blocks.
> > > 
> > > >         - 23:06:50: scanning filesystem freespace - 33 of 33 allocation groups done
> > > >         - found root inode chunk
> > > > Phase 3 - for each AG...
> > > 
> > > ...
> > > > Phase 7 - verify and correct link counts...
> > > >         - 22:29:19: verify and correct link counts - 33 of 33 allocation groups done
> > > > done
> > > > 
> > > > >  Would you be able to provide an xfs_metadump image
> > > > > of this filesystem for closer inspection?
> > > > 
> > > > This filesystem is really metadata heavy, so an xfs_metadump ended up
> > > > being around 400GB of data. Not sure if this is something you would be
> > > > willing to look into?
> > > > 
> > > 
> > > Ok, it might be difficult to get ahold of that. Does the image happen to
> > > compress well?
> > 
> > I'll see how well it compresses, but this might take a while...
> > 
> > > In the meantime, given that the corruption appears to be so isolated you
> > > might be able to provide enough information from the metadump without
> > > having to transfer it. The first thing is probably to take a look at the
> > > block in question..
> > > 
> > > First, restore the metadump somewhere:
> > > 
> > > xfs_mdrestore -g ./md.img <destination>
> > > 
> > > You'll need somewhere with enough space for that 400G or so. Note that
> > > you can restore to a file and mount/inspect that file as if it were the
> > > original fs. I'd also mount/unmount the restored metadump and run an
> > > 'xfs_repair -n' on it just to double check that the corruption was
> > > captured properly and there are no other issues with the metadump. -n is
> > > important here as otherwise repair will fix the metadump and remove the
> > > corruption.
> > > 
> > > Next, use xfs_db to dump the contents of the suspect block. Run 'xfs_db
> > > <metadump image>' to open the fs and try the following sequence of
> > > commands.
> > > 
> > > - Convert to a global fsb: 'convert agno 5 agbno 7831662 fsb'
> > > - Jump to the fsb: 'fsb <output of prev cmd>'
> > > - Set the block type: 'type finobt'
> > > - Print the block: 'print'
> > > 
> > > ... and copy/paste the output.
> > 
> > So for the moment, here's the output of the above sequence.
> > 
> > xfs_db> convert agno 5 agbno 7831662 fsb
> > 0x5077806e (1350008942)
> > xfs_db> fsb 0x5077806e
> > xfs_db> type finobt
> > xfs_db> print
> > magic = 0x49414233
> > level = 1
> > numrecs = 335
> > leftsib = 7810856
> > rightsib = null
> > bno = 7387612016
> > lsn = 0x6671003d9700
> > uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
> > owner = 5
> > crc = 0xe12b19b2 (correct)
> 
> As expected, we have the inobt magic. Interesting that this is a fairly
> full intermediate (level > 0) node. There is no right sibling, which
> means we're at the far right end of the tree. I wouldn't mind poking
> around a bit more at the tree, but that might be easier with access to
> the metadump. I also think that xfs_repair would have complained were
> something more significant wrong with the tree.
> 
> Hmm, I wonder if the (lightly tested) diff below would help us catch
> anything. It basically just splits up the currently combined inobt and
> finobt I/O verifiers to expect the appropriate magic number (rather than
> accepting either magic for both trees). Could you give that a try?
> Unless we're doing something like using the wrong type of cursor for a
> particular tree, I'd think this would catch wherever we happen to put a
> bad magic on disk. Note that this assumes the underlying filesystem has
> been repaired so as to try and detect the next time an on-disk
> corruption is introduced.
> 
> You'll also need to turn up the XFS error level to make sure this prints
> out a stack trace if/when a verifier failure triggers:
> 
> echo 5 > /proc/sys/fs/xfs/error_level

Thanks, we'll try this and see if it digs up something.

> I guess we also shouldn't rule out hardware issues or whatnot. I did
> notice you have a strange kernel version: 4.19.4-holodeck10. Is that a
> distro kernel? Has it been modified from upstream in any way? If so, I'd
> strongly suggest to try and confirm whether this is reproducible with an
> upstream kernel.

This is a custom built kernel, but really just the vanilla stable
kernel built with the Debian kernel config, specifically to rule out
any distro kernel issues and to get closer to upstream than what the
distro provides.

Regards,
Lucas
