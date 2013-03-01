Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 777F77FF0
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 16:32:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D25C304032
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 14:32:20 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SnX2fgD2BF87i9os for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 14:32:20 -0800 (PST)
Message-ID: <51312C73.5060203@sandeen.net>
Date: Fri, 01 Mar 2013 16:32:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<5131283F.8030704@sandeen.net> <20130301223116.GE23616@dastard>
In-Reply-To: <20130301223116.GE23616@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Ole Tange <tange@binf.ku.dk>

On 3/1/13 4:31 PM, Dave Chinner wrote:
> On Fri, Mar 01, 2013 at 04:14:23PM -0600, Eric Sandeen wrote:
>> On 2/28/13 9:22 AM, Ole Tange wrote:
>>> I forced a RAID online. I have done that before and xfs_repair
>>> normally removes the last hour of data or so, but saves everything
>>> else.
>>>
>>> Today that did not work:
>>>
>>> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
>>> Phase 1 - find and verify superblock...
>>> Phase 2 - using internal log
>>>         - scan filesystem freespace and inode maps...
>>> flfirst 232 in agf 91 too large (max = 128)
>>> Segmentation fault (core dumped)
>>
>> FWIW, the fs in question seems to need a log replay, so 
>> xfs_repair -n would find it in a worse state...
>> I had forgotten that xfs_repair -n won't complain about
>> a dirty log.  Seems like it should.
>>
>> But, the log is corrupt enough that it won't replay:
>>
>> XFS (loop0): Mounting Filesystem
>> XFS (loop0): Starting recovery (logdev: internal)
>> ffff88036e7cd800: 58 41 47 46 00 00 00 01 00 00 00 5b 0f ff ff 00  XAGF.......[....
>                                                      ^^
> It's detecting AGF 91 is corrupt....

Yep and that's what lights up when repair -L runs too.

Ole, you can xfs_mdrestore your metadump image and run test repairs on the result,
if you want a more realistic "dry run" of what repair would do.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
