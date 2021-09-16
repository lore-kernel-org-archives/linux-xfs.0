Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DE0C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 13:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE94B6120C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 13:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbhIPNTp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:19:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240008AbhIPNTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 09:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631798303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2XM1rnuP3zhW4SmiERJUKKcuK7akZbD7g981A9MRV7w=;
        b=QQ2aMJ2k+qWrXEpmdbQxX3JNPxlSrGoYvrfOy6G+cX0AUw+9/yVer8C3lWhI1N958Mfr5B
        ChW+cA1Ds+yfb1f3mlvdDWSn03zS79x2lFGFcC0S1tScwJ4q1QJBgZhW2rmWKoknZyXvJm
        s05Xdevvza13VYyb3Vy55Mft8do2scc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-SOPN0Z3cPtOd0z2SH_X04w-1; Thu, 16 Sep 2021 09:18:22 -0400
X-MC-Unique: SOPN0Z3cPtOd0z2SH_X04w-1
Received: by mail-wr1-f71.google.com with SMTP id z1-20020adfec81000000b0015b085dbde3so2422477wrn.14
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 06:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=2XM1rnuP3zhW4SmiERJUKKcuK7akZbD7g981A9MRV7w=;
        b=pyzqi//dfdr1phjPF9fJoAeooVUivHXQox7g6ru5d8U7qwEHYCAzyB2+kcv1ISozqu
         vBc2DEMOwdYWcuALEOpeF2r0ikjn0pndRkQhIChP/GfFAqv/4iFjoYhc8kTSgft48fTX
         g1b0fKModBrir7iV4fL0KJXm8ix6lZTq6wsMQdZkEG5Xw4I2jtXFbBd2NUCe+obi1AHU
         CsFjTkJPuX1tluO6UBDrmG2FtTOJ5TEZgxefAph798Hu1uqsBQCzRc7OVOk/oxcVbGOX
         1YRb/B6UHO3bpbTUYwwDZOI61tCNT/zUApsr5mATVknknZlrI0QnRQuIC7RBAh1MvNtU
         ItGA==
X-Gm-Message-State: AOAM532l+cYXeSBP24mYX22Iu7ceWoROz6LLqY93lw6SOl9Mk0Rphu81
        9dIMMVo4/gsBM2DG/c4t3+ggsoQSutWKbiFuosnU7l0xDR+uaExYMVW0XG/qFO2QFBUY04X+A/k
        XIUQmuAta/zf+JwHlf4qK
X-Received: by 2002:a5d:6551:: with SMTP id z17mr5986355wrv.414.1631798301440;
        Thu, 16 Sep 2021 06:18:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTj+fV9wsIgeUIUYX8ILYgLNLQHCgyQOUnxd1jBBdsFAk0XTPaHVNF6Sd3ubzRTWwfgWXILg==
X-Received: by 2002:a5d:6551:: with SMTP id z17mr5986328wrv.414.1631798301247;
        Thu, 16 Sep 2021 06:18:21 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id b204sm5447615wmb.3.2021.09.16.06.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 06:18:20 -0700 (PDT)
Date:   Thu, 16 Sep 2021 15:18:18 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
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
Subject: Re: [External] : XFS Sprints
Message-ID: <20210916131818.6x7bzwry76qmcjlb@andromeda.lan>
Mail-Followup-To: Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
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
 <87ee9oaeu4.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee9oaeu4.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 05:54:03PM +0530, Chandan Babu R wrote:
> > So the question I have is: Can we do community sprints?  Let's get
> > together (on the lists, or irc, wherever) the week after -rc2 drops to
> > figure out who thinks they're close to submitting patchsets, decide
> > which one or two big patchsets we as a group want to try to land this
> > cycle, and then let's /all/ collaborate on making it happen.  If you
> > think a cleanup would be a big help for someone else's patchset, write
> > those changes and make that part happen.
> >
> > There's never been a prohibition on us working like that, but I'd like
> > it if we were more intentional about working like a coordinated team to
> > get things done.  What do you all think?
> >
> > (Small changes and bug fixes can be sent any time and I'll take a look
> > at them; I'm not proposing any changes to that part of the process.)
> >
> 
> Apart from patchsets associated with implementing new features, small changes
> and bug fixes for an upcoming kernel release, may be we should also allow
> developers to post RFC patchsets to obtain an initial high-level feedback
> for a design that implements a fairly complicated new feature?

Hmm, AFAIK, this has never been a problem, just check the list, there are
several [RFC PATCH] patches around. Not sure if maybe you're talking about
something more specific?

-- 
Carlos

