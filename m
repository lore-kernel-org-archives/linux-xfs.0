Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:55923 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754996AbdBQBUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 20:20:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1487008001.3125.41.camel@HansenPartnership.com>
        <20170213194337.GA9852@infradead.org> <20170213213416.GA15349@dastard>
        <20170214060809.GA21114@infradead.org>
        <1487053651.3125.72.camel@HansenPartnership.com>
        <1487053720.3125.73.camel@HansenPartnership.com>
        <87lgt9mcyv.fsf@xmission.com>
        <1487088593.3133.23.camel@HansenPartnership.com>
        <87y3x8dw5q.fsf@xmission.com>
        <1487259786.2944.10.camel@HansenPartnership.com>
Date: Fri, 17 Feb 2017 14:15:38 +1300
In-Reply-To: <1487259786.2944.10.camel@HansenPartnership.com> (James
        Bottomley's message of "Thu, 16 Feb 2017 07:43:06 -0800")
Message-ID: <87tw7tbosl.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Wed, 2017-02-15 at 15:29 +1300, Eric W. Biederman wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> 
>> > On Tue, 2017-02-14 at 20:46 +1300, Eric W. Biederman wrote:
>> > > James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> > > 
>> > > > Now that we have two different views of filesystem ids (the 
>> > > > filesystem view and the kernel view), we have a problem in that
>> > > > current_fsuid/fsgid() return the kernel view but are sometimes
>> > > > used 
>> > > > in filesystem code where the filesystem view shoud be used. 
>> > > >  This
>> > > > patch introduces helpers to produce the filesystem view of
>> > > > current 
>> > > > fsuid and fsgid.
>> > > 
>> > > If I am reading this right what we are seeing is that xfs
>> > > explicitly
>> > > opted out of type safety with predictable results.   Accidentally
>> > > confusing kuids and uids, which is potentially security issue.
>> > > 
>> > > All of that said where are you getting sb->s_user_ns !=
>> > > &init_user_ns
>> > > for an xfs filesystem?
>> 
>> James please answer this question:
>> 
>>  Where are you getting sb->s_user_ns != &init_user_ns for an xfs
>> filesystem?
>
> I'm playing with a patch that allows host admin to set up an
> unprivileged container for a guest to use.  One of the extensions is to
> allow anything possessing capability(CAP_SYS_ADMIN) to make s_user_ns
> follow mnt_ns->user_ns for new mounts (as an option).  The idea was to
> see if root could set up an id shifted container with just the current
> s_user_ns infrastructure.
>
>> None of this matters if sb->s_user_ns == &init_user_ns.
>> 
>> This is signification because only xfs keeps any in-core data 
>> structure in it's on-disk encoding.  So this problem is xfs specific.
>>    So understanding how you are getting xfs to have sb->s_user_ns !=
>> &init_user_ns is important for discussing which direction we go with
>> helper functions here.
>> 
>> xfs with sb->s_user_ns == &init_user_ns is perfectly fine and as such 
>> no fixes are needed.
>
> So what you're saying is that unless the unprivileged container could
> mount the filesystem itself (i.e. only those possessing the
> FS_USERNS_MOUNT flag) the filesystems are going to be full of problems
> like this.  I suppose whether it's worthwhile trying to fix them all
> depends on whether the ability of the administrator to set up an id
> shifted container is useful or not.

Yes.  Setting s_user_ns and expecting everything to work with a
review/test cycle of the filesystem to shake out any rough edges is
likely to be problematic.  For historical reasons I actually expect xfs
is especially bad in this regard.  So in practice I would definitely
start a feature like that with another filesystem.

I would be happy to have a FS_S_USER_NS flag to say all that is well,
and the filesystem supports s_user_ns != &init_user_ns.  The bar is much
lower if a trusted user with CAP_SYS_ADMIN is mounting the filesystem
than if an unprivileged user is mounting the filesystem.  As we don't
have to worry about specially crafted malicious filesystem images.

In practice I think I would have passed in the user namespace via a file
descriptor to mount rather than inheriting it from the mount namespace
(more flexibility for roughly the same amount of code).

Eric

