Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:43374 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934676AbeFRUIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 16:08:55 -0400
Received: by mail-ot0-f193.google.com with SMTP id i19-v6so19935173otk.10
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jun 2018 13:08:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180606150905.GC9426@magnolia>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-2-mszeredi@redhat.com>
 <20180604084336.GA11333@infradead.org> <CAJfpegun8HyjODXguHstxYrGE2nuSoCCicaHT3yfYWMkxxmVWg@mail.gmail.com>
 <20180606150905.GC9426@magnolia>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2018 22:08:54 +0200
Message-ID: <CAJfpeguMN4t80cUCxyTxeHW9_Hb61DzDRPzTa371dc2YQRHuZQ@mail.gmail.com>
Subject: Re: [PATCH 01/39] vfs: dedpue: return loff_t
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Jun 6, 2018 at 5:09 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Tue, Jun 05, 2018 at 10:33:22AM +0200, Miklos Szeredi wrote:
>> On Mon, Jun 4, 2018 at 10:43 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Tue, May 29, 2018 at 04:43:01PM +0200, Miklos Szeredi wrote:
>> >> f_op->dedupe_file_range() gets a u64 length to dedup and returns an ssize_t
>> >> actual length deduped.  This breaks badly on 32bit archs since the returned
>> >> length will be truncated and possibly overflow into the sign bit (xfs and
>> >> ocfs2 are affected, btrfs limits actual length to 16MiB).
>> >
>> > Can we just make it return 0 vs errno?  The only time we return
>> > a different length than the one passed in is due to the btrfs cap.
>> >
>> > Given that this API started out on btrfs we should just do the cap
>> > everywhere to not confuse userspace.
>>
>> And that's a completely arbitrary cap; sure btrfs started out with
>> that, but there's no fundamental reason for that becoming the global
>> limit.  Xfs now added a different, larger limit, so based on what
>> reason should that limit be reduced?
>>
>> I don't care either way, but at this stage I'm not going to change
>> this patch, unless there's a very good reason to do so, because if I
>> do someone will come and suggest another improvement, ad-infinitum...
>
> I think we should hoist the MAX_RW_COUNT/2 limit to the VFS helpers
> since afaict we generally cap max IO per call at MAX_RW_COUNT.

I don't quite get it.   That MAX_RW_COUNT is to protect against
overflows in signed int.

Here we have a 64bit interface, so that's irrelevant, we can invent
any cap we want.  Lets choose our favorite bike shed size.  Mine is
1G.  But if that turns out too limiting it can be raised arbitrarily
later.

>  (I
> probably should've capped ocfs2 back when I did xfs, but forgot).  If
> btrfs wants to keep their lower (16M) limit then they're free to do so;
> the interface documentation allows for this.  One of the btrfs
> developers seems to be working on a patch series to raise the limit[1]
> anyway.

Yep, that got upstreamed now.  Which is good, we can just return zero
or error from ->dedupe_file_range() and be done with that.

Thanks,
Miklos
