Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 05:06:12 -0800 (PST)
Received: from gw02.mail.saunalahti.fi (gw02.mail.saunalahti.fi [195.197.172.116])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0ND63qw025207
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 05:06:05 -0800
Subject: RE: xfs_repair: corrupt inode error
From: Jyrki Muukkonen <jyrki.muukkonen@futurice.fi>
In-Reply-To: <200701142346.KAA16770@larry.melbourne.sgi.com>
References: <200701142346.KAA16770@larry.melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 15:05:05 +0200
Message-Id: <1169557505.6383.23.camel@mustis>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

On ma, 2007-01-15 at 10:52 +1100, Barry Naujok wrote:
> It appears the inode is corrupted. The size appears to be wrong, and
> there are no blocks allocated to the inode.
> 
> Also, looking at the u.bmbt info, this is most definitely wrong.
> 
> To get xfs_repair to wipe the inode and continue, do the following
> commands:
> 
> # xfs_db -x <dev>
> 
> xfs_db> inode 4151889543
> xfs_db> write core.mode 0
> xfs_db> quit
> 
> # xfs_repair <dev>
> 
> > -----Original Message-----
> > From: Jyrki Muukkonen [mailto:jyrki.muukkonen@futurice.fi] 
> > Sent: Friday, 12 January 2007 7:48 PM
> > To: Barry Naujok
> > Cc: xfs@oss.sgi.com
> > Subject: RE: xfs_repair: corrupt inode error
> > 
> > On pe, 2007-01-12 at 12:25 +1100, Barry Naujok wrote:
> > >  
> > > > -----Original Message-----
> > > > From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> > > > On Behalf Of Jyrki Muukkonen
> > > > Sent: Tuesday, 9 January 2007 3:07 AM
> > > > To: xfs@oss.sgi.com
> > > > Subject: Re: xfs_repair: corrupt inode error
> > > > 
> > > > On ma, 2007-01-08 at 12:23 +0200, Jyrki Muukkonen wrote:
> > > > > Got this error in phase 6 when running xfs_repair 
> > 2.8.18 on ~1.2TB
> > > > > partition over the weekend (it took around 60 hours to 
> > get to this
> > > > > point :). On earlier versions xfs_repair aborted after 
> > > > ~15-20 hours with
> > > > > "invalid inode type" error.
> > > > > 
> > > > > ...
> > > > > disconnected inode 4151889519, moving to lost+found
> > > > > disconnected inode 4151889543, moving to lost+found
> > > > > corrupt inode 4151889543 (btree).  This is a bug.
> > > > > Please report it to xfs@oss.sgi.com.
> > > > > cache_node_purge: refcount was 1, not zero (node=0x132650d0)
> > > > > 
> > > > > fatal error -- 117 - couldn't iget disconnected inode
> > > > > 
> > > > > I've got the full log (both stderr and stdout) and can put that
> > > > > somewhere if needed. It's about 80MB uncompressed and around 7MB
> > > > > gzipped. Running the xfs_repair without multithreading and 
> > > > with -v might
> > > > > also be possible if that's going to help.
> > > > > 
> > > > 
> > > > Some more information:
> > > > - running 64bit Ubuntu Edgy 2.6.17-10-generic
> > > > - one processor so xfs_repair was run with two threads
> > > > - 1.5GB RAM, 3GB swap (at some point the xfs_repair 
> > process took a bit
> > > > over 2GB)
> > > > - filesystem is ~1.14TB with about ~1.4 million files
> > > > - most of the files are in subdirectories by date
> > > > (/something/YYYY/MM/DD/), ~2-10 thousand per day
> > > > 
> > > > So is there a way to skip / ignore this error? I could do 
> > some testing
> > > > with different command line options and small code 
> > patches if that's
> > > > going to help solve the bug.
> > > > 
> > > > Most of the files have been recovered from backups, raw disk 
> > > > images etc.
> > > > but unfortunately some are still missing.
> > > > 
> > > > -- 
> > > > Jyrki Muukkonen
> > > > Futurice Oy
> > > > jyrki.muukkonen@futurice.fi
> > > > +358 41 501 7322
> > > 
> > > Would it be possible to run xfs_db and print out the inode above:
> > > 
> > > # xfs_db <dev>
> > > xfs_db> inode 4151889543
> > > xfs_db> print
> > > 
> > > and email the output back?
> > > 
> > > Regards,
> > > Barry.
> > > 
> > > 
> > 
> > OK, here it is:
> > 
> > xfs_db> inode 4151889543
> > xfs_db> print
> > core.magic = 0x494e
> > core.mode = 0102672
> > core.version = 1
> > core.format = 3 (btree)
> > core.nlinkv1 = 2308
> > core.uid = 721387
> > core.gid = 475570
> > core.flushiter = 7725
> > core.atime.sec = Sun Mar 16 17:15:13 2008
> > core.atime.nsec = 000199174
> > core.mtime.sec = Wed Dec 28 01:58:50 2011
> > core.mtime.nsec = 016845061
> > core.ctime.sec = Tue Aug 22 19:57:39 2006
> > core.ctime.nsec = 148761321
> > core.size = 1880085426117611906
> > core.nblocks = 0
> > core.extsize = 0
> > core.nextents = 0
> > core.naextents = 0
> > core.forkoff = 0
> > core.aformat = 2 (extents)
> > core.dmevmask = 0x1010905
> > core.dmstate = 11
> > core.newrtbm = 0
> > core.prealloc = 1
> > core.realtime = 0
> > core.immutable = 0
> > core.append = 0
> > core.sync = 0
> > core.noatime = 0
> > core.nodump = 0
> > core.rtinherit = 0
> > core.projinherit = 1
> > core.nosymlinks = 0
> > core.extsz = 0
> > core.extszinherit = 0
> > core.nodefrag = 0
> > core.gen = 51072068
> > next_unlinked = null
> > u.bmbt.level = 18550
> > u.bmbt.numrecs = 0
> > 
> > 
> > 
> > -- 
> > Jyrki Muukkonen
> > Futurice Oy
> > jyrki.muukkonen@futurice.fi
> > +358 41 501 7322
> > 
> 

Thanks, setting core.mode to 0 on that particular inode helped.

-- 
Jyrki Muukkonen
Futurice Oy
jyrki.muukkonen@futurice.fi
+358 41 501 7322
