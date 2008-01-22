Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 14:48:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0MMmCpH011555
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 14:48:16 -0800
Message-ID: <479672B2.9070103@sgi.com>
Date: Wed, 23 Jan 2008 09:48:18 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local> <20080122211311.GA155259@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596F@pvn-3001.purevideo.local>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253596F@pvn-3001.purevideo.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com



Mark Magpayo wrote:
>> -----Original Message-----
>> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
> Of
>> David Chinner
>> Sent: Tuesday, January 22, 2008 1:13 PM
>> To: Mark Magpayo
>> Cc: xfs@oss.sgi.com
>> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
>>
>> On Tue, Jan 22, 2008 at 11:40:52AM -0800, Mark Magpayo wrote:
>>> Any ideas on how long the xfs_repair is supposed to take on 18TB?  I
>>> started it Friday nite, and it's now Tuesday afternoon.  It's stuck
>>> here:
>>>
>>> Phase 5 - rebuild AG headers and trees...
>>>         - reset superblock...
>>> Phase 6 - check inode connectivity...
>>>         - resetting contents of realtime bitmap and summary inodes
>>>         - traversing filesystem ...
>>>
>>> I figure traversing a filesystem of 18TB takes a while, but does 4
> days
>>> sound right?
>> Yes, it can if it's swapping like mad because you don't have enough
>> RAM in the machine. Runtime is also detemrined by how many inodes
> there
>> are in the filesystem - do you know how many there are? Also, more
>> recent xfs_repair versions tend to be faster - what version are you
>> using again?
> 
> Using version 2.9.4.  I may have forgotten to allocate more swap space
> (as was told in the manual given to me by the vendor), so would breaking
> out of the repair and restarting with more swap help out, or am I too
> deep (4 days) into it and should just let it run?

cat /proc/meminfo for this machine and post it here. If it's swapping,
adding more swap wont speed it up. If it runs out of swap the repair
will stop anyway ;-)

Cheers
-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
