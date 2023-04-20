Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40806C6FD18
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 00:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjDTAa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 20:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjDTAa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 20:30:56 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0651BC2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 17:30:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b87d23729so423950b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 17:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681950654; x=1684542654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JaN8eOfJ8IA1CzYBvo8OtaFFh1t/RSWD4uJIhHdNlgY=;
        b=KVy58f5gHiQEBLypCmpuoGY4zkJFIbkyGZOS3EioxMKvjbkHVgvrI1Z9qXyKsT7ips
         uqZwiJoP0Febcx/Vkh7p9X2XrB6+chAbuAMrZ74bGn7tGapCgVdXTcTPML34J6N0Ux6M
         5L5PNgeWZvhT97Je0OzlWhdDIhvozkB4MbwEVZohX6tqqswjSSYQr6vBVYQwUQ5SUAji
         0Smcxz2E6EC8DHdil8Y8+qbqRxG4WkiOWH/VZDDpMtwGUDIUZ8UyTBhlmg8lcuTp+QtY
         Yx7d74yvXpQvdrdMFnEaOCbzXH81ujVBSXNuAFODyF2o3ivz76veiiknVckfxslt5fPG
         7SYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681950654; x=1684542654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JaN8eOfJ8IA1CzYBvo8OtaFFh1t/RSWD4uJIhHdNlgY=;
        b=VffWg4Pns3yBU72ijnl9pRZOfQwMBuqMNOdC5qv+kHv/AGzOOfAfx7cj8eZsQV7cnX
         5DWX6Vcb9zJqQ6gpnjZBz9HPvgoScgIlDkZB3HRVfK3GjA3EzCyQ+OyFWZmPY5w85aSr
         i2ZGYudumB0fquCdIpJNHy3dtJUNy5GBk9KWeYNYJLGYdArtcC3RJ/+Zg2MUBLoeFp2c
         +lpu+WNqc+R3jt8fdqdA0JFM6IyvkBhGcmkOpMqG+9Skdg/ufrAkDAJKIaOFXA5LIxcv
         jUQnq0pVb7ResecfORH6gVCufHeTJQEaEAlCL45A8g2hQ1Qj6y5QKbAc7WGutKFB/P3G
         Y40Q==
X-Gm-Message-State: AAQBX9fS0KzcDlYreduaBgdL8Rzn+ltIEpJdlK5NkgO3Iz2OMTys8NiL
        19uDbH0YEHZeGKx7VDT7Cns70g==
X-Google-Smtp-Source: AKy350aIpEuDnPShZEq52ng3gTXhK+tgbDTFGjtXcbTV1hKS80vwH2NBxVfMrEvWkSSXP7PYTU0jJA==
X-Received: by 2002:a05:6a00:21d3:b0:627:f85c:b7ee with SMTP id t19-20020a056a0021d300b00627f85cb7eemr5784150pfj.2.1681950654410;
        Wed, 19 Apr 2023 17:30:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id o131-20020a62cd89000000b0063b7bd920b3sm7345pfg.15.2023.04.19.17.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 17:30:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppICI-005SdU-SE; Thu, 20 Apr 2023 10:30:50 +1000
Date:   Thu, 20 Apr 2023 10:30:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple
 extents
Message-ID: <20230420003050.GX3223426@dread.disaster.area>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-3-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414225836.8952-3-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2023 at 03:58:36PM -0700, Wengang Wang wrote:
> At log recovery stage, we need to split EFIs with multiple extents. For each
> orginal multiple-extent EFI, split it into new EFIs each including one extent
> from the original EFI. By that we avoid deadlock when allocating blocks for
> AGFL waiting for the held busy extents by current transaction to be flushed.
> 
>  For the original EFI, the process is
>  1. Create and log new EFIs each covering one extent from the
>     original EFI.
>  2. Don't free extent with the original EFI.
>  3. Log EFD for the original EFI.
>     Make sure we log the new EFIs and original EFD in this order:
>       new EFI 1
>       new EFI 2
>       ...
>       new EFI N
>       original EFD
>  The original extents are freed with the new EFIs.

We may not have the log space available during recovery to explode a
single EFI out into many EFIs like this. The EFI only had enough
space reserved for processing a single EFI, and exploding a single
EFI out like this requires an individual log reservation for each
new EFI. Hence this de-multiplexing process risks running out of log
space and deadlocking before we've been able to process anything.

Hence the only option we really have here is to replicate how CUIs
are handled.  We must process the first extent with a whole EFD and
a new EFI containing the remaining unprocessed extents as defered
operations.  i.e.

1. free the first extent in the original EFI
2. log an EFD for the original EFI
3. Add all the remaining extents in the original EFI to an xefi chain
4. Call xfs_defer_ops_capture_and_commit() to create a new EFI from
   the xefi chain and commit the current transaction.

xfs_defer_ops_capture_and_commit() will then add a work item to the
defered list which will come back to the new EFI and process it
through the normal runtime deferred ops intent processing path.

The first patch changed that path to only create intents with a
single extent, so the continued defer ops would then do the right
thing with that change in place. However, I think that we also need
the runtime code to process a single extent per intent per commit in
the same manner as above. i.e. we process the first extent in the
intent, then relog all the remaining unprocessed extents as a single
new intent.

Note that this is similar to how we already relog intents to roll
them forward in the journal. The only difference for single extent
processing is that an intent relog duplicates the entire extent list
in the EFD and the new EFI, whilst what we want is the new EFI to
contain all the extents except the one we just processed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
