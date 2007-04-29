Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 10:22:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3THMdfB014945
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 10:22:40 -0700
Message-ID: <4634D45D.5030807@sandeen.net>
Date: Sun, 29 Apr 2007 12:22:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs cannot make sector size 64 KiB?
References: <Pine.LNX.4.64.0704291218190.10418@p34.internal.lan> <Pine.LNX.4.64.0704291225070.10607@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0704291225070.10607@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Adding LKML to cc list.
> 
> On Sun, 29 Apr 2007, Justin Piszcz wrote:
> 
>>> From the manpage:
>>
>>       -b     Block size options.
>>
>>              This option specifies the fundamental block size of the 
>> filesys-
>>              tem.   The  valid suboptions are: log=value and 
>> size=value; only
>>              one can be supplied.  The block size is specified  
>> either  as a
>>              base two logarithm value with log=, or in bytes with 
>> size=. The
>>              default value is 4096 bytes (4 KiB), the minimum is 512, 
>> and the
>>              maximum is 65536 (64 KiB).  XFS on Linux currently only 
>> supports
>>              pagesize or smaller blocks.
>>
>> The maximum size is 64 KiB, yet it seems only up to 32 KiB is valid?

above is block size, not sector size

>> I am running x86_64.

then you are limited to blocks (and therefore sectors) <= page size, so 
<= 4096.

You can -mkfs- something bigger, but you won't be able to mount it.

>> $ uname -m
>> x86_64
>>
>>
>> p34:~# mkfs.xfs -b size=512 /dev/md3
>> mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
>> mkfs.xfs: Use the -f option to force overwrite.
>> p34:~# mkfs.xfs -b size=4096 /dev/md3
>> mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
>> mkfs.xfs: Use the -f option to force overwrite.
>> p34:~# mkfs.xfs -b size=8192 /dev/md3
>> mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
>> mkfs.xfs: Use the -f option to force overwrite.
>> p34:~# mkfs.xfs -b size=16384 /dev/md3
>> mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
>> mkfs.xfs: Use the -f option to force overwrite.
>> p34:~# mkfs.xfs -b size=32768 /dev/md3
>> mkfs.xfs: /dev/md3 appears to contain an existing filesystem (xfs).
>> mkfs.xfs: Use the -f option to force overwrite.
>> p34:~# mkfs.xfs -b size=65536 /dev/md3
>> illegal sector size 65536

This is mkfs.xfs trying to be smart about making larger "sectors" (== 
blocksize) on an md device, so that it does not switch the size of the 
IO requests between data & metadata, slowing things down significantly. 
  however,

        -s     Sector size options.

               This  option  specifies the fundamental sector size of 
the filesystem.  The
               valid suboptions are: log=value and size=value; only one 
can  be  supplied.
               The  sector  size  is  specified  either as a base two 
logarithm value with
               log=, or in bytes with size=.  The default value is 512 
bytes.  The minimum
               value  for  sector  size is 512; the maximum is 32768 (32 
KiB).  The sector
               size must be a power of 2 size and cannot be made larger 
than the  filesys-
               tem block size.


looks like a buglet where it is trying to make a block == sector == 64k, 
but sectors are limited to 32.

But this is not what you want anyway, assuming you want to actually 
*mount* your new  filesystem on x86_64.  Just make take default 
blocksize (4k) and be happy.

>> Usage: mkfs.xfs
>> /* blocksize */         [-b log=n|size=num]
>> /* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
>>                            (sunit=value,swidth=value|su=num,sw=num),
>>                            sectlog=n|sectsize=num,unwritten=0|1]
>> /* inode size */        [-i 
>> log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]
>> /* log subvol */        [-l 
>> agnum=n,internal,size=num,logdev=xxx,version=n
>>                            sunit=value|su=num,sectlog=n|sectsize=num]
>> /* label */             [-L label (maximum 12 characters)]
>> /* naming */            [-n log=n|size=num,version=n]
>> /* prototype file */    [-p fname]
>> /* quiet */             [-q]
>> /* realtime subvol */   [-r extsize=num,size=num,rtdev=xxx]
>> /* sectorsize */        [-s log=n|size=num]
>> /* version */           [-V]
>>                        devicename
>> <devicename> is required unless -d name=xxx is given.
>> <num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
>>      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
>> <value> is xxx (512 byte blocks).
>> p34:~#
>>
>> Unless, the page size is not <= 64 for x86_64?

it's not, but that's not why this broke.

-Eric

>> Justin.
>>
>>
> 
> 
