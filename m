Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E113C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 09:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B5D61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 09:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhIPJvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 05:51:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236064AbhIPJvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 05:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631785810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LJHBPHkgYtEMQz+2tDVS1LZFdbWG2V6b4+RIRKN5m14=;
        b=f2/kX+VhccUzG5psvbwbLs0cjJcAma3nlQ2q1GGQdmzJ0x0bYsyWij2w91kl2zfjRRg5Q0
        Kv7xZv6EnomU0f7Rk4d8KGEnOpRI0lNqSaNR2uUBSYCq1dwBgz+BWht6hvt4Kg9d9E6jEY
        hROTC9XrBSOtT3IOVVwl71GPVoPjH8E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-KM16i_LEOK2nTtverAaaaw-1; Thu, 16 Sep 2021 05:50:09 -0400
X-MC-Unique: KM16i_LEOK2nTtverAaaaw-1
Received: by mail-wm1-f72.google.com with SMTP id m16-20020a7bca50000000b002ee5287d4bfso1117170wml.7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 02:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LJHBPHkgYtEMQz+2tDVS1LZFdbWG2V6b4+RIRKN5m14=;
        b=RMxTLGjatyudTNNGlq2lhhBRqNPyebmUhxSXYSg87KZ4sIaeEvRgw1P2dGW0d62nrC
         S+DtZwR456V3qdJqDW4ap6o3/9wAnpQfhHeep8Rdqr0l/XWGNi6wyIw8oy0LuVOXHmIO
         AFpQg/bpl6mZhBGqrvdMfs82G3l785uGv85tJjt4QiBBtvT74GVhozMRn0WwzDSD3g4B
         h950ZV6bt/lyWX/jRrPgpp4PAEc0fEj4QAsm+CYYLNnnDRDMIyc1R/jk4kq7apHfs8BZ
         Da3tFgu4883i+h9prujFOwIdYR5KLcnl0oSwUJwTeTN9X/hgfS451HZVGmGgYiu5+EjU
         lO9g==
X-Gm-Message-State: AOAM5312aMxq1w2IuC9t+Z6bcGTp94ptPggo00RFwqJIwIA8A2vj/IeE
        q2mvvs5HU3Tvj6etU2qPeCBI5ramXX0rq4kItdTnHLIzNfaSQBF/qmxQ6ofhWIWD+oDjD/VsLFy
        4VyC0s4CdSQ9l8vCwtfPP
X-Received: by 2002:adf:fb91:: with SMTP id a17mr4878437wrr.376.1631785807995;
        Thu, 16 Sep 2021 02:50:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywtZml2PhOD/nFnVeEuf1cS0sPjBvVxe8tLGZLZGrxMezoSYsuKJw6Xq3jNI7akKgMPb7Enw==
X-Received: by 2002:adf:fb91:: with SMTP id a17mr4878403wrr.376.1631785807660;
        Thu, 16 Sep 2021 02:50:07 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id h18sm2760017wmq.23.2021.09.16.02.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 02:50:06 -0700 (PDT)
Date:   Thu, 16 Sep 2021 11:50:04 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Bill O'Donnell <billodo@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: XFS Sprints
Message-ID: <20210916095004.elamntoqfmv2gv7w@andromeda.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Eryu Guan <guaneryu@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Bill O'Donnell <billodo@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210916023652.GA34820@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916023652.GA34820@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.

On Wed, Sep 15, 2021 at 07:36:52PM -0700, Darrick J. Wong wrote:
> Hi again,
> 
> The other problem I sense we're having is implied sole ownership of
> patchesets being developed.  Reviewers make comments, but then it seems
> like it's totally on the developer (as the applicant) to make all those
> changes.  It's ... frustrating to watch new code stall because reviewers
> ask for cleanups and code restructuring that are outside of the original
> scope of the series as a condition for adding a Reviewed-by tag... but
> then they don't work on those cleanups.

Not to mention cases when reviews come 'too late'. A V2 is submitted right
before a new comment on V1, and that creates a V3,4,5....
> 
> At that point, what's a developer to do?  Try to get someone else's
> attention and start the review process all over again?  Try to get
> another maintainer's attention and have them do it?  This last thing is
> hard if you're already a maintainer, because doing that slows /everyone/
> down.
> 
> So the question I have is: Can we do community sprints?  Let's get
> together (on the lists, or irc, wherever) the week after -rc2 drops to
> figure out who thinks they're close to submitting patchsets, decide
> which one or two big patchsets we as a group want to try to land this
> cycle, and then let's /all/ collaborate on making it happen.  If you
> think a cleanup would be a big help for someone else's patchset, write
> those changes and make that part happen.

Despite the fact I particularly don't like the term 'sprint' :) I believe
gathering together from time to time to discuss next steps, is much appreciated.
My experience with the past few years is mostly what you described, everything
is scattered and it's hard to know what to prioritize. At a first I was mostly
thinking it was due my TZ constrains, which usually brings me 'late to the
party' (if I arrive at all :). But with your email, it seems there are more
things in play.
Lately I've been trying to help mostly on reviews, but again, it's usually hard
to know what to review first, so, most of time I feel like randomly picking
stuff on the list to review, unless somebody asks for help reviewing something
specific. So, from a reviewing PoV, this can help a lot what should be reviewed
first.
Also, probably now mostly regarding my TZ, I'm usually oblivious regarding
what's happening, so, I sometimes have a hard time to figure out where I can
give a hand when I have some spare time, maybe these 'meetings' (or whatever
we'll call it) will also help in this case.

Regarding on 'where', may I suggest a single email thread per -rc (or week,
month, whatever)? I'm just being selfish here though, so I don't need to be
on irc late night or early morning :) But if email doesn't work, I'll do what I
can to attend the meetings.

Cheers.

-- 
Carlos

