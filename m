Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1C047CBE
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 13:48:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4ABD5AC060
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 11:48:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7Ft1Y2AjxgG5iRf1 for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2015 11:48:49 -0700 (PDT)
Message-ID: <55CF8972.8020306@sandeen.net>
Date: Sat, 15 Aug 2015 13:48:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <20150720111747.GA53450@bfoster.bfoster>	<55B73365.1050908@mygrande.net>	<20150728123307.GC38784@bfoster.bfoster>	<55B79BFD.6020509@mygrande.net>	<20150728221150.GA26604@bfoster.bfoster>	<55BE7C75.4060604@mygrande.net>
	<55C06F41.4030502@mygrande.net>	<20150804224240.GU16638@dastard>	<55C8006C.8070807@mygrande.net>
	<55CC375C.10902@mygrande.net>	<20150814012635.GT3902@dastard>
	<55CE75CA.5070506@mygrande.net>
	<74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
In-Reply-To: <74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
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

On 8/15/15 7:28 AM, Roger Willcocks wrote:
> xfs_repair 3.2.1 runs cleanly.
> 
> xfs_repair 3.1.1 complains about a load of stuff, including:

I wouldn't expect v3.1.1 to work at all, because:

# db/xfs_db -V
xfs_db version 4.2.0-rc1
# db/xfs_db /mnt/test2/leslie/md0.img -c version
versionnum [0xbdb4+0x8a] = V4,NLINK,DIRV2,ATTR,ALIGN,DALIGN,LOGV2,EXTFLG,SECTOR,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT

the filesystem has 32-bit project IDs, and:

# git log --oneline | grep -i "projid32bit"
dd536e1 xfsprogs: Note projid32bit default change in mkfs.xfs manpage
22bc10e xfsprogs: projid32bit handling

# git describe --contains 22bc10e
v3.1.4~2

that feature support didn't show up until v3.1.4.  Were you running a stock v3.1.1?

Anyway, in my testing, up to v3.2.0, repair finds a lot of errors (and spends some
time looking for a proper superblock)

v3.2.1 finds no errors.

The errors stopped showing up as of:

commit d085fb486f8b33304f2fdf704411313ffc8bcc0c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jul 8 10:36:39 2014 +1000

    repair: fix quota inode handling in secondary superblocks
    
    Changes to support separate project quota inodes changed the way
    quota inodes got written to the superblock. The current code is
    tailored for the needs to the kernel, where the inodes should only
    be written if certain falgs are set saying a quota type is enabled.
    
    Unfortunately, when recovering a corrupt secondary superblock, we
    need to unconditionally write the quota inode fields after we
    unconditionally zero the quota flags field. The result of this bug
    is that the bad quota inode fields cannot be cleared and hence
    always are reported by bad by repair in subsequent runs.
    
    Fix this by directly clearing the quota inodes in the superblock
    buffers so that we do need to set special flags to get
    xfs_sb_to_disk() to do the right thing as setting flags leave bad
    flag values in the superblock instead of bad inode numbers....
    
    Also, when clearing the inode numbers, write them as NULLFSINO
    rather than 0 as this is what the kernel will write them as if quota
    is turned off.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

I'll have to look into that commit, and the errors found prior.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
