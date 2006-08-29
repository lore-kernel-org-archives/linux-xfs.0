Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 22:33:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7T5WuDW004367
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 22:33:24 -0700
Message-ID: <44F3D0AD.5060706@sgi.com>
Date: Tue, 29 Aug 2006 15:29:17 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: accidently deleted files from directory
References: <44f384c5.270c085b.5896.ffff9b29@mx.gmail.com>
In-Reply-To: <44f384c5.270c085b.5896.ffff9b29@mx.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gert wohlgemuth <wohlgemuth@ucdavis.edu>
Cc: xfs@oss.sgi.com

gert wohlgemuth wrote:
> Hi and thx for your help,
> 
> I'm running a gentoo box and using xfs as file system.
> 
> On the weekend it happens that I accidentally deleted 1 TB of data (rm -rdf
> /mnt/lcq). We have no backup of the data (internal reasons of the
> university...) and it would be nice to get the data somehow back.
> 
> After the delete the first step was to unmount the partion and this are the
> info's from the xfs_check program.
> 
> meta-data=/mnt/lcq               isize=256    agcount=32, agsize=9154978
> blks
>          =                       sectsz=512
> data     =                       bsize=4096   blocks=292959296, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> after I did a cat /dev/sda1 | less I could see that some data are still
> exist and are not overwritten. So I think "all" what I have todo is some how
> get the journal back.
> 
What journal would that be?
If you are referring to the xfs journal or log, then that won't help you.
It is just logging metadata.
It is also only designed for replay for metadata which didn't make it to disk.

> Is there anyway or is all hope lost?
We don't support undelete as the FAQ says :)
I suggest you go thru the mailing list archive and see if anyone has suggestions
for scanning the device. Good luck :)

--Tim
