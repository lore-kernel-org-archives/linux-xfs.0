Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 444207F55
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 03:14:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FF758F8037
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 01:14:50 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id 4A9znxGC3oDifi0L (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 01:14:45 -0700 (PDT)
Message-ID: <55C468F0.2040707@tlinx.org>
Date: Fri, 07 Aug 2015 01:14:40 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
In-Reply-To: <55C43B70.4050300@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>



Eric Sandeen wrote:
> On 8/6/15 7:52 PM, L.A. Walsh wrote:
>> Could anyone point me at the discussion or literature as to why
>> a free-inodeB-Tree and inline-types, should *REQUIRE* a -crc=1 option?
> 
> In part, to limit the test matrix to something the small handful of
> developers can fully support you on.
---
	That's actually a good reason to make disabling it an option.
If a problem comes up it is one more thing that can be disabled.  _theoretically_,
as I understand it, it _should_ be an option that is *mostly* orthogonal to other
options -- yes, if you try to *enable* it (if dynamic-enabling was even 
available, which it is not AFAIK), on something that wasn't crc'd, it
be expected to give many errors.


> 
>> Ultimately isn't it about the users/customers and what they will want?
----
	Seems like providing an off switch for your M5 unit would be a
reasonable idea if not forward thinking.  Ultimately, I wouldn't mind seeing
it **if**, it could limp along until a xfx_crc_repair could be done on the
device. .. allowing normal function to continue with appropriate warnings
about, shutting down that partition ASAP.  


> 
> Well, no, not necessarily.  Users want a lot of things.  It's as much about
> what is possible, as it is about what is wished for.
> 

> 
> I don't follow ... one bit flip on a filesystem will not cause the
> filesystem to be lost. 
----
Just twitching 1 bit in the guid would cause it to not compare and give messages like
the below.

 
> 
>> Example:
>> sudo mkfs-xfs-raid SCR /dev/mapper/Data-Home2
>> mkfs.xfs -mcrc=1,finobt=1 -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/mapper/Data-Home2
>> meta-data=/dev/mapper/Data-Home2 isize=512    agcount=32, agsize=12582896 blks
>>        =                       sectsz=4096  attr=2, projid32bit=1
>>        =                       crc=1        finobt=1
>> data     =                       bsize=4096   blocks=402652672, imaxpct=5
>>        =                       sunit=16     swidth=64 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> log      =internal log           bsize=4096   blocks=32752, version=2
>>        =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> ok...
> 
>> xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.
> 
> Um, what?  What xfs_admin command generated this?  With what xfsprogs version?
> /usr/sbin/xfs_admin -V
xfs_admin version 3.1.11
---
after the  mkfs.xfs:
cmd="mkfs.xfs $iops $lops $dops ${sector_size:+-s size=$sector_size} -L $lab -f $dev"
printf -- "%s\n" "$cmd"
$cmd && 
  xfs_admin -U $(/root/bin/gen-dateguid) $dev

the gen-dateguid -- just generates the guid.

> 
> Something has gone wrong here, but you have not provided enough info for
> us to know what it is.  Full sequence of commands, please, and xfsprogs
> version number.  Is it just a bug?


Full sequence = what you ...oops... the ops aren't expanded ... minor 
scripting dysfunction....hold on...

This is the working case:
time sudo  ./mkfs-xfs-raid SCR /dev/Data/Home2
mkfs.xfs  -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/Data/Home2
meta-data=/dev/Data/Home2        isize=512    agcount=32, agsize=12582896 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=402652672, imaxpct=5
         =                       sunit=16     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=32752, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Clearing log and setting UUID
writing all SBs
new UUID = 55c466ec-0447-d5f8-2015-080701060407
26.37sec 0.10usr 15.43sys (58.89% cpu)
---non working:
time sudo finobt=1 crc=1 ./mkfs-xfs-raid SCR /dev/Data/Home2    
mkfs.xfs -m crc=1,finobt=1 -i maxpct=5,size=512 -l size=32752b,lazy-count=1 -d su=64k,sw=4  -s size=4096 -L SCR -f /dev/Data/Home2
meta-data=/dev/Data/Home2        isize=512    agcount=32, agsize=12582896 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1
data     =                       bsize=4096   blocks=402652672, imaxpct=5
         =                       sunit=16     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=32752, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.
cache_node_purge: refcount was 1, not zero (node=0x891ea0)
xfs_admin: cannot read root inode (117)
cache_node_purge: refcount was 1, not zero (node=0x894410)
xfs_admin: cannot read realtime bitmap inode (117)
xfs_admin: WARNING - filesystem uses v1 dirs,limited functionality provided.
Clearing log and setting UUID
writing all SBs
bad sb version # 0xbda5 in AG 0
failed to set UUID in AG 0
new UUID = 55c46721-1baa-6de0-2015-08070106572e
31.93sec 0.11usr 15.52sys (48.96% cpu)

> not following.
doesn't matter ... just telling you why I used guid


> 
>> I don't see any benefit in something that fails the disk that quickly.
> 
> I'm sorry, I'm still not following.  What's failing here?
----
The disk doesn't get made -- it is corrupted:
> sudo mount /home2
mount: mount /dev/mapper/Data-Home2 on /home2 failed: Structure needs cleaning

> Well ... *was* your disk at fault?  I can't tell how you arrived at the
> scenario above.
---
Explained any better?  w/crc and finobt, & set guid, I get unusable disk.
w/o those options, it's fine.

BTW -- the CRC's are stronger on 4k-sector disks -- they can recover
from more errors than the 512byte sector disks (or so disk lit says, as
they save enough space in concatenating 8 sectors, that they can use 
stronger ECC to correct more cases.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
