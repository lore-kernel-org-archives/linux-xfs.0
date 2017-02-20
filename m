Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:41503 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdBTFBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Feb 2017 00:01:23 -0500
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
        <87tw7tbosl.fsf@xmission.com>
        <1487351548.4351.13.camel@HansenPartnership.com>
Date: Mon, 20 Feb 2017 17:56:37 +1300
In-Reply-To: <1487351548.4351.13.camel@HansenPartnership.com> (James
        Bottomley's message of "Fri, 17 Feb 2017 09:12:28 -0800")
Message-ID: <87bmtxbgu2.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Fri, 2017-02-17 at 14:15 +1300, Eric W. Biederman wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> 
>> > On Wed, 2017-02-15 at 15:29 +1300, Eric W. Biederman wrote:
>> > > James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> > > 
>> > > > On Tue, 2017-02-14 at 20:46 +1300, Eric W. Biederman wrote:
>> > > > > James Bottomley <James.Bottomley@HansenPartnership.com>
>> > > > > writes:
>> > > > > 
>> > > > > > Now that we have two different views of filesystem ids (the
>> > > > > > filesystem view and the kernel view), we have a problem in 
>> > > > > > that current_fsuid/fsgid() return the kernel view but are
>> > > > > > sometimes used in filesystem code where the filesystem view 
>> > > > > > shoud be used.  This patch introduces helpers to produce 
>> > > > > > the filesystem view of current fsuid and fsgid.
>> > > > > 
>> > > > > If I am reading this right what we are seeing is that xfs
>> > > > > explicitly opted out of type safety with predictable results.
>> > > > >  Accidentally confusing kuids and uids, which is potentially 
>> > > > > security issue.
>> > > > > 
>> > > > > All of that said where are you getting sb->s_user_ns !=
>> > > > > &init_user_ns for an xfs filesystem?
>> > > 
>> > > James please answer this question:
>> > > 
>> > >  Where are you getting sb->s_user_ns != &init_user_ns for an xfs
>> > > filesystem?
>> > 
>> > I'm playing with a patch that allows host admin to set up an
>> > unprivileged container for a guest to use.  One of the extensions 
>> > is to allow anything possessing capability(CAP_SYS_ADMIN) to make
>> > s_user_ns follow mnt_ns->user_ns for new mounts (as an option). 
>> >  The idea was to see if root could set up an id shifted container 
>> > with just the current s_user_ns infrastructure.
>> > 
>> > > None of this matters if sb->s_user_ns == &init_user_ns.
>> > > 
>> > > This is signification because only xfs keeps any in-core data 
>> > > structure in it's on-disk encoding.  So this problem is xfs
>> > > specific.
>> > >    So understanding how you are getting xfs to have sb->s_user_ns 
>> > > != &init_user_ns is important for discussing which direction we 
>> > > go with helper functions here.
>> > > 
>> > > xfs with sb->s_user_ns == &init_user_ns is perfectly fine and as 
>> > > such no fixes are needed.
>> > 
>> > So what you're saying is that unless the unprivileged container 
>> > could mount the filesystem itself (i.e. only those possessing the
>> > FS_USERNS_MOUNT flag) the filesystems are going to be full of 
>> > problems like this.  I suppose whether it's worthwhile trying to 
>> > fix them all depends on whether the ability of the administrator to 
>> > set up an id shifted container is useful or not.
>> 
>> Yes.  Setting s_user_ns and expecting everything to work with a
>> review/test cycle of the filesystem to shake out any rough edges is
>> likely to be problematic.  For historical reasons I actually expect 
>> xfs is especially bad in this regard.  So in practice I would 
>> definitely start a feature like that with another filesystem.
>
> It's a pragmatic choice: xfs is the filesystem on my current laptop.  I
> know xfs was once very problematic for the user namespace, but having
> looked through the code several times, the namespace shifts are now
> nicely abstracted and easy to identify, so I don't anticipate any extra
> difficulty today.

I think you have already encountered the extra difficulty.  For xfs a
couple of little things need to be fixed.  I expect most filesystems
will pretty much work out of the box.

>> I would be happy to have a FS_S_USER_NS flag to say all that is well,
>> and the filesystem supports s_user_ns != &init_user_ns.  The bar is 
>> much lower if a trusted user with CAP_SYS_ADMIN is mounting the 
>> filesystem than if an unprivileged user is mounting the filesystem. 
>>  As we don't have to worry about specially crafted malicious
>> filesystem images.
>> 
>> In practice I think I would have passed in the user namespace via a 
>> file descriptor to mount rather than inheriting it from the mount
>> namespace (more flexibility for roughly the same amount of code).
>
> I agree on this, but lets leave the implementation details on the side
> for a while and examine the "should we do this?" question.
>
> I can see two reasons why we might need to have this functionality
>
>    1. Orchestration system use case: the orchestration system wants to
>       build an unprivileged container root from an image file or overlay
>       (I think this covers docker).
>    2. USB (or other) device insertion redirected to container.  In this
>       case, we'd like the mount on insertion to follow the container
>       user_ns.

I think those are valid.

The Docker/runc cases that I am familiar with really want the sharing of
base images between containers.  To share the base image between
containers requires having a different mapping per container to separate
them.  The savings on disk space and vfs cache sharing is important for
them.

I am torn on the fact that this sneaks up on the issue of what happens
when someone injects a malicious disk image into this process.  If we
have a full to handling malicious disk images we can just set
FS_USERNS_MOUNT.  All of these use case look like cases where
it would be very reasy for the mounter of the filesystem to skip
ensuring they trust the path that generated the filesystem.  On the
other hand that is nothing new.

> The reason I could see not bothering with this is that it doesn't fix
> the shift on a subtree issue and fixing that gives a system which can
> also be used to solve both cases above.

The only reasons I have been not bothering with this are:
- Different mappings into different containers.
- It's closeness to S_USER_NS.
- A focus and getting fuse and the generic vfs bits covered and merged.

But at this point I think a generic vfs option that would set s_user_ns
and work on filesystems that opt in would be perfectly reasonable.
Especially since (a) we want to be able to display which user namespace
s_user_ns is in, and a generic mount option seems like a way to sneak it
into existing proc files, and (b) we want the file descriptor parsing code
for shiftfs.

So it seems like we might as well implement the functionality as a
generic mount option and let the filesystems opt in with FS_USERNS_MOUNT
or FS_S_USER_NS if the filesystem is not up to a full unprivileged
unmount.

Eric
