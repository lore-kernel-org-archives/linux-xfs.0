Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932576AbdKFTZ4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:25:56 -0500
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com [209.85.223.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 630ED21944
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2017 19:25:56 +0000 (UTC)
Received: by mail-io0-f169.google.com with SMTP id i38so16903423iod.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Nov 2017 11:25:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171017141233.l3avshagrv7fr7xt@thunk.org>
References: <CABXGCsOeex62Y4qQJwvMJ+fJ+MnKyKGDj9eRbKemeMVWo5huKw@mail.gmail.com>
 <20171009000529.GY3666@dastard> <20171009183129.GE11645@wotan.suse.de>
 <87wp442lgm.fsf@xmission.com> <8729041d-05e5-6bea-98db-7f265edde193@suse.de>
 <20171015130625.o5k6tk5uflm3rx65@thunk.org> <87efq4qcry.fsf@xmission.com>
 <20171016011301.dcam44qylno7rm6a@thunk.org> <c5bb6c1b-90c9-f50e-7283-af7e0de67caa@suse.de>
 <20171017092017.GN9762@quack2.suse.cz> <20171017141233.l3avshagrv7fr7xt@thunk.org>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Mon, 6 Nov 2017 11:25:34 -0800
Message-ID: <CAB=NE6UK3463JfiZQFHUiMj=v6HDG0k+uEE-2OvRMsW7i1EMhA@mail.gmail.com>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, colyli@suse.com
Cc: Jan Kara <jack@suse.cz>, Aleksa Sarai <asarai@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Dave Chinner <david@fromorbit.com>, =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Oscar Salvador <osalvador@suse.com>, Hannes Reinecke <hare@suse.de>, xfs <linux-xfs@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>

On Tue, Oct 17, 2017 at 7:12 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Oct 17, 2017 at 11:20:17AM +0200, Jan Kara wrote:
>> The operation we are speaking about here is different. It is more along the
>> lines of "release this device".  And in the current world of containers,
>> mount namespaces, etc. it is not trivial for userspace to implement this
>> using umount(2) as Ted points out. I believe we could do that by walking
>> through all mount points of a superblock and unmounting them (and I don't
>> want to get into a discussion how to efficiently implement that now but in
>> principle the kernel has all the necessary information).
>
> Yes, this is what I want.  And regardless of how efficiently or not
> the kernel can implement such an operatoin, by definition it will be
> more efficient than if we have to do it in userspace.

It seems most folks agree we could all benefit from this, to help
userspace with a sane implementation.

>> What I'm a bit concerned about is the "release device reference" part - for
>> a block device to stop looking busy we have to do that however then the
>> block device can go away and the filesystem isn't prepared to that - we
>> reference sb->s_bdev in lots of places, we have buffer heads which are part
>> of bdev page cache, and probably other indirect assumptions I forgot about
>> now.

Is this new operation really the only place where such type of work
could be useful for, or are there existing uses cases this sort of
functionality could also be used for?

For instance I don't think we do something similar to revokefs(2) (as
described below) when a devices has been removed from a system, you
seem to suggest we remove the dev from gendisk leaving it dangling and
invisible. But other than this, it would seem its up to the filesystem
to get anything else implemented correctly?

> This all doesn't have to be a single system call.  Perhaps it would
> make sense for first and second step to be one system call --- call it
> revokefs(2), perhaps.  And then the last step could be another system
> call --- maybe umountall(2).

Wouldn't *some* part of this also help *enhance* filesystem suspend /
thaw be used on system suspend / resume as well?

If I may, if we split these up, into two, say revokefs(2) and
umountall(2), how about:

a) revokefs(2): ensures all file descriptors for the fs are closed
   - blocks access attempts high up in VFS
   - point any file descriptor to a revoked null struct file
   - redirect any task struct CWD's so as if the directory had rmmdir'd
   - munmap any mapped regions

Of these only the first one seems useful for fs suspend?

b) umountall(2): properly unmounts filesystem from all namespaces
   - May need to verify if revokefs(2) was called, if so, now that all
file descriptors should
     be closed, do syncfs() to force out any dirty pages
   - unmount() in all namespaces, this takes care of any buffer or page
     cache reference once the ref count of the struct super block goes to
     to zero

  Luis
