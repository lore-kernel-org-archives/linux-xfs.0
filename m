Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C3027F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 17:37:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 200F6304067
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 15:37:23 -0700 (PDT)
Received: from mail-we0-f173.google.com (mail-we0-f173.google.com
	[74.125.82.173]) by cuda.sgi.com with ESMTP id rgfZCUdtqlaPRy5l
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 15:37:20 -0700 (PDT)
Received: by mail-we0-f173.google.com with SMTP id u57so7561272wes.18
	for <xfs@oss.sgi.com>; Tue, 03 Jun 2014 15:37:19 -0700 (PDT)
Message-ID: <538E4E1B.1020003@gmail.com>
Date: Wed, 04 Jun 2014 01:37:15 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
	<20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
In-Reply-To: <20140603212834.GG14410@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


I think you're trying too hard to defend XFS which may be causing you
to miss my point. Or it could be my bad communication.

When I yank and replug a device, I can only remount the device only if
I kill certain processes. But this limitation exists only on the same
box. I.e. it won't prevent me from mounting the same disk on a
different machine, just the same one.

So here are a few questions.

(1) If the device vanished, why not just terminate the mount instance?
After all it's not like the device comes back one day and the
processes will be able to continue writing to the files. If you could
do that it would be good, but you yourself said you can't.

(2) Following the methods of the prior experiments I did this,
connected the disk to PC1, hexedit file, yank disk, plug disk, at this
point PC1 won't touch the disk, moved the disk to PC2, it
automatically, silently (Mounting Filesystem ++ Ending clean mount)
mounts the FS, then move the disk back and the disk still doesn't
mount, claiming it's mounted, never mind that since then the FS was
mounted somewhere else and for all intents and purposes it a
completely different disk, to which (question 1) the potentially
unwritten data will never be written back. I apologize, but I really
don't see what XFS is protecting me from or how and I doubt its
success rate. Can you please explain?

(3) Isn't it possible that XFS just doesn't recognize that whatever
error condition happened is permanent and the disk won't come back.
Isn't XFS just forcing me to take a manual action by accident?
Imagine, I have some files, just saved them, didn't call fsync, the
data is still in some cache, the cable is yanked, and the data is
lost. But in this case the XFS won't complain. Only if there's a
process. Seems more like circumstance than design. Is it? Is this an
actual intentional behavior. Designed, as opposed to just happening.
Again, I apologize, but it really seems to me that this isn't right,
that it's neither intentional nor correct. I mean, if it was
intentional, why not prevent me from mounting the FS on PC2, it wasn't
cleanly unmounted, there was a file open, clearly there was some
rationale to stop the auto-mount. And if it didn't stop me from
mounting on PC2, why does it stop me on PC1, if after all the
unwritten data will never ever be written.

> Yup - XFS refuses to mount a filesystem with a duplicate UUID, 
> preventing you from mounting the same filesystem from two
> different logical block device instances that point to the same
> physical disk. That's the only sane thing to do in enterprise
> storage systems that use multi-pathing to present failure-tolerant
> access to a physical device.

Actually, IMHO it would also be sane to forget you ever saw a UUID
after the last underlying physical device is gone and you're not going
to be ever writing to this. Since if you're never touching the FS with
UUID XYZ then it's not mounted enough to prevent use. IMHO. But yes,
as long as you do have a functioning relationship with UUID XYZ
through /dev/sda1, lock /dev/sdb1 if it has the same UUID. But not
after you've lost all block devices. ........ Or attempting to put my
understanding of the situation in humorous terms "the kernel is
preventing access to /dev/sdg100 out of grief for the death of
/dev/sdf100". Lame joke, yes, but think please, what is the actual
benefit of me having to kill a process, after which I yank again, plug
again, and the FS mounts silently. I really don't get this. How is
this not a bug?

Martin

