Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E182C83F12
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 01:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbjH3BCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 21:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239675AbjH3BCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 21:02:08 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF754CCE
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68c3ec0578bso2395189b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693357319; x=1693962119; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5A8WVMnaBdy/hKdSbh9jusfctNkObh6QifQBWQBf5xw=;
        b=wJ2avicFJVZqvA4ihcSicl9mvMS8xEw7Vd/DSgzSzO2dL3MWFD6qUAIsyfZo6ZcBSI
         cXGAbZXMg0VLzObFDmjld2Mw32obe2ZRlMphhtjVxZ5VYC9cHDwyrBdIwmuCeBfk4uJ3
         8HMF6qKkiI3I68nZa6zmevinRel5r41J8RHYYg8no+gIUK3wi4mWO7NuWCanMvxtejpq
         Wy+ku4Ifcjl8eM4W4EphDIbvd4TgW1odnUJ/2g1+aSAjt1IPD+EcvH5BRSVCQ92QvYQF
         GU8JH9AMKWG9OSPklI6Hh+J6y2vwaEL6yGSpKrhlIZnVRcviCaSJS7m9m0lmWIRafWe3
         xHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693357319; x=1693962119;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5A8WVMnaBdy/hKdSbh9jusfctNkObh6QifQBWQBf5xw=;
        b=hBXoAN9Jo77w283qvV7G4nML+38l5hpGVlUb/Kx7nk6M8cnGd0BN82asl+T5HZa597
         xgu4kzqhQqMgNlXch2n4JfyTVdMhR3GUeVlN7i1y2EC2C59G1yMfoNy7JDBpTedIFUsc
         W39UgoRPFufUFnSwV1b297H18SBFcyGPsZhmi4rlQWpK8YiYpvH/cJSIOYsAJjhUP5sW
         HMEZiQeJHMcHofEaD77G5yhtb2XYJDnMv7KWRfORTlF8A6EzQ1sjWT/wX8LLcQYtLbpe
         0gldbwj0TFn3m+Fcb5kTpCYftdaPtV17qA+xlegksuwb4klIhhXpcu/943rbyDw4QjVl
         A5jQ==
X-Gm-Message-State: AOJu0Yz0QucX3Hg9LwN/j6aXsV5BLEQWzbVMAT4NEK2hivSO4tV+B0Lv
        56M/+zGEn97rsNGO5L1QCYCsfAMdGULbMStXlKE=
X-Google-Smtp-Source: AGHT+IFxreL8BhFhkwXz8iusx3bxEcuGgRLnIGI3OrD61M/iK0O1cVx+85Xe5QjGQReBtOk2N3/8Kg==
X-Received: by 2002:a17:902:d713:b0:1bd:f1a7:8293 with SMTP id w19-20020a170902d71300b001bdf1a78293mr607687ply.69.1693357319219;
        Tue, 29 Aug 2023 18:01:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00198d7b52eefsm9964942plg.257.2023.08.29.18.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:01:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qb8qn-008I71-1p;
        Wed, 30 Aug 2023 10:14:25 +1000
Date:   Wed, 30 Aug 2023 10:14:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, sandeen@sandeen.net,
        Dave Chinner <dchinner@redhat.com>, ritesh.list@gmail.com,
        tglx@linutronix.de, peterz@infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v2 0/4] xfs: fix cpu hotplug mess
Message-ID: <ZO6J4W9msOixUk05@dread.disaster.area>
References: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:06:46PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Ritesh and Eric separately reported crashes in XFS's hook function for
> CPU hot remove if the remove event races with a filesystem being
> mounted.  I also noticed via generic/650 that once in a while the log
> will shut down over an apparent overrun of a transaction reservation;
> this turned out to be due to CIL percpu list aggregation failing to pick
> up the percpu list items from a dying CPU.
> 
> Either way, the solution here is to eliminate the need for a CPU dying
> hook by using a private cpumask to track which CPUs have added to their
> percpu lists directly, and iterating with that mask.  This fixes the log
> problems and (I think) solves a theoretical UAF bug in the inodegc code
> too.
> 
> v2: fix a few put_cpu uses, add necessary memory barriers, and use
>     atomic cpumask operations
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been lightly tested with fstests.  Enjoy!
> Comments and questions are, as always, welcome.

Series looks good. Removes a bunch of code and makes things more
reliable, so what's not to like about it?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
