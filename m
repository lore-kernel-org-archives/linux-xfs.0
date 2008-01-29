Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 04:21:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TCLMHh026392
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 04:21:24 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF42A568558
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 04:21:37 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id 4G0XDM1jsBJBXD9z for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 04:21:37 -0800 (PST)
Date: Tue, 29 Jan 2008 13:20:51 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
Message-ID: <20080129122051.GA18165@citd.de>
References: <20080129093201.GA16203@citd.de> <43347.192.168.3.1.1201601702.squirrel@mail.aconex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43347.192.168.3.1.1201601702.squirrel@mail.aconex.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com

On 29.01.2008 21:15, nscott@aconex.com wrote:
> > Hi
> >
> >
> > Yesterday i bought a 750GB HDD.
> > I encrypt nearly everything with loop-aes, so i also did it with this
> > HDD.
> >
> > I create a "fake" partition table and:
> > losetup -e aes256 -p 0 -o 4096 /dev/loop6 /dev/sdb < key
> >
> > This creates a loop with everything except the first 4KB, i.e. it leaves
> > out the MBR and another 3,5KB.
> >
> > /proc/partions shows the correct(tm) size informations for the HDD and
> > the loop:
> > - snip -
> >    7     6  732574580 loop6
> >    8    16  732574584 sdb
> >    8    17  732572001 sdb1
> > - snip -
> >
> > But when i mkfs.xfs the loop
> > #> mkfs.xfs /dev/loop6
> > meta-data=/dev/loop6             isize=256    agcount=3, agsize=45785911
> > blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=137357733, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096
> > log      =internal log           bsize=4096   blocks=32768, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> > And mount it:
> > mount /dev/loop6 /mnt
> >
> > And least but not least df it:
> > #> df -m /mnt
> > Filesystem           1M-blocks      Used Available Use% Mounted on
> > /dev/loop6              536426         5    536422   1% /mnt
> >
> > There is roughly 1/3 missing.
> >
> > What can i do to fix this?
> 
> mkfs.xfs uses the BLKGETSIZE64 ioctl to extract the device size, so
> the problem is likely in the loop device driver (just a guess).  You
> can use the test program xfs-cmds/xfstests/src/getdevicesize.c to
> test what that device returns as its size (no XFS-specific code in the
> test program, so if it returns bad data we've narrowed down the root
> cause a whole lot).
> 
> What does that program produce for your device?

After a little odyssey to actually finding getdevicesize.c :-)

#> wget 'http://oss.sgi.com/cgi-bin/cvsweb.cgi/~checkout~/xfs-cmds/xfstests/src/getdevicesize.c?rev=1.3;content-type=text%2Fplain' -O getdevicesize.c
#> gcc -o getdevicesize getdevicesize.c
#> ./getdevicesize /dev/loop6
1465149160 512 byte blocks (BLKGETSIZE64)

Which is 750156369920 bytes or 732574580 KBytes, IOW EXACTLY the number 
reported in /proc/partions for the loop.



A maybe important detail, i forgot to mention in the original mail is:
The machine has 8GB of RAM, so i compiled the kernel with "64bit=yes" 
(formaly x86_64), BUT(!) the userspace is 32bit or plain old i386.

I only need the RAM for a large tmpfs. So i didn't reinstall the machine 
with a 64bit userspace when i switched the hardware from a Dual P3 with 
3GB to a Core2Duo with 8GB.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
