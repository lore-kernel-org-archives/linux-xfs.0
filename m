Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44421E92704
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjJEORx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbjJEOP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:15:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBD249EE
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 22:13:44 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-692ada71d79so469375b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 22:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696482824; x=1697087624; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OT9nHL0DpDkpGa0i18PjBthOlwW1bR+IziAmXuFOdvg=;
        b=LoPuptLr1soWOMVl1g8ZlE7gUwn7jHN05chRGaZqEypFeCAnHffMzeeB9zIsfv6TjC
         FCOYhgy5W5aiu2ALhWFdGlv1eROBuHQ7ng3hHdnySBqWtYBQhebvgavqoK5ByB+O8kU6
         bQUtclEvF+J8BnHSRNWt4GGOCI8iE+7ORQCmpWIYGt5et6j9DGGUp/UaHvf5ny/uTwMY
         6mwJkrUY9baOj2tflEWv//+3JMacfWvMabBqJXpEOO/GjBLXbrPmTAXNnyotUHZ+4jCb
         4vW0qv35TR6NfC0PZUcwI6b0t8SEizJFAUc0Sftb5HWfAUYq5ckvnUYAH4kmtiqf0yGY
         N41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696482824; x=1697087624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT9nHL0DpDkpGa0i18PjBthOlwW1bR+IziAmXuFOdvg=;
        b=TBb6zV0N7HBSLwuOREPLTPxo5lVyAkeixWdy6lha0BudHGY4Ccvo1MVpmQ97Klw8Qr
         0maPG/S9NIX9Po5UphYA7DKHNjNhHmhChB4gFqgN2p0rQUWLgbXRz59XQwDDWOe0m6i8
         9JRhAc3U+l50Q5YoKCsYtknZh1Mqxn9AsTaJdTKBAiCt8/mej7bWn8S+yKTcZnm3EKoE
         dWe6SB7l17/yLucp7ZO12NmQv/wQJFeE2mnsWOkgmxX3wMxzJB7YpM84ubq5r6HLd259
         HXuE9ldRQljRHWb1m0ocYYMgYUGJtzilw29a671ndZh4/SUxj6CsGHjot7AONpGWQk83
         O/ew==
X-Gm-Message-State: AOJu0YzaA7+CtoDWofDFY+YSDEvF5FR5hKPCVEZ4E6+LHTMZw3ktj869
        asSHDH1poTx3H37iFqYMEroLdGdtzxNWjxRvH64=
X-Google-Smtp-Source: AGHT+IG+ZEngSbLliNRDOW+HzUpoSWRdamf34n0F5Tc3tNTdHXwdL3kW6Wore9CA7EW4+OPdmBTNtw==
X-Received: by 2002:a05:6a21:7782:b0:160:6a95:386a with SMTP id bd2-20020a056a21778200b001606a95386amr3868551pzc.25.1696482824290;
        Wed, 04 Oct 2023 22:13:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902ea0200b001bbd1562e75sm542646plg.55.2023.10.04.22.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 22:13:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoGg9-009e86-26;
        Thu, 05 Oct 2023 16:13:41 +1100
Date:   Thu, 5 Oct 2023 16:13:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: force small EFIs for reaping btree extents
Message-ID: <ZR5GBU4pF6VNtFC0@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059253.3312911.14232325060465598331.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059253.3312911.14232325060465598331.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:32:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Introduce the concept of a defer ops barrier to separate consecutively
> queued pending work items of the same type.  With a barrier in place,
> the two work items will be tracked separately, and receive separate log
> intent items.  The goal here is to prevent reaping of old metadata
> blocks from creating unnecessarily huge EFIs that could then run the
> risk of overflowing the scrub transaction.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   83 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_defer.h |    3 ++
>  fs/xfs/scrub/reap.c       |    5 +++
>  3 files changed, 91 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
