Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFE3C7F54
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 05:48:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C7C2AC005
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 03:48:37 -0700 (PDT)
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 831nCZkOYXjAeMeA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 03:48:35 -0700 (PDT)
Received: by mail-wg0-f51.google.com with SMTP id x13so6376461wgg.34
	for <xfs@oss.sgi.com>; Tue, 03 Jun 2014 03:48:34 -0700 (PDT)
Message-ID: <538DA7FF.4080002@gmail.com>
Date: Tue, 03 Jun 2014 13:48:31 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363B4C9.4000900@sandeen.net>	<5363CB5E.3090008@gmail.com>	<5363CD70.3000006@sandeen.net>	<5363DBD7.4060002@gmail.com>	<5363E65C.6010006@sandeen.net>	<5363ECE8.6030706@gmail.com>	<20140502233512.GE26353@dastard>	<536432A0.6000405@gmail.com>	<20140503030221.GJ26353@dastard>	<538C5E67.6090005@gmail.com>	<20140602234135.GO6677@dastard>	<538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
In-Reply-To: <CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 06/03/2014 12:55 PM, Stefan Ring wrote:
> From skimming this thread, it seems that there is some hardware
> issue at work here, but nonetheless, I had a very similar situation
> a while ago that was rather puzzling to me at the time, having to
> do with mount namespaces: 
> http://oss.sgi.com/pipermail/xfs/2012-August/020910.html
> 

Hardware issue or not, IMHO XFS has some issues. Specifically, thus
far I have not seen any other filesystem prevent fsck on a USB disk
that disconnected and was reconnected. After all the reconnected
device is a new device. But the new device (different from the
previous one, e.g. sda and sdb) can't be checked (xfs_repair) or mounted.

All right, here's a bit of an experiment. I have a hard drive I use
for testing with several small partitions with several filesystems.

After automounting I see this:

$ cat /proc/mounts | grep media/T
/dev/sdf101 /media/T2 ext2
rw,nosuid,nodev,relatime,errors=continue,user_xattr,acl 0 0
/dev/sdf102 /media/T4 btrfs rw,nosuid,nodev,relatime,nospace_cache 0 0
/dev/sdf104 /media/T5 ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/sdf103 /media/T4_ ext3
rw,nosuid,nodev,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered
0 0
/dev/sdf100 /media/TEST xfs
rw,nosuid,nodev,relatime,attr2,inode64,noquota 0 0

I open hexedit on some files on ext4 and xfs

and I see this:

$ lsof | grep TEST
hexedit   24010      martin    3u      REG              259,2
4198400        131 /media/TEST/TEST...FILE
hexedit   24011      martin    3u      REG              259,6
4198400         12 /media/T5/TEST...FILE

After yanking the USB cable I see this:

$ cat /proc/mounts | grep media/T
  --- no output ---
$ lsof | grep TEST
hexedit   24010      martin    3u  unknown
              /TEST...FILE (stat: Input/output error)
hexedit   24011      martin    3u      REG              259,6
4198400         12 /TEST...FILE

After reconnecting the device ext4 mounts, xfs does not.

dmegs contains this (among other [unrelated] things):

[3095915.107117] sd 60:0:0:0: [sdf] 976773167 512-byte logical blocks:
(500 GB/465 GiB)
[3095915.108343] sd 60:0:0:0: [sdf] Write Protect is off
[3095915.108360] sd 60:0:0:0: [sdf] Mode Sense: 1c 00 00 00
[3095915.110633] sd 60:0:0:0: [sdf] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[3095915.207622]  sdf: sdf69 sdf100 sdf101 sdf102 sdf103 sdf104 sdf105
[3095915.210148] sd 60:0:0:0: [sdf] Attached SCSI disk
[3095917.969887] XFS (sdf100): Mounting Filesystem
[3095918.209464] XFS (sdf100): Starting recovery (logdev: internal)
[3095918.260450] XFS (sdf100): Ending recovery (logdev: internal)
[3096069.218797] XFS (sdf100): metadata I/O error: block 0xa02007
("xlog_iodone") error 19 numblks 64
[3096069.218808] XFS (sdf100): xfs_do_force_shutdown(0x2) called from
line 1115 of file
/build/buildd/linux-lts-raring-3.8.0/fs/xfs/xfs_log.c.  Return address
= 0xffffffffa07f4fd1
[3096069.218830] XFS (sdf100): Log I/O Error Detected.  Shutting down
filesystem
[3096069.218833] XFS (sdf100): Please umount the filesystem and
rectify the problem(s)
[3096099.254131] XFS (sdf100): xfs_log_force: error 5 returned.
[3096129.289338] XFS (sdf100): xfs_log_force: error 5 returned.
[3096159.324525] XFS (sdf100): xfs_log_force: error 5 returned.
[3096185.296795] sd 61:0:0:0: [sdg] 976773167 512-byte logical blocks:
(500 GB/465 GiB)
[3096185.297431] sd 61:0:0:0: [sdg] Write Protect is off
[3096185.297447] sd 61:0:0:0: [sdg] Mode Sense: 1c 00 00 00
[3096185.298022] sd 61:0:0:0: [sdg] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[3096185.392940]  sdg: sdg69 sdg100 sdg101 sdg102 sdg103 sdg104 sdg105
[3096185.395247] sd 61:0:0:0: [sdg] Attached SCSI disk
[3096189.359859] XFS (sdf100): xfs_log_force: error 5 returned.
[3096219.395200] XFS (sdf100): xfs_log_force: error 5 returned.
[3096249.430490] XFS (sdf100): xfs_log_force: error 5 returned.
[3096279.465765] XFS (sdf100): xfs_log_force: error 5 returned.
[3096309.501089] XFS (sdf100): xfs_log_force: error 5 returned.
[3096339.536371] XFS (sdf100): xfs_log_force: error 5 returned.
[3096369.571713] XFS (sdf100): xfs_log_force: error 5 returned.
[3096399.607003] XFS (sdf100): xfs_log_force: error 5 returned.
[3096429.642332] XFS (sdf100): xfs_log_force: error 5 returned.
[3096459.677730] XFS (sdf100): xfs_log_force: error 5 returned.
[3096489.712934] XFS (sdf100): xfs_log_force: error 5 returned.
[3096519.748242] XFS (sdf100): xfs_log_force: error 5 returned.
[3096549.783642] XFS (sdf100): xfs_log_force: error 5 returned.

