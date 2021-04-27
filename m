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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1ADC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 13:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495D660FDC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 13:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbhD0NW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 09:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbhD0NW7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 09:22:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D6BC061574
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 06:22:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t13so4820075pji.4
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 06:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=dGxWdNlD7exUWc6my+Qjjf0c8KnSuoQTFwk6MGkdwqY=;
        b=KFhh6oGVv/qIwzFwEQdzUPo0ghvjzulbHlB/yvAwGELvRo8NHguwt/cH26RghkpRU9
         oNJ+ONzwYxFJjzm5v8hjjiIq8tU505Vt4VfBu3mwSecEPmGBBVobeWcDs8NHrBwDPwGZ
         kAmXlv7BofL/hrILqdBKhLMo2atX9UsfoWZbHcQ+NHa7L9kFpwdc3OXlSPtlatKMGQeE
         5CAHmpqjrAHd+nyU22Vng8PSXbkeMFDQstPgETBxSnkvODl3mYnU+9ugocL0PYWUTXQZ
         C9srp5BzcoY+ACPfrxykve7KbY7WqBPQpVktkffe6KEpp5e5G8EnHGTQEeMrsB0ITXhW
         z51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=dGxWdNlD7exUWc6my+Qjjf0c8KnSuoQTFwk6MGkdwqY=;
        b=h03kLcXxVYgLUMLw5uS6442lP7k+ufGRRlJpEHCqS+ZIdx8tqkQMBPuTDyMfTvQ8Z1
         rcjuFP84Ptwj0/9jonhq78FDHv3OnrWNSJLDtQ4DGkCsphw3q1ZMQFYp2owOww2jFoqm
         iXUBmDb0sNbE2ImErsCVQ1i72rmgQg71ue4xQOgFQvSIxOONE1dJz6Ydq5Zdbdb0JjR+
         iTwykTQdNj55FYyPWLRuqYgAz+WbV4Fgu34UJwNoNW2c5f9AiA9Q/nhM5yaPjWWte1GQ
         OBwgzowBcpqoRor2uXxLaEyoLt+G/6i8G/2D+uPEbuuBdQqRbnnBdVVieGVbkowTsTIT
         4pSg==
X-Gm-Message-State: AOAM531iRkEjkUf4TUGCKOPE1aoa+ItEYGL5t6v2Ohls29TiQ+YJqjD8
        wIyc9mJV20c9Ay+hc9LFQU1MA776QYQ=
X-Google-Smtp-Source: ABdhPJxY8HIpf09vxt87GP3AowCozGAr45fwgjZtOEcYTPGwo1Ch0Skkef/Q9cwgfYFCYzHOh0azNQ==
X-Received: by 2002:a17:90b:3551:: with SMTP id lt17mr1813437pjb.92.1619529734467;
        Tue, 27 Apr 2021 06:22:14 -0700 (PDT)
Received: from garuda ([122.171.173.111])
        by smtp.gmail.com with ESMTPSA id o127sm2783010pfd.147.2021.04.27.06.22.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Apr 2021 06:22:14 -0700 (PDT)
References: <20210423131050.141140-1-bfoster@redhat.com> <20210423131050.141140-3-bfoster@redhat.com> <8735vcm37j.fsf@garuda> <YIf2kWK/mSx4V8Rc@bfoster>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt blocks
In-reply-to: <YIf2kWK/mSx4V8Rc@bfoster>
Date:   Tue, 27 Apr 2021 18:52:11 +0530
Message-ID: <87zgxjlv5o.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Apr 2021 at 17:03, Brian Foster wrote:
> On Tue, Apr 27, 2021 at 03:58:16PM +0530, Chandan Babu R wrote:
>> On 23 Apr 2021 at 18:40, Brian Foster wrote:
>> > Introduce an in-core counter to track the sum of all allocbt blocks
>> > used by the filesystem. This value is currently tracked per-ag via
>> > the ->agf_btreeblks field in the AGF, which also happens to include
>> > rmapbt blocks. A global, in-core count of allocbt blocks is required
>> > to identify the subset of global ->m_fdblocks that consists of
>> > unavailable blocks currently used for allocation btrees. To support
>> > this calculation at block reservation time, construct a similar
>> > global counter for allocbt blocks, populate it on first read of each
>> > AGF and update it as allocbt blocks are used and released.
>> >
>> > Signed-off-by: Brian Foster <bfoster@redhat.com>
>> > ---
>> >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
>> >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
>> >  fs/xfs/xfs_mount.h              |  6 ++++++
>> >  3 files changed, 20 insertions(+)
>> >
>> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> > index aaa19101bb2a..144e2d68245c 100644
>> > --- a/fs/xfs/libxfs/xfs_alloc.c
>> > +++ b/fs/xfs/libxfs/xfs_alloc.c
>> > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
>> >  	struct xfs_agf		*agf;		/* ag freelist header */
>> >  	struct xfs_perag	*pag;		/* per allocation group data */
>> >  	int			error;
>> > +	uint32_t		allocbt_blks;
>> >
>> >  	trace_xfs_alloc_read_agf(mp, agno);
>> >
>> > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
>> >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
>> >  		pag->pagf_init = 1;
>> >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
>> > +
>> > +		/*
>> > +		 * Update the global in-core allocbt block counter. Filter
>> > +		 * rmapbt blocks from the on-disk counter because those are
>> > +		 * managed by perag reservation.
>> > +		 */
>> > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
>> 
>> pag->pagf_btreeblks gets incremented everytime a block is allocated to refill
>> AGFL (via xfs_alloc_get_freelist()). Apart from the allobt trees, blocks for
>> Rmap btree also get allocated from AGFL. Hence pag->pagf_btreeblks must be
>> larger than agf->agf_rmap_blocks.
>> 
>
> This function is actually to consume a block from the AGFL (as opposed
> to refill it).

Sorry, I meant to say "allocate a block from AGFL".

>
>> Can you please describe the scenario in which pag->pagf_btreeblks has a value
>> that is <= agf->agf_rmap_blocks?
>> 
>
> Ah, this was just an initialization quirk. I originally had an assert
> here and based the logic on the assumption that pagf_btreeblks >=
> agf_rmap_blocks, but alas:
>
> # mkfs.xfs -f -mrmapbt <dev>
> ...
> # xfs_db -c "agf 0" -c "p rmapblocks" -c "p btreeblks" <dev>
> rmapblocks = 1
> btreeblks = 0
> #

Thanks for clarifying my doubt.

The patch looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
