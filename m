Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB9237FF1
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 02:46:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2C3A304039
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 00:46:51 -0700 (PDT)
Received: from mail01.lsn.net (mail01.lsn.net [66.90.130.120]) by cuda.sgi.com
	with ESMTP id 7IbkHnlUThaEF9qo for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 00:46:49 -0700 (PDT)
Message-ID: <55B73365.1050908@mygrande.net>
Date: Tue, 28 Jul 2015 02:46:45 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
In-Reply-To: <20150720111747.GA53450@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Kris Rusocki <kszysiu@braxis.org>, "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/20/2015 6:17 AM, Brian Foster wrote:
> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>
>> 	I found the problem with md5sum (and probably nfs, as well).  One of the
>> memory modules in the server was bad.  The problem with XFS persists.  Every
>> time tar tried to create the directory:
>>
>> /RAID/Server-Main/Equipment/Drive Controllers/HighPoint Adapters/Rocket 2722/Driver/RR276x/Driver/Linux/openSUSE/rr276x-suse-11.2-i386/linux/suse/i386-11.1
>>
>> 	It would begin spitting out errors, starting with "Cannot mkdir: Structure
>> needs cleaning".  At that point, XFS had shut down.  I went into
>> /RAID/Server-Main/Equipment/Drive Controllers/HighPoint Adapters/Rocket
>> 2722/Driver/RR276x/Driver/Linux/openSUSE/rr276x-suse-11.2-i386/linux/suse/
>> and created the i386-11.1 directory by hand, and tar no longer starts
>> spitting out errors at that point, but it does start up again at
>> RR2782/Windows/Vista-Win2008-Win7-legacy_single/x64.
>>
>
> So is this untar problem a reliable reproducer? If so, here's what I

	The processes I was running this weekend ran longer than expected, and 
in fact were still running just a couple of hours ago.  I was doing an 
rsync with CRC check from the backup system to the one with the problem. 
  There were a few corrupt files, but not a huge number.  Although 
slower than I hoped, everything was running fine until a short time ago, 
when rsync encountered the very same issue I keep having with tar, which 
is to say it tried to create a directory and the file system crashed 
with precisely the same symptoms as when tar was failing.

> would try to hopefully isolate a filesystem problem from something
> underneath:
>
> xfs_metadump -go /dev/md0 /somewhere/on/rootfs/md0.metadump
> xfs_mdrestore -g /somewhere/on/rootfs/md0.metadump /.../fileonrootfs.img
> mount /.../fileonrootfs.img /mnt/

	I tried to do the xfs_mdrestore to the root file system, but it fails:

RAID-Server:/TEST# xfs_mdrestore -g md0.metadump RAIDfile.img
xfs_mdrestore: cannot set filesystem image size: File too large

	So then I did the same thing to a directory on an nfs mount from 
another machine.  That worked.  I then went to the other machine, 
mounted the image on /media, copied the tarball to the location on the 
mount where the tarball resides on the real array, dn ran the tar job. 
It completed without errors.

	I then created the image on the array where the tasks are failing and 
attempted to mount it to /media on the problematic machine.  That fails 
with:

RAID-Server:/TEST# mount /RAID/TEST/RAIDfile.img /media/
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

	The problem is this (from syslog):
Jul 28 01:53:48 RAID-Server kernel: [431155.847523] loop: module loaded
Jul 28 01:53:48 RAID-Server kernel: [431155.927238] XFS (loop0): 
Filesystem has duplicate UUID 228cfaa7-ae6b-44fc-b703-1c32385231c0 - 
can't mount
Jul 28 01:55:51 RAID-Server kernel: [431278.916490] XFS (loop0): 
Filesystem has duplicate UUID 228cfaa7-ae6b-44fc-b703-1c32385231c0 - 
can't mount

	Presumably it has the same UUID as the RAID array because it is 
expected to do so.  I can't mount it unless I umount the RAID array, but 
if I do that, I can't get to the file to mount the dump image, since it 
is on the array.

	I then copied both the tarball and the image over to the root, and 
while the system would not let me create the image on the root, it did 
let me copy the image to the root.  I then umounted the RAID array, 
mounted the image, and attempted to cd to the original directory in the 
image mount where the tarball was saved.  That failed with an I/O error:

RAID-Server:/# cd "/media/Server-Main/Equipment/Drive 
Controllers/HighPoint Adapters/Rocket 2722/Driver/"
bash: cd: /media/Server-Main/Equipment/Drive Controllers/HighPoint 
Adapters/Rocket 2722/Driver/: Input/output error

	I changed directories to a point two directories above the previous 
attempt and did a long listing:

RAID-Server:/# cd "/media/Server-Main/Equipment/Drive 
Controllers/HighPoint Adapters"
RAID-Server:/media/Server-Main/Equipment/Drive Controllers/HighPoint 
Adapters# ll
ls: cannot access RocketRAID 2722: Input/output error
total 4
drwxr-xr-x 6 root lrhorer 4096 Jul 18 19:26 Rocket 2722
?????????? ? ?    ?          ?            ? RocketRAID 2722

	As you can see, Rocket 2722 is still there, but RocketRAID 2722 is very 
sick.  Rocket 2722 is the parent of where the tarbal was, however, so I 
did a cd and an ll again:

RAID-Server:/media/Server-Main/Equipment/Drive Controllers/HighPoint 
Adapters# cd "Rocket 2722"/
RAID-Server:/media/Server-Main/Equipment/Drive Controllers/HighPoint 
Adapters/Rocket 2722# ll
ls: cannot access BIOS: Input/output error
ls: cannot access Driver: Input/output error
ls: cannot access HighPoint RAID Management Software: Input/output error
ls: cannot access Manual: Input/output error
total 248
-rwxr--r-- 1 root lrhorer 245760 Nov 20  2008 autorun.exe
-rwxr--r-- 1 root lrhorer     51 Mar 21  2001 autorun.inf
?????????? ? ?    ?            ?            ? BIOS
?????????? ? ?    ?            ?            ? Driver
?????????? ? ?    ?            ?            ? HighPoint RAID Management 
Software
?????????? ? ?    ?            ?            ? Manual
-rwxr--r-- 1 root lrhorer   1134 Feb  5  2012 readme.txt

	So now, what?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
