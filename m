Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607AAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Mar 2022 09:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiCaJQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiCaJQn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 05:16:43 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC841FB539
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 02:14:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso2040677pjb.0
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 02:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jVre27Ahf/5rD14vU7rXWW0hIHXmqmYv7Ee+VLl2etY=;
        b=oGyFCw7C74o5yZHggPw2mnKUrj4WSZ7o55Iz6G3L31aDKEFUM1ACO7BB5hIOOebRj4
         EXgTNKFLFQTFvWGpknw+5Wxq9MXsCkp+AX1lugkxDJWLhzJJQHNJownFt3jaEZ7ry55O
         DnFUcYhFDqV7v1hD20F09sDSX6muTiyQufZgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jVre27Ahf/5rD14vU7rXWW0hIHXmqmYv7Ee+VLl2etY=;
        b=0KF/due1vwIp9ZlngRuWj79lYYn99qxSorQ99YWf5MKc3wPraBILrC2wPXgBoAvfA4
         E6vgo+t5/asVqp4QycyYKdMT9WpN8UD8KEkWwhaqIMdeUrEMrh7h3tk4MLyNHTzhqYrN
         ItKOyN7AHAFxLj0oHRRPuImyZLRkfvbOm6T0BjOdhWYG+nPy5FFareHzdUb6nYFWM6g/
         1EQF7waujB655OQBE824Kuqn7Pqt/S1X+y66RFGVi3kuMhLcxo6l+ZBGuWUPL7HLW3HO
         RBNAK8P8SHI4jybN8DpkqZvMGXztfXYkN+GBRrzr+et75p3IuOAPRDYPASwaVO8W+mCc
         EqVA==
X-Gm-Message-State: AOAM531RJj+LVe6wtUklMDPZjuRAP92WtSuxFZkbidOMIQeZkz7rlNEe
        2Rx+X1Qusjhx+kdyYGalXGdHJw==
X-Google-Smtp-Source: ABdhPJwi+60kjdMCZa0i5QXnKzfkVLGga2TXoxe/Bz2MMjAxywSoKDYbgNTfafPSYB89qQLwl4HoRw==
X-Received: by 2002:a17:902:c652:b0:154:2920:df6d with SMTP id s18-20020a170902c65200b001542920df6dmr39691022pls.146.1648718096298;
        Thu, 31 Mar 2022 02:14:56 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:5343:1a35:9cf7:fa4c])
        by smtp.gmail.com with ESMTPSA id k15-20020a63ab4f000000b00381eef69bfbsm21768333pgp.3.2022.03.31.02.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 02:14:55 -0700 (PDT)
Date:   Thu, 31 Mar 2022 18:14:50 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <YkVxCi2+tt0UAsVI@google.com>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <20220330004649.GG27713@magnolia>
 <20220330012624.GC1544202@dread.disaster.area>
 <20220330145955.GB4384@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330145955.GB4384@pathway.suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On (22/03/30 16:59), Petr Mladek wrote:
> Document the printk index feature. The primary motivation is to
> explain that it is not creating KABI from particular printk() calls.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Great write up!

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
