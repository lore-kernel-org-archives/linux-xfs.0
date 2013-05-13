Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 114E17CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 11:59:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94D9AAC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 09:59:00 -0700 (PDT)
Received: from mail-oa0-f44.google.com (mail-oa0-f44.google.com
	[209.85.219.44]) by cuda.sgi.com with ESMTP id QEvrodGmcfD4x4tj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 May 2013 09:58:59 -0700 (PDT)
Received: by mail-oa0-f44.google.com with SMTP id n12so7907303oag.31
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 09:58:59 -0700 (PDT)
Message-ID: <51911BBC.9080208@gmail.com>
Date: Mon, 13 May 2013 12:58:36 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de>
In-Reply-To: <5190DB7F.2050505@tum.de>
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
To: benediktibk@aon.at
Cc: Benedikt Schmidt <benedikt.schmidt@tum.de>, xfs@oss.sgi.com

Ordinary user comments follow...

On 05/13/2013 08:24 AM, Benedikt Schmidt wrote:
> Hi,
> currently I'm looking for the correct usage of the force_geometry option
> of xfs_repair. I wasn't able to find more documentation on this option
> beside that it exists. Could please somebody explain it to me?

According to the xfs_repair man page, it just means to skip the geometry 
test.  In other words, it's not a place to place CHS values or specify 
that your new drive has 4k sectors.  Usage is '-o force_geometry'.

> For a more detailed description of my problem: I've got here a hard disk
> which is dying at the moment, so I copied all the content with dd_rescue
> to a new and bigger one. To use xfs_copy wasn't possible as the
> filesystem was already corrupted. So now I've got nearly everything on
> the second hard disk (dd_rescue could'nt copy something around 6 or 7
> MB), but I can not mount the filesystem or even run xfs_repair on it, as
> it fails to find a superblock. I think the problem lies in the fact that
> the new disk has a different geometry than the previous one.
>
> Kind regards,
> Benedikt Schmidt

Did you ddrescue to a regular file or to a new partition?  In my case, 
ddrescue didn't let me do a simple `ddrescue /dev/sda8 /dev/sdb6`, so I 
passed on using ddrescue's suggested '--force' flag and instead did 
something like this:

root@plbearer:~# ddrescue /dev/sda8 /mnt/xfstests-test/fs_as_file

GNU ddrescue 1.16
Press Ctrl-C to interrupt
rescued:   671088 kB,  errsize:       0 B,  current rate:    9043 kB/s
    ipos:   671023 kB,   errors:       0,    average rate:   31956 kB/s
    opos:   671023 kB,     time since last successful read:       0 s
Finished

# -f means "check a regular file"
# -n means "do not modify filesystem"
root@plbearer:~# xfs_repair -f -n -o force_geometry 
/mnt/xfstests-test/fs_as_file
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

root@plbearer:~# mount -t xfs -o loop /mnt/xfstests-test/fs_as_file 
/mnt/loopback/

With the regular file mounted loopback, this is the part where I would 
somehow get the data to a freshly-made XFS filesystem somewhere else, 
then verify that the data that I need is indeed still intact and valid. 
  There are lots of tools to do such operations.  I lean on 
xfsdump/xfsrestore because I have longstanding good experience with the 
programs and see such situations as a really bad time to learn new tools.

If this is your last copy of important data, you should a) use the '-n' 
flag of xfs_repair before deciding to modify the ddrescued filesystem, 
and/or b) duplicate your recovered filesystem to another place so you 
have at least one good emergency backup.

Good luck, and be careful!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
