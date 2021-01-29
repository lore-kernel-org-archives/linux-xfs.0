Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBFDC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 07:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C755064E00
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 07:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhA2HlF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 02:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhA2Hko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jan 2021 02:40:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8058BC061574
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 23:40:04 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b8so4772092plh.12
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 23:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=pYYybBG2C9S7p4z+n/PiwccRT9EQZ6w2jFMutEaSBrI=;
        b=Fg+0xDbYs1Jtis/+zcjo4Wb1hV3TC3ON7E0aq2F8oRIzPkl6CuSXaTFcXn7wMQq/0H
         9KW+TiQ5eD8lD16dmYJlcgN69mE4fHNvdKlV6kvNJeeQlvrRiWhUNHr0CDF8gbSIsbLM
         kjgDGxU53zKSvU5KE2xCs2+kMCRWqI3EfC3B0OJoTNm24W20dqs4/NMLUnQgFB0q7liM
         eIqq1iI9VUx6QW21hMoCigcEf4HEqLXKE2EgKdsLj6UgllVwQM3tVNvuxRdPC9ysmr9G
         LvH4cl6MFaC/jKktl+P0HO9ZDJhnyz6mk7tCh+9dN9q98oBFC/pvn016Z9MFXQkBDfJ/
         dRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=pYYybBG2C9S7p4z+n/PiwccRT9EQZ6w2jFMutEaSBrI=;
        b=Btf7qIvEYb31Y/7fumjv7xqWqnfaaALgAz21G8u8Lu+yrBNMao/vjQmw7w7cOd8rE7
         ATlY+AepJWZnOi+iO9as2fnIu6ZcdImKPWLSNOaYmvAPEwkxESL/fQUoloH7kGq0+Meg
         odC9UXwXkVxgvvpEq35vOboZCaajiovy8NIk/iIxpNwklFf6CB7hRlOYTl9vUihKMQiT
         AJQwpYPe9VQe0AWNyEkzQ1sfxkpmkdCDnZPiZJsN7KxBxbQ422ucfzR953pJnOljpFcW
         0xv91Fbhja24ZjAVhyIMyQI3mIPsYHdn8U1rDNgspVJaayM0NhY3it8f7cWLKs3bgEyb
         rHbA==
X-Gm-Message-State: AOAM532EjpUr7vwv9UQsVYr6DkT8ol5zybeK2zC6GQiU2K8+i/fJR9q4
        jDbO9sgRv1OIxDt1MxhSkLY=
X-Google-Smtp-Source: ABdhPJzLvwBUdfSSb+RG755RRa3/xzPmOOCV+nY6kqKjByuRNNtsNZ3CuiuYySHt2CmVAcQDd2zf8Q==
X-Received: by 2002:a17:90b:4d06:: with SMTP id mw6mr3363699pjb.24.1611906004087;
        Thu, 28 Jan 2021 23:40:04 -0800 (PST)
Received: from garuda ([122.179.112.28])
        by smtp.gmail.com with ESMTPSA id z13sm7891451pgf.89.2021.01.28.23.40.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Jan 2021 23:40:03 -0800 (PST)
References: <20210127090537.2640164-1-chandanrlinux@gmail.com> <20210128153412.GD2599027@bfoster> <20210128174447.GS7698@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: Fix 'set but not used' warning in xfs_bmap_compute_alignments()
In-reply-to: <20210128174447.GS7698@magnolia>
Date:   Fri, 29 Jan 2021 13:10:00 +0530
Message-ID: <87k0rwi433.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jan 2021 at 23:14, Darrick J. Wong wrote:
> On Thu, Jan 28, 2021 at 10:34:12AM -0500, Brian Foster wrote:
>> On Wed, Jan 27, 2021 at 02:35:37PM +0530, Chandan Babu R wrote:
>> > With both CONFIG_XFS_DEBUG and CONFIG_XFS_WARN disabled, the only reference to
>> > local variable "error" in xfs_bmap_compute_alignments() gets eliminated during
>> > pre-processing stage of the compilation process. This causes the compiler to
>> > generate a "set but not used" warning.
>> >
>> > Reported-by: kernel test robot <lkp@intel.com>
>> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> > ---
>> > This patch is applicable on top of current xfs-linux/for-next branch.
>> >
>> >  fs/xfs/libxfs/xfs_bmap.c | 9 ++++-----
>> >  1 file changed, 4 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> > index 2cd24bb06040..ba56554e8c05 100644
>> > --- a/fs/xfs/libxfs/xfs_bmap.c
>> > +++ b/fs/xfs/libxfs/xfs_bmap.c
>> > @@ -3471,7 +3471,6 @@ xfs_bmap_compute_alignments(
>> >  	struct xfs_mount	*mp = args->mp;
>> >  	xfs_extlen_t		align = 0; /* minimum allocation alignment */
>> >  	int			stripe_align = 0;
>> > -	int			error;
>> >
>> >  	/* stripe alignment for allocation is determined by mount parameters */
>> >  	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
>> > @@ -3484,10 +3483,10 @@ xfs_bmap_compute_alignments(
>> >  	else if (ap->datatype & XFS_ALLOC_USERDATA)
>> >  		align = xfs_get_extsz_hint(ap->ip);
>> >  	if (align) {
>> > -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
>> > -						align, 0, ap->eof, 0, ap->conv,
>> > -						&ap->offset, &ap->length);
>> > -		ASSERT(!error);
>> > +		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
>> > +			align, 0, ap->eof, 0, ap->conv, &ap->offset,
>> > +			&ap->length))
>> > +			ASSERT(0);
>>
>> I was wondering if we should just make xfs_bmap_extsize_align() return
>> void and push the asserts down into the function itself, but it looks
>> like xfs_bmap_rtalloc() actually handles the error. Any idea on why we
>> might have that inconsistency?
>
> It only returns nonzero if isrt (the fifth parameter) is nonzero, and
> only if the requested range is still not aligned to the rt extent size
> after aligning it and eliminating any overlaps with existing extents.
>

Adding to what Darrick has mentioned above ...

Space on realtime devices are tracked at a granularity of "rextsize"
bytes. Each bit held in the data blocks of xfs_mount->m_rbmip represents usage
status of a single rextsized block. Most likely this seems to be underlying
reason for strict allocation alignment requirements for realtime files.

--
chandan
