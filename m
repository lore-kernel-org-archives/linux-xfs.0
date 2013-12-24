Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA0687F9B
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:21:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E9C8304043
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 10:21:54 -0800 (PST)
Received: from mail-ea0-f179.google.com (mail-ea0-f179.google.com
	[209.85.215.179]) by cuda.sgi.com with ESMTP id
	pwHdTkfSZsob1uS7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Dec 2013 10:21:52 -0800 (PST)
Received: by mail-ea0-f179.google.com with SMTP id r15so3006802ead.24
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 10:21:51 -0800 (PST)
Message-ID: <8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
In-Reply-To: <20131219105513.GZ31386@dastard>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Date: Tue, 24 Dec 2013 20:21:50 +0200
MIME-Version: 1.0
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

Hi Dave,
Reading through the code some more, I see that the extent that is freed 
through xfs_free_extent() can be an XFS metadata extent as well.
For example, xfs_inobt_free_block() frees a block of the AG's free-inode 
btree. Also, xfs_bmbt_free_block() frees a generic btree block by putting it 
onto the cursor's "to-be-freed" list, which will be dropped into the 
free-space btree (by xfs_free_extent) in xfs_bmap_finish(). If we discard 
such metadata block before the transaction is committed to the log and we 
crash, we might not be able to properly mount after reboot, is that right? I 
mean it's not that some file's data block will show 0s to the user instead 
of before-delete data, but some XFS btree node (for example) will be wiped 
in such case. Can this happen?

Thanks,
Alex.


-----Original Message----- 
From: Dave Chinner
Sent: 19 December, 2013 12:55 PM
To: Alex Lyakas
Cc: xfs@oss.sgi.com
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)

On Thu, Dec 19, 2013 at 11:24:15AM +0200, Alex Lyakas wrote:
> Hi Dave,
> Thank you for your comments.
> I realize now that what I proposed cannot be done; I need to
> understand deeper how XFS transactions work (unfortunately, the
> awesome "XFS Filesystem Structure" doc has a TODO in the "Journaling
> Log" section).
>
> Can you please comment on one more question:
> Let's say we had such fully asynchronous "fire-and-forget" discard
> operation (I can implement one myself for my block-device via a
> custom IOCTL). What is wrong if we trigger such operation in
> xfs_free_ag_extent(), right after we have merged the freed extent
> into a bigger one? I understand that the extent-free-intent is not
> yet committed to the log at this point. But from the user's point of
> view, the extent has been deleted, no? So if the underlying block
> device discards the merged extent right away, before committing to
> the log, what issues this can cause?

Think of what happens when a crash occurs immediately after the
discard completes. The freeing of the extent never made it to th
elog, so after recovery, the file still exists and the user can
access it. Except that it's contents are now all different to
before the crash occurred.

IOWs, issuing the discard before the transaction that frees the
extent is on stable storage means we are discarding user data or
metadata before we've guaranteed that the extent free transaction
is permanent and that means we violate certain guarantees with
respect to crash recovery...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
