Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53976 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbeJCWYp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 18:24:45 -0400
Subject: Re: [PATCH] xfs: zero posteof blocks when cloning above eof
References: <20181003020342.GD19324@magnolia>
 <24443553-fc5e-a377-dcb4-dabc0177bf99@sandeen.net>
 <20181003151253.GF19324@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e32c24ba-2f8d-78f6-fe2e-5a6ca9b56c3b@sandeen.net>
Date: Wed, 3 Oct 2018 10:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <20181003151253.GF19324@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, zlang@redhat.com

On 10/3/18 10:12 AM, Darrick J. Wong wrote:
> On Wed, Oct 03, 2018 at 07:11:14AM -0500, Eric Sandeen wrote:
>> On 10/2/18 9:03 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> When we're reflinking between two files and the destination file range
>>> is well beyond the destination file's EOF marker, zero any posteof
>>> speculative preallocations in the destination file so that we don't
>>> expose stale disk contents.  The previous strategy of trying to clear
>>> the preallocations does not work if the destination file has the
>>> PREALLOC flag set but no delalloc blocks.
>>>
>>> Uncovered by shared/010.
>>>
>>> Reported-by: Zorro Lang <zlang@redhat.com>
>>> Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> The action makes sense, and this does resolve my simple testcase,
>> and makes shared/010 pass for me as well.
>>
>> However, this makes my correctness spidey-sense tingle; why is there a
>> new helper unique to extending reflinks, when extending writes already
>> must do the same thing?
> 
> I think you're referring to Dave's earlier question of "Why don't you
> just use xfs_file_aio_write_checks?"
> 
> It's tempting to adapt xfs_file_aio_write_checks for reflink, but I
> think I have to create a new function because (a) we don't have a kiocb
> to pass in, and (b) we have to lock two inodes for reflink while abiding
> the [VX]FS inode locking rules and making sure we break the destination
> flie's layout correctly.
> 
>> I didn't follow all the discussion on IRC, but might be worth
>> explaining on the list for others as well.  Are there any other
>> extending write tests that aren't happening for extending reflink?
> 
> Yes, there are a number of behavioral inconsistencies between regular
> write and clonerange that have been discovered in the past few days, and
> it's going to take me a few days to clean all of this up:
> 
> - Lack of file_update_times(), though the ctime update is open-coded in
>   the reflink routines.
> 
> - Lack of file_remove_privs() to drop suid and capabilities on write.
>   Totally missing from the btrfs implementation and xfs/ocfs2 followed
>   that behavior warts and all.
> 
> - Lack of RLIMIT_FSIZE checking: D'oh.  Same lame excuse as above.
> 
> - Lack of MAX_NON_LFS size checking: Same.
> 
> - Lack of s_maxbytes checking: Same.  Alarming since this means we can
>   reflink to offsets the pagecache doesn't support.
> 
> - Should our clonerange return bytes reflinked to copy_file_range?
> 
> That last one requires more careful consideration & will take longer;
> the first two are nearly ready.

Ok, so let's say something like "this patch looks good as far as it goes,
but as you work out these other issues, please consider code structure
so that requirements which are common to extending write & extending reflink
are done in common code rather than cut & pasted?"  :)

-Eric
