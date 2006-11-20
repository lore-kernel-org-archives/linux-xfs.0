Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 19:51:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAK3pjaG002431
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 19:51:46 -0800
Message-ID: <45612621.5010404@sandeen.net>
Date: Sun, 19 Nov 2006 21:50:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>
In-Reply-To: <455CE1E3.7020703@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201
>>
>> Bugzilla Bug 212201: Cannot build sysem with XFS file system.
>>
>> I turned on attr2 in FC6 at nathan's suggestion, for selinux goodness 
>> with more efficient xattr space usage.
>>
>> But, many reports that this was totally broken in fc6, on x86_64.
> 
> ugh.  it's broken on x86 too, so it's not just the alignment/padding,
> although that should be fixed for cross-arch mounts.
> 
> -Eric
> 
> 
here's a testcase to corrupt it FWIW.

Russell has a slightly different one derived from this.


#!/bin/sh

remount() {
	umount mnt
	xfs_db -r fsfile2 -c "inode 131" -c "p core.forkoff" -c "p u" -c "p a"
	mount -o loop fsfile2 mnt/
}

umount mnt/
rm -f fsfile2
mkfs.xfs -dfile,name=fsfile2,size=100m -iattr=2
mount -o loop fsfile2 mnt/
mkdir mnt/dir
setfattr -n user.rity.selinux -v user_foo:blah_foo:mnt_what:0 mnt/dir/
for I in `seq 10 20`; do touch mnt/file$I; done
for I in `seq 100 700`; do touch mnt/dir/file$I; done
remount
for I in `seq 1000 1400`; do touch mnt/dir/file$I; done
#remount # works if we do remount here
setfattr -n user.rity.selinux -v user_foo:blah_foo:mnt_what:0 mnt/dir/
echo "unmounting"
umount mnt/
xfs_db -r fsfile2 -c "inode 131" -c "p core.forkoff" -c "p u" -c "p a" 
-c "type text"  -c "p"


Run it and you'll get the bmap root block from the wrong offset; it'll 
be "0"

-Eric
