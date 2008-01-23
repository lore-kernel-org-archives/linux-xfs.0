Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 15:17:42 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NNHCtZ007089
	for <linux-xfs@oss.sgi.com>; Wed, 23 Jan 2008 15:17:15 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 664C7552A53
	for <linux-xfs@oss.sgi.com>; Wed, 23 Jan 2008 15:17:32 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id aFAHnrFLGyXyzEmY for <linux-xfs@oss.sgi.com>; Wed, 23 Jan 2008 15:17:32 -0800 (PST)
Message-ID: <4797CB0A.7050406@tlinx.org>
Date: Wed, 23 Jan 2008 15:17:30 -0800
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: blktrace & btrace usability
References: <47906577.8090604@tlinx.org> <20080122164145.GB4531@hasse.suse.de> <47964B66.5020001@tlinx.org> <20080123132700.GI4531@hasse.suse.de>
In-Reply-To: <20080123132700.GI4531@hasse.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Blunck <jblunck@suse.de>
Cc: linux-btrace@vger.kernel.org, Linux-Xfs <linux-xfs@oss.sgi.com>

Jan Blunck wrote:
> On Tue, Jan 22, Linda Walsh wrote:
>
>   
>> Jan Blunck wrote:
>>     
>>> blktrace is used by the preload package. The preload package is capable of
>>> remapping blocks for faster booting. Therefore we need the blktrace
>>> output. But we only have a remapper for ext3.
>>>  
>>>       
>> ----
>>    I wondered about that, but the blktrace package doesn't containg
>> any utility for remapping blocks. The blktrace-0.99.3-12 package
>> included in OSuse-10.3, I only see utilities "blkparse, blktrace, btrace,
>> blkrawverify, btt, and verify_blktrace". 
>>    Was it left out by accident?  ---or---
>>     
>
> No, this is the reason why I said "blktrace is used by the preload
> package". The ext3remapper is part of the preload package.
>   
----
    Ahh...I'm sorry, I didn't know that the blktrace rc-scripts were
unrelated to the blktrace package and that by preload package you meant
a package named "preload" (I thought preload was some other phase
that I didn't know about that happened before other packages
were processed, or something).  I got confused by the names (no
idea why...*cough*)...  I'm not sure why the package, "preload", got
installed and "chkconfig'ed on" when I have no ext{23} disks.

    I have "personal" issues with each new version adding more
automatically run "services".  Reminds me more and more of WinXP with
all its auto-start boot progs & services and how it initially (pre-SP2),
installed with most services turned on (even though they weren't
needed by most users).  In a similar way, SuSE organizes its
rpms to "require" features (packages) that I don't want and don't
need (avahi an apple-ad-hoc networking util with most of gnome
requiring its presence).

    xfs has a file-system re-organizer, but its design goal
(probably ~10 years back) was simply to coalesce discontiguous
file parts to speed up speed sensitive real-time video streaming.
If it was deemed important, the existing xfs_fsr might be
adaptable...

    Sorry for my confusion..., from the names "boot.blktrace" &
"stopblktrace", I thought they were general scripts for recording
the "boot+rc" block actions -- not specifically for the
package named "preload".

-l
