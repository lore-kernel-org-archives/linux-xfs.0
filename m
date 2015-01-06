Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5ED67F54
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 17:16:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C59CB8F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 15:16:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BJH7qJdgIORD1M8f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 15:16:37 -0800 (PST)
Date: Tue, 6 Jan 2015 18:16:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS corrupt after RAID failure and resync
Message-ID: <20150106231617.GA18544@bfoster.bfoster>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
	<44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
	<CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
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
Cc: stefanrin@gmail.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 07, 2015 at 07:34:37AM +1100, David Raffelt wrote:
> Hi Brian and Stefan,
> Thanks for your reply.  I checked the status of the array after the rebuild
> (and before the reset).
> 
> md0 : active raid6 sdd1[8] sdc1[4] sda1[3] sdb1[7] sdi1[5] sde1[1]
>       14650667520 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6]
> [UUUUUU_]
> 
> However given that I've never had any problems before with mdadm rebuilds I
> did not think to check the data before rebooting.  Note that the array is
> still in this state. Before the reboot I tried to run a smartctl check on
> the failed drives and it could not read them. When I rebooted I did not
> actually replace any drives, I just power cycled to see if I could
> re-access the drives that were thrown out of the array. According to
> smartctl they are completely fine.
> 
> I guess there is no way I can re-add the old drives and remove the newly
> synced drive?  Even though I immediately kicked all users off the system
> when I got the mdadm alert, it's possible a small amount of data was
> written to the array during the resync.
> 
> It looks like the filesystem was not unmounted properly before reboot:
> Jan 06 09:11:54 server systemd[1]: Failed unmounting /export/data.
> Jan 06 09:11:54 server systemd[1]: Shutting down.
> 
> Here is the mount errors in the log after rebooting:
> Jan 06 09:15:17 server kernel: XFS (md0): Mounting Filesystem
> Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount and
> run xfs_repair
> Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount and
> run xfs_repair
> Jan 06 09:15:17 server kernel: XFS (md0): Corruption detected. Unmount and
> run xfs_repair
> Jan 06 09:15:17 server kernel: XFS (md0): metadata I/O error: block 0x400
> ("xfs_trans_read_buf_map") error 117 numblks 16
> Jan 06 09:15:17 server kernel: XFS (md0): xfs_imap_to_bp:
> xfs_trans_read_buf() returned error 117.
> Jan 06 09:15:17 server kernel: XFS (md0): failed to read root inode
> 

So it fails to read the root inode. You could also try to read said
inode via xfs_db (e.g., 'sb,' 'p rootino,' 'inode <ino#>,' 'p') and see
what it shows.

Are you able to run xfs_metadump against the fs? If so and you're
willing/able to make the dump available somewhere (compressed), I'd be
interested to take a look to see what might be causing the difference in
behavior between repair and xfs_db.

Brian

> xfs_repair -n -L also complains about a bad magic number.
> 
> Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed
> volume. It was only ever meant to be a scratch drive for intermediate
> scientific results, however inevitably most users used it to store lots of
> data. Oh well.
> 
> Thanks again,
> Dave
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> On 6 January 2015 at 23:47, Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Tue, Jan 06, 2015 at 05:12:14PM +1100, David Raffelt wrote:
> > > Hi again,
> > > Some more information.... the kernel log show the following errors were
> > > occurring after the RAID recovery, but before I reset the server.
> > >
> >
> > By after the raid recovery, you mean after the two drives had failed out
> > and 1 hot spare was activated and resync completed? It certainly seems
> > like something went wrong in this process. The output below looks like
> > it's failing to read in some inodes. Is there any stack trace output
> > that accompanies these error messages to confirm?
> >
> > I suppose I would try to verify that the array configuration looks sane,
> > but after the hot spare resync and then one or two other drive
> > replacements (was the hot spare ultimately replaced?), it's hard to say
> > whether it might be recoverable.
> >
> > Brian
> >
> > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount
> > and
> > > run xfs_repair
> > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount
> > and
> > > run xfs_repair
> > > Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount
> > and
> > > run xfs_repair
> > > Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
> > > 0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
> > > Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
> > > xfs_trans_read_buf() returned error 117.
> > >
> > >
> > > Thanks,
> > > Dave
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
