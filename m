Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2.postbox.xyz ([81.169.216.193]:34240 "EHLO
        mail2.postbox.xyz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933675AbcKNSjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 13:39:08 -0500
Message-ID: <25b69ec53ba731ddd2f04d4e70341bdd.squirrel@mail2.postbox.xyz>
In-Reply-To: <20161114125654.GA37689@bfoster.bfoster>
References: <004eca882d70d671bce9dff6f25633cc.squirrel@mail2.postbox.xyz>
    <20161114125654.GA37689@bfoster.bfoster>
Date: Mon, 14 Nov 2016 19:39:03 +0100
Subject: Re: XFS_WANT_CORRUPTED_GOTO
From: "Chris" <chris2014@postbox.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Dear Brian,

thank you for your detailed answer.

Brian Foster wrote:
> On Sat, Nov 12, 2016 at 11:52:02AM +0100, Chris wrote:
>> I tried XFS-repair, but it couldn't find the first or second super block
>> after four hours.
>>
>
> That sounds like something more significant is going on either with the
> fs, the storage or xfs_repair has been pointed in the wrong place. The
> above issue should at worst require zeroing the log, dealing with the
> resulting inconsistency and rebuilding the fs btrees accurately.

Well, did it crash, because I called

xfs_db -c "freespc -s" /dev/...

while it was still in this unmount-loop?

> I suspect it's too late to inspect what's going on there if you have
> already restored from backup. In the future, you can use xfs_metadump to
> capture a metadata only image of a broken fs to share with us and help
> us diagnose what might have gone wrong.

OK.

> I'd suggest to run "xfs_repair -n" on those as soon as possible to see
> if they are affected by the same problem. It might also be a good idea
> to run it against the fs you've restored from backup to see if it
> returns and possibly get an idea on what might have caused the problem.

On those filesystems, that aren't in use now, xfs_repair hasn't found any
problems.

Thanks again for your help. Next time, I'll do a metadump.

- Chris

