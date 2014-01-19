Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C68BC7F51
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 03:38:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D668304043
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 01:38:28 -0800 (PST)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id SGI7fFxEFX3DkQeN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 19 Jan 2014 01:38:23 -0800 (PST)
Received: by mail-we0-f175.google.com with SMTP id p61so6050926wes.34
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 01:38:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140115014503.GQ3469@dastard>
References: <20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
Date: Sun, 19 Jan 2014 11:38:22 +0200
Message-ID: <CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
From: Alex Lyakas <alex@zadarastorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,
I believe I understand your intent of having the discard tree almost
fully disconnected from the busy extents tree. I planned to use the
the same pagb_lock for the discard tree as well, which solves the
atomicity and ordering issues you have described. If we use a
different lock (mutex), then some additional care is needed.
One thing I like less about such approach, is that we need to be
careful of not growing the discard tree too large. If, for some
reason, the worker thread is not able to keep up discarding extents
while they are queued for discard, we may end up with too many discard
ranges in the tree. Also at the same time user can trigger an offline
discard, which will add more discard ranges to the tree. While the
online discard that you have, kind of throttles itself. So if the
underlying block device is slow on discarding, the whole system will
be slowed down accordingly.

[snip]

I have one additional question regarding your comment on metadata

>> Q1: why it is ok to do so? why it is ok for "metadata" to reuse part
>> (or all) of the busy extent before its extent-free-intent is
>> committed?
>
> The metadata changes are logged, and crash recovery allows correct
> ordering of the free, realloc and modify process for metadata. Hence
> it doesn't matter that we overwrite the contents of the block before
> the free transaction is on disk - the correct contents will always
> be present after recovery.
>
> We can't do that for user data because we don't log user data.
> Therefore if we allow user data to overwrite the block whil eit is
> still busy, crash recovery may not result in the block having the
> correct contents (i.e. the transaction that freed the block never
> reaches the journal) and we hence expose some other user's data or
> metadata in the file.
If that is the case, why cannot we just issue an async discard before
the busy extent is committed? I understand that if we crashed, we
might have knocked off some of the user data (or changed it to some
new data). But can XFS get corrupted (unmountable) this way? You said
earlier that it can, but now you are saying that reusing a metadata
block, before its busy extent commits, is fine.

Thanks,
Alex.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
