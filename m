Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 17:00:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBK10fqw021526
	for <linux-xfs@oss.sgi.com>; Tue, 19 Dec 2006 17:00:43 -0800
Message-Id: <200612200059.LAA04335@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Wed, 20 Dec 2006 12:05:47 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <em84t3$b27$1@sea.gmane.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-2?Q?'Marcin_Zaj=B1czkowski'?= <mszpak@wp.pl>, linux-xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Marcin Zajaczkowski
> Sent: Tuesday, 19 December 2006 6:39 PM
> To: linux-xfs@oss.sgi.com
> Subject: Re: xfs_ncheck (actually xfs_db) eats a lot of 
> memory and is killed
> 
> Marcin Zaj±czkowski wrote:
> > Barry Naujok wrote:
> >>> Subject: xfs_ncheck (actually xfs_db) eats a lot of 
> memory and is killed
> > (...)
> >>> Recently I've got rescue CD with xfs_progs in version 2.8.11 and 
> >>> tried to repair it. xfs_repair gave me about 150 files with names 
> >>> like inode numbers in /lost+found and 1500 "normal" named 
> files in 
> >>> its subdirectory.
> >>> I've tried to use "xfs_ncheck -i inode /dev/hdX" to got names 
> >>> corresponding with specified inode(s), but program had 
> been runing 
> >>> several minutes, xfs_db had eaten all available memory 
> (768MB) and 
> >>> was killed by system (whole system hung too). The second time I 
> >>> killed it (kill -15) when it ate whole available memory.
> >>> My file system has about 6GB and is filled with 95%.
> >>
> >> This is the second report of a smallish filesystem using all of the
> >> system's memory (the other being xfs_repair). Hopefully 
> when I diagnose
> >> the problem with the previous report, I can fix the same issue with
> >> xfs_db and your filesystem.
> >>
> >> If it at all possible, can you xfs_copy the offending 
> filesystem to a
> >> file and compress it and make it available to me to find/fix the
> >> problem.
> > 
> > Hmm, it won't be so easy. Compressed dump of a fielsystem 
> before repair 
> > (I had to use dd, because xfsdump refused to cooperate) has 2,5GB.
> > Damaged files were (probably) only in one directory 
> /usr/bin. Maybe I 
> > could reduce size of the image excluding few other directories (in 
> > xfsdump)?
> > Do you think that error would still occur?
> 
> What do you think about that?

xfs_dump won't recreate the filesystem that causes xfs_db to gobble up
memory unfortunately, xfs_copy copies the filesystem as it is, block for
block.

> Btw, is it possible to mount XFS filesystem from the file created by 
> xfs_copy?
> If not, is it possible to restore file system "backuped" to file (by 
> xfs_copy)? I read in the manual that the first parameter 
> xfs_copy has to 
> be device (not file). xfs_restore will work with that "dump"?
 
Yes, you can mount an XFS filesystem file using the "-o loop" mount
option and specifying the file for the device.

Yes, you can xfs_copy from a file back to a device. From the man page:
"The first (source) argument must be the pathname of the device or file
containing the XFS filesystem.". 

xfs_dump/xfs_restore is more like tar copying all metadata, but not disk
layout.
 
> >>> Am I doing something wrong with xfs_db?
> >>> Is there any easier way to restore my files?
> >>
> >> Your files have been restored as much as possible. You'll 
> have to work
> >> out what is in lost+found and move them back to their appropriate
> >> locations.
> > 
> > With files with "normal" names there is no problem. There 
> are all from 
> > one directory (/usr/bin), but I'm unable (without 
> xfs_ncheck) to map 
> > files with inode-like names with their normal names (150+ files). I 
> > tried with xfs_db and the way described in your FAQ, but I had some 
> > problems too.
> 
> Currently I have to use LiveCD (/usr/bin is a quite important 
> directory 
> ;) ). Do you suggest to try to repair it manually (copy files with 
> names, try to boot and try to use RPM to repair broken packages 
> (restore missing files) or there could be an easiest way (at the xfs 
> layer to match numbers with proper names)?

If the /usr/bin directory was trashed, I think you can only restore from
the original packages, I don't think you'll have much luck doing it
manually. (xfs_repair 2.8.10 onwards will restore the same files that
the manual approach can retrieve.)
