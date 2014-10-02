Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1EF27F67
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 08:27:55 -0500 (CDT)
Message-ID: <542D52DB.6090709@sgi.com>
Date: Thu, 02 Oct 2014 08:27:55 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix the xfs_iflush_done callback search
References: <20141001191803.153063401@sgi.com> <20141001223456.GV4758@dastard>
In-Reply-To: <20141001223456.GV4758@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/01/14 17:34, Dave Chinner wrote:
> On Wed, Oct 01, 2014 at 04:18:02PM -0500, Mark Tinguely wrote:
>> Commit "xfs: remove all the inodes on a buffer from the AIL in bulk"
>> made the xfs inode flush callback more efficient by combining all
>> the inode writes on the buffer and the deletions of the inode log
>> item from AIL.
>>
>> The initial loop in this patch should be looping through all
>> the log items on the buffer to see which items have
>> xfs_iflush_done as their callback function. But currently,
>> only the log item passed to the function has its callback
>> compared to xfs_iflush_done. If the log item pointer passed to
>> the function does have the xfs_iflush_done callback function,
>> then all the log items on the buffer are removed from the
>> li_bio_list on the buffer b_fspriv and could be removed from
>> the AIL eventhough they may have not been written yet.
>
> Looks like a bug, but what I don't know from this description is
> the symptoms and impact of this bug being hit? Is there a risk of
> filesystem corruption on crash or power loss? Perhaps it's a data
> loss issue? I can't tell, and for anyone scanning the commit logs to
> determine if they need to backport the fix will be asking the same
> questions.
>
> Also, is there a reproducable test case for it?

I was looking in this code for a way an inode could be removed from the 
AIL but not written to disk.

I have a metadata dump that shows a truncate on two inodes just before a 
clean unmount. The free space btrees are updated but neither inode has 
been updated. A clean shutdown will wait until the AIL is empty, so 
something removed the inode from the AIL but did not write the latest 
changes to disk. Yes, there were earlier changes to inode/chunk in 
previous pushes. This results in the blocks being both free and 
allocated....if we are lucky, we get a XFS_WANT_CORRUPTED_GOTO forced 
shutdowns because of partial frees in xfs_free_ag_extent(). Most of the 
time it is reallocated and that leads to all kinds of data/metadata 
corruption.

I tried to recreate the problem with truncates on files while unmounting 
but have not gotten the correct combination. I have been chasing the 
ghost of the duplicate allocation corruption problem for months and I 
did not want to over state my beliefs until I could replicate the problem.

I would advise an xfs_repair in addition to the patch, the corruption 
could have happened a long time ago and could be waiting to trigger.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
