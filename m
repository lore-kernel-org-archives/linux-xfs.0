Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4B1C7F54
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 19:24:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 940C98F8039
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 17:24:14 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id sfuwr20G79hA5gj5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 17:24:12 -0700 (PDT)
Message-ID: <55CBE3A5.1070206@tlinx.org>
Date: Wed, 12 Aug 2015 17:24:05 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org> <20150807225531.GG3902@dastard>
In-Reply-To: <20150807225531.GG3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

(re: timelag: It took me a few revisions to get this out..)

Dave Chinner wrote:
> Can you please ensure that you are running an up-to-date xfsprogs
> and not some mix-and-match of different versions with differing
> feature support capabilities?
----
	Will the latest version allow me to specify 
finobt=1, ftype=1  && projid32bit=0 with crc=1?

	I'm pretty sure I don't have a version of xfs_admin that
disallows setting the GUID in the presence of a mkfs.xfs that does.

	As to how they would get mismatched, I have "/" on a different
partition from "/usr" (among others).  My distro has been moving files
from "/" -> /usr  primarily the  bin & lib dirs.  xfs_admin in their
setup was in /usr/sbin/ before this "move", while mkfs.xfs was in /sbin
(along with xfs_repair and fsck.xfs).  They have been "supporting the 
old paths by moving the binaries under /usr, while putting symlinks
from progs like "/bin/mount" -> "/usr/bin/mount".  On systems like mine,
that would result in system that boots but can't mount any other file
systems.  So wrote script that detected "mount order", and dereferenced
unsafe symlinks that pointed to file systems later in the mount order.

	Since the xfsprogs were split, and I hadn't gotten around to
inspecting date-stamps on binaries (I *did* manage to do version checks
on libraries, as mount's libraries were moved to /usr/lib64 before
mount was -- so the /bin/mount wouldn't load w/o /usr mounted.

	There's also the fact that I've tried to keep the mkfs & xfsrestore 
utils on the rootfs -- since that's allowed me to recover/restore
/usr and /var partitions that have gone belly up, but backups and such
aren't that important to most people, it seems.

	Also, needless to say, suse couldn't move from /usr to "/", because
"/" is now on device /dev/rootfs, so programs and users won't easily know 
when they are running in a "container" or "virtualized" root.  Anyway,
this move has caused a few headaches and not just to me.  


As for the 'crc' option:


	I wouldn't mind having the 'crc option being a default'
just as 'recovery' and 'uuid' are default -- I.e. allow mounting
a crc-fs w/o crc checks -- so a known bad disk can still have data
recovered from it.  It seems the ability to make a file system with
crc=0 while other options (finobt ftype) can be on would be a 
pre-rerequisite for allowing that at *mount* time (in addition to
mkfs time).

I use norecovery, to mount 'temporary'  snapshots as I
know, the logs may be out-of-sync with the contents, but for
my purposes that's never been a problem. 

Since it seems that 'ftype' is headed toward crc-independence, 
and finobt (I think) is hoped to be more efficient for free space
allocation, -- just how much metadata is normally associated with
free space (i.e. normally I think of time/date/access/ext_attrs
as metadata)?

	I keep trying to keep my xfs-repair and restore utils
on my rootfs (whether it has /usr on it or not), since, more than
once I've been able to restore a /usr or /var from the rootfs alone.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
