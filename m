Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 194207F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 12:44:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF99DAC004
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 10:44:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ORtrW1rhCgrSHtiS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 10:44:29 -0700 (PDT)
Date: Thu, 3 Jul 2014 13:39:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140703173916.GB3452@laptop.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, Jul 03, 2014 at 05:00:47AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> On Wednesday, 2014-07-02 at 08:04 -0400, Brian Foster wrote:
> >On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:
> 
> ...
> 
> >This is the background eofblocks scanner attempting to free preallocated
> >space on a file. The scanner looks for files that have been recently
> >grown and since been flushed to disk (i.e., no longer concurrently being
> >written to) and trims the post-eof preallocation that comes along with
> >growing files.
> >
> >The corruption errors at xfs_alloc.c:1602,1629 on v3.11 fire if the
> >extent we are attempting to free is already accounted for in the
> >by-block allocation btree. IOW, this is attempting to free an extent
> >that the allocation metadata thinks is already free.
> >
> >>
> >>Brief description:
> >>
> >>
> >> * It happens only on restore from hibernation.
> >
> >Interesting, could you elaborate a bit more on the behavior this system
> >is typically subjected to? i.e., is this a server that sees a constant
> >workload that is also frequently hibernated/awakened?
> 
> It is a desktop machine I use for work at home. I typically have many
> applications opened on diferent workspaces in XFCE. Say one has terminals,
> another has Thunderbird/Pine, another Firefox, another LibreOffice; another
> may have gimp, another may be kbabel or lokalize, another may have vmplayer,
> etc, whatever. When I go out or go to sleep, I hibernate the machine,
> instead of powering down, because it is much faster than reboot, login, and
> start the wanted applications, and I want to conserve some electricity.
> 
> I also use the machine for testing configurations, but these I try to do on
> virtual machines, instead of my work partition.
> 
> 
> The machine may be used anywhere from 4 to 16 hours a day, and hibernated at
> least once a day, perhaps three times if I have to go out several times. It
> makes no sense to me to leave the machine powered doing nothing, if
> hibernating is so easy and reliable - till now. If I have to leave for more
> than a week, I tend to do a full "halt".
> 
> 
> 
> By the way, this started hapening when I replaced an old 500 GB hard disk
> (Seagate ST3500418AS) with a 2 TB new unit (Seagate ST2000DM001-1CH164).
> Smartctl long test says fine (and seatools from Windows, too).
> 

Ok, so there's a lot going on. I was mainly curious to see what was
causing lingering preallocations, but it could be anything extending a
file multiple times.

> 
> 
> >>I do not have more info than what appears on the logs, but four times (two
> >>different kernels):
> >>
> >>cer@Telcontar:~> zgrep XFS_WANT_CORRUPTED_GOTO /var/log/messages*xz
> >>/var/log/messages-20140402.xz:<0.1> 2014-03-15 03:35:17 Telcontar kernel - - - [37685.111787] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
> >>/var/log/messages-20140402.xz:<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
> >>/var/log/messages-20140506.xz:<0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
> >>/var/log/messages-20140629.xz:<0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
> >>cer@Telcontar:~>
> 
> >So you have reproduced this, reformatted with mkfs, restored from
> >backups and continued to reproduce the problem? And still only on this
> >particular partition?
> 
> Right. Exactly that.
> 
> Only that I can not reproduce the issue at will, but about once a month,
> randomly.
> 
> AFAIK, xfsdump can not carry over a filesystem corruption, right?
> 

I think that's accurate, though it might complain/fail in the act of
dumping an fs that is corrupted. The behavior here suggests there might
not be on disk corruption, however.

> 
> 
> **** LONG DESCRIPTION and LOGS start here ********
> 
...
> <5.6> 2014-06-29 12:48:34 Telcontar rsyslogd - - -  [origin software="rsyslogd" swVersion="7.4.7" x-pid="1111" x-info="http://www.rsyslog.com"] exiting on signal 15.
> 2014-06-29 12:48:35+02:00 - Halting the system now  =========================================== uptime:  12:48pm  up 4 days  8:43,  33 users,  load average: 1.40, 0.53, 0.67
> 2014-06-29 12:57:41+02:00 - Booting the system now  ================================================================================  Linux Telcontar 3.11.10-11-desktop #1 SMP PREEMPT Mon May 12 13:37:06 UTC 2014 (3d22b5f) x86_64 x86_64 x86_64 GNU/Linux
> 
> (it does not show in the log that I had to hit the hardware reset button,
> the machine refused to reboot normally, apparently)
> 
> 
>    (If you ask why I took so long to notice the problem after thawing,
>    my routine is to power up the machine, then go prepare tea.  :-)
>    When I come back with the mug, I'm dismayed to see I can not
>    start working; and this day I was in a a hurry)
> 
> 
> So I reboot (text mode, level 3), umount home, run xfsrepair, mount again,
> do xfsdump, do simultanesouly an rsync (it is a file by file copy, in case
> of problems with dump), umount, use YaST in text mode to reformat the
> partition, mount, and then xfsrestore.  It did not occur to me to make a
> 'dd' photo this time: I was tired and busy.
> 
> Maybe next time I can take the photo with dd before doing anything else (it
> takes about 80 minutes), or simply do an "xfs_metadump", which should be
> faster.  And I might not have then 500 GiB of free space to make a dd copy,
> anyway.
> 

xfs_metadump should be faster. It will grab the metadata only and
obfuscate filenames so as to hide sensitive information.

> 
> 
> 
> 
> 
> Question.
> 
> As this always happens on recovery from hibernation, and seeing the message
> "Corruption of in-memory data detected", could it be that thawing does a bad
> memory recovery from the swap?  I thought that the procedure includes some
> checksum, but I don't know for sure.
> 

