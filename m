Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 May 2008 16:26:14 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4UNQBA4004572
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 16:26:11 -0700
Received: from wx-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D57CA1764CE4
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 16:27:03 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.226]) by cuda.sgi.com with ESMTP id dHtbhH86zmuUszU7 for <xfs@oss.sgi.com>; Fri, 30 May 2008 16:27:03 -0700 (PDT)
Received: by wx-out-0506.google.com with SMTP id h30so74235wxd.32
        for <xfs@oss.sgi.com>; Fri, 30 May 2008 16:27:03 -0700 (PDT)
Message-ID: <48408D3E.3090401@gmail.com>
Date: Fri, 30 May 2008 19:26:54 -0400
From: Hamid <spam.wax@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net>	 <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>	 <483F1AED.3010808@sandeen.net>	 <3607657a0805291446t79808c63l664780c1cbc3d871@mail.gmail.com>	 <483F907A.3020108@sgi.com> <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com> <4840406F.50402@stesmi.com>
In-Reply-To: <4840406F.50402@stesmi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Stefan Smietanowski wrote:
>
> Are you dd'ing the whole disk or just the partition(s) you want ? I
> recommend just doing the partition(s) into seperate files. I'm uncertain
> if loopback nowadays handles partitions or not. I know it didn't before
> but there were patches back then.
>
> // Stefan
>
I did the whole disk under Linux:

$ dd if=/dev/sdb of=disk.img conv=noerror,sync

This is how fdisk sees my image:

$ sudo fdisk -ul disk.img
Disk disk.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
Units = sectors of 1 * 512 bytes

----- partitions -----
Pt#    Device  Info     Start       End   Sectors  Id  System
 8: disk.img1            4096   3915599   3911504   a  SGI xfs
 9: disk.img2               0      4095      4096   0  SGI volhdr
11: disk.img3               0   3915599   3915600   6  SGI volume
----- Bootinfo -----
Bootfile: /unix
----- Directory Entries -----
 0: sgilabel   sector    2 size     512

I could mount the image of the healthy disk using:

$ sudo mount -t xfs -o loop,offset=$((512*4096)) disk.img /mnt

and I was able to browse the content of /mnt :)
Trying to mount the whole image didn't work. I was hoping I could do 
that so it gives me the possibility of modifying the partition table of 
the bad disks that refuse to mount under either OS.
Basically I want to play with bad disks' images to see if I can recover 
any data without actually modifying the disks.
Is there any work around for this ?
Should I create a device (rather than a loop) for the whole image ?

I should mention that creating the whole disk image by using dd under 
Irix6.5 and using the same mount command as above in Linux didn't work! 
Something might have gone wrong during the file transfer from Irix to 
Linux. If I get a chance I'll try it again.

Thanks again
