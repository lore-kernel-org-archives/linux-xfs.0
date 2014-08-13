Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F3157F3F
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 07:05:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 830E3304043
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 05:04:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OPd6fsXIzV9ON1xb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 05:04:56 -0700 (PDT)
Date: Wed, 13 Aug 2014 08:04:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20140813120450.GA3569@bfoster.bfoster>
References: <alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
	<alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
	<alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
	<20140812165143.GB46654@bfoster.bfoster>
	<alpine.LSU.2.11.1408122212410.14631@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408122212410.14631@Telcontar.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Tue, Aug 12, 2014 at 11:17:36PM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> =

> =

> =

> On Tuesday, 2014-08-12 at 12:51 -0400, Brian Foster wrote:
> >On Tue, Aug 12, 2014 at 02:17:00AM +0200, Carlos E. R. wrote:
> =

> >I see the same thing from repair that was in your repair output:
> >
> >block (1,12608397-12608397) multiply claimed by cnt space tree, state - 2
> =

> Is it possible to find out what file uses that block?
> I have a non-obfuscated copy of the metadata. Knowing the file, we can kn=
ow
> what application is involved - and that might help, or perhaps not.
> =


I don't see how given the current situation. The space appears to be
free initially, so zeroing the log contents on repair puts the fs in a
state where the space is not allocated to any particular file. Perhaps
there is some incremental state created by the log that can provide this
information (e.g., space is free, space is preallocated, extent is
converted, eofblocks are trimmed all in a single checkpoint), but that
could be difficult to trace back since iirc the btree had grown as well.

> =

> >If I take a look at the btrees as is, I see "235:[12608397,10]" included
> >in the bnobt (fsb 0x200aa55) and "270:[12608397,10]" in the cntbt (fsb
> >0x2000781). If I skip the mount, zero the log and repair, everything
> >seems Ok. I can allocate the remainder of available space and rm -rf
> >everything in the fs without an error.
> >
> >Once I replay the log, I see "272:[12608397,10] 273:[12608397,10]" in
> >the cntbt, which is clearly a duplicate entry. This is what repair
> >detects and cleans up and seems to lead to the shutdown. E.g., if I
> >mount and use the fs, I can hit an assert or failure just by attempting
> >to allocate the rest of the space in the fs. If that is the state of the
> >fs on disk, it's only a matter of time we explode due to allocating and
> >freeing that range of space or possibly attempting to allocate that
> >space twice.
> =

> I'm not sure if I follow you.
> =

> The sequence of events here is:
> =

>  a) hibernate
>  b) thaw
>  c) immediately, in memory corruption found and kernel error message.
>     Filesystem is switched to read only.
>     System is unstable, has to be halted or rebooted.
>     Umount is impossible.
> =


Ok, so the crash is fairly immediate after the wake (also according to
the log output below).

>  d) (=AC) Reboot
>  e) Mount (=AC), manual umount, xfs_repair (=AC), mount
>     (photos of metadata taken at the appropriate points (marked with =AC))
> =

> =

> This the point I'm at now. Are you saying that the filesystem can explode=
 at
> any time now? I have not written any files, beyond what the desktop does
> automatically.
> =


No, the filesystem has been fixed by repair. I'm just saying that
somehow the fs creates a duplicate free space record in one of the free
space trees. That particular condition means it's only a matter of time
before some block allocation operation trips up on that inconsistent
state and shuts down the fs. You happen to hit it immediately due to
that space being involved with speculative preallocation.

The current theory is that this is probably due to XFS workqueues not
being freezable, and therefore can make changes on disk after the dump
image is created. This seems logical to me, but I'd still like to see
some kind of verification of the potential fix if possible. I can repeat
some vm hibernate testing with that in mind. Alternatively, would you
have the ability to test a patch? Have you been able to reproduce this
again since the most recent instance?

Brian

> =

> =

> What I have not done (on your request), this time, is:
> =

>  f) backup, format, restore.
> =

> =

> =

> =

> >Mark mentioned that he didn't see the superblock item in the log with
> >regard to the freeze. I don't see that either... which perhaps suggests
> >that this all happens during the wake-from-hibernate sequence..? My
> >understanding is that we should freeze on hibernate, thus force
> >everything out to the log, write an unmount record and then dirty the
> >log with a superblock transaction. Therefore, that should be the only
> >item in the log post-freeze. Here, we have various items in the log
> >including several logged buffers that correspond to the cntbt block that
> >ends up corrupted (daddr 0xf427c08).
> >
> >Given the failure occurs on freeing an extent via the xfs_eofblocks
> >scanner, perhaps this extent was initially allocated as speculative
> >preallocation and the eofblocks scanner is where we happen to first
> >identify the corrupted cntbt. What is strange is that, as mentioned
> >previously, the space appears to be free if I zero the log, so that
> >means it was probably free before the freeze. It seems highly unlikely
> >for a file to gain preallocation, be written out and then get trimmed by
> >the scanner all on wake-from-hibernate.
> =

