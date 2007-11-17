Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Nov 2007 21:13:26 -0800 (PST)
Received: from mxmail.synplicity.com (synvpn.synplicity.com [209.157.48.1])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAH5DCsi006562
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2007 21:13:14 -0800
Message-ID: <473E7870.7070901@synplicity.com>
Date: Fri, 16 Nov 2007 21:13:20 -0800
From: Chris Eddington <chrise@synplicity.com>
MIME-Version: 1.0
Subject: Re: xfs_repair - what's the damage?
References: <4739F2CD.2020800@synplicity.com> <20071113210853.GY995458@sgi.com>
In-Reply-To: <20071113210853.GY995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks David.  I had a 2-port SATA failure on a RAID5 array.  I've got
all disks up and running again , but in a RAID5 degraded state (3 out of
4 disks).  The logs tell me one port failed and then the other 8 hours
later and the raid system shut down immediately.  So I'm very surprised
so much data is lost, as the machine was pretty idle when the failures
occured.  I'm thinking that maybe the array got assembled incorrectly
somehow.

Thanks,
Chris

David Chinner wrote:
> On Tue, Nov 13, 2007 at 10:54:05AM -0800, Chris Eddington wrote:
>   
>> Hi,
>>
>> Can someone point me to instructions on how to understand the scope of
>> damage to this filesystem based on the output from xfs_repair below?
>> What is it repairing, and what data is lost?  I'm not sure how to interpret
>> these messages or where to go to find out.
>>     
>
> Looks like you had something write crap over various parts of
> the filesystem. Both AG 2 and ag 24 have header problems, and
> then there's a bunch of freespace and allocated inode problems
> because the indexes were lost due ot the header corruption.
>
> Who knows how much else is broken - it depends on how much
> bad data got written into the filesystem. best you can do is
> to run xfs_repair and sift through the debris in lost+found
> and try to work out what the lost data is...
>
> As I always ask - how did the filesytem get into this state?
>
> Cheers,
>
> Dave.
>   
