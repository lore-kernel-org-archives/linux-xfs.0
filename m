Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 166947F67
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 08:24:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 057C7304051
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 06:24:26 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id C2PZ5PhbIY23LLlA for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 06:24:25 -0800 (PST)
Message-ID: <5277AE19.0@sandeen.net>
Date: Mon, 04 Nov 2013 08:24:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to use increased number of ACL entries?
References: <20131103081704.GE9974@fit.vutbr.cz>	<20131104003915.GN6188@dastard>	<5277086E.6030905@sandeen.net>
	<52771FFE.8030009@gmail.com>
In-Reply-To: <52771FFE.8030009@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>, Dave Chinner <david@fromorbit.com>, Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: xfs@oss.sgi.com

On 11/3/13, 10:18 PM, Michael L. Semon wrote:
> On 11/03/2013 09:37 PM, Eric Sandeen wrote:
>> On 11/3/13, 6:39 PM, Dave Chinner wrote:
>>> On Sun, Nov 03, 2013 at 09:17:04AM +0100, Kasparek Tomas wrote:
>>>> Hello,
>>>>
>>>> I'm trying to get more then 25 ACLs entries to work according to
>>>> http://oss.sgi.com/pipermail/xfs/2013-May/026544.html . I'm running 3.10.x
>>>> kernel which seems to contain these changes. I understand, that this is
>>>> on-disk format change, so I expect to need new xfsprogs too. I tried the
>>>> version from CentOS 6.4 (3.1.1) and one from git repo (
>>>> git://oss.sgi.com/xfs/cmds/xfsprogs), but still it fails to create more then
>>>> 25 ACL entries (21 user defined). Is there something I'm still missing?
>>>
>>> You haven't told mkfs to change the on disk format to enable more
>>> than 25 ACLs. Only the version from git will do it, and your CentOS
>>> kernel will not support it.
>>
>> but the 3.10.x kernel you're running will IIRC; use "-m crc=1" on the mkfs.xfs
>> commandline from a git mkfs.xfs.
>>
>> -Eric
>>  
>>> Cheers,
>>>
>>> Dave.
> 
> Y'know, Eric, your best suggestions are always made when I'm working on a 
> non-test PC that I don't really want to touch ;-)  But anyway, (i686 Pentium 
> 4, kernel 3.10.17)...
> 
> git xfsprogs will make the filesystem in question:
> 
> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs /dev/sdb3
> mkfs.xfs: /dev/sdb3 appears to contain an existing filesystem (swap).
> mkfs.xfs: Use the -f option to force overwrite.
> root@bpserver:/storage/devel/git-xfsprogs# mkfs/mkfs.xfs -f -m crc=1 /dev/sdb3
> meta-data=/dev/sdb3              isize=512    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> However, it should be dirent (ftype=1 in the above output) that keeps a 
> vanilla 3.10.17 kernel from mounting the resulting filesystem:

I'm sorry, you are right - it hit kernel v3.11:

5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57 xfs: increase number of ACL entries for V5 superblocks

$ git describe --contains 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57
v3.11-rc1~18^2~41

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
