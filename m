Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6720C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 14:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiEZOVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 10:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiEZOVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 10:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D9B4C5DA4
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 07:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653574892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hL/KQo32vTQRIkHJpeTsNgTFWGw5AA8jPdAcnm3W/dA=;
        b=iozDS8yZ0LC18wE7ULl2NKPhWmp1uJelRATBgjB2wfepPPfhAbX1Hk0TW85bLiJ9uPTKkN
        uLpCdeQQRNY711IaGYrbIsxiM0oB/yRhww3Bjoc+Qa8fFHIqt0VF4/ITzXEN0gisNeeIpF
        JdO8yZeLLYIXLODPnt0DMyaTG0i+72s=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-0BoZCTM2MbmRLed6ETp9FA-1; Thu, 26 May 2022 10:21:31 -0400
X-MC-Unique: 0BoZCTM2MbmRLed6ETp9FA-1
Received: by mail-qt1-f197.google.com with SMTP id w21-20020a05622a135500b002f3b801f51eso1646739qtk.23
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 07:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hL/KQo32vTQRIkHJpeTsNgTFWGw5AA8jPdAcnm3W/dA=;
        b=MNhyCdb58h3/IkWYDy8sJ5KIePQE86Q7Cox9vokZ11ozy2APaAlMpWuUB0g/evNqCi
         aKdXfINtl5w+fZSjLdLEUOTTiFZVAj8QH/Kk4MPaRS4StzVimINagCTT7UmOjGH4JKZc
         fvwix9H5hAe3pDDcLke50NGWaGJPmcaXer5sU5FQOCjC3BmaEgC3LJCSy6yFKhHsVfrJ
         MaQ7+IEY2s2+JenWl+Ocs58CRPmfwq9kc0bQzhbdlzIBgDY33pe5WoRkSknQNn/YykW6
         snmRBKvQ4iDcQGY3fYuLHd9hGNrnzWRe4LQCrrOkk9saN9oliDli6N1XO2v2sAQrCVrT
         W93g==
X-Gm-Message-State: AOAM532W8a77l+UtAD2lpxleYQF6HQslRN9CFHM+7ARHpwOS2A4Z25RS
        W35Jj43dnRNht8+NNc+3gencasTSzM2K8e80vaL/c1etb6pD2wje/icqQTpukJj98NyvUI5sAHu
        nvzu6UEuLN1Vo7R+ewyEO
X-Received: by 2002:a05:620a:b0b:b0:6a3:5f9a:1b80 with SMTP id t11-20020a05620a0b0b00b006a35f9a1b80mr18062212qkg.283.1653574890731;
        Thu, 26 May 2022 07:21:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3SDfMqeCxWl5YrkXl2c1i4+Fv9HdH7eNVVgCkNOF5JuUMdx6aDrkxa8ry7gmqzJgdyS57zQ==
X-Received: by 2002:a05:620a:b0b:b0:6a3:5f9a:1b80 with SMTP id t11-20020a05620a0b0b00b006a35f9a1b80mr18062189qkg.283.1653574890365;
        Thu, 26 May 2022 07:21:30 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id e5-20020a37ac05000000b006a353b7bf78sm1121530qkm.122.2022.05.26.07.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:21:30 -0700 (PDT)
Date:   Thu, 26 May 2022 10:21:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <Yo+M6Jhjwt/ruOfi@bfoster>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
 <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 02:34:38PM +0300, Amir Goldstein wrote:
