Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B22C0015E
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 06:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjHCGey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 02:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjHCGey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 02:34:54 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC4DE7D
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 23:34:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-686f090310dso564184b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Aug 2023 23:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691044492; x=1691649292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sc8zCf63P5fWFiV1/wfS6d15JwAfbwD1+aHehBcQug4=;
        b=WuEuI3e1i9LcLRzGIeAfktuCvg1EImL6sPgQUj9IjR6L/ZOWJgQvDvTjuFrUHqTfU2
         Q4PPhZZvF8Pa3+eNrjfiLEXB0pB7x101uANncqZBT0Qy2Qptef31e6DguAA7pxFJHul1
         KQ8eBJQ1aAeEcx1T4r7SDUWQ62SL3T0jlaa6cqUIgYuSN6dntXF4lMPCqf7DkMD8PF72
         accFqtSzWVyj5JKMe3bY2J/WooETWab+/Zf1x5iFGvUFE1NszjI/lME+Pu96XbvXvQRK
         QsfpCKgZ/Q26EIvpnQKSEBkC73OlQfIZ73VO8IqGRa41hiKCEG1YaDrJyxhYN5BNi7kq
         Dmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691044492; x=1691649292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sc8zCf63P5fWFiV1/wfS6d15JwAfbwD1+aHehBcQug4=;
        b=l4Yty58oqFp3q+Tkc0/7K4QJqhzUwDTk/zqm0gpxPkLKxXvPDI5m99uYlsM+RHf8xE
         1Ow3nIgRoIxXzAjoxMB64sNGSH3uFTVoPxwZiDwDABWsEOQ4IPsomqsHdDkV6D4bABNI
         noCQpoy85ojMvkxh5B9Br9OIxdPKyM8pe6Lnk6VH/FXKYdku+7cJ7T+f3VVxtGdRqKQU
         H9+jf7bcjRSP2P++oo3yZFS3W3h5VpEiDuG7QTRt5H8iwgSo0aNn9L0FH/lxpu2ZoVxy
         rqQxl6gR85IW223Xg1gV/2RVBaGWcGfgCDgblMiR9wdeDeUJUvAgqCwzAGgVV30M2JZo
         beFw==
X-Gm-Message-State: ABy/qLYd1GsEJF3znJhdjVz6/kIiIOIhHdAywWPDWU2MByaWLYdGKyLt
        jV7SdDYewzYLIEuyaHUgrCoqnNE5f127ez5lfrw=
X-Google-Smtp-Source: APBJJlFub5xHeljJPS+Hse3WNll7AqSOG7Mbo2V30G4bwQzJSVx6zeZ0/PrjaPeV1BSHeneDi5k/nQ==
X-Received: by 2002:a05:6a00:1ac9:b0:668:6445:8931 with SMTP id f9-20020a056a001ac900b0066864458931mr22524322pfv.29.1691044492211;
        Wed, 02 Aug 2023 23:34:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id p2-20020a62ab02000000b006826c9e4397sm12074390pff.48.2023.08.02.23.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 23:34:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qRRv6-000Qa9-0U;
        Thu, 03 Aug 2023 16:34:48 +1000
Date:   Thu, 3 Aug 2023 16:34:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize fs summary counters for online fsck
Message-ID: <ZMtKiMSVOtk7CbmL@dread.disaster.area>
References: <20230803052218.GE11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803052218.GE11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 02, 2023 at 10:22:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the fscounters scrubber notices incorrect summary counters, it's
> entirely possible that scrub is simply racing with other threads that
> are updating the incore counters.  There isn't a good way to stabilize
> percpu counters or set ourselves up to observe live updates with hooks
> like we do for the quotacheck or nlinks scanners, so we instead choose
> to freeze the filesystem long enough to walk the incore per-AG
> structures.
> 
> Past me thought that it was going to be commonplace to have to freeze
> the filesystem to perform some kind of repair and set up a whole
> separate infrastructure to freeze the filesystem in such a way that
> userspace could not unfreeze while we were running.  This involved
> adding a mutex and freeze_super/thaw_super functions and dealing with
> the fact that the VFS freeze/thaw functions can free the VFS superblock
> references on return.
> 
> This was all very overwrought, since fscounters turned out to be the
> only user of scrub freezes, and it doesn't require the log to quiesce,
> only the incore superblock counters.  We prevent other threads from
> changing the freeze level by calling freeze_super_excl with a custom
> freeze cookie to keep everyone else out of the filesystem.
> 
> The end result is that fscounters should be much more efficient.  When
> we're checking a busy system and we can't stabilize the counters, the
> custom freeze will do less work, which should result in less downtime.
> Repair should be similarly speedy, but that's in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/fscounters.c |  198 ++++++++++++++++++++++++++++++++++-----------
>  fs/xfs/scrub/fscounters.h |   20 +++++
>  fs/xfs/scrub/scrub.c      |    6 +
>  fs/xfs/scrub/scrub.h      |    1 
>  fs/xfs/scrub/trace.h      |   26 ++++++
>  5 files changed, 203 insertions(+), 48 deletions(-)
>  create mode 100644 fs/xfs/scrub/fscounters.h

Code changes look ok, though I am wondering why struct
xchk_fscounters needs to be moved to it's own header file? AFAICT it
is still only used by fs/xfs/scrub/fscounters.c, so I'm not sure
what purpose the new header file serves....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