On 06/04/2014 12:28 AM, Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 01:48:31PM +0300, Martin Papik wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA512
>> 
>> On 06/03/2014 12:55 PM, Stefan Ring wrote:
>>> From skimming this thread, it seems that there is some
>>> hardware issue at work here, but nonetheless, I had a very
>>> similar situation a while ago that was rather puzzling to me at
>>> the time, having to do with mount namespaces: 
>>> http://oss.sgi.com/pipermail/xfs/2012-August/020910.html
>>> 
>> 
>> Hardware issue or not, IMHO XFS has some issues.
> 
> No issues, XFS just behaves differently to hot-unplug scenarios to 
> ext4. the ext4 behaviour is actually problematic when it comes to
> data and filesystem security in error conditions and so it is not a
> model we shoul dbe following.
> 
> To summarise, yanking the device out from behind XFS iis causin an 
> EIO error to a critical metadata write and it is shutting down to 
> prevent further error and/or corruption propagation. You have to 
> unmount the XFS shutdown filesystem before you can access the 
> filesystem and mount point again.
> 
> The fact that ext4 is not failing when you yank the plug is a bad 
> sign. That's actually a major potential for Bad Stuff because 
> there's no guarantee that the device you plugged back in is the
> same device, yet ext4 appears to think it is just fine. What
> happens next is likely to be filesystem corruption and data loss.
> 
>> $ cat /proc/mounts | grep media/T --- no output --- $ lsof | grep
>> TEST hexedit   24010      martin    3u  unknown /TEST...FILE
>> (stat: Input/output error)
> 
> Yup, EIO - the device is gone, filesystem shutdown. This is a
> correct reposnse to the conditions you have created.
> 
>> hexedit   24011      martin    3u      REG              259,6 
>> 4198400         12 /TEST...FILE
>> 
>> After reconnecting the device ext4 mounts, xfs does not.
> 
> Yup - XFS refuses to mount a filesystem with a duplicate UUID, 
> preventing you from mounting the same filesystem from two
> different logical block device instances that point to the same
> physical disk. That's the only sane thing to do in enterprise
> storage systems that use multi-pathing to present failure-tolerant
> access to a physical device.
> 
>> dmegs contains this (among other [unrelated] things):
>> 
>> [3095915.107117] sd 60:0:0:0: [sdf] 976773167 512-byte logical
>> blocks: (500 GB/465 GiB) [3095915.108343] sd 60:0:0:0: [sdf]
>> Write Protect is off [3095915.108360] sd 60:0:0:0: [sdf] Mode
>> Sense: 1c 00 00 00 [3095915.110633] sd 60:0:0:0: [sdf] Write
>> cache: enabled, read cache: enabled, doesn't support DPO or FUA 
>> [3095915.207622]  sdf: sdf69 sdf100 sdf101 sdf102 sdf103 sdf104
>> sdf105 [3095915.210148] sd 60:0:0:0: [sdf] Attached SCSI disk 
>> [3095917.969887] XFS (sdf100): Mounting Filesystem 
>> [3095918.209464] XFS (sdf100): Starting recovery (logdev:
>> internal) [3095918.260450] XFS (sdf100): Ending recovery (logdev:
>> internal) [3096069.218797] XFS (sdf100): metadata I/O error:
>> block 0xa02007 ("xlog_iodone") error 19 numblks 64
> 
> #define ENODEV          19      /* No such device */
> 
> Yup, that's what happened to the filesystem - you unplugged the 
> device and it:
> 
>> [3096069.218808] XFS (sdf100): xfs_do_force_shutdown(0x2) called
>> from line 1115 of file 
>> /build/buildd/linux-lts-raring-3.8.0/fs/xfs/xfs_log.c.  Return
>> address = 0xffffffffa07f4fd1 [3096069.218830] XFS (sdf100): Log
>> I/O Error Detected.  Shutting down filesystem [3096069.218833]
>> XFS (sdf100): Please umount the filesystem and rectify the
>> problem(s)
> 
> triggered a shutdown and told you what to do next.
> 
>> [3096099.254131] XFS (sdf100): xfs_log_force: error 5 returned. 
>> [3096129.289338] XFS (sdf100): xfs_log_force: error 5 returned. 
>> [3096159.324525] XFS (sdf100): xfs_log_force: error 5 returned. 
>> [3096185.296795] sd 61:0:0:0: [sdg] 976773167 512-byte logical
>> blocks: (500 GB/465 GiB) [3096185.297431] sd 61:0:0:0: [sdg]
>> Write Protect is off [3096185.297447] sd 61:0:0:0: [sdg] Mode
>> Sense: 1c 00 00 00 [3096185.298022] sd 61:0:0:0: [sdg] Write
>> cache: enabled, read cache:
> 
> Then the device was hot-plugged and it came back as a different 
> block device.
> 
>> sdf100 (the old device) and sdg100 (the reconnected device) are 
>> different, but XFS won't touch it.
>> 
>> # xfs_repair /dev/sdg100 xfs_repair: /dev/sdg100 contains a
>> mounted filesystem
>> 
>> fatal error -- couldn't initialize XFS library
> 
> Yup, because the filesystem is still mounted at /mnt/TEST. XFS 
> checks whether the filesystem on the block device is mounted, not 
> whether the block device *instance* is mounted. Again, this is 
> needed in redundant path storage setups because, for example, 
> /dev/sdc and /dev/sdx might be the same physical disk and
> filesystem but have different paths to get them.
> 
>> Also please do carefully note the difference between the lsof
>> output for the hung file descriptor for xfs and ext4. ext4
>> reports everything the same as before, except for the mount path.
>> xfs report changes, the device ID is missing, the file changes
>> from REG to unknown.
> 
> Of course - it can't be queried because the filesystem has shut
> down and it returned an error.
> 
>> So, AFAIK and IMHO this is an issue with XFS. The impact can be
>> the inability to recover from a device disconnect, since so far I
>> don't see a good way to figure out which processes are holding up
>> the FS. And besides, having to kill processes to mount a
>> filesystem (xfs) is not a happy state of affairs.
> 
> I think you have incorrect expectations of how filesystems should 
> handle device hot-unplug and a later replug.  You're expecting a 
> filesystem that is designed for robustness in data center 
> environments and complex redundant path storage configurations to 
> behave like a filesystem designed for your laptop.
> 
> Hot-unplug is a potential data loss event. Silent data loss is the 
> single worst evil a filesystem can perpetrate on a user because
> the user does not know they lost their important cat videos until
> they try to show them to their friends. Now, would you prefer to
> know you lost your cat videos straight away (XFS behaviour), or a
> few months later when you try to retreive them (ext4 behaviour)?
> 
> Cheers,
> 
> Dave.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTjk4IAAoJELsEaSRwbVYrOyQQAIkEibi8/SNJkKpghkXEb8ZZ
Ek+DO6xSeKg6glzXsZppQuKGPVytqJ0/J8X8+I98khnrI0+U07vzjHB/L7PFyZ/m
afdrnROcxtJxgXF/td/a1+lZjx3JXZnXxidEkDIpJmb9EpjLErgHDyPqbBmVTcja
o6FVAYG57av1LeTm07jL7T75f7Egb1i/LYMH44g/KKUYjo+b3Hr7LckkG58PGZZj
a3bAeEnfnQnXCBSRJP6zsESiB3OZmfTCbN3m2BGLRMdfBYC4tp+duouWLn5raCWn
cWjVfY9XzbfAR7ls2oKAN29Yfvz9mBecTwiL7F9cDRxpCtvfQXYBcyexkuK6w8Dn
+FnsVP4DcrbxlMf7nf9c3kAxL0epis6WKKc+d2aiZZvwyZcqNGXx02Sm5/cB8Qqk
4Vrwe8/Ja2BcJFEK9WaT8DOLn91pIyVcUubH5yWVm830w/aYOWR+B7ZgUyH4HAee
/DZrnMyzivE+hwEdFBuYnLxGypWhC/m+Zc3HpYOiycsn6t5lXXThmyfK/uzK5Vn1
qUirSp0IfBiCJaqvQGL/SyGAyWRUHHIj7Z/ZQb3WJblobN9gPYX9vRdno3TaIJas
fQNMePWdpxxExFnj2mEWTFcanFwaIPQNmWxbPebiSn++KEdk1VPhtShrBD3ei5dO
D895KEfSbfhA5ZIayc3x
=M2a5
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
