Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C730E7F3F
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 14:00:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A41B13041B0
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 12:00:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RbvIdEs4IlnAxVz3 for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2015 12:00:33 -0700 (PDT)
Message-ID: <55CF8C4F.1080906@sandeen.net>
Date: Sat, 15 Aug 2015 14:00:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <20150720111747.GA53450@bfoster.bfoster>	<55B73365.1050908@mygrande.net>	<20150728123307.GC38784@bfoster.bfoster>	<55B79BFD.6020509@mygrande.net>	<20150728221150.GA26604@bfoster.bfoster>	<55BE7C75.4060604@mygrande.net>	<55C06F41.4030502@mygrande.net>	<20150804224240.GU16638@dastard>	<55C8006C.8070807@mygrande.net>	<55CC375C.10902@mygrande.net>	<20150814012635.GT3902@dastard>	<55CE75CA.5070506@mygrande.net>	<74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
	<55CF8972.8020306@sandeen.net>
In-Reply-To: <55CF8972.8020306@sandeen.net>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>, Leslie Rhorer <lrhorer@mygrande.net>
Cc: Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 8/15/15 1:48 PM, Eric Sandeen wrote:
> On 8/15/15 7:28 AM, Roger Willcocks wrote:
>> xfs_repair 3.2.1 runs cleanly.
>>
>> xfs_repair 3.1.1 complains about a load of stuff, including:
> 
> I wouldn't expect v3.1.1 to work at all, because:
> 
> # db/xfs_db -V
> xfs_db version 4.2.0-rc1
> # db/xfs_db /mnt/test2/leslie/md0.img -c version
> versionnum [0xbdb4+0x8a] = V4,NLINK,DIRV2,ATTR,ALIGN,DALIGN,LOGV2,EXTFLG,SECTOR,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
> 
> the filesystem has 32-bit project IDs, and:
> 
> # git log --oneline | grep -i "projid32bit"
> dd536e1 xfsprogs: Note projid32bit default change in mkfs.xfs manpage
> 22bc10e xfsprogs: projid32bit handling
> 
> # git describe --contains 22bc10e
> v3.1.4~2
> 
> that feature support didn't show up until v3.1.4.  Were you running a stock v3.1.1?
> 
> Anyway, in my testing, up to v3.2.0, repair finds a lot of errors (and spends some
> time looking for a proper superblock)
> 
> v3.2.1 finds no errors.
> 
> The errors stopped showing up as of:
> 
> commit d085fb486f8b33304f2fdf704411313ffc8bcc0c
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Jul 8 10:36:39 2014 +1000
> 
>     repair: fix quota inode handling in secondary superblocks

I take that back, a bit:  "errors vs. no errors" was for xfs_repair -n.

a "full" repair with v3.1.4 shows only:

# repair/xfs_repair /mnt/test2/leslie/md0.img 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
non-null user quota inode field in superblock 5
reset bad sb for ag 5
non-null user quota inode field in superblock 10
reset bad sb for ag 10
non-null user quota inode field in superblock 18
reset bad sb for ag 18
non-null user quota inode field in superblock 23
reset bad sb for ag 23
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
...
        - agno = 29
bad version number 0x3 on inode 124656869424
bad version number 0x3 on inode 124656869424, resetting version number

latest git does indeed find no errors; I'll re-check with full repairs to see when the detection stopped, and see if it's a false positive or not.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