> On Tue, Feb 23, 2021 at 2:35 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Mon, Feb 22, 2021 at 10:27:45AM -0800, Darrick J. Wong wrote:
> > > On Mon, Feb 22, 2021 at 10:34:42AM -0500, Brian Foster wrote:
> > > > Freed extents are marked busy from the point the freeing transaction
> > > > commits until the associated CIL context is checkpointed to the log.
> > > > This prevents reuse and overwrite of recently freed blocks before
> > > > the changes are committed to disk, which can lead to corruption
> > > > after a crash. The exception to this rule is that metadata
> > > > allocation is allowed to reuse busy extents because metadata changes
> > > > are also logged.
> > > >
> > > > As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
> > > > has allowed modification or complete invalidation of outstanding
> > > > busy extents for metadata allocations. This implementation assumes
> > > > that use of the associated extent is imminent, which is not always
> > > > the case. For example, the trimmed extent might not satisfy the
> > > > minimum length of the allocation request, or the allocation
> > > > algorithm might be involved in a search for the optimal result based
> > > > on locality.
> > > >
> > > > generic/019 reproduces a corruption caused by this scenario. First,
> > > > a metadata block (usually a bmbt or symlink block) is freed from an
> > > > inode. A subsequent bmbt split on an unrelated inode attempts a near
> > > > mode allocation request that invalidates the busy block during the
> > > > search, but does not ultimately allocate it. Due to the busy state
> > > > invalidation, the block is no longer considered busy to subsequent
> > > > allocation. A direct I/O write request immediately allocates the
> > > > block and writes to it.
> > >
> > > I really hope there's a fstest case coming for this... :)
> > >
> >
> > generic/019? :) I'm not sure of a good way to reproduce on demand given
> > the conditions required to reproduce.
> >
> > > > Finally, the filesystem crashes while in a
> > > > state where the initial metadata block free had not committed to the
> > > > on-disk log. After recovery, the original metadata block is in its
> > > > original location as expected, but has been corrupted by the
> > > > aforementioned dio.
> > >
> > > Wheee!
> > >
> > > Looking at xfs_alloc_ag_vextent_exact, I guess the allocator will go
> > > find a freespace record, call xfs_extent_busy_trim (which could erase
> > > the busy extent entry), decide that it's not interested after all, and
> > > bail out without restoring the busy entry.
> > >
> > > Similarly, xfs_alloc_cur_check calls _busy_trim (same side effects) as
> > > we wander around the free space btrees looking for a good chunk of
> > > space... and doesn't restore the busy record if it decides to consider a
> > > different extent.
> > >
> >
> > Yep. I was originally curious whether the more recent allocator rework
> > introduced this problem somehow, but AFAICT that just refactored the
> > relevant allocator code and this bug has been latent in the existing
> > code for quite some time. That's not hugely surprising given the rare
> > combination of conditions required to reproduce.
> >
> > > So I guess this "speculatively remove busy records and forget to restore
> > > them" behavior opens the door to the write allocating blocks that aren't
> > > yet free and nonbusy, right?  And the solution presented here is to
> > > avoid letting go of the busy record for the bmbt allocation, and if the
> > > btree split caller decides it really /must/ have that block for the bmbt
> > > it can force the log and try again, just like we do for a file data
> > > allocation?
> > >
> >
> > Yes, pretty much. The metadata allocation that is allowed to safely
> > reuse busy extents ends up invalidating a set of blocks during a NEAR
> > mode search (i.e. bmbt allocation), but ends up only using one of those
> > blocks. A data allocation immediately comes along next, finds one of the
> > other invalidated blocks and writes to it. A crash/recovery leaves the
> > invalidated busy block in its original metadata location having already
> > been written to by the dio.
> >
> > > Another solution could have been to restore the record if we decide not
> > > to go ahead with the allocation, but as we haven't yet committed to
> > > using the space, there's no sense in thrashing the busy records?
> > >
> >
> > That was my original thought as well. Then after looking through the
> > code a bit I thought that something like allowing the allocator to
> > "track" a reusable, but still busy extent until allocation is imminent
> > might be a bit more straightforward of an implementation given the
> > layering between the allocator and busy extent tracking code. IOW, we'd
> > split the busy trim/available and busy invalidate logic into two steps
> > instead of doing it immediately in the busy trim path. That would allow
> > the allocator to consider the same set of reusable busy blocks but not
> > commit to any of them until the allocation search is complete.
> >
> > However, either of those options require a bit of thought and rework
> > (and perhaps some value proposition justification for the complexity)
> > while the current trim reuse code is pretty much bolted on and broken.
> > Therefore, I think it's appropriate to fix the bug in one step and
> > follow up with a different implementation separately.
> >
> 
> Hi Brian,
> 
> This patch was one of my selected fixes to backport for v5.10.y.
> It has a very scary looking commit message and the change seems
> to be independent of any infrastructure changes(?).
> 
> The problem is that applying this patch to v5.10.y reliably reproduces
> this buffer corruption assertion [*] with test xfs/076.
> 
> This happens on the kdevops system that is using loop devices over
> sparse files inside qemu images. It does not reproduce on my small
> VM at home.
> 
> Normally, I would just drop this patch from the stable candidates queue
> and move on, but I thought you might be interested to investigate this
> reliable reproducer, because maybe this system exercises an error
> that is otherwise rare to hit.
> 
> It seemed weird to me that NOT reusing the extent would result in
> data corruption, but it could indicate that reusing the extent was masking
> the assertion and hiding another bug(?).
> 

