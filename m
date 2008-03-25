Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 23:13:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P6DLLx007068
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 23:13:23 -0700
Date: Tue, 25 Mar 2008 17:16:44 +1100
Subject: Re: REVIEW: Write primary superblock info to ALL secondaries during mkfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com> <20080325060017.GK103491721@sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t8j6d6sj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080325060017.GK103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, 25 Mar 2008 17:00:17 +1100, David Chinner <dgc@sgi.com> wrote:

> On Tue, Mar 25, 2008 at 04:39:02PM +1100, Barry Naujok wrote:
>> Secondaries should contain redundant information from the primary
>> superblock. It does this for the filesystem geometry information,
>> but not inode values (rootino, rt inos, quota inos).
>>
>> This patch updates all the secondaries from the primary just before
>> it marks the filesystem as good to go.
>
> So it's got all the inodes, geometry, etc correct in them?
>
> So what about the fact that the kernel code doesn't keep all
> copies up to date? e.g. growfs will only write new values into
> a handful of superblocks, changing sunit/swidth via mount options
> only change the primary, etc....
>
> If you are going to change mkfs to keep them all up to date, the
> kernel code really needs to do the same thing....

Yes it should :) Geometry information was already done across all
the AGs.

>>
>>  	/*
>> -	 * Dump all inodes and buffers before marking us all done.
>> -	 * Need to drop references to inodes we still hold, first.
>> +	 * Flush out all inodes and buffers before marking us all done.
>>  	 */
>>  	libxfs_rtmount_destroy(mp);
>>  	libxfs_icache_purge();
>> -	libxfs_bcache_purge();
>> +	libxfs_bcache_flush();
>
> Don't you still need a purge there to free all the objects in the
> cache?

No, the flush does what is required. There is no libxfs_icache_flush
at the moment, so I left the purge there for that.

libxfs_umount later on does a libxfs_*_purge() anyway.

The main thing is to make sure all objects are written to disk before
the sb_inprogress field in the primary superblock is zeroed.

Barry.
