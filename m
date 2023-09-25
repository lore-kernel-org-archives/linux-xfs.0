Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1E0CE79A5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjIYVoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjIYVoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:44:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BFEA2
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:44:14 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso50527725ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695678254; x=1696283054; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ICrFdllfJRcq7L2isLB19A5qsqr0qG/hxxqYVLfQrLA=;
        b=fu9jj6fi3Y+E/OS4EhbaQZI4AMQrLcCgewPsSrTOgCvNK9lj0FmPTGDGl7nLeh9e5h
         kR6+1sAbFo6N9o5lH2tQxaQxxGbclNgbR6NBTsArePwI+PGI1bc9bayLeTdxbbU7vZ9s
         tNWNjFI8cnyT6l4BvoNzB9TsPaDsWS875IBu3PZPzA+MgQA5m7vXPczfrEyBoZwgFJ1S
         oR+As0DDNBDlFAUSxSczEqTluDnvdz9bv+gnrUSrVhkeMsh0iWyhX8fSD8hGa1todQdM
         0cP4SlWJyUel6Onto9Sxk8UKjf3HjzCRlpYHwMYpqYcPyg8bye3oAClwrp8RifwyETnJ
         fnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695678254; x=1696283054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICrFdllfJRcq7L2isLB19A5qsqr0qG/hxxqYVLfQrLA=;
        b=Gqe+IVUZ18R/DEhn6Q/2fB/HQ/guxDdRgax0wExRoOB1I+SmRUsn8OIjcDy/gbr5QY
         sxoPbBcscplv6EvQJWe4ntGaG0tM9M4IEGKHkstfEJGYimnS6exj+OJEvjWTUeHihu1V
         MyQmSr22JfcwEdr+J2cLBDXseBw3X+ASQxX6ok13to4ynANKnyKcHOMKtd9m1ukbnDzA
         p0exoPiWEJFXIRdfzOSvocA96kh/U5r1PLGEi3vnnHFC/i5Le73h9ZU0usbyLHIis4Zd
         Ud2QDEwYkFqBNfUqTzaEjZYSKq3JdBR9ykUx37fINmWL+7UN4IDKd3WXvaWr50nJo3dj
         BC4w==
X-Gm-Message-State: AOJu0Yw6+TWLs0vNhBBG7g9Hmfl/5vI621UPs2EdBq7cuk4h4cgTdd3X
        3b+SvLWU3/5ttJpkQMXR9ZqwQQ==
X-Google-Smtp-Source: AGHT+IHKbIHFVi6XktLVugAN7L01HTfbjypbuLqc/g1kV0u5LVSpQqForGdbbgIyF/5z9mDi/eljcg==
X-Received: by 2002:a17:902:ea0e:b0:1c3:29c4:c4e4 with SMTP id s14-20020a170902ea0e00b001c329c4c4e4mr6634104plg.36.1695678253781;
        Mon, 25 Sep 2023 14:44:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b001bc0f974117sm9376295plr.57.2023.09.25.14.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 14:44:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qktNC-005ZLB-1u;
        Tue, 26 Sep 2023 07:44:10 +1000
Date:   Tue, 26 Sep 2023 07:44:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanbabu@kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix reloading entire unlinked bucket lists
Message-ID: <ZRH/KmCEjlUzTajS@dread.disaster.area>
References: <169565628450.1982077.8839912830345775826.stgit@frogsfrogsfrogs>
 <169565629026.1982077.12646061547002741492.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169565629026.1982077.12646061547002741492.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 08:38:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During review of the patcheset that provided reloading of the incore
> iunlink list, Dave made a few suggestions, and I updated the copy in my
> dev tree.  Unfortunately, I then got distracted by ... who even knows
> what ... and forgot to backport those changes from my dev tree to my
> release candidate branch.  I then sent multiple pull requests with stale
> patches, and that's what was merged into -rc3.
> 
> So.
> 
> This patch re-adds the use of an unlocked iunlink list check to
> determine if we want to allocate the resources to recreate the incore
> list.  Since lost iunlinked inodes are supposed to be rare, this change
> helps us avoid paying the transaction and AGF locking costs every time
> we open any inode.
> 
> This also re-adds the shutdowns on failure, and re-applies the
> restructuring of the inner loop in xfs_inode_reload_unlinked_bucket, and
> re-adds a requested comment about the quotachecking code.
> 
> Retain the original RVB tag from Dave since there's no code change from
> the last submission.
> 
> Fixes: 68b957f64fca1 ("xfs: load uncached unlinked inodes into memory on demand")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_export.c |   16 ++++++++++++----
>  fs/xfs/xfs_inode.c  |   48 +++++++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_itable.c |    2 ++
>  fs/xfs/xfs_qm.c     |   15 ++++++++++++---
>  4 files changed, 61 insertions(+), 20 deletions(-)

Looks good.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