Indeed, this does seem like an odd failure. The shutdown on transaction
cancel implies cancellation of a dirty transaction. This is not
necessarily corruption as much as just being the generic
naming/messaging related to shutdowns due to unexpected in-core state.
The patch in question removes some modifications to in-core busy extent
state during extent allocation that are fundamentally unsafe in
combination with how allocation works. This change doesn't appear to
affect any transaction directly, so the correlation may be indirect.

xfs/076 looks like it's a sparse inode allocation test, which certainly
seems relevant in that it is stressing the ability to allocate inode
chunks under free space fragmentation. If this patch further restricts
extent allocation by removing availability of some set of (recently
freed, busy) extents, then perhaps there is some allocation failure
sequence that was previously unlikely enough to mask some poor error
handling logic or transaction handling (like an agfl fixup dirtying a
transaction followed by an allocation failure, for example) that we're
now running into.

> Can you think of another reason to explain the regression this fix
> introduces to 5.10.y?
> 

Not off the top of my head. Something along the lines of the above seems
plausible, but that's just speculation at this point.

> Do you care to investigate this failure or shall I just move on?
> 

I think it would be good to understand whether there's a regression
introduced by this patch, a bug somewhere else or just some impedence
mismatch in logic between the combination of this change and whatever
else happens to be in v5.10.y. Unfortunately I'm not able to reproduce
if I pull just this commit back into latest 5.10.y (5.10.118). I've
tried with a traditional bdev as well as a preallocated and sparse
loopback scratch dev. Have you tested this patch (backport) in isolation
in your reproducer env or only in combination with other pending
backports?

Brian

> Thanks,
> Amir.
> 
> [*]
> : XFS (loop5): Internal error xfs_trans_cancel at line 954 of file
> fs/xfs/xfs_trans.c.  Caller xfs_create+0x22f/0x590 [xfs]
> : CPU: 3 PID: 25481 Comm: touch Kdump: loaded Tainted: G            E
>    5.10.109-xfs-2 #8
> : Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
> : Call Trace:
> :  dump_stack+0x6d/0x88
> :  xfs_trans_cancel+0x17b/0x1a0 [xfs]
> :  xfs_create+0x22f/0x590 [xfs]
> :  xfs_generic_create+0x245/0x310 [xfs]
> :  ? d_splice_alias+0x13a/0x3c0
> :  path_openat+0xe3f/0x1080
> :  do_filp_open+0x93/0x100
> :  ? handle_mm_fault+0x148e/0x1690
> :  ? __check_object_size+0x162/0x180
> :  do_sys_openat2+0x228/0x2d0
> :  do_sys_open+0x4b/0x80
> :  do_syscall_64+0x33/0x80
> :  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> : RIP: 0033:0x7f36b02eff1e
> : Code: 25 00 00 41 00 3d 00 00 41 00 74 48 48 8d 05 e9 57 0d 00 8b 00
> 85 c0 75 69 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d
> 00 f0 ff ff 0
> : RSP: 002b:00007ffe7ef6ca10 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> : RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f36b02eff1e
> : RDX: 0000000000000941 RSI: 00007ffe7ef6ebfa RDI: 00000000ffffff9c
> : RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> : R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000002
> : R13: 00007ffe7ef6ebfa R14: 0000000000000001 R15: 0000000000000001
> : XFS (loop5): xfs_do_force_shutdown(0x8) called from line 955 of file
> fs/xfs/xfs_trans.c. Return address = ffffffffc08f5764
> : XFS (loop5): Corruption of in-memory data detected.  Shutting down filesystem
> : XFS (loop5): Please unmount the filesystem and rectify the problem(s)
> 

