Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB9AE7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 16:17:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8D4030406A
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 14:17:56 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	B4vtzg74FshPMzV9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 14:17:54 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id d1so6425638wiv.3
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 14:17:53 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id i8sm797868wib.6.2014.08.12.14.17.50
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 12 Aug 2014 14:17:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 83C6960682
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 23:17:48 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id NO5JKXJ2m_cJ for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 23:17:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 5D65B605B8
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 23:17:48 +0200 (CEST)
Date: Tue, 12 Aug 2014 23:17:36 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <20140812165143.GB46654@bfoster.bfoster>
Message-ID: <alpine.LSU.2.11.1408122212410.14631@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
	<alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
	<alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
	<20140812165143.GB46654@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463808511-1570526093-1407878268=:14631"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808511-1570526093-1407878268=:14631
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Tuesday, 2014-08-12 at 12:51 -0400, Brian Foster wrote:
> On Tue, Aug 12, 2014 at 02:17:00AM +0200, Carlos E. R. wrote:

> I see the same thing from repair that was in your repair output:
>
> block (1,12608397-12608397) multiply claimed by cnt space tree, state - 2

Is it possible to find out what file uses that block?
I have a non-obfuscated copy of the metadata. Knowing the file, we can 
know what application is involved - and that might help, or perhaps not.


> If I take a look at the btrees as is, I see "235:[12608397,10]" included
> in the bnobt (fsb 0x200aa55) and "270:[12608397,10]" in the cntbt (fsb
> 0x2000781). If I skip the mount, zero the log and repair, everything
> seems Ok. I can allocate the remainder of available space and rm -rf
> everything in the fs without an error.
>
> Once I replay the log, I see "272:[12608397,10] 273:[12608397,10]" in
> the cntbt, which is clearly a duplicate entry. This is what repair
> detects and cleans up and seems to lead to the shutdown. E.g., if I
> mount and use the fs, I can hit an assert or failure just by attempting
> to allocate the rest of the space in the fs. If that is the state of the
> fs on disk, it's only a matter of time we explode due to allocating and
> freeing that range of space or possibly attempting to allocate that
> space twice.

I'm not sure if I follow you.

The sequence of events here is:

  a) hibernate
  b) thaw
  c) immediately, in memory corruption found and kernel error message.
     Filesystem is switched to read only.
     System is unstable, has to be halted or rebooted.
     Umount is impossible.

  d) (¬) Reboot
  e) Mount (¬), manual umount, xfs_repair (¬), mount
     (photos of metadata taken at the appropriate points (marked with ¬))


This the point I'm at now. Are you saying that the filesystem can explode 
at any time now? I have not written any files, beyond what the desktop 
does automatically.



What I have not done (on your request), this time, is:

  f) backup, format, restore.




> Mark mentioned that he didn't see the superblock item in the log with
> regard to the freeze. I don't see that either... which perhaps suggests
> that this all happens during the wake-from-hibernate sequence..? My
> understanding is that we should freeze on hibernate, thus force
> everything out to the log, write an unmount record and then dirty the
> log with a superblock transaction. Therefore, that should be the only
> item in the log post-freeze. Here, we have various items in the log
> including several logged buffers that correspond to the cntbt block that
> ends up corrupted (daddr 0xf427c08).
>
> Given the failure occurs on freeing an extent via the xfs_eofblocks
> scanner, perhaps this extent was initially allocated as speculative
> preallocation and the eofblocks scanner is where we happen to first
> identify the corrupted cntbt. What is strange is that, as mentioned
> previously, the space appears to be free if I zero the log, so that
> means it was probably free before the freeze. It seems highly unlikely
> for a file to gain preallocation, be written out and then get trimmed by
> the scanner all on wake-from-hibernate.


Well, I understand little of that, but if you do, and can do whatever 
modifications need to be done to the code, that's fine with me :-)



