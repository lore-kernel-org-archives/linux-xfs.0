Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7238C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A6120758
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4t+T1xn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHQHoK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 03:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHQHoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 03:44:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD67C061388
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 00:44:09 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t11so7095821plr.5
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 00:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6dQPJ+3YUSDEbYuKMBdD/w935YiYtTwUXg+/iQC5KHw=;
        b=k4t+T1xnZvMULDBozkEhHAdYFPkR4ogKnpxE/hhRrmN9t+5uNvX3nTIz2n/LXhq3z4
         JIKoJWHdmp3L4rOK3EJr8Oeht6xoB3guoKCKKYniGlTBjQMSNpmUMwMZHqZFRBhlzTQ+
         ytluY+ySXLvllLiRlrAR0kCiK1ki5l36PU5jrSZDrAEN/PTERkIIyjqRsTEhbnqfmBob
         qhPCHUnrmSJz0j3ZPA72GNOs7RSlF4kE8P9urquGCoN/VsTxm2wgvlEP3AFE9VKU8Vyq
         VayzAC1lO5aQvA20N4/6SdS54xkSt4Ho6jPskB6b3V/W6PJPoiKkles4Z6JpHx0rKPb4
         tmSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dQPJ+3YUSDEbYuKMBdD/w935YiYtTwUXg+/iQC5KHw=;
        b=RiQfsYaYVq1ECi1QstnRCAx0ulwUdldCofa8UfNUPwnfPcVyrBueHzS4Fpz1S6CZ3T
         aL16IyzN460642JJv/VWXWzn5FD1ZD/elKgIXOwFfsFhCQqmYSaabCd/Y5shWns3zLJG
         FyiCrzyKfFZyWDu7gK9hIMoP2w818pUbEfxOLTlBX9jpxOTBDyQ+9M5eaeSJ4VpFUkMX
         2dype3Ab60/kzTelfb82SRpX+8ljNRXL0vrHDVHC3v1AhN6BtoWrq5gJpDxKyK46sQ9q
         qSK3LyofcA4OcdlW8ixj2qpi7faGFywJ6wwJXPjEuf5DXmtoJJdSFlSS2sGMCMw4Ht0r
         p/Vw==
X-Gm-Message-State: AOAM530WydMTWke9YvTnz4vGEVFSP7qbHxOz7YotxunU1+G16ycdOQ7U
        0uDh2eKYt7rRGWRrhBWH/Ro=
X-Google-Smtp-Source: ABdhPJyb8QcEPnEcccIjWrI5zKlIBlvauB4CenWyLhBZtpBBq0Ixew1rrBI8pzSowYNlFSfxDdFgsw==
X-Received: by 2002:a17:902:a703:: with SMTP id w3mr10025679plq.264.1597650248793;
        Mon, 17 Aug 2020 00:44:08 -0700 (PDT)
Received: from garuda.localnet ([171.48.27.213])
        by smtp.gmail.com with ESMTPSA id s17sm9543877pgm.63.2020.08.17.00.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 00:44:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V2 01/10] xfs: Add helper for checking per-inode extent count overflow
Date:   Mon, 17 Aug 2020 13:14:05 +0530
Message-ID: <1668045.YsUOKkzclo@garuda>
In-Reply-To: <20200817065123.GA23516@infradead.org>
References: <20200814080833.84760-1-chandanrlinux@gmail.com> <20200814080833.84760-2-chandanrlinux@gmail.com> <20200817065123.GA23516@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 17 August 2020 12:21:23 PM IST Christoph Hellwig wrote:
> > +int
> > +xfs_iext_count_may_overflow(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	int			nr_to_add)
> > +{
> > +	struct xfs_ifork	*ifp;
> > +	uint64_t		max_exts = 0;
> > +	uint64_t		nr_exts;
> > +
> > +	switch (whichfork) {
> > +	case XFS_DATA_FORK:
> > +		max_exts = MAXEXTNUM;
> > +		break;
> > +
> > +	case XFS_ATTR_FORK:
> > +		max_exts = MAXAEXTNUM;
> > +		break;
> > +
> > +	default:
> > +		ASSERT(0);
> > +		break;
> > +	}
> > +
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	nr_exts = ifp->if_nextents + nr_to_add;
> > +
> > +	if (nr_exts > max_exts)
> > +		return -EFBIG;
> > +
> > +	return 0;
> > +}
> 
> Maybe it's just me, but I would structure this very different (just
> cosmetic differences, though).  First add a:
> 
> static inline uint32_t xfs_max_extents(int whichfork)
> {
> 	return XFS_ATTR_FORK ? MAXAEXTNUM : MAXEXTNUM;
> }
> 
> to have a single place that determines the max number of extents.
> 
> And the simplify the helper down to:
> 
> int
> xfs_iext_count_may_overflow(
> 	struct xfs_inode	*ip,
> 	int			whichfork,
> 	int			nr_to_add)
> {
> 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> 	uint64_t		max_exts = xfs_max_extents(whichfork);
> 	uint64_t		nr_exts;
> 
> 	if (check_add_overflow(ifp->if_nextents, nr_to_add, &nr_exts) ||
> 	    nr_exts > max_exts))
> 		return -EFBIG;
> 	return 0;
> }
> 
> which actually might be small enough for an inline function now.
> 

I agree. I will make the suggested changes in the next version.

-- 
chandan



