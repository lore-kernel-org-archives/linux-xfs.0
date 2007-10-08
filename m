Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 19:32:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l982WXdI011121
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 19:32:35 -0700
Date: Mon, 08 Oct 2007 12:32:30 +1000
Subject: Re: XFS internal error
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <47098DD4.4090207@fastmail.co.uk>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzuxcgsi3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47098DD4.4090207@fastmail.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Max Waterman <davidmaxwaterman+kernel@fastmail.co.uk>, David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 08 Oct 2007 11:54:28 +1000, Max Waterman  
<davidmaxwaterman+kernel@fastmail.co.uk> wrote:

> David Chinner wrote:
>> I suggest that you run xfs_check on the filesystem and if that
>> shows up errors, run xfs_repair onteh filesystem to correct them.
>>
> It did, and I did, and another xfs_check produced no output.
>
> Do I need to do anything else to correct it? xfs_repair produced a whole  
> bunch of stuff that I don't understand...this is the bit that looks most  
> significant :
>
>> Phase 6 - check inode connectivity...
>>         - resetting contents of realtime bitmap and summary inodes
>>         - traversing filesystem ...
>> can't read freespace block 16777216 for directory inode 2095141277
>> rebuilding directory inode 2095141277
>> free block 16777216 for directory inode 2100841732 bad nused
>> rebuilding directory inode 2100841732
>> free block 16777216 for directory inode 2102199514 bad nused
>> rebuilding directory inode 2102199514
>> free block 16777216 for directory inode 2102200124 bad nused
>> rebuilding directory inode 2102200124
>> free block 16777216 for directory inode 2102905843 bad nused
>> rebuilding directory inode 2102905843
>> free block 16777216 for directory inode 3277510927 bad nused
>> rebuilding directory inode 3277510927
>> free block 16777216 for directory inode 3277524487 bad nused
>> rebuilding directory inode 3277524487
>> free block 16777216 for directory inode 3379886019 bad nused
>> rebuilding directory inode 3379886019
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
> That last line looks suspicious...furthermore, when I mount the  
> filesystem, I don't see a 'lost+found' directory (which I've been used  
> to seeing on IRIX). Ah, perhaps the '...' with *nothing* after it means  
> it didn't do any moving. Am I right?

Yes, the latest xfs_repair doesn't create a lost+found unless it
needs to, and if it does so, it will list the inodes moved there.

So, in your case, nothing went to lost+found.

Regards,
Barry.
