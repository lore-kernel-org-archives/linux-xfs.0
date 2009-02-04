Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n141kwGW108407 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 19:46:59 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 762F4E3480
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 17:46:19 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id A0bF6Y7kCcS6sAzw for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2009 17:46:19 -0800 (PST)
Message-ID: <4988F363.1070708@sandeen.net>
Date: Tue, 03 Feb 2009 19:46:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS corruption on ubuntu 2.6.27-9-server
References: <2653B83E-85DA-4949-BCED-AF2BA3D324E1@alink.co.za>	<4988EF37.7020306@sandeen.net>
	<5CCF20F5-33D5-409E-BB27-5E1C5CB4D9E5@alink.co.za>
In-Reply-To: <5CCF20F5-33D5-409E-BB27-5E1C5CB4D9E5@alink.co.za>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: George Barnett <george@alink.co.za>
Cc: xfs@oss.sgi.com

George Barnett wrote:
> On 04/02/2009, at 12:28 PM, Eric Sandeen wrote:
> 
>> George Barnett wrote:
>>> Hi,
>>>
>>> I'm seeing the following errors:
>>>
>>> [822153.422851] Filesystem "md2": XFS internal error xfs_da_do_buf(2)
>>> at line 2107 of file /build/buildd/linux-2.6.27/fs/xfs/
>> we really should make that more informative.
>>
>> What it means is that you read a piece of metadata that did not match
>> any of the metadata magic numbers.
>>
>> hard to say whether it might be an xfs bug I think; this does come up
>> occasionally though and it'd at least be nice to print more details on
>> the error (what the magic *was*, what block, etc)
>>
>> Do you happen to have the repair output?
>>
>> Did your md raid lose power w/ write cache enabled?
> 
> Hi Eric,
> 
> Thanks for your response.  The system did not lose power.  This  
> failure just "happens".  I have a cronjob which rsync's /data to a  
> spare drive that's not on raid.  It seems that is enough to cause this  
> failure.
> 
> Fortunately, I still have the xfs_repair output in my term buffer:
> 
> root@slut:/# xfs_repair /dev/md2
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>          - zero log...
>          - scan filesystem freespace and inode maps...
>          - found root inode chunk
> Phase 3 - for each AG...
>          - scan and clear agi unlinked lists...
>          - process known inodes and perform inode discovery...
>          - agno = 0
> bad magic number 0x0 on inode 18042
> bad version number 0x0 on inode 18042
> bad magic number 0x0 on inode 18043
> bad version number 0x0 on inode 18043
> bad magic number 0x0 on inode 18044
> bad version number 0x0 on inode 18044
> bad magic number 0x0 on inode 18045
> bad version number 0x0 on inode 18045
> bad magic number 0x0 on inode 18046
> bad version number 0x0 on inode 18046
> bad magic number 0x0 on inode 18047
> bad version number 0x0 on inode 18047
> bad directory block magic # 0 in block 0 for directory inode 18000

Interesting that all the bad magic numbers were 0... not sure what to
make of that, offhand, I'm afraid...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
