Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35307C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 06:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BFC6139A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 06:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFAGoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 02:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhFAGoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 02:44:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C0FC061574
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 23:42:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q15so9933712pgg.12
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 23:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=B9flEdjtWT8sI6XmEHx5R1ue22RDHTwR5gHfh6ldPAc=;
        b=d9uO7/MO6ZFWafz90FkSUZWhaW5y36W4pZlouH7uvWi7iGLqfCM/PAQJw1My467s6U
         Dfqsjr/6RGumYyPqkkCBIhxGP/u+eNZ6PwlTVDOxLp9kv+nnCipHUA0k/Yc+0K9HGE/z
         VoWowplzWaWsD0IvPWypl0ltiP/UUm/MtF7SkMOhHwlu4W1Zx5vxdDptuf27RWIuHXRb
         VeUMILjlO3exLI6UfBj2CkgE0htaSi5WlH4puEOjCR/rqU8B86AUBTjC15GtldpCDGNZ
         9WgFIs9PfVzoN9z4tJ87OWNVacQ9C0IYIlxD5BitaYqvQvs/gRNis/jsvB2Qpz8RKYow
         qg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=B9flEdjtWT8sI6XmEHx5R1ue22RDHTwR5gHfh6ldPAc=;
        b=aDP2NBbWIqpcsLIVjrTJYjd8b5r2Mti7cIMtbM7OkupCKgfwvBnl/CFsKInxyRGSjm
         LDJ6Dl+8dZbDonzNr4ay0EBD6/EdtcM/YPhRn+5gm9iCCDoygy+MnuhDKzxYUL8j+N1F
         gBT0nQQioKmSQFOdcA/4attWgarsGgUyZNMDw5e1sw11jtfKj47fNwGqqkCxwMzieX2K
         iKGafNONOCURyDH9qsIdwuziPz1j4YJ6WTZn5LZzpwikisyhffTguK6/H6h4uVj8G58X
         QxrOARSgiMcqOYXeLAFnsJAzcB6hiZCCBnfQSrrz/jF/nWiXc9PdLLvn4pRxePiUxj9p
         7uDg==
X-Gm-Message-State: AOAM532Ah+ohgZJ0cSEqdx+otRQDUBh3nfgXjGnBHdw4gBLxuj6YMaRY
        gZjCGQpq6u7xWI3YXQxD8tG7ntPp/E3XOw==
X-Google-Smtp-Source: ABdhPJxBMUAePdZWBmx1NbAhB4FprR3Lz0lphVlCwcDxuv+KKNS/sIbNk9adYA2AK7/Jld1hFX0G4A==
X-Received: by 2002:a63:a54b:: with SMTP id r11mr12631238pgu.76.1622529760072;
        Mon, 31 May 2021 23:42:40 -0700 (PDT)
Received: from garuda ([171.61.76.81])
        by smtp.gmail.com with ESMTPSA id l20sm12294491pjq.38.2021.05.31.23.42.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 May 2021 23:42:39 -0700 (PDT)
