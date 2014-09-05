Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EA827F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 07:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED874AC001
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 05:40:35 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id 2YhsP0qR1jKU4a6O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Sep 2014 05:40:33 -0700 (PDT)
Message-ID: <5409AF40.10801@profihost.ag>
Date: Fri, 05 Sep 2014 14:40:32 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
In-Reply-To: <20140905123058.GA29710@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Am 05.09.2014 um 14:30 schrieb Brian Foster:
> On Fri, Sep 05, 2014 at 11:47:29AM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> i have a backup system running 20TB of storage having 350 million files.
>> This was working fine for month.
>>
>> But now the free space is so heavily fragmented that i only see the
>> kworker with 4x 100% CPU and write speed beeing very slow. 15TB of the
>> 20TB are in use.
>>
>> Overall files are 350 Million - all in different directories. Max 5000
>> per dir.
>>
>> Kernel is 3.10.53 and mount options are:
>> noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota
>>
>> # xfs_db -r -c freesp /dev/sda1
>>    from      to extents  blocks    pct
>>       1       1 29484138 29484138   2,16
>>       2       3 16930134 39834672   2,92
>>       4       7 16169985 87877159   6,45
>>       8      15 78202543 999838327  73,41
>>      16      31 3562456 83746085   6,15
>>      32      63 2370812 102124143   7,50
>>      64     127  280885 18929867   1,39
>>     256     511       2     827   0,00
>>     512    1023      65   35092   0,00
>>    2048    4095       2    6561   0,00
>>   16384   32767       1   23951   0,00
>>
>> Is there anything i can optimize? Or is it just a bad idea to do this
>> with XFS? Any other options? Maybe rsync options like --inplace /
>> --no-whole-file?
>>
> 
> It's probably a good idea to include more information about your fs:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Generally sure but the problem itself is clear. If you look at the free
space allocation you see that free space is heavily fragmented.

But here you go:
- 3.10.53 vanilla
- xfs_repair version 3.1.11
- 16 cores
- /dev/sda1 /backup xfs
rw,noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0
- Raid 10 with 1GB controller cache running in write back mode using 24
spinners
- no lvm
- no io waits
- xfs_info /serverbackup/
meta-data=/dev/sda1              isize=256    agcount=21,
agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5369232896, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

anything missing?

> ... as well as what your typical workflow/dataset is for this fs. It
> seems like you have relatively small files (15TB used across 350m files
> is around 46k per file), yes?

Yes - most fo them are even smaller. And some files are > 5GB.

> If so, I wonder if something like the
> following commit introduced in 3.12 would help:
> 
> 133eeb17 xfs: don't use speculative prealloc for small files

Looks interesting.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
