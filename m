Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76D5C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 06:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbjFFGvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 02:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjFFGvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 02:51:44 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A849193
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 23:51:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-652dd220d67so4640151b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 23:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686034303; x=1688626303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzrUn3TJn9oHZTuuml4d9wxIwzfuVemXzrEhOgGgfqc=;
        b=Mol2lFfO3T5qt9ASa5cDKUGoDR391wKygoARbFbUOt06c38QAlReGPGuhhdywFHin+
         ye9WDTddzUqRpVTLEinDAx6UNqTHEaIrT8SLnNxGYiXkp/CBNYxMV0z/PDMX+1j5U3Jd
         WxwFYOsx8ce70hx4WC8WefuW6A5LqsRrlsQ9PPVWMe5ODehqdXe2Jj5Ef2gipg/Ob5P2
         v26JxTIdLG1DyfdXner2agtMonw6uWNulLZaEtr+b7yOG72BhrDD8wBjWcym0KhriKiG
         sp98K5E8yYiUS3P2h5aBHr3+yVz/l/cQzyDhbHJYzbnxsdc94+6W1CHdGy3yrVdEV+ba
         qpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686034303; x=1688626303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzrUn3TJn9oHZTuuml4d9wxIwzfuVemXzrEhOgGgfqc=;
        b=LFpiaYMLSHC5sQ9PiuHMX7rFFYCxzSOuY1Bmy8+vRAgYvBRB2zxpUj5LhbR60DPyN2
         UuXCqfMAjLlnYtTNtSKWzsXpuxC1HCudDLVfOEUrdxe/TDbJqYWc/FAWr9/hL3W2ujYO
         j6rvxCx/CZSYXRjoJ6o3jSSIy3gm9It/RyyIhuj/ugK03RY2neQo7xnzlzFlegoMqDDJ
         qvIXh85fUOEdK7GxKQeG+lyqodBxPSqy1rMMeNGx8J2+z7gqfEGNI62ybdjKavQtAWnH
         SNuwv+XAgBD2NGoVUa4vilOVQuWQblA+pgCAjbI3R3m4BH/NA2sVxf5OR7IAy4bKx0WY
         QnEg==
X-Gm-Message-State: AC+VfDx4SXnuB0S+PbaAoL8nZgeFEtpRVS5sMSe7rqmVXVemnvQPlAlX
        wmxYhP0xNbuf9ZB4yezpBTG1Gg==
X-Google-Smtp-Source: ACHHUZ7x3NSPqUc0MTztC3yNbXyqO3LPo4HDdDohroIB2GxY1bF8kqh0D++Jt31Y34GGHHc8wE6CTg==
X-Received: by 2002:a05:6a21:9986:b0:10f:7e62:3806 with SMTP id ve6-20020a056a21998600b0010f7e623806mr2043000pzb.22.1686034303169;
        Mon, 05 Jun 2023 23:51:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id 19-20020a630e53000000b00513973a7014sm6543861pgo.12.2023.06.05.23.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 23:51:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q6QXc-008OVH-0F;
        Tue, 06 Jun 2023 16:51:40 +1000
Date:   Tue, 6 Jun 2023 16:51:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Kirill Tkhai <tkhai@ya.ru>, akpm@linux-foundation.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, brauner@kernel.org,
        djwong@kernel.org, hughd@google.com, paulmck@kernel.org,
        muchun.song@linux.dev, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v2 3/3] fs: Use delayed shrinker unregistration
Message-ID: <ZH7XfD/pBcWzhHcc@dread.disaster.area>
References: <168599103578.70911.9402374667983518835.stgit@pro.pro>
 <168599180526.70911.14606767590861123431.stgit@pro.pro>
 <ZH6AA72wOd4HKTKE@P9FQF9L96D>
 <ZH6K0McWBeCjaf16@dread.disaster.area>
 <ZH6ge3yiGAotYRR9@P9FQF9L96D>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH6ge3yiGAotYRR9@P9FQF9L96D>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 07:56:59PM -0700, Roman Gushchin wrote:
> On Tue, Jun 06, 2023 at 11:24:32AM +1000, Dave Chinner wrote:
> > On Mon, Jun 05, 2023 at 05:38:27PM -0700, Roman Gushchin wrote:
> > > Isn't it possible to hide it from a user and call the second part from a work
> > > context automatically?
> > 
> > Nope, because it has to be done before the struct shrinker is freed.
> > Those are embedded into other structures rather than being
> > dynamically allocated objects.
> 
> This part we might consider to revisit, if it helps to solve other problems.
> Having an extra memory allocation (or two) per mount-point doesn't look
> that expensive. Again, iff it helps with more important problems.

Ah, I guess if you're concerned about memory allocation overhead
during register_shrinker() calls then you really aren't familiar
with what register_shrinker() does on memcg and numa aware
shrinkers? 

Let's ignore the fact that we could roll the shrinker structure
allocation into the existing shrinker->nr_deferred array allocation
(so it's effectively a zero cost modification), and just look at
what a memcg enabled shrinker must initialise if it expands the
shrinker info array because the index returned from idr_alloc()
is larger than the current array:

	for each memcg {
		for_each_node {
			info = kvmalloc_node();
			rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
		}
	}

Hmmmm?

So, there really isn't any additional cost, it completely decouples
the shrinker infrastructure from the subsystem shrinker
implementations, it enables the shrinker to control infrastructure
teardown independently of the subsystem that registered the
shrinker, and it still gives guarantees that the shrinker is never
run after unregister_shrinker() completes. What's not to like?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
