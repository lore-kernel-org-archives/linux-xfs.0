Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 May 2008 17:18:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4V0IV6O007745
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 17:18:31 -0700
Received: from proxy1.bredband.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3CBBC2C085
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 17:19:22 -0700 (PDT)
Received: from proxy1.bredband.net (proxy1.bredband.net [195.54.101.71]) by cuda.sgi.com with ESMTP id Q28DpMJbK3OOY89w for <xfs@oss.sgi.com>; Fri, 30 May 2008 17:19:22 -0700 (PDT)
Received: from ironport2.bredband.com (195.54.101.122) by proxy1.bredband.net (7.3.127)
        id 4811823A00B2F2FF for xfs@oss.sgi.com; Sat, 31 May 2008 02:19:21 +0200
Message-ID: <48409981.1050405@stesmi.com>
Date: Sat, 31 May 2008 02:19:13 +0200
From: Stefan Smietanowski <stesmi@stesmi.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net>	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>	 <483F907A.3020108@sgi.com> <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com> <4840406F.50402@stesmi.com> <48408D3E.3090401@gmail.com>
In-Reply-To: <48408D3E.3090401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hamid <spam.wax@gmail.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hamid wrote:
> Stefan Smietanowski wrote:
>>
>> Are you dd'ing the whole disk or just the partition(s) you want ? I
>> recommend just doing the partition(s) into seperate files. I'm uncertain
>> if loopback nowadays handles partitions or not. I know it didn't before
>> but there were patches back then.
>>
>> // Stefan
>>
> I did the whole disk under Linux:
> 
> $ dd if=/dev/sdb of=disk.img conv=noerror,sync
> 
> This is how fdisk sees my image:
> 
> $ sudo fdisk -ul disk.img
> Disk disk.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
> Units = sectors of 1 * 512 bytes
> 
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
> 8: disk.img1            4096   3915599   3911504   a  SGI xfs
> 9: disk.img2               0      4095      4096   0  SGI volhdr
> 11: disk.img3               0   3915599   3915600   6  SGI volume
> ----- Bootinfo -----
> Bootfile: /unix
> ----- Directory Entries -----
> 0: sgilabel   sector    2 size     512
> 
> I could mount the image of the healthy disk using:
> 
> $ sudo mount -t xfs -o loop,offset=$((512*4096)) disk.img /mnt
> 
> and I was able to browse the content of /mnt :)

Excellent, that's one step on the way.

> Trying to mount the whole image didn't work. I was hoping I could do 

Well of course, since "mounting" implies a filesystem and how is
the mount command to know which partition you want to mount and
what filesystem it is to mount? For all it knows you can have 4
partitions with 4 different filesystems on it and how is it to
choose the correct one?

Remember mounting = enabling a filesystem (in a device or file or...)
to be used via a filesystem driver and exported to a mountpoint (/mnt
for example).

In order to do what you're really after you either use your offset
trickery OR use a kernel that can mount partitioned loopback OR write
the image to another disk.

> that so it gives me the possibility of modifying the partition table of 
> the bad disks that refuse to mount under either OS.

If you want to play with the whole device (ie not files) then you can
just run your favorite partition program on your image file or your
favorite binary patching program on the image file.

> Basically I want to play with bad disks' images to see if I can recover 
> any data without actually modifying the disks.
> Is there any work around for this ?
> Should I create a device (rather than a loop) for the whole image ?

I think you have the terminology a little mixed up.

If you mount a something without supplying -o loop "mount" will assume
the filesystem resides in a DEVICE.

If you mount a something WHILE supplying -o loop you tell "mount" that
it should mount it using a loop device. Note device here, it's trickery
really as what it does is that "mount" will FIRST create a new device
node "/dev/loop0" for example and then it will mount from that device
node.

So "should I create a device .." is a little mixed up as that's what
mount is doing deep inside.

> I should mention that creating the whole disk image by using dd under 
> Irix6.5 and using the same mount command as above in Linux didn't work! 
> Something might have gone wrong during the file transfer from Irix to 
> Linux. If I get a chance I'll try it again.

If you do, then create a checksum (sha1sum och md5sum or something) and
compare the image before and after transfer to make sure it's identical.

// Stefan