> Carlos,
>
> How long after hibernate does the shutdown/crash typically occur? Do you
> basically wake-up and within a few seconds the filesystem crashes, or is
> it some time (minutes) later?

Instantly during the wake-up (thaw), according to the log.

I'm typically not present when it happens: my routine is switch on the 
computer, then go make coffee/tea, and then return and start using the 
machine. It takes a minute or two to wake up from hibernation, and then 
the machine is sluggish for a minute or two more while processes start 
doing things and claiming chunks from swap, mail is fetched, etc.

And instead of starting work, I find the machine in a bad state.


Look, an excerpt from the last event (the full log is in another post 
yesterday), but taken from another log file with finer grained timestaps:


<30>1 2014-08-11T05:22:25.861413+02:00 Telcontar ntp 5867 - -  Shutting down network time protocol daemon (NTPD)..done
<30>1 2014-08-11T05:22:25.917520+02:00 Telcontar systemd 1 - -  Stopped LSB: Network time protocol daemon (ntpd).
<28>1 2014-08-11T05:22:25.977431+02:00 Telcontar pm-utils - - -  Hibernating (95)...
<7>1 2014-08-11T05:22:30.605714+02:00 Telcontar kernel - - - [73220.857511] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
<7>1 2014-08-11T05:22:30.605728+02:00 Telcontar kernel - - - [73220.857516] PM: Marking nosave pages: [mem 0xbff90000-0xffffffff]
<7>1 2014-08-11T05:22:30.605729+02:00 Telcontar kernel - - - [73220.858132] PM: Basic memory bitmaps created
<4>1 2014-08-11T15:17:18.911655+02:00 Telcontar kernel - - - [73221.946553] Syncing filesystems ... done.
<4>1 2014-08-11T15:17:18.911744+02:00 Telcontar kernel - - - [73222.682396] Freezing user space processes ... (elapsed 0.002 seconds) done.
<6>1 2014-08-11T15:17:18.911746+02:00 Telcontar kernel - - - [73222.685031] PM: Preallocating image memory... done (allocated 1140745 pages)


The "Hibernating (95)" is written by a script of mine in
"/etc/pm/sleep.d/95cosas" which main purpose is to write to the log that
line.

Then the machine wakes up, hours later - despite the timestamp not saying 
so (the time jump is written instead lines above):


<6>1 2014-08-11T15:17:18.911768+02:00 Telcontar kernel - - - [73228.307358] CPU3 is up
<6>1 2014-08-11T15:17:18.911769+02:00 Telcontar kernel - - - [73228.335219] PM: noirq restore of devices complete after 22.779 msecs
<6>1 2014-08-11T15:17:18.911770+02:00 Telcontar kernel - - - [73228.335354] PM: early restore of devices complete after 0.110 msecs
<7>1 2014-08-11T15:17:18.911771+02:00 Telcontar kernel - - - [73228.508789] uhci_hcd 0000:00:1a.0: setting latency timer to 64
<4>1 2014-08-11T15:17:18.911771+02:00 Telcontar kernel - - - [73228.508809] usb usb3: root hub lost power or was reset

...


