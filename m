Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 450F17F58
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 22:21:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E4418F8037
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 20:21:09 -0700 (PDT)
Received: from mail-yk0-f177.google.com (mail-yk0-f177.google.com
	[209.85.160.177]) by cuda.sgi.com with ESMTP id
	ycmEmLVAGeAmWDbG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 20:21:04 -0700 (PDT)
Received: by mail-yk0-f177.google.com with SMTP id 10so2590030ykt.8
	for <xfs@oss.sgi.com>; Mon, 09 Jun 2014 20:21:04 -0700 (PDT)
Received: from [192.168.0.129] (rrcs-97-79-21-178.se.biz.rr.com.
	[97.79.21.178])
	by mx.google.com with ESMTPSA id w36sm15127696yhn.4.2014.06.09.20.21.03
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Mon, 09 Jun 2014 20:21:03 -0700 (PDT)
Message-ID: <5396799F.3050801@gmail.com>
Date: Mon, 09 Jun 2014 23:21:03 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: xfs_repair issue with ACLs on v5 XFS when beyond v4 limits
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hi!  I've been running around in circles trying to work with too many 
ACLs, even losing my ability to count for a while.  Along the way, 
xfs_repair from git xfsprogs (last commit around May 27) is showing 
the following symptoms:

On v5-superblock XFS...

1) When the ACL count is just above the limit from v4-superblock XFS--
96 is a good test figure--`xfs_repair -n` and `xfs_repair` will both 
end in a segmentation fault.

2) When the ACL count is in a higher range--as low as 250, IIRC--
xfs_repair will complain about "Too many ACL entries" and proceed to 
remove them.  Below is a full session:

root@oldsvrhw:~# mkfs.xfs -f -m crc=1 $SCRATCH_DEV
meta-data=/dev/sdb5              isize=512    agcount=4, agsize=786432 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0
data     =                       bsize=4096   blocks=3145728, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@oldsvrhw:~# mount $SCRATCH_DEV $SCRATCH_MNT

root@oldsvrhw:~# mkdir $SCRATCH_MNT/acl-dir

root@oldsvrhw:~# for a in `seq 1000 1325`; do setfacl -d -m u:$a:r-- $SCRATCH_MNT/acl-dir; done

root@oldsvrhw:~# sync

root@oldsvrhw:~# umount $SCRATCH_MNT

root@oldsvrhw:~# xfs_repair -n $SCRATCH_DEV
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
Too many ACL entries, count 330
entry contains illegal value in attribute named SGI_ACL_FILE or SGI_ACL_DEFAULT
remote attribute value check failed for entry 0, inode 67
problem with attribute contents in inode 67
would clear attr fork
bad nblocks 2 for inode 67, would reset to 0
bad anextents 1 for inode 67, would reset to 0
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

root@oldsvrhw:~# xfs_repair $SCRATCH_DEV
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
Too many ACL entries, count 330
entry contains illegal value in attribute named SGI_ACL_FILE or SGI_ACL_DEFAULT
remote attribute value check failed for entry 0, inode 67
problem with attribute contents in inode 67
clearing inode 67 attributes
correcting nblocks for inode 67, was 2 - counted 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
bad attribute format 1 in inode 67, resetting value
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

root@oldsvrhw:~# mount $SCRATCH_DEV $SCRATCH_MNT

root@oldsvrhw:~# getfacl $SCRATCH_MNT/acl-dir
getfacl: Removing leading '/' from absolute path names
# file: mnt/xfstests-scratch/acl-dir
# owner: root
# group: root
user::rwx
group::r-x
other::r-x

3) When the ACL count is at the max for v5-superblock XFS--at least 
with both regular and default ACL slots filled--xfs_repair will 
complain of corrupt remote attributes.  AFAIK, xfs_repair doesn't 
bother with the "Too many ACL entries" line.  Those ACLs will be 
cleansed, too.

I can't tell if this is due to one missed check or three different 
tiny issues.

ACLs seem to be OK when doing normal filesystem operations and using 
setfacl and getfacl.  No kernel stack traces have been seen on this 
path of testing.

Sorry I missed this one in all of my limits testing.  This was 
discovered when I saw a bug in my ACL population script and hit 
Ctrl-c so I could stop and edit the script.  Donations of brown paper 
bags are welcome...the plastic bags I'm using make it hard to breathe 
and don't hide my face very well...

Test PC was a Pentium III, 733 MHz, 512 MB of RAM, running kernel 
3.15.0-rc8 + xfs-oss/for-next, on Slackware 14.1.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
