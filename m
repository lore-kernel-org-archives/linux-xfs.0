Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6C867F69
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 10:17:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56AC8AC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 08:17:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DLUzYFmi61QCF3HY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 08:16:41 -0800 (PST)
Date: Wed, 7 Jan 2015 11:16:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS corrupt after RAID failure and resync
Message-ID: <20150107161625.GA2232@laptop.bfoster>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
	<44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
	<CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
	<8cc9a649ec2240faa4e38fd742437546@000S-EX-HUB-NP2.unimelb.edu.au>
	<CAOFq7B6t8jrBBu81CuT2tqTyPEYROqkCJ4ChnxCtCvMGiGb7wg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOFq7B6t8jrBBu81CuT2tqTyPEYROqkCJ4ChnxCtCvMGiGb7wg@mail.gmail.com>
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
To: David Raffelt <david.raffelt@florey.edu.au>
Cc: "stefanrin@gmail.com" <stefanrin@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 07, 2015 at 10:47:00AM +1100, David Raffelt wrote:
> Hi Brain,
> Below is the root inode data. I'm currently running xfs_metadump and will
> send you a link to the file.
> Cheers!
> David
> 
> 

Thanks for the metadump. It appears that repair complains about the sb
magic number and goes off scanning for secondary superblocks due to a
bug in verify_set_primary_sb(). This function scans through all the
superblocks and tries to find a consistent value across the set by
tracking which valid sb value occurs most frequently. The bug is that
even if enough valid superblocks are found, we return the validity of
the last sb we happened to look at.

In your case, 10 or so of the 32 superblocks are corrupted and the last
one scanned ('sb 31,' 'p') is one of those. If I work around that issue,
the repair continues on a bit. It generates a _ton_ of noise and
eventually falls over somewhere else (and if I work around that, the
cycle repeats yet again somewhere else). Anyways, I'm adding to my todo
list to take a closer look at this code and perhaps put together a test
case if we don't have enough coverage as is, but that problem doesn't
appear to be gating the ability to recover this particular fs.

Given that, and as Dave pointed out from the output below, the root
inode is clearly completely zeroed out, it does appear that this array
ended up pretty scrambled one way or another. The best I can recommend
is to try and see if the array can be put back together in some manner
that repair can cope with or restore from whatever backups might be
available (others more familiar with md are better help here).

It also might be a good idea to audit the array recovery process
involved with this scenario for future occurrences, because clearly
something went horribly wrong. E.g., was the hotspare or whatever other
array mods made done via script or manually? Do the storage servers that
run these arrays have sane shutdown/startup sequences in the event of
degraded/syncing/busy arrays? etc. It might be worthwhile to try and
reproduce some of these array failure conditions on a test box to
identify any problems with the recovery process before it has to be run
again on one of your other glusterfs servers.

Brian

