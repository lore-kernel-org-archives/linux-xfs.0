Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B1AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiC3Rqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiC3Rqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 13:46:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1E7101F0E
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:44:48 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h1so25353556edj.1
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K9mTfr+9yfX3AQnQTAMmg9qUgbHlxUCd+LHRj3aLr3g=;
        b=a8uyOGhltB2hbdhzxesec2SJFiOfBuRDY4Q7L8qOaFZZxhIh9JTcjqiO6qP55q6bAh
         7f3cNxL67IGepkCXg5GjknH7P18HeGKudRvZ/BCA34+GS+pdR2N+55Gwz2VILXtuczZ8
         eTdGY/LB/U9MS/gKOBAktt+WY1dwMAFoRrqDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K9mTfr+9yfX3AQnQTAMmg9qUgbHlxUCd+LHRj3aLr3g=;
        b=j+XU6ewe3Oxj4U6HD+6HBQeKwf+kt/3HSQY6qznHUrZoc9s3AQZunBW5CjDdMCm8Ky
         y0VgEyP69YacDzLuFCm1QnrqyIIDglLHuPiHFyLxy88AD85kgyJARyWwAgMxP5oBt+2c
         Fli8qSAAPlxRsl6fNi7YJe5NbHOboTmvPXpusVyWvxxJFu5Wz/QMPFsTxafWqtMFpOPQ
         EeLeA8YrBsotpEuaivihO90ab1+vau4VczrYSy0SzYpfJx8ER6fftCcC584VLlGPdHln
         rjvm7lsE7XIcOmXlZaqG/ZZ3/ZwSAt+3nxzKSxEO1VmbjVa/kGMJQjd9iao/LF2v4+Qb
         mFWQ==
X-Gm-Message-State: AOAM531+pTmegaHUx7AYZoac3oqQgZnctsi2XfeaKeqoe5Av58ue3XRD
        Al57ekr0+NVxt7S6xeaJksNWMQ==
X-Google-Smtp-Source: ABdhPJyXZjJVdo9jS5TputnGifcTBItqiDHBkCcTIzy1elSLr+zghA9tBYudVSaXXnwB9ZaE/g6Ojw==
X-Received: by 2002:a05:6402:362:b0:419:2b6d:a662 with SMTP id s2-20020a056402036200b004192b6da662mr12211868edw.54.1648662286785;
        Wed, 30 Mar 2022 10:44:46 -0700 (PDT)
Received: from localhost ([2620:10d:c093:400::5:c1bb])
        by smtp.gmail.com with ESMTPSA id u23-20020a17090626d700b006cfcd39645fsm8329857ejc.88.2022.03.30.10.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:44:46 -0700 (PDT)
Date:   Wed, 30 Mar 2022 18:44:45 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Dave Chinner <david@fromorbit.com>, Petr Mladek <pmladek@suse.com>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkSXDWztoLpqn4/7@chrisdown.name>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <YkREmrfoTcqOYbma@chrisdown.name>
 <20220330124739.70edca36@gandalf.local.home>
 <YkSOyC+vEMVSDsdU@chrisdown.name>
 <20220330133950.6ed0ead6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220330133950.6ed0ead6@gandalf.local.home>
User-Agent: Mutt/2.2.2 (aa28abe8) (2022-03-25)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Steven Rostedt writes:
>There isn't a majority opinion on this. There's only one opinion, and
>that's Linus's ;-)

Fair enough :-)

Regardless, I don't think we need to get too into the weeds about whether 
debugfs is a stable ABI or not here. Even if it is considered to be so, the ABI 
here would be the format and location of the printk index -- printk entries 
being added, changed, or removed are just backing data changes in the same way 
that adding or removing a map and that then being reflected in /proc/self/smaps 
isn't an ABI break either.
