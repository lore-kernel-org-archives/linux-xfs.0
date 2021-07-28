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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B36CC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 06:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEBF60F9B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 06:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhG1G4q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 02:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhG1G4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 02:56:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF886C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 23:56:44 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e5so1523306pld.6
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 23:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=wnXTfws+vu+86rjokNuiUuMvk+/RCjQI9OcHFy/Uj+c=;
        b=umet5paTNJ2dpF+iNzobVFOUlPoUiVsJNIenr3sP5StWQsHLtpGo3A5D5kWqpWXo1P
         AbCV+ENdKDrnCGRc/tZU9YXV72WQ79xzYCOmppu38yEmSbb28/n3XN6NGKFaBPTVInkI
         eZkQ5i6puldZpeIjETprhHuRaQn1+cFoFke+p+pIxoh4RFZL6guQ1AejeEEuM4/dtMDv
         zHXco+L2Tfo9Rd3rza0xIM/nDKZUeazGGLsaTPSnjcMx+FWgYiCFKwu92XT1/rGtRbS2
         Gb7vAYJ41YwgdtdFm95BpXcoqrnYYmyHXTfHd2o9pzI9PPLPU8ZSFC7xosTdz+IeFQgQ
         Jr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=wnXTfws+vu+86rjokNuiUuMvk+/RCjQI9OcHFy/Uj+c=;
        b=mX5N9ow568ItgnHowIpsI1sXEQ8oTxaBn3IRG+1YQjqNOnWs73TcrZjkKfbf8fMZPu
         pZU3b6xbcw4qYBwXgt1qRrZQvCAeYcnmeSVCiqDdGYwBB8kkRM0MCaBG/xlch+piJ4aB
         L0mZZ5GOSAjmQ/4NZw2aiLqkiKLjyVbeV9Yqf3itdGI/646X8A0I2IBij1EMTtWgs/wF
         9ZMazd27s0nEA9yUlzoFJBtNNbV4MkRmIOZ4RYb6h9I2pU9zMRg7/+TBTZUtZwUCo+iH
         UadkyiA0XTqWBMKU49Lbdy3nVo87oTGTM1YGqvKyJCGumWCVrT+4BFp3cbAnQazXHS8D
         r1Kg==
X-Gm-Message-State: AOAM532vCGun7s4bYPPSpR4ahZvH4688mfBryDMbC2AT3qRvcLI/CmC+
        oJrpGFEccLYvU8AV0flpoY8eNgNSrRLq/A==
X-Google-Smtp-Source: ABdhPJw6PX7u67tkpyTjdeTk/5h7RGrlIBpe4wvricfOqI/xaouSg7132tmsgGG4e15uuQC865uibg==
X-Received: by 2002:a17:90b:1d84:: with SMTP id pf4mr26112830pjb.166.1627455404298;
        Tue, 27 Jul 2021 23:56:44 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id w3sm4984901pjq.12.2021.07.27.23.56.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 23:56:43 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-10-chandanrlinux@gmail.com> <20210727225400.GS559212@magnolia> <20210727230002.GT559212@magnolia> <20210727231713.GX664593@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 09/12] xfs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
In-reply-to: <20210727231713.GX664593@dread.disaster.area>
Date:   Wed, 28 Jul 2021 12:26:41 +0530
Message-ID: <875ywvvsd2.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 04:47, Dave Chinner wrote:
> On Tue, Jul 27, 2021 at 04:00:02PM -0700, Darrick J. Wong wrote:
>> On Tue, Jul 27, 2021 at 03:54:00PM -0700, Darrick J. Wong wrote:
>> > On Mon, Jul 26, 2021 at 05:15:38PM +0530, Chandan Babu R wrote:
>> > > This commit renames XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5 to allow a future
>> > > commit to extend bulkstat facility to support 64-bit extent counters. To this
>> > > end, this commit also renames xfs_bulkstat->bs_extents field to
>> > > xfs_bulkstat->bs_extents32.
>> > >
>> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> > > ---
>> > >  fs/xfs/libxfs/xfs_fs.h |  4 ++--
>> > >  fs/xfs/xfs_ioctl.c     | 27 ++++++++++++++++++++++-----
>> > >  fs/xfs/xfs_ioctl32.c   |  7 +++++++
>> > >  fs/xfs/xfs_itable.c    |  4 ++--
>> > >  fs/xfs/xfs_itable.h    |  1 +
>> > >  5 files changed, 34 insertions(+), 9 deletions(-)
>> > >
>> > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> > > index 2594fb647384..d760a969599e 100644
>> > > --- a/fs/xfs/libxfs/xfs_fs.h
>> > > +++ b/fs/xfs/libxfs/xfs_fs.h
>> > > @@ -394,7 +394,7 @@ struct xfs_bulkstat {
>> > >  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>> > >
>> > >  	uint32_t	bs_nlink;	/* number of links		*/
>> > > -	uint32_t	bs_extents;	/* number of extents		*/
>> > > +	uint32_t	bs_extents32;	/* number of extents		*/
>> >
>> > I wish I'd thought of this when we introduced bulkstat v5 so you
>> > wouldn't have had to do this.
>> >
>> > (I might have more to say in the bulkstat v6 patch review.)
>> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> Actually, I take that back, I have things to say /now/. :)
>>
>> Rather than adding a whole new ioctl definition which (I haven't looked
>> at the xfsprogs changes) likely creates a bunch of churn in userspace,
>> what if we added a XFS_IBULK_ flag for supporting large extent counts?
>> There's also quite a bit of reserved padding space in xfs_bulk_ireq, so
>> perhaps we should define one of those padding u64 as a op-specific flag
>> field that would be a way to pass bulkstat-specific flags to the
>> relevant operations.  That way the 64-bit extent counts are merely a
>> variant on bulkstat v5 instead of a whole new format.
>
> Yup, this.
>
> The only reason for creating a new revision of the ioctl is if we've
> run out of expansion space in the existing ioctl structures to cater
> for new information we want to export to userspace.
>

Thanks for the suggestion. I will make the relevant changes before posting the
next version of the patchset.

--
chandan
