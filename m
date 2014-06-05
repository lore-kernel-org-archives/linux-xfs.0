Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDFC47F4E
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 20:07:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9ABDE304071
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 18:07:41 -0700 (PDT)
Received: from mail-we0-f177.google.com (mail-we0-f177.google.com
	[74.125.82.177]) by cuda.sgi.com with ESMTP id G4IIlSu8177kGk5C
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Jun 2014 18:07:40 -0700 (PDT)
Received: by mail-we0-f177.google.com with SMTP id x48so278415wes.36
	for <xfs@oss.sgi.com>; Wed, 04 Jun 2014 18:07:38 -0700 (PDT)
Message-ID: <538FC2D5.3080402@gmail.com>
Date: Thu, 05 Jun 2014 04:07:33 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E532E.7050008@gmail.com> <20140605000803.GA4523@dastard>
In-Reply-To: <20140605000803.GA4523@dastard>
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

>> 1) I would LOVE to unmount the FS, but how? umount /dev/xxx ... 
>> device no longer there. umount /media/xxx ... mount point no 
>> longer there.
> 
> Oh, something is doing a lazy unmount automatically on device 
> unplug? I missed the implications of that - your system is 
> behaviour exactly as it has been told to behave.
> 
> That is, lazy unmount only detaches the mount namespace from the 
> mount - it doesn't actually tell the kernel to unmount the 
> filesystem internally, instead it just removes the reference count
>  it has on it. If there are other open references to the 
> filesystem, then it won't actually do the real unmount until those 
> references go away.  i.e. lazy unmount is designed to leave the 
> kernel superblock (i.e. the filesystem) mounted internally until 
> the last reference to it goes away.
> 
> And that leaves the user to find those references and clean them up
> so the kernel can actually unmount it. Put simply, the system is
> behaving exactly as it has been asked to act in response to your
> actions. Whether the automounter is behaving correctly or not, that
> is a different matter, but it is certainly not an XFS bug that a
> lazy unmount is leaving you with a mess that you need to cleanup 
> manually.

But XFS is the one that prevents the repair. For reasons you've
outlined, granted, but it's XFS no longer has access to the device, so
it shouldn't be blocking it.

>> 2) I can't rectify the problems exactly because the FS is mounted
>> (according to xfs_repair [ustat]), yet not mounted (according to
>> /proc/mounts). .... unless rectifying the problem means reporting
>> this as a bug. :-)
> 
> Not a bug, it's the desired behaviour of lazy unmounts. Fix 
> userspace not to hold references when unmounting the filesystem...

Yet it doesn't affect ext4 (to pick an example at random). And the
only way to fix the userspace in this case is to start killing
processes, and again, this is only required for XFS.

>> 3) "Shutting down filesystem" ... isn't this when the new device
>>  should no longer be detected as mounted?
> 
> No. Filesystems get shut down for all sorts of reasons and the 
> correct action to take after unmounting the filesystem depends on 
> the reason for the shutdown. i.e. a shutdown filesystem requires 
> manual intervention to recover from, and so the filesystem remains
>  mounted until such manual intervention can take place.

Once more, shouldn't XFS stop holding onto the UUID after the FS is
shut down AND the underlying device (all of them, in case of
multipath) is returning an error code which means the device won't
ever come back? Seriously, the device is gone, won't come back.
Wouldn't it make sense to just let xfs_repair do its job?

And one more question, did you see the lsof output in my previous
email? Did you notice that while both XFS ans ext4 are still there,
the file that's still in use on ext4 shows the device number, but not
XFS. Just to refresh, here's a copy.

$ lsof | grep TEST
hexedit   24010      martin    3u  unknown /TEST...FILE (stat:
Input/output error)
hexedit   24011      martin    3u      REG              259,6 4198400
        12 /TEST...FILE

See, ext4 was device 259:6, but on XFS the device number doesn't show up.

Looks like lsof is doing a stat (not an lstat) on /proc/X/fd/Y, and
ext4 returns the full inode info, but XFS doesn't. Is this OK? This
info would be the only way to positively tie the processes to the
specific filesystem, wouldn't it?

# stat -L /proc/{15478,15496}/fd/3
stat: cannot stat `/proc/15478/fd/3': Input/output error
  File: `/proc/15496/fd/3'
  Size: 4198400   	Blocks: 520        IO Block: 4096   regular file
Device: 10306h/66310d	Inode: 12          Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/  martin)   Gid: ( 1000/  martin)
Access: 2014-06-05 03:46:42.969617017 +0300
Modify: 2014-03-11 16:24:22.500349375 +0300
Change: 2014-03-11 16:24:22.500349375 +0300
 Birth: -