> =

> Well, I understand little of that, but if you do, and can do whatever
> modifications need to be done to the code, that's fine with me :-)
> =

> =

> =

> >Carlos,
> >
> >How long after hibernate does the shutdown/crash typically occur? Do you
> >basically wake-up and within a few seconds the filesystem crashes, or is
> >it some time (minutes) later?
> =

> Instantly during the wake-up (thaw), according to the log.
> =

> I'm typically not present when it happens: my routine is switch on the
> computer, then go make coffee/tea, and then return and start using the
> machine. It takes a minute or two to wake up from hibernation, and then t=
he
> machine is sluggish for a minute or two more while processes start doing
> things and claiming chunks from swap, mail is fetched, etc.
> =

> And instead of starting work, I find the machine in a bad state.
> =

> =

> Look, an excerpt from the last event (the full log is in another post
> yesterday), but taken from another log file with finer grained timestaps:
> =

> =

> <30>1 2014-08-11T05:22:25.861413+02:00 Telcontar ntp 5867 - -  Shutting d=
own network time protocol daemon (NTPD)..done
> <30>1 2014-08-11T05:22:25.917520+02:00 Telcontar systemd 1 - -  Stopped L=
SB: Network time protocol daemon (ntpd).
> <28>1 2014-08-11T05:22:25.977431+02:00 Telcontar pm-utils - - -  Hibernat=
ing (95)...
> <7>1 2014-08-11T05:22:30.605714+02:00 Telcontar kernel - - - [73220.85751=
1] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
> <7>1 2014-08-11T05:22:30.605728+02:00 Telcontar kernel - - - [73220.85751=
6] PM: Marking nosave pages: [mem 0xbff90000-0xffffffff]
> <7>1 2014-08-11T05:22:30.605729+02:00 Telcontar kernel - - - [73220.85813=
2] PM: Basic memory bitmaps created
> <4>1 2014-08-11T15:17:18.911655+02:00 Telcontar kernel - - - [73221.94655=
3] Syncing filesystems ... done.
> <4>1 2014-08-11T15:17:18.911744+02:00 Telcontar kernel - - - [73222.68239=
6] Freezing user space processes ... (elapsed 0.002 seconds) done.
> <6>1 2014-08-11T15:17:18.911746+02:00 Telcontar kernel - - - [73222.68503=
1] PM: Preallocating image memory... done (allocated 1140745 pages)
> =

> =

> The "Hibernating (95)" is written by a script of mine in
> "/etc/pm/sleep.d/95cosas" which main purpose is to write to the log that
> line.
> =

> Then the machine wakes up, hours later - despite the timestamp not saying=
 so
> (the time jump is written instead lines above):
> =

> =

> <6>1 2014-08-11T15:17:18.911768+02:00 Telcontar kernel - - - [73228.30735=
8] CPU3 is up
> <6>1 2014-08-11T15:17:18.911769+02:00 Telcontar kernel - - - [73228.33521=
9] PM: noirq restore of devices complete after 22.779 msecs
> <6>1 2014-08-11T15:17:18.911770+02:00 Telcontar kernel - - - [73228.33535=
4] PM: early restore of devices complete after 0.110 msecs
> <7>1 2014-08-11T15:17:18.911771+02:00 Telcontar kernel - - - [73228.50878=
9] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> <4>1 2014-08-11T15:17:18.911771+02:00 Telcontar kernel - - - [73228.50880=
9] usb usb3: root hub lost power or was reset
> =

> ...
> =

> =

