Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 19:14:15 -0700 (PDT)
Received: from out1.smtp.messagingengine.com (out1.smtp.messagingengine.com [66.111.4.25])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l982E8Rr007875
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 19:14:11 -0700
Message-ID: <47098DD4.4090207@fastmail.co.uk>
Date: Mon, 08 Oct 2007 09:54:28 +0800
From: Max Waterman <davidmaxwaterman+kernel@fastmail.co.uk>
MIME-Version: 1.0
Subject: Re: XFS internal error
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com>
In-Reply-To: <20071008001452.GX995458@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

David Chinner wrote:
>> 1994 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff889b2de4
>>     
>
> Did you ever run 2.6.17-2.6.17.6?
I guess so, since I've been upgrading steadily since I installed FC6 
some time ago.
>  If so, this implies:
>
> http://oss.sgi.com/projects/xfs/faq.html#dir2
>   
Ah. I did see that, but stopped reading when I read it was fixed in 
later versions ... didn't get to the part where it still needed to be 
repaired/etc.

>> I am fairly sure there is nothing I can do about this, but I thought it
>> prudent to mention it. Searching turned up some similar issues, but they
>> seem related to a previous kernel version and claimed to be fixed in
>> subsequent versions.
>>     
>
> Yes, but those previous corruptions get left on disk as a landmine
> for you to trip over some time later, even on a kernel that has the
> bug fixed.
>   
ah, ok.
> I suggest that you run xfs_check on the filesystem and if that
> shows up errors, run xfs_repair onteh filesystem to correct them.
>   
It did, and I did, and another xfs_check produced no output.

Do I need to do anything else to correct it? xfs_repair produced a whole 
bunch of stuff that I don't understand...this is the bit that looks most 
significant :

> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> can't read freespace block 16777216 for directory inode 2095141277
> rebuilding directory inode 2095141277
> free block 16777216 for directory inode 2100841732 bad nused
> rebuilding directory inode 2100841732
> free block 16777216 for directory inode 2102199514 bad nused
> rebuilding directory inode 2102199514
> free block 16777216 for directory inode 2102200124 bad nused
> rebuilding directory inode 2102200124
> free block 16777216 for directory inode 2102905843 bad nused
> rebuilding directory inode 2102905843
> free block 16777216 for directory inode 3277510927 bad nused
> rebuilding directory inode 3277510927
> free block 16777216 for directory inode 3277524487 bad nused
> rebuilding directory inode 3277524487
> free block 16777216 for directory inode 3379886019 bad nused
> rebuilding directory inode 3379886019
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
That last line looks suspicious...furthermore, when I mount the 
filesystem, I don't see a 'lost+found' directory (which I've been used 
to seeing on IRIX). Ah, perhaps the '...' with *nothing* after it means 
it didn't do any moving. Am I right?

Max.
