Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EB9EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 06:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjHGGTS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 02:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjHGGTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 02:19:17 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31B0F9
        for <linux-xfs@vger.kernel.org>; Sun,  6 Aug 2023 23:19:15 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-564b8ea94c1so1675368a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 06 Aug 2023 23:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691389155; x=1691993955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ClmPjAiirPZ62vTNlugqFUoCAz9bfHnoyA9wRNRVb0g=;
        b=dJGww/k1bLvnUsqCu469uVR0T98FHNJYRkeQ1Z53407Z8oF8K40ugKASgcPHNSYbxB
         nlpoGLxVfDxBg/QZTGfYq6HilN1Xm7i8yT9f1yrOv3Kx/A/geeiv1A/cS7IVzmjJzC17
         wr59GjXvmDQvlZKiT0mm8LwQwAaQEXcroIuW/N+HmoLouPZVYMN0hZCXwG8mAdbxFAkb
         356Z/9yjd2zKnQaIuUTq1JGOEQoec2t30bEv+gnq8dewOthbNIbedsR+9x5FDzeyLx/e
         mcxgWCx089tNOd9y7DvLxKkskUnjkKUe3lFhLYIPCVCpX1Xi1OfNLBvCeKQfYle3rYjY
         qT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691389155; x=1691993955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClmPjAiirPZ62vTNlugqFUoCAz9bfHnoyA9wRNRVb0g=;
        b=gb0rmmEk+HPTToueXgpxrXMx7eFQQanuOVd6yVrwPOnb27eD3SCbPVFof1Sq7uaXPZ
         giS3/k8hg/qUftuXuaxBLJ78CZqLVofpG/EDI9Dw7cyWQiZp+lcGnp2Qxz+61U8jsbG+
         VDM0phZ1J1wLQ1WfGjIUoCdwAXz8mEfiym7IzeAhjTjlwuqcN4gB7OkKzh1mvtaD2CXB
         2vw6vXg+tWeGaxjn70ajhUrGmqy3jd+22vodnQpfWOqJ9+e4m/6fDMT0rGX5WF4S+Ajv
         lSd1lvGNF5xJZX5Na/ov0cqbuh44zqydAe5FEO31BxfUBF/3RkUK/6Vn2YLzB8JQnIfO
         qCoA==
X-Gm-Message-State: AOJu0YyZpskLSO7hEtRghhMojsjrlCjXVYjhheberIFeuQIt4PO19lqM
        CXcEVRiWumjOq74O0Uon2qZCF2su4fyBkGxsJ40=
X-Google-Smtp-Source: AGHT+IFZubWIS16SanJE6smWcrCFrkK4TlJTuO7xCYJZw0VRGkXydqd/2/ykiU6WK8Y2mmvaveo7mw==
X-Received: by 2002:a17:90a:c7cb:b0:269:2195:c322 with SMTP id gf11-20020a17090ac7cb00b002692195c322mr5763948pjb.41.1691389155318;
        Sun, 06 Aug 2023 23:19:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b00267bb769652sm5664189pjk.6.2023.08.06.23.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 23:19:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qStaB-002A6m-1M;
        Mon, 07 Aug 2023 16:19:11 +1000
Date:   Mon, 7 Aug 2023 16:19:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/9] xfs: fix online repair block reaping
Message-ID: <ZNCM35YJ/yroXI/n@dread.disaster.area>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:18:32PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> These patches fix a few problems that I noticed in the code that deals
> with old btree blocks after a successful repair.
> 
> First, I observed that it is possible for repair to incorrectly
> invalidate and delete old btree blocks if they were crosslinked.  The
> solution here is to consult the reverse mappings for each block in the
> extent -- singly owned blocks are invalidated and freed, whereas for
> crosslinked blocks, we merely drop the incorrect reverse mapping.
> 
> A largeish change in this patchset is moving the reaping code to a
> separate file, because the code are mostly interrelated static
> functions.  For now this also drops the ability to reap file blocks,
> which will return when we add the bmbt repair functions.
> 
> Second, we convert the reap function to use EFIs so that we can commit
> to freeing as many blocks in as few transactions as we dare.  We would
> like to free as many old blocks as we can in the same transaction that
> commits the new structure to the ondisk filesystem to minimize the
> number of blocks that leak if the system crashes before the repair fully
> completes.
> 
> The third change made in this series is to avoid tripping buffer cache
> assertions if we're merely scanning the buffer cache for buffers to
> invalidate, and find a non-stale buffer of the wrong length.  This is
> primarily cosmetic, but makes my life easier.
> 
> The fourth change restructures the reaping code to try to process as many
> blocks in one go as possible, to reduce logging traffic.
> 
> The last change switches the reaping mechanism to use per-AG bitmaps
> defined in a previous patchset.  This should reduce type confusion when
> reading the source code.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

Overall I don't see any red flags, so from that perspective I think
it's good to merge as is. THe buffer cache interactions are much
neater this time around.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

The main thing I noticed is that the deferred freeing mechanism ifo
rbulk reaping will add up to 128 XEFIs to the transaction. That
could result in a single EFI with up to 128 extents in it, right?

What happens when we try to free that many extents in a single
transaction loop? The extent free processing doesn't have a "have we
run out of transaction reservation" check in it like the refcount
item processing does, so I don't think it can roll to renew the
transaction reservation if it is needed. DO we need to catch this
and renew the reservation by returning -EAGAIN from
xfs_extent_free_finish_item() if there isn't enough of a reservation
remaining to free an extent?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