sdf100 (the old device) and sdg100 (the reconnected device) are
different, but XFS won't touch it.

# xfs_repair /dev/sdg100
xfs_repair: /dev/sdg100 contains a mounted filesystem

fatal error -- couldn't initialize XFS library


Also please do carefully note the difference between the lsof output
for the hung file descriptor for xfs and ext4. ext4 reports everything
the same as before, except for the mount path. xfs report changes, the
device ID is missing, the file changes from REG to unknown.

So, AFAIK and IMHO this is an issue with XFS. The impact can be the
inability to recover from a device disconnect, since so far I don't
see a good way to figure out which processes are holding up the FS.
And besides, having to kill processes to mount a filesystem (xfs) is
not a happy state of affairs.

Oh yes, there is a hardware issue somewhere, but that is not the cause
of the XFS behavior, only the trigger. Since the experiment in this
email was without my USB HUB going nuts, I merely did a good old
fashioned cable yank. And yes, it's not an every day occurrence, but a
stable and reliable FS should deal with it. At least I think so, don't
you? Sadly I can't help with the coding, I am not familiar with the
code base, I got a bit lost trying to follow the path of ustat and
proc mounts, it was ages since I touched the kernel sources. But I can
provide information about what happened. :-) I hope it helps us all
have a good FS.

Martin

PS

# xfs_repair /dev/sdg100
xfs_repair: /dev/sdg100 contains a mounted filesystem

fatal error -- couldn't initialize XFS library
# kill 24010
# xfs_repair /dev/sdg100
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which
needs to
be replayed.  Mount the filesystem to replay the log, and unmount it
before
re-running xfs_repair.  If you are unable to mount the filesystem,
then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a
mount
of the filesystem before doing this.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTjaf4AAoJELsEaSRwbVYrJfsP/3z/WI5+dkk2XduRayB2FdOo
S97IMjGHSEbNDNEAKvTsahYwZENE5TizuhyOrvQORl+fsMaedIdn2QYVS6fGAnJR
llhNMQezUKOfwBZtpf3S3FmvFZCoN+q3BTfl2qkmY29c0aivLyxyTCsGlDprHY2Q
pxv3QzsXRtM1FYk6+FFtc9XQYCiLU3KOAq4I7GoGcAMjFRpH8xpuogI2fQQQkFo8
NGxZBmtTq3xbOd/7237tug44Z98iM/uz+tT2xE5g3iJSqcEhaMTJbAkv9d6uBY8G
xLb+yT5M2O6Z6xuZowk3ySFtO+Ia5Row3BhQrpuySdkRNueiJf9KTLMleMNxVqj8
DcNL2hFS6Fyog6g0wVfoUM3txm5wx80w15K2zN2cPnOsdDO11QKUbV9ktFjQ7f++
CLcmxGHtuq7SFM0bMgbcxvA5B9Gs/9tlzXDiN/jag3ixMZYTmOC15ayJevAM3Nru
xN/lPBMiFO+Rr89yZz303M+hRRRD4pQL1VxcyPjs0f6l0tWqb2Xx0wpFBjantUyF
EzIUwgekwMktzLefhTgXumDH/aE9xlY2au+sJtL255uX1XBq4qE4sxrGv73+L9Ti
M+tToCi7sQPoMwzCqJqHHbYWwaisgbq9AFymy2FUFUSqiiV21NMdIZeu7zcDEzuj
pG51qhnHCz5O48cPBpZx
=ecc3
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
