Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A38BA7F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 12:02:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67E0D304059
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 10:02:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sAUePHaXEsVpjwoy for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 10:01:58 -0700 (PDT)
Message-ID: <55C4E483.2060801@sandeen.net>
Date: Fri, 07 Aug 2015 10:01:55 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org>
In-Reply-To: <55C468F0.2040707@tlinx.org>
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
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/7/15 1:14 AM, L.A. Walsh wrote:
> 
> 
> Eric Sandeen wrote:
>> On 8/6/15 7:52 PM, L.A. Walsh wrote:
>>> Could anyone point me at the discussion or literature as to why
>>> a free-inodeB-Tree and inline-types, should *REQUIRE* a -crc=1 option?
>>
>> In part, to limit the test matrix to something the small handful of
>> developers can fully support you on.
> ---
>     That's actually a good reason to make disabling it an option.

Not from a test matrix POV.  If V5 superblocks have features A, B, and C,
that's one thing to test.   If you allow all 3 to be independent, now you
have 8 scenarios to test.  Well - more like *we* have 8 scenarios to test.

...

>>
>> I don't follow ... one bit flip on a filesystem will not cause the
>> filesystem to be lost. 
> ----
> Just twitching 1 bit in the guid would cause it to not compare and give messages like
> the below.

Ok, but the filesystem is not "lost."  It just needs to be repaired after
corruption.
 
> 
>>
>>> Example:
>>> sudo mkfs-xfs-raid SCR /dev/mapper/Data-Home2
>>> mkfs.xfs -mcrc=1,finobt=1 -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/mapper/Data-Home2
>>> meta-data=/dev/mapper/Data-Home2 isize=512    agcount=32, agsize=12582896 blks
>>>        =                       sectsz=4096  attr=2, projid32bit=1
>>>        =                       crc=1        finobt=1
>>> data     =                       bsize=4096   blocks=402652672, imaxpct=5
>>>        =                       sunit=16     swidth=64 blks
>>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>>> log      =internal log           bsize=4096   blocks=32752, version=2
>>>        =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> ok...
>>
>>> xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.
>>
>> Um, what?  What xfs_admin command generated this?  With what xfsprogs version?
>> /usr/sbin/xfs_admin -V
> xfs_admin version 3.1.11

Over 2 years old, from May 2013... :(

You've hit an old bug, not a design feature; it was patched up with:

609f6bb xfs_db: disallow sb UUID write on v5 filesystems

and changing the UUID has only recently become possible, and will be available
in the next release.

So, yes, that xfs_db bug let you create a mismatch which shouldn't have been allowed,
and caused corruption.  But the more relevant question is, could xfs_repair fix it?

You're right, this "one bit flip" caused it to be unmountable.  But all XFS knows
is that the superblock has been corrupted, and the CRC is now wrong, so it stops and
lets you take a look, and fix things as appropriate.

> ---
> after the  mkfs.xfs:
> cmd="mkfs.xfs $iops $lops $dops ${sector_size:+-s size=$sector_size} -L $lab -f $dev"
> printf -- "%s\n" "$cmd"
> $cmd &&  xfs_admin -U $(/root/bin/gen-dateguid) $dev
> 
> the gen-dateguid -- just generates the guid.
> 
>>
>> Something has gone wrong here, but you have not provided enough info for
>> us to know what it is.  Full sequence of commands, please, and xfsprogs
>> version number.  Is it just a bug?
> 
> 
> Full sequence = what you ...oops... the ops aren't expanded ... minor scripting dysfunction....hold on...
> 
> This is the working case:
> time sudo  ./mkfs-xfs-raid SCR /dev/Data/Home2
> mkfs.xfs  -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/Data/Home2

(right, non-crc filesystems can always handle UUID changes)

> ---non working:
> time sudo finobt=1 crc=1 ./mkfs-xfs-raid SCR /dev/Data/Home2    mkfs.xfs -m crc=1,finobt=1 -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/Data/Home2

(right, until very recently, crc filesystems could not change UUIDs,
but a bug allowed xfs_db to do it anyway, and corrupt the CRC)

>>> I don't see any benefit in something that fails the disk that quickly.
>>
>> I'm sorry, I'm still not following.  What's failing here?
> ----
> The disk doesn't get made -- it is corrupted:
>> sudo mount /home2
> mount: mount /dev/mapper/Data-Home2 on /home2 failed: Structure needs cleaning

dmesg should tell you in detail what's wrong.
and xfs_repair should be able to fix it.

But yes, this is a bug (fixed last April) that incorrectly allowed xfs_admin/xfs_db
to modify the UUID on a CRC filesystem, causing corruption.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
