Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 00:34:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m517Yp0u009710
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 00:34:52 -0700
Received: from yw-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 753A1C348C8
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2008 00:35:43 -0700 (PDT)
Received: from yw-out-1718.google.com (yw-out-1718.google.com [74.125.46.155]) by cuda.sgi.com with ESMTP id L2tMDiGEC9vYOpxl for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 00:35:43 -0700 (PDT)
Received: by yw-out-1718.google.com with SMTP id 5so212602ywm.32
        for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 00:35:43 -0700 (PDT)
Message-ID: <48425148.1080105@gmail.com>
Date: Sun, 01 Jun 2008 03:35:36 -0400
From: Hamid <spam.wax@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net>	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>	 <483F907A.3020108@sgi.com> <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com> <4840406F.50402@stesmi.com> <48408D3E.3090401@gmail.com> <48409981.1050405@stesmi.com>
In-Reply-To: <48409981.1050405@stesmi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


> I think you have the terminology a little mixed up.
>
> If you mount a something without supplying -o loop "mount" will assume
> the filesystem resides in a DEVICE.
>
> If you mount a something WHILE supplying -o loop you tell "mount" that
> it should mount it using a loop device. Note device here, it's trickery
> really as what it does is that "mount" will FIRST create a new device
> node "/dev/loop0" for example and then it will mount from that device
> node.
>
Thanks Stefan, Now it makes real sense.

I guess I am back to my original question:
What does 'SB validate failed' indicate and what it really means to my 
case ?

fdisk reports the structure of the Jaz disk as:

$ sudo fdisk -ul jaz7.img

Disk jaz7.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
Units = sectors of 1 * 512 bytes

----- partitions -----
Pt#    Device  Info     Start       End   Sectors  Id  System
 8: jaz7.img1            3072   2091007   2087936   a  SGI xfs
 9: jaz7.img2               0      3071      3072   0  SGI volhdr
11: jaz7.img3               0   2091007   2091008   6  SGI volume
----- Bootinfo -----
Bootfile: /unix
----- Directory Entries -----
 0: sgilabel   sector    3 size     512

I went ahead and tried to mount Partition 8 from image using the offset 
and loop options of the mount command:

$ sudo mount -t xfs -o loop,offset=$((512*3072)) jaz7-partition.img /mnt
mount: wrong fs type, bad option, bad superblock on /dev/loop1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

And system log says:

XFS: bad magic number
XFS: SB validate failed

So I am guessing I have one of these 3 cases:
1- Bad partition table, good file system
2- Good partition table, corrupt file system
3- Or both gone south!!!

I checked the man pages of 'vh' on Irix. It seems that the volhdr
partition is 'usually' 2 megabytes but the disk in question has 3072*512 
bytes ?
Can this be a sign of corruption ?

So where would you start looking at if you wanted to fix this problem ?
Partition table or the file system ?
