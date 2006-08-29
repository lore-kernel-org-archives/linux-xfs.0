Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 03:06:30 -0700 (PDT)
Received: from goliath.sylaba.poznan.pl (goliath.sylaba.poznan.pl [193.151.36.3])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7TA6DDW025384
	for <xfs@oss.sgi.com>; Tue, 29 Aug 2006 03:06:14 -0700
Subject: Re: accidently deleted files from directory
From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
In-Reply-To: <44F3D0AD.5060706@sgi.com>
References: <44f384c5.270c085b.5896.ffff9b29@mx.gmail.com>
	 <44F3D0AD.5060706@sgi.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Aug 2006 10:03:36 +0200
Message-Id: <1156838616.10176.13.camel@venus.local.navi.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: gert wohlgemuth <wohlgemuth@ucdavis.edu>, xfs@oss.sgi.com

On Tue, 2006-08-29 at 15:29 +1000, Timothy Shimmin wrote:
> gert wohlgemuth wrote:
> > Hi and thx for your help,
> > 
> > I'm running a gentoo box and using xfs as file system.
> > 
> > On the weekend it happens that I accidentally deleted 1 TB of data (rm -rdf
> > /mnt/lcq). We have no backup of the data (internal reasons of the
> > university...) and it would be nice to get the data somehow back.
> > 
> > After the delete the first step was to unmount the partion and this are the
> > info's from the xfs_check program.
> > 
> > meta-data=/mnt/lcq               isize=256    agcount=32, agsize=9154978
> > blks
> >          =                       sectsz=512
> > data     =                       bsize=4096   blocks=292959296, imaxpct=25
> >          =                       sunit=0      swidth=0 blks, unwritten=1
> > naming   =version 2              bsize=4096
> > log      =internal               bsize=4096   blocks=32768, version=1
> >          =                       sectsz=512   sunit=0 blks
> > realtime =none                   extsz=65536  blocks=0, rtextents=0
> > 
> > after I did a cat /dev/sda1 | less I could see that some data are still
> > exist and are not overwritten. So I think "all" what I have todo is some how
> > get the journal back.
> > 
> What journal would that be?
> If you are referring to the xfs journal or log, then that won't help you.
> It is just logging metadata.
> It is also only designed for replay for metadata which didn't make it to disk.
> 
> > Is there anyway or is all hope lost?
> We don't support undelete as the FAQ says :)
> I suggest you go thru the mailing list archive and see if anyone has suggestions
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
Olaf Frączyk <olaf@cbk.poznan.pl>
