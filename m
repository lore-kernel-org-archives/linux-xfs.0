Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 01:20:24 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7T8K4DW006001
	for <xfs@oss.sgi.com>; Tue, 29 Aug 2006 01:20:04 -0700
Received: by py-out-1112.google.com with SMTP id x31so2535888pye
        for <xfs@oss.sgi.com>; Tue, 29 Aug 2006 01:19:28 -0700 (PDT)
From: "gert wohlgemuth" <wohlgemuth@ucdavis.edu>
Subject: RE: accidently deleted files from directory
Date: Tue, 29 Aug 2006 01:19:32 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <1156838616.10176.13.camel@venus.local.navi.pl>
Message-ID: <44f3f88f.067ad1b6.2efd.ffff8b76@mx.gmail.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-2?Q?'Olaf_Fr=B1czyk'?= <olaf@cbk.poznan.pl>, 'Timothy Shimmin' <tes@sgi.com>
Cc: xfs@oss.sgi.com

Yeah like always (it would be boring afterwards)

1. our file size is between 100k - 20 GB
2. we have tons of these files...
3. we have all kind of files from xls,xml,bz2 to special files from
scientific machines.

In short we gave up and considering it a loss and a lesson for the future. 

At least I get now the money for a backup server with some space...

Thx for all your help!

gert

-----Original Message-----
From: Olaf Fr±czyk [mailto:olaf@cbk.poznan.pl] 
Sent: Tuesday, August 29, 2006 1:04 AM
To: Timothy Shimmin
Cc: gert wohlgemuth; xfs@oss.sgi.com
Subject: Re: accidently deleted files from directory

On Tue, 2006-08-29 at 15:29 +1000, Timothy Shimmin wrote:
> gert wohlgemuth wrote:
> > Hi and thx for your help,
> > 
> > I'm running a gentoo box and using xfs as file system.
> > 
> > On the weekend it happens that I accidentally deleted 1 TB of data (rm
-rdf
> > /mnt/lcq). We have no backup of the data (internal reasons of the
> > university...) and it would be nice to get the data somehow back.
> > 
> > After the delete the first step was to unmount the partion and this are
the
> > info's from the xfs_check program.
> > 
> > meta-data=/mnt/lcq               isize=256    agcount=32, agsize=9154978
> > blks
> >          =                       sectsz=512
> > data     =                       bsize=4096   blocks=292959296,
imaxpct=25
> >          =                       sunit=0      swidth=0 blks, unwritten=1
> > naming   =version 2              bsize=4096
> > log      =internal               bsize=4096   blocks=32768, version=1
> >          =                       sectsz=512   sunit=0 blks
> > realtime =none                   extsz=65536  blocks=0, rtextents=0
> > 
> > after I did a cat /dev/sda1 | less I could see that some data are still
> > exist and are not overwritten. So I think "all" what I have todo is some
how
> > get the journal back.
> > 
> What journal would that be?
> If you are referring to the xfs journal or log, then that won't help you.
> It is just logging metadata.
> It is also only designed for replay for metadata which didn't make it to
disk.
> 
> > Is there anyway or is all hope lost?
> We don't support undelete as the FAQ says :)
> I suggest you go thru the mailing list archive and see if anyone has
suggestions
> for scanning the device. Good luck :)
It won't be easy. All depends on what data did you have on that disk.
I remember that some time ago a friend of mine has deleted a lot of
jpegs from one partition. I was able to recover most of the data just
reading the disk, looking for something that looked like the beginning
of jpeg file and then copying till the end marker or < 6 MB.
If you know what data were on the device and what to do find them out,
the filesystem is not too fragmented and single files are not big then
you should be able to relativelly easy recover the data. Just find
somebody at your university that knows a little C programming and you
should be fine. In other case - if the data are woth it - I would look
for a company specialized in data recovery, but that will be pricey :(

Regards,

Olaf
-- 
Olaf Fr±czyk <olaf@cbk.poznan.pl>
