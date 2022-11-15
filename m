Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1390CC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 04:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKOEJV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiKOEIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 23:08:21 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F07F5AB
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 20:08:20 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b29so12953965pfp.13
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 20:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ifFtvBnkpPz0ioPgDnWikYYRpT/nAt7sd2bM0tOOi4E=;
        b=5nH4Q4wu1WSsadyf2dGnshvvEHnzGwrwbNjIuNqo+7SHVqN8VQwMa6/Wcw8JwWTMRA
         FnLosNaK5QCpLxkpqeluo2KyzRTy1VIX8ZgAZHJKkqC3DCmqiYPft6ysQnAj66R/2+7m
         bu9OmrUhHntriHfCBu54aiNS/KR1cIvRiMFVudoTA5jSHIUlgEasw5BHtu/kGi51KiPB
         NBwk929vlVO5rEiSL6LiBP6b2bPlmVgKLJPaMMJHUTv2UxtP6ZMMT+4/jjRJd/yKMpzb
         jqEosv/KTqS3yauceUu58SPFzRVX/xZIl7Vzm5r4FOBtwRm/x6zQNwaogoyWL5mQTwa9
         Zb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifFtvBnkpPz0ioPgDnWikYYRpT/nAt7sd2bM0tOOi4E=;
        b=FVop0zGWoSKKjjS3OBXhcOtLNKNfxhvrblF6flx4UuapU4EJHtDFn0r1SBKje2fLxq
         ncMEjKl4NC+KrUggFJ3vvbsoAtwyoBIGQv6OP7eP//5WOBoVEeNoqieb+cWQIFKfTKZ2
         kLweAEemy4Tbm49VsjXgVCMg4zJt+JOyw+3XPtYAabmr2/jcmKi9FtmP6LmRzABc5kNV
         /EVA8Ia4tNo/kdTnKzvZKsD8oygxqmJmRkyWi5NrFImx5M1EmWaj985Y7tT7My+KBapi
         wisFoCDLOvcJiGnna+piZC8+43MK0f9cTYS074AskQJbU0FWRd9E1lgcEl2nDeXcpnaR
         k/ow==
X-Gm-Message-State: ANoB5pmPdRMZ3zLnQCaJVo3sN9c4CSdC+lDUldtWokeIx0XZBSWdKuTl
        WKLxI1+dU3wQqYcTMwGuOYT8YQ==
X-Google-Smtp-Source: AA0mqf5pw6wkxPVW2Fw9WO5rhGAAFVHUKN7jMqVO8PUw0EMLDGsSHRF+TyyF28566MMHxIYSj03IGA==
X-Received: by 2002:a63:5a02:0:b0:476:adaa:371b with SMTP id o2-20020a635a02000000b00476adaa371bmr1979862pgb.61.1668485299714;
        Mon, 14 Nov 2022 20:08:19 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id c129-20020a621c87000000b00561b3ee73f6sm7808352pfc.144.2022.11.14.20.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 20:08:19 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ounFA-00EMt9-5r; Tue, 15 Nov 2022 15:08:16 +1100
Date:   Tue, 15 Nov 2022 15:08:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: retain the AGI when we can't iget an inode to
 scrub the core
Message-ID: <20221115040816.GY3600936@dread.disaster.area>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482971.1084685.9939611867095895186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473482971.1084685.9939611867095895186.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xchk_get_inode is not quite the right function to be calling from the
> inode scrubber setup function.  The common get_inode function either
> gets an inode and installs it in the scrub context, or it returns an
> error code explaining what happened.  This is acceptable for most file
> scrubbers because it is not in their scope to fix corruptions in the
> inode core and fork areas that cause iget to fail.
> 
> Dealing with these problems is within the scope of the inode scrubber,
> however.  If iget fails with EFSCORRUPTED, we need to xchk_inode to flag
> that as corruption.  Since we can't get our hands on an incore inode, we
> need to hold the AGI to prevent inode allocation activity so that
> nothing changes in the inode metadata.
> 
> Looking ahead to the inode core repair patches, we will also need to
> hold the AGI buffer into xrep_inode so that we can make modifications to
> the xfs_dinode structure without any other thread swooping in to
> allocate or free the inode.
> 
> Adapt the xchk_get_inode into xchk_setup_inode since this is a one-off
> use case where the error codes we check for are a little different, and
> the return state is much different from the common function.

The code look fine, but...

... doesn't this mean that xchk_setup_inode() and xchk_get_inode()
now are almost identical apart from the xchk_prepare_iscrub() bits?
This kinda looks like a lot of duplicated but subtly different code
- does xchk_get_inode() still need all that complexity if we are now
doing it in xchk_setup_inode()? If it does, why does
xchk_setup_inode() need to duplicate the code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