# strace -e trace=stat stat -L /proc/{15478,15496}/fd/3
stat("/proc/15478/fd/3", 0x7fffcfad7580) = -1 EIO (Input/output error)
stat: cannot stat `/proc/15478/fd/3': Input/output error
stat("/proc/15496/fd/3", {st_mode=S_IFREG|0644, st_size=4198400, ...}) = 0
  File: `/proc/15496/fd/3'
  Size: 4198400   	Blocks: 520        IO Block: 4096   regular file
Device: 10306h/66310d	Inode: 12          Links: 1
stat("/lib/x86_64-linux-gnu/tls/x86_64", 0x7fffcfad69a0) = -1 ENOENT
(No such file or directory)
stat("/lib/x86_64-linux-gnu/tls", 0x7fffcfad69a0) = -1 ENOENT (No such
file or directory)
stat("/lib/x86_64-linux-gnu/x86_64", 0x7fffcfad69a0) = -1 ENOENT (No
such file or directory)
stat("/lib/x86_64-linux-gnu", {st_mode=S_IFDIR|0755, st_size=12288,
...}) = 0
stat("/usr/lib/x86_64-linux-gnu/tls/x86_64", 0x7fffcfad69a0) = -1
ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls", 0x7fffcfad69a0) = -1 ENOENT (No
such file or directory)
stat("/usr/lib/x86_64-linux-gnu/x86_64", 0x7fffcfad69a0) = -1 ENOENT
(No such file or directory)
stat("/usr/lib/x86_64-linux-gnu", {st_mode=S_IFDIR|0755,
st_size=69632, ...}) = 0
stat("/lib/tls/x86_64", 0x7fffcfad69a0) = -1 ENOENT (No such file or
directory)
stat("/lib/tls", 0x7fffcfad69a0)        = -1 ENOENT (No such file or
directory)
stat("/lib/x86_64", 0x7fffcfad69a0)     = -1 ENOENT (No such file or
directory)
stat("/lib", {st_mode=S_IFDIR|0755, st_size=12288, ...}) = 0
stat("/usr/lib/tls/x86_64", 0x7fffcfad69a0) = -1 ENOENT (No such file
or directory)
stat("/usr/lib/tls", 0x7fffcfad69a0)    = -1 ENOENT (No such file or
directory)
stat("/usr/lib/x86_64", 0x7fffcfad69a0) = -1 ENOENT (No such file or
directory)
stat("/usr/lib", {st_mode=S_IFDIR|0755, st_size=90112, ...}) = 0
Access: (0644/-rw-r--r--)  Uid: ( 1000/  martin)   Gid: ( 1000/  martin)
Access: 2014-06-05 03:46:42.969617017 +0300
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=195, ...}) = 0
Modify: 2014-03-11 16:24:22.500349375 +0300
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=195, ...}) = 0
Change: 2014-03-11 16:24:22.500349375 +0300
 Birth: -

>> 4) come to think of it, if XFS is shutting down, why isn't it 
>> unmounting itself?
> 
> Because a filesystem cannot unmount itself - that has to be done 
> from userspace.

That makes sense.

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTj8LPAAoJELsEaSRwbVYrQ7IP/1rLx09jgQBK+4tlcSZqjd8G
dOYQ4onEUrUPUh9/wfzmfArK0DqKSrNK2Gp9y2IpuHIW7i/700TziL1ryVh9k6F+
4Yf+7xPz/tzKQONe/X3XpdO9jSoyJ3pfIQh5Zq7fgUMl6dSr+S3hFYGJ/ZoDgwz5
/E9z17J8Avur3PJNto1CZA5/KqpiRcm/EwXclQMkvN6I7VfJWLiTtmpzntAbzYJI
2QaUP3/k9IxIEB3sydZcGCvcMxljglCrGhFnUX/Q0/qtVMZpHH/oyGZw1KifxUFf
/R5lw1h5CBSHY6fMsjZXWXFvIfzSnli5hV9jIjjRi/tVdXLDCnz4JV3DUP3lMjLc
K8srNBQwk/FM7jOnNcmoAS/EIAx3+FAC8JZL47GbA8EWgDjzUk/AhVAfpvwXkIig
5MA0qn2aYMnLNaUeE8/ZYN5c/5ZnJUnruaL4vM/oP+7YNHnr04GQXoFmIoJ7KOL+
0bhtozACj7K2pNlBS+0jvSY7HnampTdcNXREqHk+hkKzn69vI4xcPNrYRCCyY0hz
OISdfUAMlUighsxy999EYLVz6bLiSy4IJ3aen09SHvRS1iifJycV3MLpiOJl3GED
84AEGLCGCBNHAqP7oWn5acXNSzkvuNTJ1dTpSmL3V+mg9GeoduNyhwP8ymEdsyOE
BH075Xvzf5qh3qLTCELi
=84Mu
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
