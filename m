Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0F977F3F
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 13:24:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 748F08F8071
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 11:24:41 -0800 (PST)
Received: from mail-ee0-f49.google.com (mail-ee0-f49.google.com
	[74.125.83.49]) by cuda.sgi.com with ESMTP id iff3XGZU1SQmiSfw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 Dec 2013 11:24:36 -0800 (PST)
Received: by mail-ee0-f49.google.com with SMTP id c41so643169eek.36
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 11:24:35 -0800 (PST)
Message-ID: <31B8E1DCCA4F45918621D6461ED19B19@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
In-Reply-To: <20131219105513.GZ31386@dastard>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Date: Thu, 19 Dec 2013 21:24:40 +0200
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
It makes sense. I agree it might break some guarantees. Although if the user 
deleted some blocks in the file or the whole file, maybe it's ok to not have 
a clear promise what he sees after the crash. But I agree, it's not a clear 
semantics.

Thanks for the comments,
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