<6>1 2014-08-11T15:17:18.911838+02:00 Telcontar kernel - - - [73230.798419] r8169 0000:06:00.0 eth0: link up
<6>1 2014-08-11T15:17:18.911839+02:00 Telcontar kernel - - - [73231.245103] PM: restore of devices complete after 2736.365 msecs
<4>1 2014-08-11T15:17:18.911839+02:00 Telcontar kernel - - - [73231.514298] Restarting kernel threads ... done.
<4>1 2014-08-11T15:17:18.911842+02:00 Telcontar kernel - - - [73231.518736] Restarting tasks ... done.
<7>1 2014-08-11T15:17:18.911843+02:00 Telcontar kernel - - - [73231.562307] PM: Basic memory bitmaps freed
<28>1 2014-08-11T15:17:19.946945+02:00 Telcontar rtkit-daemon 4535 - -  The canary thread is apparently starving. Taking action.
<30>1 2014-08-11T15:17:19.947259+02:00 Telcontar rtkit-daemon 4535 - -  Demoting known real-time threads.
<29>1 2014-08-11T15:17:19.951276+02:00 Telcontar rtkit-daemon 4535 - -  Successfully demoted thread 4541 of process 4534 (/usr/bin/pulseaudio).
<29>1 2014-08-11T15:17:19.951546+02:00 Telcontar rtkit-daemon 4535 - -  Successfully demoted thread 4540 of process 4534 (/usr/bin/pulseaudio).
<29>1 2014-08-11T15:17:19.951799+02:00 Telcontar rtkit-daemon 4535 - -  Successfully demoted thread 4534 of process 4534 (/usr/bin/pulseaudio).
<29>1 2014-08-11T15:17:19.952033+02:00 Telcontar rtkit-daemon 4535 - -  Demoted 3 threads.
<20>1 2014-08-11T15:17:20.808125+02:00 Telcontar dovecot - - -  imap: Warning: Time jumped forwards 33996 seconds
<20>1 2014-08-11T15:17:20.840771+02:00 Telcontar dovecot - - -  imap: Warning: Time jumped forwards 35660 seconds
<22>1 2014-08-11T15:17:20.841006+02:00 Telcontar dovecot - - -  imap(cer): Disconnected for inactivity in=237010 out=9273919
<1>1 2014-08-11T15:17:22.173611+02:00 Telcontar kernel - - - [73235.439809] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
<1>1 2014-08-11T15:17:22.173625+02:00 Telcontar kernel - - - [73235.439809]


...


<5>1 2014-08-11T15:17:22.174493+02:00 Telcontar kernel - - - [73235.440751] XFS (sdd5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa0c4c3d8
<1>1 2014-08-11T15:17:22.232589+02:00 Telcontar kernel - - - [73235.498979] XFS (sdd5): Corruption of in-memory data detected.  Shutting down filesystem
<1>1 2014-08-11T15:17:22.232594+02:00 Telcontar kernel - - - [73235.499136] XFS (sdd5): Please umount the filesystem and rectify the problem(s)
<30>1 2014-08-11T15:17:22.716184+02:00 Telcontar systemd 1 - -  Time has been changed
<30>1 2014-08-11T15:17:27.171188+02:00 Telcontar acpid - - -  1 client rule loaded
<28>1 2014-08-11T15:17:29.413944+02:00 Telcontar pm-utils - - -  Thawing (95)...
<29>1 2014-08-11T15:17:30.048264+02:00 Telcontar dbus 1020 - -  [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
<30>1 2014-08-11T15:17:30.833496+02:00 Telcontar systemd 1 - -  Starting LSB: Network time protocol daemon (ntpd)...
<4>1 2014-08-11T15:17:30.990470+02:00 Telcontar kernel - - - [73244.256012] XFS (sdd5): xfs_log_force: error 5 returned.
<29>1 2014-08-11T15:17:31.324585+02:00 Telcontar dbus 1020 - -  [system] Activated service 'org.freedesktop.PackageKit' failed: Cannot launch daemon, file not found or permissions invalid


As you see, the corruption is detected instantly after waking up, before 
pm-utils scripts have a chance to run.




> If the former, I wonder if it's possible that the scanner returns to
> life pointing to a stale or freed incore inode and does something bogus
> based on that.


Well, as I said, that's above my understanding ;-)



- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPqhHwACgkQtTMYHG2NR9WmrwCglBRRHEMgU9mCEHkU9iHqYehX
+1AAn2oUn8/M3Rfb7mLWapLqYxDfvHNv
=9Yft
-----END PGP SIGNATURE-----
---1463808511-1570526093-1407878268=:14631
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463808511-1570526093-1407878268=:14631--