> <6>1 2014-08-11T15:17:18.911838+02:00 Telcontar kernel - - - [73230.79841=
9] r8169 0000:06:00.0 eth0: link up
> <6>1 2014-08-11T15:17:18.911839+02:00 Telcontar kernel - - - [73231.24510=
3] PM: restore of devices complete after 2736.365 msecs
> <4>1 2014-08-11T15:17:18.911839+02:00 Telcontar kernel - - - [73231.51429=
8] Restarting kernel threads ... done.
> <4>1 2014-08-11T15:17:18.911842+02:00 Telcontar kernel - - - [73231.51873=
6] Restarting tasks ... done.
> <7>1 2014-08-11T15:17:18.911843+02:00 Telcontar kernel - - - [73231.56230=
7] PM: Basic memory bitmaps freed
> <28>1 2014-08-11T15:17:19.946945+02:00 Telcontar rtkit-daemon 4535 - -  T=
he canary thread is apparently starving. Taking action.
> <30>1 2014-08-11T15:17:19.947259+02:00 Telcontar rtkit-daemon 4535 - -  D=
emoting known real-time threads.
> <29>1 2014-08-11T15:17:19.951276+02:00 Telcontar rtkit-daemon 4535 - -  S=
uccessfully demoted thread 4541 of process 4534 (/usr/bin/pulseaudio).
> <29>1 2014-08-11T15:17:19.951546+02:00 Telcontar rtkit-daemon 4535 - -  S=
uccessfully demoted thread 4540 of process 4534 (/usr/bin/pulseaudio).
> <29>1 2014-08-11T15:17:19.951799+02:00 Telcontar rtkit-daemon 4535 - -  S=
uccessfully demoted thread 4534 of process 4534 (/usr/bin/pulseaudio).
> <29>1 2014-08-11T15:17:19.952033+02:00 Telcontar rtkit-daemon 4535 - -  D=
emoted 3 threads.
> <20>1 2014-08-11T15:17:20.808125+02:00 Telcontar dovecot - - -  imap: War=
ning: Time jumped forwards 33996 seconds
> <20>1 2014-08-11T15:17:20.840771+02:00 Telcontar dovecot - - -  imap: War=
ning: Time jumped forwards 35660 seconds
> <22>1 2014-08-11T15:17:20.841006+02:00 Telcontar dovecot - - -  imap(cer)=
: Disconnected for inactivity in=3D237010 out=3D9273919
> <1>1 2014-08-11T15:17:22.173611+02:00 Telcontar kernel - - - [73235.43980=
9] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/a=
build/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c. =
 Caller 0xffffffffa0c39fe9
> <1>1 2014-08-11T15:17:22.173625+02:00 Telcontar kernel - - - [73235.43980=
9]
> =

> =

> ...
> =

> =

> <5>1 2014-08-11T15:17:22.174493+02:00 Telcontar kernel - - - [73235.44075=
1] XFS (sdd5): xfs_do_force_shutdown(0x8) called from line 916 of file /hom=
e/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_bmap.c=
.  Return address =3D 0xffffffffa0c4c3d8
> <1>1 2014-08-11T15:17:22.232589+02:00 Telcontar kernel - - - [73235.49897=
9] XFS (sdd5): Corruption of in-memory data detected.  Shutting down filesy=
stem
> <1>1 2014-08-11T15:17:22.232594+02:00 Telcontar kernel - - - [73235.49913=
6] XFS (sdd5): Please umount the filesystem and rectify the problem(s)
> <30>1 2014-08-11T15:17:22.716184+02:00 Telcontar systemd 1 - -  Time has =
been changed
> <30>1 2014-08-11T15:17:27.171188+02:00 Telcontar acpid - - -  1 client ru=
le loaded
> <28>1 2014-08-11T15:17:29.413944+02:00 Telcontar pm-utils - - -  Thawing =
(95)...
> <29>1 2014-08-11T15:17:30.048264+02:00 Telcontar dbus 1020 - -  [system] =
Activating service name=3D'org.freedesktop.PackageKit' (using servicehelper)
> <30>1 2014-08-11T15:17:30.833496+02:00 Telcontar systemd 1 - -  Starting =
LSB: Network time protocol daemon (ntpd)...
> <4>1 2014-08-11T15:17:30.990470+02:00 Telcontar kernel - - - [73244.25601=
2] XFS (sdd5): xfs_log_force: error 5 returned.
> <29>1 2014-08-11T15:17:31.324585+02:00 Telcontar dbus 1020 - -  [system] =
Activated service 'org.freedesktop.PackageKit' failed: Cannot launch daemon=
, file not found or permissions invalid
> =

> =

> As you see, the corruption is detected instantly after waking up, before
> pm-utils scripts have a chance to run.
> =

> =

> =

> =

> >If the former, I wonder if it's possible that the scanner returns to
> >life pointing to a stale or freed incore inode and does something bogus
> >based on that.
> =

> =

> Well, as I said, that's above my understanding ;-)
> =

> =

> =

> - -- Cheers,
>        Carlos E. R.
>        (from 13.1 x86_64 "Bottle" at Telcontar)
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> =

> iEYEARECAAYFAlPqhHwACgkQtTMYHG2NR9WmrwCglBRRHEMgU9mCEHkU9iHqYehX
> +1AAn2oUn8/M3Rfb7mLWapLqYxDfvHNv
> =3D9Yft
> -----END PGP SIGNATURE-----

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
