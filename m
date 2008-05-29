Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 12:55:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TJt8c9009954
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 12:55:11 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC6001757DC7
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 12:56:00 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.242]) by cuda.sgi.com with ESMTP id LFAoOEng84efaXa6 for <xfs@oss.sgi.com>; Thu, 29 May 2008 12:56:00 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so3342969rvb.32
        for <xfs@oss.sgi.com>; Thu, 29 May 2008 12:55:59 -0700 (PDT)
Message-ID: <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>
Date: Thu, 29 May 2008 15:55:59 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <483EE5BD.8020407@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
	 <483EE5BD.8020407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, May 29, 2008 at 1:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Spam Magnet wrote:
>> Hello there :)
>>
>> I have a Iomega Jaz cartrdige which seems to be formatted in xfs under
>> Irix 6.5.
>> When I insert the cartridge in a drive attached to an Octane machine
>> (running IRIX 6.5) I get an error message saying that the drive could not
>> be mounted:
>> The file system on device: /dev/dsk/dks1d3s7 cannot be mounted
>>
>> I connected the Jaz drive to a Linux box using a SCSI-to-USB
>> adapter. When I do a fdisk I get:
>>
>> $ sudo fdisk -l /dev/sdb
>>
>> Disk /dev/sdb (SGI disk label): 33 heads, 62 sectors, 1022 cylinders
>> Units = cylinders of 2046 * 512 bytes
>>
>> ----- partitions -----
>> Pt#    Device  Info     Start       End   Sectors  Id  System
>>  8: /dev/sdb1               2      1021   2087936   a  SGI xfs
>>  9: /dev/sdb2               0         1      3072   0  SGI volhdr
>> 11: /dev/sdb3               0      1021   2091008   6  SGI volume
>
> I can't remember how sgi disklabels work under linux; does this show up
> as /dev/sdb8 /dev/sdb9 /dev/sdb11 or  as /dev/sdb1 /dev/sdb2 /dev/sdb3
> in linux?
>
> Look at /proc/partitions...
>
> point file -s at /dev/sdb$WHATEVER
>
> see if any of them say "xfs"
>
> and try to mount that :)

Thanks for your response.
Linux shows them as /dev/sdb8 /dev/sdb9 and /dev/sdb11
and none of them are mountable :(

To narrow down the problem, I formatted a clean, error free disk
under SGI(Irix 6.5). Its partition table looks like:

#  prtvtoc /dev/dsk/dks1d3vol
* /dev/dsk/dks1d3vol (bootfile "/unix")
*     512 bytes/sector
Partition  Type  Fs   Start: sec    Size: sec   Mount Directory
 7          xfs  yes        4096      3911504
 8       volhdr                0         4096
10       volume                0      3915600

Now if I connect the same disk to Linux and run fdisk I get the
similar info:
Disk /dev/sdb (SGI disk label): 255 heads, 63 sectors, 0 cylinders
Units = sectors of 1 * 512 bytes

----- partitions -----
Pt#   Device  Info     Start       End   Sectors  Id  System
 8: /dev/sdb1            4096   3915599   3911504   a  SGI xfs
 9: /dev/sdb2               0      4095      4096   0  SGI volhdr
11: /dev/sdb3               0   3915599   3915600   6  SGI volume
----- Bootinfo -----
Bootfile: /unix
----- Directory Entries -----
 0: sgilabel   sector    2 size     512

Again mounting /dev/sdb1 or /dev/sdb8 gives error:
mount: wrong fs type, bad option, bad superblock on /dev/sdb8

and system logs:
XFS: bad magic number
XFS: SB validate failed

So can this be related to the byte ordering or any of the other
issues mentioned in the FAQ regarding xfs under Linux ?
How can I figure out if my disk is using XLV or is a v2 directory ?

Thanks again
