Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00BDD7F3F
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 00:00:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE5B48F8050
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 22:00:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fW4WYfrATHq3MOMG for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 22:00:35 -0700 (PDT)
Message-ID: <55C43B70.4050300@sandeen.net>
Date: Thu, 06 Aug 2015 22:00:32 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org>
In-Reply-To: <55C41D75.4040504@tlinx.org>
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
To: "L.A. Walsh" <xfs@tlinx.org>, xfs-oss <xfs@oss.sgi.com>

On 8/6/15 7:52 PM, L.A. Walsh wrote:
> 
> Could anyone point me at the discussion or literature as to why
> a free-inodeB-Tree and inline-types, should *REQUIRE* a -crc=1 option?

In part, to limit the test matrix to something the small handful of
developers can fully support you on.

> Ultimately isn't it about the users/customers and what they will want?

Well, no, not necessarily.  Users want a lot of things.  It's as much about
what is possible, as it is about what is wished for.

> I not saying to not make it a default -- but to require it to try
> the other features?
> Main reason I asked, is I have had disks get partly corrupted meta data
> before, and it looks like the crc information just says "this disk
> has errors, so assume ALL is LOST!  Seems like one bit flip out of
> a 32+Tb(4TB) are not great odds.

I don't follow ... one bit flip on a filesystem will not cause the
filesystem to be lost.

> Example:
> sudo mkfs-xfs-raid SCR /dev/mapper/Data-Home2
> mkfs.xfs -mcrc=1,finobt=1 -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/mapper/Data-Home2
> meta-data=/dev/mapper/Data-Home2 isize=512    agcount=32, agsize=12582896 blks
>        =                       sectsz=4096  attr=2, projid32bit=1
>        =                       crc=1        finobt=1
> data     =                       bsize=4096   blocks=402652672, imaxpct=5
>        =                       sunit=16     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=32752, version=2
>        =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

ok...

> xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.

Um, what?  What xfs_admin command generated this?  With what xfsprogs version?

> cache_node_purge: refcount was 1, not zero (node=0x891ea0)
> xfs_admin: cannot read root inode (117)
> cache_node_purge: refcount was 1, not zero (node=0x894410)
> xfs_admin: cannot read realtime bitmap inode (117)
> xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.
> Clearing log and setting UUID
> writing all SBs
> bad sb version # 0xbda5 in AG 0
> failed to set UUID in AG 0
> new UUID = 55c29a43-19b6-ba02-2015-08051620352b
> 26.34sec 0.11usr 14.97sys (57.28% cpu)

Something has gone wrong here, but you have not provided enough info for
us to know what it is.  Full sequence of commands, please, and xfsprogs
version number.  Is it just a bug?

> Ishtar:law/bin> time sudo mkfs-xfs-raid SCR /dev/mapper/Data-Home2
> mkfs.xfs  -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/mapper/Data-Home2
> meta-data=/dev/mapper/Data-Home2 isize=512    agcount=32, agsize=12582896 blks
>        =                       sectsz=4096  attr=2, projid32bit=1
>        =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=402652672, imaxpct=5
>        =                       sunit=16     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal log           bsize=4096   blocks=32752, version=2
>        =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Clearing log and setting UUID
> writing all SBs55
> new UUID = 55c29acd-2ce9-d15a-2015-08051622534b
> In case you were curious why  ^^date^^:time^^^?? gives me an idea of
> how long a disk  (or partition) has been in service....

not following.

> I don't see any benefit in something that fails the disk that quickly.

I'm sorry, I'm still not following.  What's failing here?

> While I've heard a patch for the GUID is in the input stream -- that's
> one thing.  If I go in and a bit-error has reduced my disk to v1-dirs
> as a side effect, it sounds like the potential for damage is far greater
> than with that option turned on.  Sure it may make you **aware** of a
> potential problem more quickly (or a new SW error), but I didn't see
> how it helped repair the disk when it was at fault.

Well ... *was* your disk at fault?  I can't tell how you arrived at the
scenario above.

but you're right, CRCs are more about early error detection than
enhanced error recovery.

> Also, is it my imagination or is mkfs.xfs taking longer, occasionally
> alot longer -- on the order of >60 seconds  at long end vs ~30 at
> lower endd.  It sorta felt like a drop cache was being done before
> the real long one but the memusage didn't change. at
> least part of the time.

I've not experienced that...

> Has anyone done any benchmarks both
> ways on meta-data intensive workloads (I guess lots of mkdirs,
> touch, rm, adding large ACL's) ...?

Both which ways?  With and without CRCs?  Yes, Dave did a lot of that
during development, IIRC.

-Eric

> 
> Thanks much!
> L. Walsh
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