References: <20210527045202.1155628-1-david@fromorbit.com> <20210527045202.1155628-4-david@fromorbit.com> <87eednukpk.fsf@garuda> <87czt7uk7v.fsf@garuda> <20210531232820.GT664593@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_itruncate_extents has no extent count limitation
In-reply-to: <20210531232820.GT664593@dread.disaster.area>
Date:   Tue, 01 Jun 2021 12:12:36 +0530
Message-ID: <871r9mytk3.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01 Jun 2021 at 04:58, Dave Chinner wrote:
> On Mon, May 31, 2021 at 06:35:40PM +0530, Chandan Babu R wrote:
>> On 31 May 2021 at 18:25, Chandan Babu R wrote:
>> > On 27 May 2021 at 10:21, Dave Chinner wrote:
>> >> From: Dave Chinner <dchinner@redhat.com>
>> >>
>> >> Ever since we moved to freeing of extents by deferred operations,
>> >> we've already freed extents via individual transactions. Hence the
>> >> only limitation of how many extents we can mark for freeing in a
>> >> single xfs_bunmapi() call bound only by how many deferrals we want
>> >> to queue.
>> >>
>> >> That is xfs_bunmapi() doesn't actually do any AG based extent
>> >> freeing, so there's no actually transaction reservation used up by
>> >> calling bunmapi with a large count of extents to be freed. RT
>> >> extents have always been freed directly by bunmapi, but that doesn't
>> >> require modification of large number of blocks as there are no
>> >> btrees to split.
>> >>
>> >> Some callers of xfs_bunmapi assume that the extent count being freed
>> >> is bound by geometry (e.g. directories) and these can ask bunmapi to
>> >> free up to 64 extents in a single call. These functions just work as
>> >> tehy stand, so there's no reason for truncate to have a limit of
>> >> just two extents per bunmapi call anymore.
>> >>
>> >> Increase XFS_ITRUNC_MAX_EXTENTS to 64 to match the number of extents
>> >> that can be deferred in a single loop to match what the directory
>> >> code already uses.
>> >>
>> >> For realtime inodes, where xfs_bunmapi() directly frees extents,
>> >> leave the limit at 2 extents per loop as this is all the space that
>> >> the transaction reservation will cover.
>> >>
>> >> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> >> ---
>> >>  fs/xfs/xfs_inode.c | 15 ++++++++++++---
>> >>  1 file changed, 12 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> >> index 0369eb22c1bb..db220eaa34b8 100644
>> >> --- a/fs/xfs/xfs_inode.c
>> >> +++ b/fs/xfs/xfs_inode.c
>> >> @@ -40,9 +40,18 @@ kmem_zone_t *xfs_inode_zone;
>> >>
>> >>  /*
>> >>   * Used in xfs_itruncate_extents().  This is the maximum number of extents
>> >> - * freed from a file in a single transaction.
>> >> + * we will unmap and defer for freeing in a single call to xfs_bunmapi().
>> >> + * Realtime inodes directly free extents in xfs_bunmapi(), so are bound
>> >> + * by transaction reservation size to 2 extents.
>> >>   */
>> >> -#define	XFS_ITRUNC_MAX_EXTENTS	2
>> >> +static inline int
>> >> +xfs_itrunc_max_extents(
>> >> +	struct xfs_inode	*ip)
>> >> +{
>> >> +	if (XFS_IS_REALTIME_INODE(ip))
>> >> +		return 2;
>> >> +	return 64;
>> >> +}
>> >>
>> >>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
>> >>  STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
>> >> @@ -1402,7 +1411,7 @@ xfs_itruncate_extents_flags(
>> >>  	while (unmap_len > 0) {
>> >>  		ASSERT(tp->t_firstblock == NULLFSBLOCK);
>> >>  		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
>> >> -				flags, XFS_ITRUNC_MAX_EXTENTS);
>> >> +				flags, xfs_itrunc_max_extents(ip));
>> >>  		if (error)
>> >>  			goto out;
>> >
>> > The list of free extent items at xfs_defer_pending->dfp_work could
>> > now contain XFS_EFI_MAX_FAST_EXTENTS (i.e. 16) entries in the worst case.
>
> Yes, but we do exactly this when freeing a large fragmented directly
> block. That is, we ask xfs_bunmapi to unmap a 64kB range regardless
> of how many extents map that range.
>
> IOWs, the limitation in extent count placed in
> xfs_itruncate_extents() doesn't actually address the underlying
> problem - it's just a band-aid that has been placed over the easy to
> trigger transaction overrun symptom that has always been present in
> the underlying extent freeing code.
>
>> > For a single transaction, xfs_calc_itruncate_reservation() reserves space for
>> > logging only 4 extents (i.e. 4 exts * 2 trees * (2 * max depth - 1) * block
>> > size).
>>
>> ... Sorry, I meant to say "xfs_calc_itruncate_reservation() reserves log space
>> required for freeing 4 extents ..."
>
> My point exactly - the code has always had a mismatch between
> reservations and what we can stuff into an EFI.  EFIs are unbound in
> size, so having a fixed "4 extents per EFI" reservation limit has
> never made any real sense given that unmaping a 64kB directory block
> on a 1kb block size filesystem has a worst case of freeing 64
> extents in a single transaction. As I said above, the limitations
> placed on xfs_itruncate_extents is largely a hack because it doesn't
> address other avenues to the same overruns...
>

Ok. Thanks for the explanation.

> This "4 extents per transaction" reservation makes even less sense
> now that extents are freed by defer ops, not by the transaction that
> unmaps them. We've completely decoupled extent freeing from the
> higher level code that unmaps them, and so now the freeing
> transactions are independent of the high level code that runs the
> freeing operations.
>
> IOWs, having a reservation big enough to free a single extent is all
> we should need now as we can break the extent freeing up into
> individual transactions and still have them complete atomically even
> after a crash. That's where I'm trying to get to here, but it's
> clear that I need to refine the code a bit further such that we only
> allow individual EFIs to queue up and free multiple extents within
> an AG to be freed in the same transaction....

Ok. That should limit the number of CNTBT/BNOBT blocks being logged by a
transaction which is freeing extents.

>
> FWIW, I suspect that the right thing to do here is make use of the
> xfs_defer_finish_one() mechanism for relogging the remaining intents
> in work list while it is processing that list. All we need is for
> xfs_extent_free_finish_item() to return -EAGAIN instead of running
> the free transaction, and we will log the completed EFDs and the
> remaining EFIs to be run and roll the transaction.
>
> Hence we can control exactly when we roll the extent freeing
> transaction (e.g. when the next extent to free is in a different AG
> to the one we've just been freeing extents in) and as a result we
> can define a fixed transaction reservation for extent freeing that
> works in every situation without having to care about arbitrary
> "how many extents can we unmap without overrun" concerns.
>

That sounds perfect.

> That's the goal here - fixed, small reservation for extent freeing
> that is decoupled from and independent of the number of extents that
> need to be freed atomically by the high level operation...
>
> Hence I think that a minor amount of rework will allow the EFI code
> to log large numbers of extents to be freed whilst still processing
> them within single AG free space tree modification reservation
> bounds...


--
chandan
