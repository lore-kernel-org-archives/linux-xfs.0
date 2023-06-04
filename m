Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84610C7EE23
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 23:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjFDXCN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 19:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjFDXCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 19:02:12 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E8892
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 16:02:10 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-33bbb78248fso21370175ab.0
        for <linux-xfs@vger.kernel.org>; Sun, 04 Jun 2023 16:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685919729; x=1688511729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EDJnSV+2s4y4J3cOEkqDqC+KJZ57WWFuIrMQa/6SiSk=;
        b=gfGuolYeunyEkhQC6VdLNeSgLBP2TrwVkonfaQqxggjOiXKfuzNB/aqoOd2zjEXqXM
         5Gb9ZCr3ytRWI/J0mFFD3HHxOInV8AEH1VRDr2gi41/z8LXyYO5zN2GpwJ8lfbzpZm5M
         4bToaInOm4k4VLK9GL69703xmIlnT4xm6CqBjH8QwP1bD7HEHCM08z8lhsx7mwPu0Q5g
         9pmcvt7KFf+YZ8bj9o1TKM5pBGVRnotWuXCNoKGAN33jwfHGei5tEtagQY9lzcgRQDNQ
         sKvCW4Cc9orGw21sHaTgnga0A6HmODPyDbLJkGVLzEwgmMCXKpDhwTVoXo43jnm2t3/7
         1YrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685919729; x=1688511729;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EDJnSV+2s4y4J3cOEkqDqC+KJZ57WWFuIrMQa/6SiSk=;
        b=EAsHN0ul3fDm0AexFNs7zg4+qa3j04pBYEZhs1JYQ/q/JCctt8RHjOgoEW5DctIjyN
         MmMy+LSi/hozhIHpwDCUy6mqOK3/T2yS0R/nrRi0Baoiyd2mntcfa7rZpULuH1s71xXr
         3YdSfYtDDSdsPSaeGHiWAWsAqZdfMC/pcQIMzEwHp8EiBjU1BJjKDgQfZaVgCqcQbSu9
         ka6kPrrLI9J+x65cvSCzM/r4z9Vlj6paAiB1OEofSqjwWeoVv+Q3yr1dM2Wq0d+9+gTI
         C+l1r1ompVAWOpfQm26tp8qcwTsE9Hqb87QqS0fJIfgfYaTUwwTvllzE6bM33eqqcTFD
         O5fg==
X-Gm-Message-State: AC+VfDy6ZjJUSgNaE+BfYjKJQah/rmoMVvFy2LC6RpQ1Kpstygp5c+hs
        avOlKfve0HiPj0I8J9H4WMdfql1dQ/hsuhGxdyY=
X-Google-Smtp-Source: ACHHUZ6APb3Lr2JCmxdG2w3PwmYWhXgZQO3ERiN9IXIu/QMC03/KNLLuwZyG7adRkAXbv/+FLzNDmg==
X-Received: by 2002:a92:c9cd:0:b0:33d:6988:c000 with SMTP id k13-20020a92c9cd000000b0033d6988c000mr10009928ilq.8.1685919729557;
        Sun, 04 Jun 2023 16:02:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id n35-20020a635923000000b0051303d3e3c5sm4520367pgb.42.2023.06.04.16.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 16:02:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q5wje-007run-06;
        Mon, 05 Jun 2023 09:02:06 +1000
Date:   Mon, 5 Jun 2023 09:02:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/7] xfs: fix ranged queries and integer overflows in
 GETFSMAP
Message-ID: <ZH0X7i1GFC3QTg/f@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
 <20230604175623.GB72241@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604175623.GB72241@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 04, 2023 at 10:56:23AM -0700, Darrick J. Wong wrote:
> Ping?  Even if it's too late for 6.5, can we at least get this bug fix
> series reviewed?

I haven't even had time to read the description of this mega patchset,
so I had no idea there were bug fixes in it. Normally you send them
separately, so it's obvious they are bug fixes that need immediate
attention.

I'll put it on my list, but I have no idea right now when I'll get
to it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
