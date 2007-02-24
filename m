Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 Feb 2007 07:04:58 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1OF4km7020155
	for <xfs@oss.sgi.com>; Sat, 24 Feb 2007 07:04:48 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: xfsdump/xfsrestore question
Date: Sat, 24 Feb 2007 17:04:33 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1172148497.4634.36.camel@venus.local.navi.pl>
Message-Id: <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>, 'Timothy Shimmin' <tes@sgi.com>
Cc: xfs@oss.sgi.com

> (...)
> > Yes it is meant to handle a changing filesystem - you do see warning
> msgs sometimes because
> > it can't see a particular inode anymore, which can happen as we do
> multiple
> > scans of the inodes and if they get deleted then it obviously can't do
> anything
> > with it anymore or if the inode is reused as a dir instead of a reg-file
> etc...
> Hmm,
> I suppose he asked about something else:
> Unless you use lvm snapshots (or something alike) you may get incorrect
> files that are in use. Consider having 20GB file:
> 1. Dump starts reading the file
> 2. Dump is at 18th GB
> 3. You change the data in 1-5 GB region.
> 4. You have inconsistent data.
> 
> So after dump you get consistent filesystem but not necessairly
> consistent data.
> 

Yep, consistent FS is what I care about in the case of disaster.

Now, when I've tried to make non-interactive xfsdump I'vo got > prompt with
no action, like this
# xfsdump -f /data/backup2.file -L 'session1' -M 'media1" /
>
#

So, I've got to Ctrl+C the process.

Questions:
1) What could be the syntax problem in the above command?
2) Any examples for incremental xfsdump (non-interactive, i.e. run from
cronjob) would be very welcome (and also comments about xfsrestore from
these backups).

On the other hand, interactive xfsdump went fine:

# xfsdump -f /data/sysbackup.file /
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 2.2.42 (dump format 3.0) - Running single-threaded

 ============================= dump label dialog
==============================

please enter label for this dump session (timeout in 300 sec)
 -> label1
session label entered: "label1"

 --------------------------------- end dialog
---------------------------------

xfsdump: level 0 dump of vod:/
xfsdump: dump date: Fri Feb 23 16:38:05 2007
xfsdump: session id: 53a70b7b-5114-41ae-9a82-6b2f3d0e394c
xfsdump: session label: "label1"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 2053243392 bytes
xfsdump: /var/lib/xfsdump/inventory created

 ============================= media label dialog
=============================

please enter label for media in drive 0 (timeout in 300 sec)
 -> media1
media label entered: "media1"

 --------------------------------- end dialog
---------------------------------

xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: ending media file
xfsdump: media file size 1503663968 bytes
xfsdump: dump size (non-dir files) : 1425357712 bytes
xfsdump: dump complete: 577 seconds elapsed
xfsdump: Dump Status: SUCCESS
vod / # ls -lh /data
total 1.5G
-rw-r--r-- 1 root root 1.5G Feb 23 16:47 sysbackup.file
#
#



> Regards,
> 
> Olaf
> 
> --
> Olaf Fr?czyk <olaf@cbk.poznan.pl>

Best Regards,
Leon