> 
> 
> xfs_db> sb
> xfs_db> p rootino
> rootino = 1024
> xfs_db> inode 1024
> xfs_db> p
> core.magic = 0
> core.mode = 0
> core.version = 0
> core.format = 0 (dev)
> core.uid = 0
> core.gid = 0
> core.flushiter = 0
> core.atime.sec = Thu Jan  1 10:00:00 1970
> core.atime.nsec = 000000000
> core.mtime.sec = Thu Jan  1 10:00:00 1970
> core.mtime.nsec = 000000000
> core.ctime.sec = Thu Jan  1 10:00:00 1970
> core.ctime.nsec = 000000000
> core.size = 0
> core.nblocks = 0
> core.extsize = 0
> core.nextents = 0
> core.naextents = 0
> core.forkoff = 0
> core.aformat = 0 (dev)
> core.dmevmask = 0
> core.dmstate = 0
> core.newrtbm = 0
> core.prealloc = 0
> core.realtime = 0
> core.immutable = 0
> core.append = 0
> core.sync = 0
> core.noatime = 0
> core.nodump = 0
> core.rtinherit = 0
> core.projinherit = 0
> core.nosymlinks = 0
> core.extsz = 0
> core.extszinherit = 0
> core.nodefrag = 0
> core.filestream = 0
> core.gen = 0
> next_unlinked = 0
> u.dev = 0
> 
> 
> On 7 January 2015 at 10:16, Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Wed, Jan 07, 2015 at 07:34:37AM +1100, David Raffelt wrote:
> > > Hi Brian and Stefan,
> > > Thanks for your reply.  I checked the status of the array after the
> > rebuild
> > > (and before the reset).
> > >
> > > md0 : active raid6 sdd1[8] sdc1[4] sda1[3] sdb1[7] sdi1[5] sde1[1]
> > >       14650667520 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6]
> > > [UUUUUU_]
> > >
> > > However given that I've never had any problems before with mdadm
> > rebuilds I
> > > did not think to check the data before rebooting.  Note that the array is
> > > still in this state. Before the reboot I tried to run a smartctl check on
> > > the failed drives and it could not read them. When I rebooted I did not
> > > actually replace any drives, I just power cycled to see if I could
> > > re-access the drives that were thrown out of the array. According to
> > > smartctl they are completely fine.
> > >
> > > I guess there is no way I can re-add the old drives and remove the newly
> > > synced drive?  Even though I immediately kicked all users off the system
> > > when I got the mdadm alert, it's possible a small amount of data was
> > > written to the array during the resync.
> > >
> > > It looks like the filesystem was not unmounted properly before reboot:
> > > Jan 06 09:11:54 server systemd[1]: Failed unmounting /export/data.
> > > Jan 06 09:11:54 server systemd[1]: Shutting down.
> > >
> > > Here is the mount errors in the log after rebooting:
> > > Jan 06 09:15:17 server kernel: XFS (md0): Mounting Filesystem
> > > Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount
> > and
> > > run xfs_repair
> > > Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount
> > and
> > > run xfs_repair
> > > Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount
> > and
> > > run xfs_repair
> > > Jan 06 09:15:17 server kernel: XFS (md0): metadata I/O error: block 0x400
> > > ("xfs_trans_read_buf_map") error 117 numblks 16
> > > Jan 06 09:15:17 server kernel: XFS (md0): xfs_imap_to_bp:
> > > xfs_trans_read_buf() returned error 117.
> > > Jan 06 09:15:17 server kernel: XFS (md0): failed to read root inode
> > >
> >
> > So it fails to read the root inode. You could also try to read said
> > inode via xfs_db (e.g., 'sb,' 'p rootino,' 'inode <ino#>,' 'p') and see
> > what it shows.
> >
> > Are you able to run xfs_metadump against the fs? If so and you're
> > willing/able to make the dump available somewhere (compressed), I'd be
> > interested to take a look to see what might be causing the difference in
> > behavior between repair and xfs_db.
> >
> > Brian
> >
> > > xfs_repair -n -L also complains about a bad magic number.
> > >
> > > Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed
> > > volume. It was only ever meant to be a scratch drive for intermediate
> > > scientific results, however inevitably most users used it to store lots
> > of
> > > data. Oh well.
> > >
> > > Thanks again,
> > > Dave
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > On 6 January 2015 at 23:47, Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > > On Tue, Jan 06, 2015 at 05:12:14PM +1100, David Raffelt wrote:
> > > > > Hi again,
> > > > > Some more information.... the kernel log show the following errors
> > were
> > > > > occurring after the RAID recovery, but before I reset the server.
> > > > >
> > > >
> > > > By after the raid recovery, you mean after the two drives had failed
> > out
> > > > and 1 hot spare was activated and resync completed? It certainly seems
> > > > like something went wrong in this process. The output below looks like
> > > > it's failing to read in some inodes. Is there any stack trace output
> > > > that accompanies these error messages to confirm?
> > > >
> > > > I suppose I would try to verify that the array configuration looks
> > sane,
> > > > but after the hot spare resync and then one or two other drive
> > > > replacements (was the hot spare ultimately replaced?), it's hard to say
> > > > whether it might be recoverable.
> > > >
> > > > Brian
> > > >
> > > > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected.
> > Unmount
> > > > and
> > > > > run xfs_repair
> > > > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected.
> > Unmount
> > > > and
> > > > > run xfs_repair
> > > > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected.
> > Unmount
> > > > and
> > > > > run xfs_repair
> > > > > Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
> > > > > 0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
> > > > > Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
> > > > > xfs_trans_read_buf() returned error 117.
> > > > >
> > > > >
> > > > > Thanks,
> > > > > Dave
> > > >
> > > > > _______________________________________________
> > > > > xfs mailing list
> > > > > xfs@oss.sgi.com
> > > > > http://oss.sgi.com/mailman/listinfo/xfs
> > > >
> > > >
> > >
> > >
> > > --
> > > *David Raffelt (PhD)*
> > > Postdoctoral Fellow
> > >
> > > The Florey Institute of Neuroscience and Mental Health
> > > Melbourne Brain Centre - Austin Campus
> > > 245 Burgundy Street
> > > Heidelberg Vic 3084
> > > Ph: +61 3 9035 7024
> > > www.florey.edu.au
> >
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> >
> >
> 
> 
> -- 
> *David Raffelt (PhD)*
> Postdoctoral Fellow
> 
> The Florey Institute of Neuroscience and Mental Health
> Melbourne Brain Centre - Austin Campus
> 245 Burgundy Street
> Heidelberg Vic 3084
> Ph: +61 3 9035 7024
> www.florey.edu.au

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