Not sure, though if so I would think that might be a more common source
of problems. 

> 
> 
> 
> 
> 
> >This is interesting because the corruption appears to be associated with
> >post-eof space, which is generally transient. The worst case is that
> >this space is trimmed off files when they are evicted from cache, such
> >as during a umount. To me, that seems to correlate with a more
> >recent/runtime problem rather than something that might be lingering on
> >disk, but we don't really know for sure.
> 
> Dunno.
> 
> To me, there are two problems:
> 
>  1) The corruption itself.
>  2) That xfs_repair fails to repair the filesystem. In fact, I believe
>     it does not detect it!
> 
> To me, #2 is the worst, and it is what makes me do the backup, format,
> restore cycle for recovery. An occassional kernel crash is somewhat
> acceptable :-}
> 

Well it could be that the "corruption" is gone at the point of a
remount. E.g., something becomes inconsistent in memory, the fs detects
it and shuts down before going any further. That's actually a positive.
;)

That also means it's probably not be necessary to do a full backup,
reformat and restore sequence as part of your routine here. xfs_repair
should scour through all of the allocation metadata and yell if it finds
something like free blocks allocated to a file.

> 
> 
> >>Wait! I have a "dd" copy of the entire partition (500 GB), made on March
> >>16th, 5 AM, so hard data could be obtained from there. I had forgotten. I'll
> >>get something for you now:
> 
> ...
> 
> >>I could do a "xfs_metadump" on it - just tell me what options to use, and
> >>where can the result be uploaded to, if big.
> >>
> >
> >A metadump would be helpful, though that only gives us the on-disk
> >state. What was the state of this fs at the time the dd image was
> >created?
> 
> I'm sorry, I'm not absolutely sure. I believe it is corrupted, but I can not
> vouch it.
> 
> >I'm curious if something like an 'rm -rf *' on the metadump
> >would catch any other corruptions or if this is indeed limited to
> >something associated with recent (pre)allocations.
> 
> Sorry, run 'rm -rf *' where???
> 

On the metadump... mainly just to see whether freeing all of the used
blocks in the fs triggered any other errors (i.e., a brute force way to
check for further corruptions).

> 
> >Run 'xfs_metadump <src> <tgtfile>' to create a metadump that will
> >obfuscate filenames by default. It should also be compressible. In the
> >future, it's probably worth grabbing a metadump as a first step (before
> >repair, zeroing the log, etc.) so we can look at the fs in the state
> >most recent to the crash.
> 
> I will take that photo next time, using a rescue system in order to impede
> the system from mounting the partition and replaying the log. Dunno how long
> that will take to happen, though... usually a month - but at least now I
> know how to do it.
> 
> 
> 
> 
> Meanwhile, I have done a xfs_metadump of the image, and compressed it with
> xz. It has 10834536 bytes. What do I do with it? I'm not sure I can email
> that, and even less to a mail list.
> 
> Do you still have a bugzilla system where I can upload it? I had an account
> at <http://oss.sgi.com/bugzilla/>, made on 2010. I don't know if it still
> runs :-?
> 

I think http://bugzilla.redhat.com should allow you to file a bug and
attach the file.

Brian

> If you don't, I can try to create it a bugzilla on openSUSE instead, and
> tell you the number... but I don't know if it takes files that big. If it
> doesn't, I'll fragment the file. You need to have an account there, I think,
> to retrieve the attachment, and I would prefer to mark the bug private, or
> at least the attachment.
> 
> 
> 
> 
> I did the following.
> 
> First I made a copy, with "dd", of the partition image, all 489G of it. On
> this copy I ran "xfs_check", "xfs_repair -n", and "xfs_repair", with these
> results:
> 
> 
> Telcontar:/data/storage_d/old_backup # xfs_check xfs_copy_home_workonit
> xfs_check is deprecated and scheduled for removal in June 2014.
> Please use xfs_repair -n <dev> instead.
> Telcontar:/data/storage_d/old_backup # xfs_repair -n xfs_copy_home_workonit
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> Telcontar:/data/storage_d/old_backup # time xfs_repair xfs_copy_home_workonit
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> real    0m28.058s
> user    0m1.692s
> sys     0m2.265s
> Telcontar:/data/storage_d/old_backup #
> 
> 
> Maybe the image was made after repair, or maybe xfs_repair doesn't detect
> anything, which as far as I remember, was the case.
> 
> 
> 
> I recreate the copy, to try "mount" on an unaltered copy.
> 
> 
> Telcontar:/data/storage_d/old_backup # time dd if=xfs_copy_home
> of=xfs_copy_home_workonit && mount -v xfs_copy_home_workonit mount/
> 1024000000+0 records in
> 1024000000+0 records out
> 524288000000 bytes (524 GB) copied, 4662.7 s, 112 MB/s
> 
> real    77m43.697s
> user    3m1.420s
> sys     28m41.958s
> mount: /dev/loop0 mounted on /data/storage_d/old_backup/mount.
> (reverse-i-search)`mount': time dd if=xfs_copy_home
> Telcontar:/data/storage_d/old_backup #
> 
> 
> So it mounts...
> 
> 
> 
> 
> 
> - -- Cheers,
>        Carlos E. R.
>        (from 13.1 x86_64 "Bottle" at Telcontar)
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> 
> iEYEARECAAYFAlO0x18ACgkQtTMYHG2NR9X6QwCcD8r5qXIHVh4ELklM/tzXASds
> yskAoIcwxYNC2tKsS7wE9Jp+g4MNUdpd
> =pIZI
> -----END PGP SIGNATURE-----
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
